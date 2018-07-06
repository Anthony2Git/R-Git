#*************************************************************
# Export NetCDF file to TIFF: Single or Multiple File
#*************************************************************
rm(list=ls())
library(ncdf4)
library(raster)
library(rgdal)

date <- as.Date(as.character(20140101), "%Y%m%d")
seq(date, by = "1 day", length.out = 20)

yy = ((2017-1981)+1)*12   ; yy
# Monthly data sequence
date <- as.Date(as.character(19810101), "%Y%m%d")
days = seq(date, by = "1 months", length.out = yy)
days

#
#Working directory
PATH="D:\\PhD\\Publication\\data\\nc\\"
setwd(PATH)
INTO="SM_global_1981-2017.nc"
#INTO="SM_NCEP_JAN-MAY_1981-2018.nc"
OUTO="SM_NCEP_JAN-MAY_2018.tif"
nc<-nc_open(INTO)
summary(nc)
print(nc)
#Output variable
varsal <- brick(INTO, varname="w")
summary(varsal)

# Define the coordinate System
crs(varsal) <- CRS('+init=EPSG:4326')

print(varsal)
r<-stack(varsal)
print(r)
x = days
names(r) = x
names(r)
extent(r) <- extent(0, 360, -90, 90)
rr <- rotate(r)
print(rr)
names(rr)
#*************************************************************
#Save all layers in a single TIFF file
#*************************************************************
######writeRaster(rr, filename="tair.tif", format="GTiff",overwrite=TRUE)
#*************************************************************

#Save each layer in a multiple TIFF file
#*************************************************************
gsub("[.]", "-", substr(names(r), 2, 8))
#Numbers of layers
NL<-nlayers(r)
NL
#Cicle for save each TIFF file
for(i in 1:NL){
  plot(rr[[i]])
  #filout=paste0("SM_Global_",gsub("[.]", "-", substr(names(r), 2, 8))[i],".tif")
  #writeRaster(rr[[i]], filename=filout, format="GTiff",overwrite=TRUE)
  filout=paste0("SM_Global_",gsub("[.]", "-", substr(names(r), 2, 8))[i],".bil")
  writeRaster(rr[[i]], filename=filout, format="BIL",overwrite=TRUE)
}

rm(list=ls())
