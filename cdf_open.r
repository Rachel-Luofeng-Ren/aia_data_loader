library(ncdf4)
library(ggplot2)

cdf_file <- nc_open("sample1.CDF")
var_data <- ncvar_get(cdf_file, "total_intensity")
nc_close(cdf_file)

plot_data <- read.csv("retention_time.csv")
plot_data <- cbind(plot_data, var_data)

ggplot() +
  geom_line(data = plot_data, 
            aes(x = retention_time, y = var_data), linewidth = 0.5)

