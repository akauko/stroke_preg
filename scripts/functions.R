
my.kable <- function(my.table) {
  my.table %>%
    knitr::kable() %>%
    kable_classic() %>%
    row_spec(0,bold=TRUE)
  
}

my_char_table <- function(df_tmp, myvars, fact_vars, strata, chr_rownames = NULL, nonnormal=NULL, includeNA=F){
  
  chr_all <- 
    CreateTableOne(vars=myvars, data=df_tmp, factorVars = fact_vars, test=F) %>%
    print(dropEqual=T, printToggle=F, contDigits=1, nonnormal=nonnormal, includeNA=includeNA)
  if(!is.null(chr_rownames)){row.names(chr_all) <- c(chr_rownames)} 
  
  chr_strata <- 
    CreateTableOne(vars=myvars, data=df_tmp, factorVars = fact_vars, strata=strata, test=T) %>%
    print(dropEqual=T, printToggle=F, contDigits=1, nonnormal=nonnormal)
  if(!is.null(chr_rownames)){row.names(chr_strata) <- c(chr_rownames)}
  
  cbind(chr_all, chr_strata)[,-6] 
  
}


my_tidy_est <- function(table, digits = 2, sign =2){
  
  table %>%
    mutate_at(c("est", "lower", "upper", "pval"), as.numeric) %>%
    mutate_at(c("est","lower", "upper"), ~round(.,digits)) %>%
    mutate_at("pval", ~signif(., sign)) %>%
    mutate_all(as.character) %>%
    mutate(est_ci = str_glue("{est} ({lower}-{upper})"))
}    



# Extract coefficients and ci's from cox model

my_extr_coef <- function(cx, title, select){
  cbind(row.names(summary(cx)$coefficients), 
        summary(cx)$coefficients,
        summary(cx)$conf[,3:4]) %>%
    as_tibble() %>%
    rename(exposure=V1, est="exp(coef)", pval="Pr(>|z|)",  lower="lower .95", upper="upper .95") %>%
    filter(str_detect(exposure, select)) %>%
    mutate(title=title)
}



# Extract coefficients and ci's from glm

my_extr_coef_glm <- function(glm, title, select){
  
  cbind(row.names(summary(glm)$coefficients),
        summary(glm)$coefficients,
        exp(confint.default(glm)) ) %>%
    as_tibble() %>%
    rename(exposure=V1, est="Estimate", pval="Pr(>|z|)",  lower="2.5 %", upper="97.5 %") %>%
    mutate_at(c("est", "pval", "lower", "upper"), as.numeric) %>% 
    mutate(est = exp(est)) %>%
    mutate(title=title) %>%
    select(exposure, est, pval, lower, upper, title) %>%
    filter(str_detect(exposure, select)) 
   
}


my_expand_covs <- function(df, batch) {
  
  expand.grid(
    batch = batch,
    BL_YEAR = round(mean(df$BL_YEAR)),
    PC1 = mean(df$PC1),
    PC2 = mean(df$PC2),
    PC3 = mean(df$PC3),
    PC4 = mean(df$PC4),
    PC5 = mean(df$PC5),
    PC6 = mean(df$PC6),
    PC7 = mean(df$PC7),
    PC8 = mean(df$PC8),
    PC9 = mean(df$PC9),
    PC10 = mean(df$PC10)
  ) 
}



#Draws facet wrapped histograms

my_histo_wrap <-  function(var_names, df=df, xlab, ncol=4){

  df_long <-   df %>%
    select(all_of(var_names)) %>%
    pivot_longer(cols=all_of(var_names), names_to = "names", values_to = "values")
  
  ggplot(data=df_long, aes(values), xlab=xlab) +
    geom_histogram(alpha=0.85) +
    theme(legend.title = element_blank()) +
    facet_wrap(~names, ncol=4)
}




my_table_line  <- function(dfi, var1, var2){
  
  pval <- chisq.test(dfi %>% select(all_of(c(var1,var2))) %>% table())[["p.value"]]
  
  dfi %>% 
    #mutate_at(unlist(names_ep), ~as.integer(as.character(.))) %>%
    select(all_of(c(var1,var2))) %>%
    rename(VAR2 = var2) %>%
    #mutate(APO2 = fct_recode(APO2, `No APO`="0",`1 APO`="1", `2+ APO`="2"))%>% 
    group_by_at(c(var1)) %>%
      summarise(n = sum(VAR2), N = n()-n, perc = n/(n+N)*100) %>%
    ungroup() %>%
    mutate(n_N = str_glue("{n}/{N} ({round(perc, 2)})")) %>%
    mutate(n_N = if_else(n<5, " - ", as.character(n_N))) %>%
    select(APO2, n_N) %>%
    pivot_wider(names_from="APO2", values_from = c(n_N)) %>%
    mutate(pval=if_else(pval < 0.001, "<0.001", as.character(round(pval,3))))
  
}   


# Function to calculate mode...
getmode <- function(v, na.rm=F) {
  uniqv <- unique(v)
  if(na.rm){uniqv <- uniqv[!is.na(uniqv)]}
  uniqv[which.max(tabulate(match(v, uniqv)))]
}


create_3level_var <- function(dfi, var_name, var_vec=var_name){

  age = str_glue("{var_name}_AGE")
  year = str_glue("{var_name}_YEAR")
  
  dfi %>%
    filter(ENDPOINT %in% var_vec) %>%
    select(FINNGENID, EVENT_AGE, EVENT_YEAR) %>%
    distinct %>%
    group_by(FINNGENID) %>%
    mutate(NR_EVENTS = 1:n()) %>%   
    ungroup() %>%
    mutate(EXP_TMP = if_else(NR_EVENTS > 1, 2L, NR_EVENTS)) %>%
    group_by(FINNGENID) %>%
    summarise(!!var_name :=  max(EXP_TMP),  !!year := min(EVENT_YEAR),!!age := min(EVENT_AGE)) %>%
    ungroup() 
  
}



