Some R code examples for plotting GCMS data under the AIA data structure
Only .CDF files are used in the .AIA folder as all data appears to be stored there

This is created as a part of the "Microbial Production of Capnellene A Structurally Unique Coral Metabolite" dissertation submitted to University of Auckland

-Code included-
cdf_open.r: opens the sample1.CDF file provided, extracts and plots GC-MS TIC intensity values and uses data recored on retention_time.csv for time points
cdf_open_autotime: same as cdf_open.r but automatically caluculates time using data from sample1.CDF, not used in dissertation to prevent rounding discrepencies 
ms_opem.r: reads, interprets and outputs the MS spectrum at a specific time point (index number of the scan), also automacticly decides which peaks to label

!not tested with any other chromatography system other than the Agilent 5977A Series GC/MSD