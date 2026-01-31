## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
 collapse = TRUE,
 comment = "#>",
 eval = FALSE
)

## ----filter-basic-------------------------------------------------------------
# library(pixr)
# 
# # Filter transactions by state
# get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Estado eq 'MARANHÃO'"
# )
# 
# # Filter by region
# get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Sigla_Regiao eq 'NE'"
# )
# 
# # Filter transaction stats by nature
# get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P'"
# )
# 
# # Filter PIX keys by key type
# get_pix_keys(
#   date = "2025-12-01",
#   filter = "TipoChave eq 'CPF'"
# )

## ----comparison-examples------------------------------------------------------
# # Greater than
# get_pix_transaction_stats(
#   database = "202509",
#   filter = "VALOR gt 10000"
# )
# 
# # Less than or equal
# get_pix_keys(
#   date = "2025-12-01",
#   filter = "qtdChaves le 1000"
# )

## ----logical-examples---------------------------------------------------------
# # AND - both conditions must be true
# get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'SUDESTE'"
# )
# 
# # OR - either condition can be true
# get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Estado eq 'SÃO PAULO' or Estado eq 'RIO DE JANEIRO'"
# )
# 
# # Complex filter with multiple conditions
# get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P' and PAG_REGIAO eq 'NORDESTE' and VALOR gt 1000"
# )

## ----string-functions---------------------------------------------------------
# # Find institutions containing "SICREDI"
# get_pix_keys(
#   date = "2025-12-01",
#   filter = "contains(Nome, 'SICREDI')"
# )
# 
# # Find cooperatives (starting with COOP)
# get_pix_keys(
#   date = "2025-12-01",
#   filter = "startswith(Nome, 'COOP')"
# )

## ----orderby-basic------------------------------------------------------------
# # Ascending order (default)
# get_pix_keys(
#   date = "2025-12-01",
#   orderby = "qtdChaves"
# )
# 
# # Descending order (add "desc")
# get_pix_keys(
#   date = "2025-12-01",
#   orderby = "qtdChaves desc"
# )
# 
# # Order municipalities alphabetically
# get_pix_transactions_by_municipality(
#   database = "202512",
#   orderby = "Municipio"
# )
# 
# # Order by value descending
# get_pix_transaction_stats(
#   database = "202509",
#   orderby = "VALOR desc"
# )

## ----filter-orderby-----------------------------------------------------------
# # Filter by state and order by municipality name (descending)
# get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Estado eq 'MARANHÃO'",
#   orderby = "Municipio desc",
#   top = 10
# )
# 
# # Filter P2P transactions and order by value
# get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P'",
#   orderby = "VALOR desc",
#   top = 100
# )
# 
# # Filter by key type and order by quantity
# get_pix_keys(
#   date = "2025-12-01",
#   filter = "TipoChave eq 'CPF' and NaturezaUsuario eq 'PF'",
#   orderby = "qtdChaves desc",
#   top = 50
# )

## ----select-example-----------------------------------------------------------
# # Select specific columns for PIX keys
# get_pix_keys(
#   date = "2025-12-01",
#   columns = c("Nome", "ISPB", "TipoChave", "qtdChaves"),
#   top = 100
# )
# 
# # Select specific columns for transactions
# get_pix_transactions_by_municipality(
#   database = "202512",
#   columns = c("Estado", "Municipio", "VL_PagadorPF", "QT_PagadorPF"),
#   top = 100
# )

## ----pagination-example-------------------------------------------------------
# # Get first 10 records
# get_pix_keys(date = "2025-12-01", top = 10)
# 
# # Skip first 100 records, get next 50
# get_pix_keys(date = "2025-12-01", top = 50, skip = 100)

