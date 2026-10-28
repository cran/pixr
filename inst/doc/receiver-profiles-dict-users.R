## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
 collapse = TRUE,
 comment = "#>",
 eval = FALSE
)

## ----setup--------------------------------------------------------------------
# library(pixr)
# library(dplyr)

## ----dict-recent--------------------------------------------------------------
# users <- get_pix_dict_users(orderby = "DataGraficosPix desc", top = 6)
# users
# #> # A tibble: 6 x 4
# #>   DataGraficosPix qtdUsuariosPessoaFisica qtdUsuariosPessoaJuridica qtdUsuariosCadastrad...
# #>   <date>                            <dbl>                     <dbl>                  <dbl>
# #> 1 2026-09-30                    168245596                  18729138              186974734
# #> 2 2026-08-31                    167721822                  18557780              186279602
# #> 3 2026-07-31                    167141580                  18496255              185637835
# #> 4 2026-06-30                    166529238                  18338313              184867551
# #> 5 2026-05-31                    165981454                  18136372              184117826
# #> 6 2026-04-30                    165307979                  17911400              183219379

## ----dict-growth--------------------------------------------------------------
# users |>
#   arrange(DataGraficosPix) |>
#   mutate(
#     monthly_growth = qtdUsuariosCadastradosDICTTotal -
#       lag(qtdUsuariosCadastradosDICTTotal)
#   ) |>
#   select(DataGraficosPix, total = qtdUsuariosCadastradosDICTTotal, monthly_growth)
# #> # A tibble: 6 x 3
# #>   DataGraficosPix     total monthly_growth
# #>   <date>              <dbl>          <dbl>
# #> 1 2026-04-30      183219379             NA
# #> 2 2026-05-31      184117826         898447
# #> 3 2026-06-30      184867551         749725
# #> 4 2026-07-31      185637835         770284
# #> 5 2026-08-31      186279602         641767
# #> 6 2026-09-30      186974734         695132

## ----dict-plot----------------------------------------------------------------
# library(ggplot2)
# library(scales)
# 
# get_pix_dict_users() |>
#   ggplot(aes(DataGraficosPix, qtdUsuariosCadastradosDICTTotal)) +
#   geom_line(linewidth = 1) +
#   scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
#   labs(
#     x = NULL, y = "Users registered in DICT",
#     title = "PIX adoption: users with at least one registered key"
#   ) +
#   theme_minimal()

## ----cnae-columns-------------------------------------------------------------
# pix_columns("cnae")

## ----cnae-filter--------------------------------------------------------------
# cnae <- get_pix_cnae_stats(
#   database = "202506",
#   filter = "AnoMes eq 202506"
# )

## ----cnae-mei-----------------------------------------------------------------
# mei <- get_pix_cnae_stats(
#   database = "202506",
#   filter = "AnoMes eq 202506 and mei eq 'S'"
# )
# 
# mei |>
#   group_by(cnssecao) |>
#   summarise(
#     total_value = sum(vllanliq),
#     transactions = sum(qtlanliq),
#     .groups = "drop"
#   ) |>
#   arrange(desc(total_value)) |>
#   slice_head(n = 5)
# #> # A tibble: 5 x 3
# #>   cnssecao                                                        total_value transactions
# #>   <chr>                                                                 <dbl>        <dbl>
# #> 1 Pessoa fisica                                                 129893546653.    545210144
# #> 2 G - Comercio, reparacao de veiculos automotores e motocicletas  8253029010.     56506481
# #> 3 I - Alojamento e alimentacao                                    2488863327.     31068838
# #> 4 H - Transporte, armazenagem e correio                           2474709446.      7724758
# #> 5 S - Outras atividades de servicos                               2317447612.     13550221

## ----cnae-porte---------------------------------------------------------------
# get_pix_cnae_stats(
#   database = "202506",
#   filter = "AnoMes eq 202506 and tipopessoa eq 'PJ'"
# ) |>
#   group_by(porte) |>
#   summarise(
#     total_value = sum(vllanliq),
#     transactions = sum(qtlanliq),
#     .groups = "drop"
#   ) |>
#   arrange(desc(total_value))
# #> # A tibble: 5 x 3
# #>   porte         total_value transactions
# #>   <chr>               <dbl>        <dbl>
# #> 1 Demais            1.06e12   1141105592
# #> 2 Microempresa      2.57e11   1190137127
# #> 3 Pequeno Porte     1.14e11    348707396
# #> 4 Outros            7.01e 7       119364
# #> 5 NA                1.57e 6          930

## ----cnae-other---------------------------------------------------------------
# # Only Pix Saque / Pix Troco (cash withdrawal) transactions
# saque <- get_pix_cnae_stats(
#   database = "202506",
#   filter = "AnoMes eq 202506 and finalidade ne 'Pix'"
# )
# 
# # Payments between accounts of the same person
# mesma_titularidade <- get_pix_cnae_stats(
#   database = "202506",
#   filter = "AnoMes eq 202506 and mesmatit eq 'S'"
# )

