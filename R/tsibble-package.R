#' tsibble: tidy temporal data frames and tools
#'
#' \if{html}{\figure{logo.png}{options: align='right'}}
#' The **tsibble** package provides a data class of `tbl_ts` to represent tidy 
#' time series data. A tsibble consists of a time index, key, and other measured 
#' variables in a data-centric format, which is built on top of the tibble. 
#'
#' @section Index:
#' An extensive range of indices are supported by tsibble: native time classes in R
#' (such as `Date`, `POSIXct`, and `difftime`) and tsibble's new additions 
#' (such as [yearweek], [yearmonth], and [yearquarter]). Some commonly-used classes
#' have built-in support too, including `ordered`, `hms::hms`, `zoo::yearmon`,
#' `zoo::yearqtr`, and `nanotime`. 
#'
#' For a `tbl_ts` of regular interval, a choice of index representation has to 
#' be made. For example, a monthly data should correspond to time index created
#' by [yearmonth] or `zoo::yearmon`, instead of `Date` or `POSIXct`. Because 
#' months in a year ensures the regularity, 12 months every year. However, if 
#' using `Date`, a month containing days ranges from 28 to 31 days, which results
#' in irregular time space. This is also applicable to year-week and year-quarter.
#'
#' Since the **tibble** that underlies the **tsibble** only accepts a 1d atomic 
#' vector or a list, the tsibble doesn't accept types of `POSIXlt` and `timeDate`.
#'
#' Tsibble supports arbitrary index classes, as long as they can be ordered from
#' past to future. To support a custom class, one needs to define [index_valid()]
#' for the class and calculate the interval through [interval_pull()].
#'
#' @section Key:
#' Key variable(s) together with the index uniquely identifies each record:
#' * Empty: an implicit variable. `NULL` resulting in a univariate time series.
#' * A single variable: For example, `data(pedestrian)` use the bare `Sensor` as 
#' the key.
#' * Multiple variables: For example, Declare `key = c(Region, State, Purpose)`
#' for `data(tourism)`.
#' Key can be created in conjunction with tidy selectors like `starts_with()`.
#'
#' @section Interval:
#' The [interval] function returns the interval associated with the tsibble.
#' * Regular: the value and its time unit including "nanosecond", "microsecond",
#' "millisecond", "second", "minute", "hour", "day", "week", "month", "quarter", 
#' "year". An unrecognisable time interval is labelled as "unit".
#' * Irregular: `as_tsibble(regular = FALSE)` gives the irregular tsibble. It is
#' marked with `!`.
#' * Unknown: if there is only one entry for each key variable, the interval
#' cannot be determined (`?`).
#'
#' An interval is obtained based on the corresponding index representation:
#' * `integer`/`numeric`/`ordered` (ordered factor): either "unit" or "year" (`Y`)
#' * `yearquarter`/`yearqtr`: "quarter" (`Q`)
#' * `yearmonth`/`yearmon`: "month" (`M`)
#' * `yearweek`: "week" (`W`)
#' * `Date`: "day" (`D`)
#' * `difftime`: "quarter" (`Q`), "month" (`M`), "week" (`W`), "day" (D),
#' "hour" (`h`), "minute" (`m`), "second" (`s`)
#' * `POSIXct`/`hms`: "hour" (`h`), "minute" (`m`), "second" (`s`), "millisecond" (`us`), "microsecond" (`ms`)
#' * `nanotime`: "nanosecond" (`ns`)
#'
#' @section Time zone:
#' Time zone corresponding to index will be displayed if index is `POSIXct`.
#' `?` means that the obtained time zone is a zero-length character "".
#'
#' @section Print options:
#' The tsibble package fully utilises the `print` method from the tibble. Please
#' refer to [tibble::tibble-package] to change display options.
#'
#' @aliases NULL tsibble-package
#' @importFrom utils head tail
#' @importFrom purrr map map_dbl map_int map_chr map_lgl
#' @importFrom purrr map2 map2_dbl map2_int map2_chr map2_lgl
#' @importFrom purrr pmap pmap_dbl pmap_int pmap_chr pmap_lgl
#' @importFrom dplyr arrange filter slice select mutate transmute summarise rename
#' @importFrom dplyr group_by ungroup group_data grouped_df group_vars
#' @importFrom dplyr group_rows groups new_grouped_df
#' @importFrom dplyr anti_join left_join right_join full_join semi_join inner_join
#' @importFrom tidyr gather spread nest unnest
#' @importFrom tibble new_tibble
#' @import rlang tidyselect
#' @examples
#' # create a tsibble w/o a key ----
#' tsibble(
#'   date = as.Date("2017-01-01") + 0:9,
#'   value = rnorm(10)
#' )
#'
#' # create a tsibble with one key ----
#' tsibble(
#'   qtr = rep(yearquarter("2010-01") + 0:9, 3),
#'   group = rep(c("x", "y", "z"), each = 10),
#'   value = rnorm(30),
#'   key = group
#' )
"_PACKAGE"

