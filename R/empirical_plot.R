#' Function to generate empirical unidimensional item and test plots
#'
#' Given a dataset containing item responses this function will construct empirical graphics
#' using the observed responses to each item conditioned on the total score. When individual
#' item plots are requested then the total score will be formed without the item of interest
#' (i.e., the total score without that item).
#'
#' Note that these types of plots should only be used for unidimensional
#' tests with monotonically increasing item
#' response functions. If monotonicity is not true for all items, however, then these plots may
#' serve as a visual diagnostic tool so long as the majority of items are indeed monotonic.
#'
#' @aliases empirical_plot
#' @param data a \code{data.frame} or \code{matrix} of item responses (see \code{\link{mirt}}
#'   for typical input)
#' @param which.items a numeric vector indicating which items to plot in a faceted image plot.
#'   If NULL then empirical test plots will be constructed instead
#' @param smooth logical; include a GAM smoother instead of the raw proportions? Default is FALSE
#' @param type character vector specifying type of plot to draw. When \code{which.item} is NULL
#'   can be 'prop' (default) or 'hist', otherwise can be 'prop' (default) or 'boxplot'
#' @param formula formula used for the GAM smoother
#' @param main the main title for the plot. If NULL an internal default will be used
#' @param auto.key plotting argument passed to \code{\link[lattice]{lattice}}
#' @param par.strip.text plotting argument passed to \code{\link[lattice]{lattice}}
#' @param par.settings plotting argument passed to \code{\link[lattice]{lattice}}
#' @param ... additional arguments to be passed to \code{\link[lattice]{lattice}} and \code{coef()}
#' @keywords empirical plots
#' @export empirical_plot
#' @references
#' Chalmers, R., P. (2012). mirt: A Multidimensional Item Response Theory
#' Package for the R Environment. \emph{Journal of Statistical Software, 48}(6), 1-29.
#' \doi{10.18637/jss.v048.i06}
#' @seealso \code{\link{itemstats}}, \code{\link{itemplot}}, \code{\link{itemGAM}}
#' @examples
#'
#' \donttest{
#'
#' SAT12[SAT12 == 8] <- NA
#' data <- key2binary(SAT12,
#'    key = c(1,4,5,2,3,1,2,1,3,1,2,4,2,1,5,3,4,4,1,4,3,3,4,1,3,5,1,3,1,5,4,5))
#'
#' # test plot
#' empirical_plot(data)
#' empirical_plot(data, type = 'hist')
#' empirical_plot(data, type = 'hist', breaks=20)
#'
#' # items 1, 2 and 5
#' empirical_plot(data, c(1, 2, 5))
#' empirical_plot(data, c(1, 2, 5), smooth = TRUE)
#' empirical_plot(data, c(1, 2, 5), type = 'boxplot')
#'
#' # replace weird looking items with unscored versions for diagnostics
#' empirical_plot(data, 32)
#' data[,32] <- SAT12[,32]
#' empirical_plot(data, 32)
#' empirical_plot(data, 32, smooth = TRUE)
#'
#' }
empirical_plot <- function(data, which.items = NULL, type = 'prop',
                           smooth = FALSE, formula = resp ~ s(TS, k = 5),
                           main = NULL, par.strip.text = list(cex = 0.7),
                           par.settings = list(strip.background = list(col = '#9ECAE1'),
                                               strip.border = list(col = "black")),
                           auto.key = list(space = 'right', points=FALSE, lines=TRUE), ...){
    stopifnot(is.matrix(data) || is.data.frame(data))
    stopifnot(type %in% c('prop', 'hist', 'boxplot'))
    if(is.null(which.items))
        stopifnot(type %in% c('prop', 'hist'))
    if(!is.null(which.items))
        stopifnot(type %in% c('prop', 'boxplot'))
    if(type == 'boxplot') smooth <- FALSE
    data <- na.omit(as.matrix(data))
    K <- apply(data, 2, function(x) length(unique(x)))
    if(all(K == 2L)) auto.key <- FALSE
    TS <- rowSums(data)
    ord <- order(TS)
    data <- data[ord,]
    TS <- TS[ord]
    tab <- table(TS)
    if(is.null(which.items)){
        if(type == 'prop'){
            prop <- cumsum(tab) / nrow(data)
            df <- data.frame(TS=as.integer(names(tab)), P=prop)
            plt <- lattice::xyplot(P ~ TS, df, type = 'b',
                                   main = if(is.null(main)) 'Empirical Test Plot' else main,
                                   xlab = 'Total Score', ylab = 'Cumulative Proportion',
                                   ylim = c(-.1, 1.1), ...)
        } else if(type == 'hist'){
            df <- data.frame(TS=as.integer(names(tab)), freq=as.integer(tab))
            plt <- lattice::histogram(TS,
                                      main = if(is.null(main)) 'Total Scores' else main,
                                      xlab = 'Total Score', ylab = 'Frequency', ...)
        }
    } else {
        stopifnot(all(which.items >= 1L & which.items <= ncol(data)))
        pltdat <- vector('list', length(which.items))
        nms <- colnames(data)
        for(i in 1:length(which.items)){
            item <- data[, which.items[i]]
            TS <- rowSums(data[ ,-which.items[i]])
            ord <- order(TS)
            item <- item[ord]
            TS <- TS[ord]
            if(smooth){
                uniq <- sort(unique(item))
                if(length(uniq) == 2L) uniq <- uniq[2L]
                splt <- as.list(uniq)
                for(j in 1:length(uniq)){
                    df <- data.frame(resp = item==uniq[j], TS=TS)
                    props <- fitted(gam(formula, df, family = binomial()))
                    splt[[j]] <- data.frame(item=nms[which.items[i]], TS=TS,
                                            props=as.numeric(props), cat=uniq[j])
                }
                pltdat[[i]] <- do.call(rbind, splt)
            } else {
                tab <- table(TS)
                tmptab <- tab
                splt <- split(TS, item)
                if(type != "boxplot")
                    if(length(splt) == 2L) splt[[1L]] <- NULL
                for(j in 1:length(splt)){
                    tmptab[] <- NA
                    tab2 <- table(splt[[j]])
                    tmptab[names(tab) %in% names(tab2)] <- unname(tab2)
                    props <- tmptab / tab
                    names(props) <- names(tab)
                    splt[[j]] <- data.frame(item=nms[which.items[i]], TS=as.integer(names(tab)),
                                            props=as.numeric(props), cat=names(splt)[j])

                }
                pltdat[[i]] <- do.call(rbind, splt)
            }
        }
        df <- na.omit(do.call(rbind, pltdat))
        df$cat <- factor(df$cat)
        if(type == "boxplot"){
            plt <- lattice::bwplot(TS ~ cat | item, df,
                                   main = if(is.null(main)) "Empirical Item Differences" else main,
                                   xlab = 'Item Category', ylab = 'Reduced Total Score',
                                   par.strip.text=par.strip.text, par.settings=par.settings,
                                   auto.key=auto.key, ...)
        } else if(type == 'prop'){
            plt <- lattice::xyplot(props ~ TS|item, df, groups = cat,
                                   type = ifelse(smooth, 'l', 'b'),
                                   main = if(is.null(main)) "Empirical Item Plot" else main,
                                   xlab = 'Reduced Total Score', ylab = 'Proportion',
                                   par.strip.text=par.strip.text, par.settings=par.settings,
                                   auto.key=auto.key, ylim = c(-.1, 1.1), ...)
        }
    }
    plt
}
