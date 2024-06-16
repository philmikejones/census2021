library("dplyr")
library("readr")
library("stringr")
library("tidyr")
library("apyramid")
library("ggplot2")
library("scales")

dir.create("figures", showWarnings = FALSE)

data = readr::read_csv("data/census-2021-age-sex.csv", skip = 9, show_col_types = FALSE, n_max = 91)

data$Age = str_replace_all(data$Age, "Aged ", "")
data$Age = str_replace_all(data$Age, " years", "")
data$Age = str_replace_all(data$Age, " year", "")
data$Age = str_replace_all(data$Age, " and over", "")
data$Age[data$Age == "under 1"] <- "0"
data$Age = as.integer(data$Age)
data$Female = as.integer(data$Female)
data$Male = as.integer(data$Male)

data = pivot_longer(data, cols = c("Female", "Male"))
data = rename(data, Sex = name, Count = value)

# https://cran.r-project.org/web/packages/apyramid/vignettes/intro.html
data$Age = cut(data$Age, breaks = pretty(data$Age, n = 20), right = TRUE, include.lowest = TRUE)

plot =
    age_pyramid(data, age_group = Age, split_by = Sex, count = Count)
plot

ggsave("figures/age-sex-pyramid.pdf", plot = plot, width = 420, height = 297, units = "mm", dpi = 300)
ggsave("figures/age-sex-pyramid.png", plot = plot, width = 1680, height = 920, units = "px", dpi = 96)