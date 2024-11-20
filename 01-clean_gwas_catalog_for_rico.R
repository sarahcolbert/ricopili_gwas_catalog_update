# Author: Sarah Colbert
# Title:  Cleaning gwas catolog file to use with area plots in ricopili
# Date: 20241120

############################################
############## load packages ###############
############################################

## load packages
library(data.table)
library(dplyr)
library(stringr)
library(tidyr)

############################################
############### load files #################
############################################

## load full gwas catolog file
full <- fread("full")

############################################
################# filter ###################
############################################

## apply some filters
filtered <- full %>% rename(N='INITIAL SAMPLE SIZE') %>% 
                    mutate(trait=`DISEASE/TRAIT`) %>% 
                    mutate(`P-VALUE`=as.numeric(`P-VALUE`)) %>% 
                    filter(`P-VALUE` < 5e-8) %>% ## only keep significant hits
                    filter(DATE > as.IDate("2018-01-01")) %>% ## only keep gwas published after jan 1, 2018
                    filter(!(trait %like% "level")) %>% filter(!(trait %like% "ratio")) %>% ## remove some of the biomarker traits like levels and ratios
                    mutate( ## get the total Ns for the GWAS
                        N = str_extract_all(N, "\\d{1,3}(?:,\\d{3})*") %>%  ## get case/control and male/female numbers
                        lapply(function(x) sum(as.numeric(gsub(",", "", x)))) %>%  # remove commas and sum numbers
                        unlist()  # convert list to vector
                    ) %>% 
                    filter(N > 10000) ## only keep GWAS with N > 10k 


############################################
################ reformat ##################
############################################

cleaned <- filtered %>% 
            select(SNPS, CHR_ID, CHR_POS, CHR_POS, 'P-VALUE', 'DISEASE/TRAIT', PUBMEDID) %>% 
            rename(disease='DISEASE/TRAIT') %>% 
            mutate(disease = sub("^(([^_]*_){2}[^_]*)_.*", "\\1...", gsub(" ", "_", disease)),
                    disease = ifelse(nchar(disease) > 25, paste0(substr(disease, 1, 22), "..."), disease)) %>% 
            mutate('DISEASE/TRAIT(PUBMEDID)'=paste0(disease, "(", PUBMEDID, ")")) %>% 
            select(-c("disease", "PUBMEDID")) %>% 
            mutate(`P-VALUE` = as.numeric(`P-VALUE`)) %>% 
            filter(as.numeric(`P-VALUE`)<5e-8) %>% 
            mutate(CHR_ID=as.numeric(CHR_ID), CHR_POS=as.numeric(CHR_POS)) %>% 
            arrange(CHR_ID, CHR_POS) %>% 
            drop_na() %>% 
            mutate(CHR_POS2=CHR_POS) %>% 
            relocate(CHR_POS2, .after=CHR_POS)

names(cleaned)[4] <- names(cleaned)[3] <- "CHR_POS"


## save
fwrite(cleaned, file="gwascatalog.Nov_2024.rp.txt", sep="\t")
