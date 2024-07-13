library(ggplot2)
library(tidyverse)
library(scales)
library(colorspace)

# sample names have been extracted from the vnf file using a tool called bcftools 
file_path <- "data/samplenames.txt"
# Read the file into a vector
values <- readLines(file_path)
# Convert the vector to a data frame with a column name "sample"
samplelist <- data.frame(sample = values)

all_data <- tibble(sample=character(),
                   k=numeric(),
                   QN=numeric(),
                   Q=character(),
                   value=numeric())

for (k in 5:25){
  data <- read_delim(paste0("data/ALL.wgs.phase3_shapeit2_filtered.20141217.maf0.05.",k,".Q"),
                     col_names = paste0("Q",seq(1:k)),
                     delim=" ",show_col_types = FALSE)
  data$sample <- samplelist$sample
  data$k <- k
  
  #This step converts from wide to long.
  data %>% gather(Q, value, -sample,-k) -> data
  all_data <- rbind(all_data,data)
}
all_data$QN = factor(all_data$Q, paste0("Q",seq(1:25)), ordered=TRUE)
#all_data
#custom_palette <- hue_pal(h.start=90)(25) # Creates a palette with 25 distinct colors
custom_palette <- divergingx_hcl(25,"Roma")

all_data %>%
  filter(k <= 25) %>%
  #filter(sample == "HG00096") %>%
  #ggplot(.,aes(x=sample,y=value,fill=factor(Q))) + 
  ggplot(.,aes(x=sample,y=value,fill=QN)) + 
  geom_bar(stat="identity",position="stack") +
  xlab("Sample") + ylab("Ancestry") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  scale_fill_manual(values = custom_palette, name = "K", labels = seq(1:25)) +
  facet_wrap(~k,ncol=1)
# debug
#HG0096 <- tibble(sample=character(),
#                   k=numeric(),
#                   QN=numeric(),
#                   Q=character(),
#                   value=numeric())
#HG00096 <- all_data %>%
#  filter(k <= 25) %>%
#  filter(sample == "HG00096")
#HG00096$QN = factor(HG00096$Q, paste0("Q",seq(1:25)), ordered=TRUE)
#print(n=100,HG00096)

  