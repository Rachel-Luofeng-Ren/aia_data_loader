    library(ncdf4)
    library(ggplot2)
    
    plot_data <- read.csv("retention_time.csv")
    
    cdf_file <- nc_open("sample1.CDF")
    MS_intensity <- ncvar_get(cdf_file, "intensity_values")
    MS_mass <- ncvar_get(cdf_file, "mass_values")
    MS_scale <- ncvar_get(cdf_file, "point_count")
    nc_close(cdf_file)
    

    time_number = 164
    
    MS_target <- MS_scale[1:time_number-1]
    MS_frame_L = sum(MS_target) + 1
    MS_frame_R = MS_frame_L + MS_scale[time_number] - 1
    
    MS_output <- data.frame(mass = MS_mass[MS_frame_L:MS_frame_R], 
                            intensity = MS_intensity[MS_frame_L:MS_frame_R])
    MS_output$mass <- round(MS_output$mass, digits=1)
    MS_output$peak <- 0

    MS_plot <- MS_output
    
    peak_min = 20
    frame_size = 5
    size_factor = 1.8
    peak_sep = 4
    intensity_sep = max(MS_plot$intensity)/30
    txt_sep = 2
    
    
    scan_number = nrow(MS_plot) - peak_sep
    frame_size_m1 = frame_size - 1
    skip_amount = 0
    
    for(i in 1:scan_number){
      skip_amount = skip_amount - 1
      if (skip_amount > 0){
        next
      }
      if (MS_plot[i, "intensity"] < max(MS_plot$intensity[(i+1):(i+peak_sep)])){
        next
      }
      
      scan_start = i - frame_size
      scan_end = i + frame_size
      if (scan_start < 1){
        scan_start = 1
      }
      if (scan_end > scan_number){
        scan_end = scan_number
      }
      
      avg_size = mean(MS_plot$intensity[scan_start:scan_end]) * size_factor
      if (MS_plot[i, "intensity"] > avg_size
          && MS_plot[i, "intensity"] > peak_min){
        if (skip_amount < 1 - txt_sep){
          MS_plot[i, "peak"] = 1
          skip_amount = peak_sep + 1
          next
        }
        
        skip_amount_m1 = skip_amount - 1
        
        intensity_diff = MS_plot$intensity[i - peak_sep + skip_amount_m1] - MS_plot$intensity[i]
        
        if (intensity_diff > intensity_sep) {
          MS_plot[i, "peak"] = 1
          MS_plot[i, "x_nudge"] = 1
          skip_amount = peak_sep + 1
          next
        }
        
        if (abs(intensity_diff) > intensity_sep) {
          MS_plot[i, "peak"] = 1
          MS_plot[i - peak_sep + skip_amount_m1, "x_nudge"] = -1
          skip_amount = peak_sep + 1
          next
        }
        
        if (MS_plot$intensity[i - peak_sep + skip_amount_m1] > MS_plot$intensity[i]) {
          MS_plot[i - peak_sep + skip_amount_m1, "peak"] = abs(intensity_diff)
          MS_plot[i, "peak"] = 1
          skip_amount = peak_sep + 1
          next
        }
        MS_plot[i, "peak"] = abs(intensity_diff) 
        skip_amount = peak_sep + 1
      }
    }
    
    ggplot(MS_plot, aes(x = mass, y = intensity)) +
      geom_segment(aes(x = mass, xend = mass, y = 0, yend = intensity), 
                   color = "red", linewidth = 1) +
      geom_text(data = subset(MS_plot, peak > 0), aes(label = mass, y = ifelse((peak> 1), intensity + intensity_sep - peak, intensity), x = mass), vjust = -0.5, size = 5) + 
      labs(x = "M/Z", y = "Relative Abundance") +
       scale_x_continuous(limits = c(50, 400), breaks = seq(50, 400, by = 10))  

    