## ----pagination-loop----------------------------------------------------------
# # Download all data in chunks
# all_data <- list()
# skip <- 0
# batch_size <- 1000
# 
# repeat {
#   batch <- get_pix_keys(
#     date = "2025-12-01",
#     top = batch_size,
#     skip = skip,
#     verbose = FALSE
#   )
# 
#   if (nrow(batch) == 0) break
# 
#   all_data <- c(all_data, list(batch))
#   skip <- skip + batch_size
# 
#   if (nrow(batch) < batch_size) break
# }
# 
# # Combine all batches
# final_data <- dplyr::bind_rows(all_data)

## ----custom-query-------------------------------------------------------------
# # Custom query with all parameters
# pix_query(
#   endpoint = "TransacoesPixPorMunicipio",
#   params = list(DataBase = "202512"),
#   filter = "Sigla_Regiao eq 'SE'",
#   select = c("Estado", "Municipio", "VL_PagadorPF"),
#   orderby = "VL_PagadorPF desc",
#   top = 50
# )
# 
# # Custom query for transaction stats
# pix_query(
#   endpoint = "EstatisticasTransacoesPix",
#   params = list(Database = "202509"),
#   filter = "NATUREZA eq 'P2B' and FORMAINICIACAO eq 'QRDN'",
#   orderby = "QUANTIDADE desc",
#   top = 100
# )

## ----debug-url----------------------------------------------------------------
# # See the URL for a query
# pix_url(
#   "TransacoesPixPorMunicipio",
#   params = list(DataBase = "202512"),
#   filter = "Estado eq 'MARANHÃO'",
#   orderby = "Municipio desc",
#   top = 10
# )
# # Returns:
# # https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/
# #   TransacoesPixPorMunicipio(DataBase=@DataBase)?$format=json&@DataBase='202512'
# #   &$filter=Estado eq 'MARANHÃO'&$orderby=Municipio desc&$top=10

## ----example-states-----------------------------------------------------------
# library(dplyr)
# 
# # Get all municipalities and aggregate by state
# get_pix_transactions_by_municipality(database = "202512") |>
#   group_by(Estado) |>
#   summarise(
#     total_value = sum(VL_PagadorPF + VL_PagadorPJ),
#     total_count = sum(QT_PagadorPF + QT_PagadorPJ),
#     n_municipalities = n()
#   ) |>
#   arrange(desc(total_value)) |>
#   head(10)

## ----example-nature-----------------------------------------------------------
# # Get P2P transactions by region
# p2p <- get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2P'"
# ) |>
#   group_by(PAG_REGIAO) |>
#   summarise(p2p_value = sum(VALOR))
# 
# # Get P2B transactions by region
# p2b <- get_pix_transaction_stats(
#   database = "202509",
#   filter = "NATUREZA eq 'P2B'"
# ) |>
#   group_by(PAG_REGIAO) |>
#   summarise(p2b_value = sum(VALOR))
# 
# # Join and compare
# left_join(p2p, p2b, by = "PAG_REGIAO")

## ----example-keys-------------------------------------------------------------
# # Get keys by type
# get_pix_keys(date = "2025-12-01") |>
#   group_by(TipoChave) |>
#   summarise(total_keys = sum(qtdChaves)) |>
#   mutate(share = total_keys / sum(total_keys) * 100) |>
#   arrange(desc(share))

## ----tip-filter---------------------------------------------------------------
# # Good: Filter on the server
# get_pix_transactions_by_municipality(
#   database = "202512",
#   filter = "Estado eq 'SÃO PAULO'"
# )
# 
# # Avoid: Downloading all data then filtering in R
# get_pix_transactions_by_municipality(database = "202512") |>
#   dplyr::filter(Estado == "SÃO PAULO")

## ----tip-select---------------------------------------------------------------
# # Good: Request only what you need
# get_pix_keys(
#   date = "2025-12-01",
#   columns = c("Nome", "qtdChaves")
# )

## ----tip-top------------------------------------------------------------------
# # Good: Explore with limited data
# get_pix_keys(date = "2025-12-01", top = 10)

## ----tip-verbose--------------------------------------------------------------
# get_pix_keys(date = "2025-12-01", verbose = FALSE)

