library(ncdf4)
library(ggplot2)

cdf_file <- nc_open("sample1.CDF")
var_data <- ncvar_get(cdf_file, "total_intensity")
scan_time_sec <- ncvar_get(cdf_file, "scan_acquisition_time")
nc_close(cdf_file)

scan_time_min <- round(scan_time_sec/60, digits = 3)

plot_data <- read.csv("retention_time.csv")
plot_data <- cbind(scan_time_min, var_data)


ggplot() +
  geom_line(data = plot_data, 
            aes(x = scan_time_sec, y = var_data), linewidth = 0.5)


