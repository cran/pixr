## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
 collapse = TRUE,
 comment = "#>",
 eval = FALSE
)

## ----install------------------------------------------------------------------
# # install.packages("remotes")
# remotes::install_github("StrategicProjects/pixr")

## ----setup--------------------------------------------------------------------
# library(pixr)

## ----endpoints----------------------------------------------------------------
# # List all available endpoints
# pix_endpoints()
# 
# # Get column information for each endpoint
# pix_columns("keys")
# pix_columns("municipality")
# pix_columns("stats")

## ----keys-example-------------------------------------------------------------
# # Get all PIX keys data for December 2025
# # Note: date uses YYYY-MM-DD format
# keys <- get_pix_keys(date = "2025-12-01")
# 
# # Filter by key type
# cpf_keys <- get_pix_keys(
#   date = "2025-12-01",
#   filter = "TipoChave eq 'CPF'",
#   orderby = "qtdChaves desc",
#   top = 100
# )
# 
# # Get summary by institution
# get_pix_keys_summary(date = "2025-12-01", n_top = 20)

## ----municipality-example-----------------------------------------------------
# # Get transactions for December 2025
# # Note: database uses YYYYMM format
# muni <- get_pix_transactions_by_municipality(database = "202512")
# 
# # Filter by state using OData filter
# maranhao <- get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Estado eq 'MARANHÃO'",
#   orderby = "Municipio desc",
#   top = 10
# )
# 
# # Aggregate by state
# state_summary <- get_pix_transactions_by_state(database = "202512")
# 
# # Aggregate by region
# region_summary <- get_pix_transactions_by_region(database = "202512")

## ----stats-example------------------------------------------------------------
# # Get detailed transaction statistics for September 2025
# stats <- get_pix_transaction_stats(database = "202509")
# 
# # Filter by transaction nature (P2P, P2B, etc.)
# p2p <- get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P'"
# )
# 
# # Get summary by transaction nature
# get_pix_summary(database = "202509", group_by = "NATUREZA")
# 
# # Get summary by region
# get_pix_summary(database = "202509", group_by = "PAG_REGIAO")
# 
# # Get data for multiple months
# q3_data <- get_pix_transaction_stats_multi(
#   databases = c("202507", "202508", "202509")
# )

## ----fraud-example------------------------------------------------------------
# # Get fraud statistics (MED - Mecanismo Especial de Devolução)
# fraud <- get_pix_fraud_stats(database = "202509")

## ----filter-example-----------------------------------------------------------
# # Filter by state
# get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Estado eq 'SÃO PAULO'"
# )
# 
# # Multiple filters with 'and'
# get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'SUDESTE'"
# )
# 
# # Order by value descending
# get_pix_transaction_stats(
#   database = "202509",
#   orderby = "VALOR desc",
#   top = 100
# )

## ----tidyverse-example--------------------------------------------------------
# library(dplyr)
# library(ggplot2)
# 
# # Analyze transactions by region
# get_pix_transactions_by_region(database = "202512") |>
#   mutate(
#     total_value_billions = (vl_pagador_pf + vl_pagador_pj) / 1e9
#   ) |>
#   ggplot(aes(x = reorder(Regiao, total_value_billions), y = total_value_billions)) +
#   geom_col(fill = "#008060") +
#   coord_flip() +
#   labs(
#     title = "PIX Transaction Volume by Region",
#     x = "Region",
#     y = "Transaction Value (R$ Billions)"
#   ) +
#   theme_minimal()

## ----timeout-example----------------------------------------------------------
# # Set timeout to 3 minutes
# pix_timeout(180)
# 
# # Check current timeout
# pix_timeout()
# 
# # Or use options
# options(pixr.timeout = 180)

## ----verbose-example----------------------------------------------------------
# # Suppress messages
# data <- get_pix_keys(date = "2025-12-01", verbose = FALSE)

## ----debug-example------------------------------------------------------------
# # See the URL for a query
# pix_url(
#   "TransacoesPixPorMunicipio",
#   params = list(DataBase = "202512"),
#   filter = "Estado eq 'MARANHÃO'",
#   orderby = "Municipio desc",
#   top = 10
# )

