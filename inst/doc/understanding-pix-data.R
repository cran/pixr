## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
 collapse = TRUE,
 comment = "#>",
 eval = FALSE
)

## ----keys-data----------------------------------------------------------------
# library(pixr)
# 
# # View available columns
# pix_columns("keys")
# 
# # Retrieve data - note: date uses YYYY-MM-DD format
# keys <- get_pix_keys(date = "2025-12-01")
# 
# # Filter by key type using OData filter
# cpf_keys <- get_pix_keys(
#   date = "2025-12-01",
#   filter = "TipoChave eq 'CPF'"
# )

## ----municipality-data--------------------------------------------------------
# # View available columns
# pix_columns("municipality")
# 
# # Retrieve data - note: database uses YYYYMM format
# transactions <- get_pix_transactions_by_municipality(database = "202512")
# 
# # Filter by state using OData filter
# sp_data <- get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Estado eq 'SÃO PAULO'"
# )

## ----stats-data---------------------------------------------------------------
# # View available columns
# pix_columns("stats")
# 
# # Retrieve data
# stats <- get_pix_transaction_stats(database = "202509")
# 
# # Filter by transaction nature
# p2p_stats <- get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P'"
# )

## ----fraud-data---------------------------------------------------------------
# # View available columns
# pix_columns("fraud")
# 
# # Retrieve data
# fraud <- get_pix_fraud_stats(database = "202509")

## ----filter-examples----------------------------------------------------------
# # Filter by state
# get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Estado eq 'SÃO PAULO'"
# )
# 
# # Filter by region
# get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Sigla_Regiao eq 'NE'"
# )
# 
# # Filter by transaction nature
# get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P'"
# )
# 
# # Filter by key type
# get_pix_keys(
#   date = "2025-12-01",
#   filter = "TipoChave eq 'CPF'"
# )
# 
# # Multiple filters with 'and'
# get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'SUDESTE'"
# )
# 
# # Order by column
# get_pix_keys(
#   date = "2025-12-01",
#   filter = "TipoChave eq 'CPF'",
#   orderby = "qtdChaves desc",
#   top = 100
# )

## ----date-helpers-------------------------------------------------------------
# # ChavesPix uses YYYY-MM-DD
# get_pix_keys(date = "2025-12-01")
# 
# # Other endpoints use YYYYMM
# get_pix_transaction_stats(database = "202509")
# 
# # Convert YYYYMM to Date object (first day of month)
# year_month_to_date("202312")
# # [1] "2023-12-01"
# 
# # Works with vectors
# year_month_to_date(c("202301", "202306", "202312"))
# # [1] "2023-01-01" "2023-06-01" "2023-12-01"

## ----currency-helpers---------------------------------------------------------
# # Format as BRL
# format_brl(1234567.89)
# # [1] "R$ 1.234.567,89"
# 
# # Without prefix
# format_brl(1234567.89, prefix = FALSE)
# # [1] "1.234.567,89"

## ----ispb-example-------------------------------------------------------------
# # Filter by institution name
# bb_keys <- get_pix_keys(
#   date = "2025-12-01",
#   filter = "contains(Nome, 'BANCO DO BRASIL')"
# )

