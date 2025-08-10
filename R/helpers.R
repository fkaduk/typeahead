#' @title Null-coalescing operator
#' @description Returns the right-hand side if the left-hand side is NULL
#' @param a Left-hand side value
#' @param b Right-hand side value
#' @return Returns \code{b} if \code{a} is NULL, otherwise returns \code{a}
`%||%` <- function(a, b) if (is.null(a)) b else a

#' @title Drop NULL elements from a list
#' @description Removes NULL elements from a list or vector
#' @param x A list or vector
#' @return The input with NULL elements removed
dropNulls <- function(x) Filter(Negate(is.null), x)
