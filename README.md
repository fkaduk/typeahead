
# typeahead

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/fkaduk/typahead/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fkaduk/typahead/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/fkaduk/typahead/graph/badge.svg)](https://app.codecov.io/gh/fkaduk/typahead)
[![R-CMD-check](https://github.com/fkaduk/typaheadsa/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fkaduk/typaheadsa/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of typeahead is to ...

## Installation

The development version can be installed from
[GitHub](https://github.com/fkaduk/typeahead) with

```r
devtools::install_github("fkaduk/typahead")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(typeahead)
## basic example code
```

## Local Testing

`shinytest2` requires Chrome/Chromium for browser testing. The package includes a Docker setup that provides a complete testing environment with chrome-headless-shell.

```bash
docker build -t typeahead-test . 

docker run --rm -v "$(pwd):/pkg" typeahead-test R -e "setwd('/pkg'); devtools::install_deps(dependencies = TRUE); devtools::install(); devtools::test()"
```

