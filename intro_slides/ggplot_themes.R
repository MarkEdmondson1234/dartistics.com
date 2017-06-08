# ---- default-theme ----
####################
# Define base theme You have an option of tweaking settings
# here OR in the actual functions/output that use default_theme
####################

default_theme <-   theme_bw() +
  theme(axis.text = element_text(face = "bold", size = 20, colour = "black"),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.line.x = element_line(colour = "grey30"),
        axis.line.y = element_blank(),
        legend.title = element_blank(),
        legend.background = element_blank(),
        legend.position = "top",
        legend.justification = "center",
        panel.border = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(colour = "grey90"),
        panel.grid.minor = element_blank()
  )

theme_bar <- default_theme +
  theme(panel.grid.major.y = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(face = "bold", size = 20, colour = "grey5",
                                   margin = margin(10,0,0,0, "pt")))

theme_bar_horiz <- default_theme +
  theme(axis.text.y = element_text(face = "plain", size = 12, colour = "grey5",
                                   margin = margin(10,0,0,0, "pt")),
        axis.line.x = element_blank(),
        axis.line.y = element_line(colour = "grey30"),
        axis.text.x = element_blank(),
        panel.grid.major.y = element_blank())


theme_heatmap <- default_theme +
  theme(panel.grid.major.y = element_blank(),
        axis.text.x = element_text(face = "plain", size = 15, colour = "black",
                                 margin = margin(0,0,10,0)),
        axis.text.y = element_text(face = "plain", size = 15, colour = "black",
                                   margin = margin(0,0,0,10)),
        axis.title = element_text(face = "bold", size = 20, colour = "black"),
        axis.line.x = element_blank(),
        legend.position = "none")
