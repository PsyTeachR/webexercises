library(shiny)
library(ggplot2)

ui <- fluidPage(

  titlePanel("BRMA prior visualization"),

  sidebarLayout(

    sidebarPanel(
      htmlOutput("general"),
      br(),
      numericInput("ndraws",
                   "Number of draws from the prior",
                   value = 1000),
      selectInput("priortype", "Prior",
                  list("hs", "lasso")),
      conditionalPanel(
        condition = "input.priortype == 'hs'",
        numericInput("hs_df",
                     "df",
                     value = 1),
        numericInput("hs_df_global",
                     "df_global",
                     value = 1),
        numericInput("hs_df_slab",
                     "df_slab",
                     value = 4),
        numericInput("hs_scale_global",
                     "scale_global",
                     value = 1),
        numericInput("hs_scale_slab",
                     "hs_scale_slab",
                     value = 1)
      ),
      conditionalPanel(
        condition = "input.priortype == 'lasso'",
        numericInput("lasso_df",
                     "df",
                     value = 1),
        numericInput("lasso_scale",
                     "scale",
                     value = 1)
      ),
      actionButton("update_plot", "Add to plot"),
      uiOutput("ui_removelist"),
      uiOutput("ui_removebutton")
    ),

    mainPanel(
      plotOutput("prior_plot"),
      uiOutput("prior_list")
    )
  )
)

# Define server logic
server <- function(input, output) {
  reactives <- reactiveValues()
  reactives[["priors"]] <- list()
  reactives[["prior_names"]] <- vector("character")
  reactives[["prior_deets"]] <- list()
  reactives[["counter"]] <- 0
  observeEvent(input$update_plot, {
    priorargs <- switch(input$priortype,
                        "hs" = c(df = input$hs_df,
                                 df_global = input$hs_df_global,
                                 df_slab = input$hs_df_slab,
                                 scale_global = input$hs_scale_global,
                                 scale_slab = input$hs_scale_slab),
                        "lasso" = c(df = input$lasso_df,
                                    scale = input$lasso_scale)
    )

    newdata <- sample_prior(method = input$priortype, prior = priorargs)
    priorname <- paste0("Prior ", reactives[["counter"]]+1)
    reactives[["counter"]] <- reactives[["counter"]]+1
    tmp <- density(newdata$samples@sim$samples[[1]]$b)
    tmp <- data.frame(x = tmp$x, y = tmp$y, Prior = priorname)
    reactives[["prior_names"]][length(reactives[["priors"]])+1] <- priorname
    reactives[["prior_deets"]][[length(reactives[["priors"]])+1]] <- c(input$priortype, priorargs)
    reactives[["priors"]][[length(reactives[["priors"]])+1]] <- tmp

  })
  observeEvent(input$removebutton, {
    thisone <- which(reactives[["prior_names"]] == input$removeprior)
    reactives[["prior_names"]] <- reactives[["prior_names"]][-thisone]
    reactives[["prior_deets"]][[thisone]] <- NULL
    reactives[["priors"]][[thisone]] <- NULL

  })
  output$ui_removelist <- renderUI({
    if(length(reactives[["priors"]]) > 1){
    selectInput(inputId = "removeprior", label = "Priors", choices = reactives[["prior_names"]])
    }
  })
  output$ui_removebutton <- renderUI({
    if(length(reactives[["priors"]]) > 1){
      actionButton("removebutton", "Remove selected")
    }
  })
  output$prior_plot <- renderPlot({
    if(length(reactives[["priors"]]) > 0){
      p <- ggplot(data = NULL, aes_string(x = "x", y = "y", colour = "Prior"))
      #saveRDS(reactives, "c:/tmp/reactives.RData")
      #reactives <- readRDS("c:/tmp/reactives.RData")
      for(i in seq(length(reactives[["priors"]]))){
        p <- p + geom_line(data = reactives[["priors"]][[i]])
      }
      p + scale_x_continuous(limits = c(-5, 5)) +
        theme_bw(base_size = 14) +
        theme(legend.title = element_blank()) +
        labs(x = "", y = "Density")
    }

  })
  output$prior_list <- renderUI({
    if(length(reactives[["priors"]]) > 0){
      pdeets <- sapply(reactives[["prior_deets"]], function(x){
        paste0(x[1], "(", paste0(names(x)[-1], " = ", x[-1], collapse = ", "), ")")
      })

      HTML(
        paste0("<ul>",
        paste0("<li>", reactives[["prior_names"]], ": ", pdeets, "</li>", collapse = ""),
        "</ul>", collapse = ""))
    }

  })


}

#' @title Interactively Sample from the Prior Distribution
#' @description Launches a `Shiny` app that allows interactive comparison of
#' different priors for \code{\link{brma}}.
#' @return NULL, function is called for its side-effect of launching a Shiny
#' app.
#' @examples
#' \dontrun{
#' shiny_prior()
#' }
#' @import shiny
#' @import ggplot2
#' @export
shiny_prior <- function(){
  shinyApp(ui = ui, server = server)
}

