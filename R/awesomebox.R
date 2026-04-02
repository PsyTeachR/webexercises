#' Print an awesomebox
#' @keywords internal
box_args <- function(
    vrulecolor = 'white',
    hrule = c('\\abLongLine', '\\abShortLine', ''),
    title = '', vrulewidth = '0pt',
    icon = 'Question', iconcolor = 'black'
) {
  #hrule <- match.arg(hrule)
  sprintf(
    '[%s][%s][\\textbf{%s}]{%s}{\\fa%s}{%s}',
    vrulecolor, hrule, title, vrulewidth, icon, iconcolor
  )
}
