'''
**************************
Program Download the data of ERA5 to run de MPAS 

#################################################
To run:

Define :
    INITIAL DATA  
        datain ='1995010100'
    FINAL DATA  
        datain ='1995010123'
    Path to save the data 
        path= '/pwd'

#################################################
Before run the first time :

    see: https://cds.climate.copernicus.eu/api-how-to

    1) Go to  CDS registration page and make the sing in 
    2) Get the uid and api-key in your login information, CLick in your name upper rigth conner 
    3) Install pytho lib of era5: pip install cdsapi 

#################################################
Data:25-04-24
Created by: Jhonatan A. A. Manco
**************************
python 3.9

'''

import  os,sys

import  dfunctions as df 

path='/home/jhonatan.aguirre/MPAS_Model_Regional/pre/ERA5'

datain ='1997010100'
dataout='1997010123'

#Directory
dire='%s/%s'%(path,datain)

#Directory 2
# Check if the directory exists
if not os.path.exists(dire):
    # If it doesn't exist, create it
    os.makedirs(dire)

df.download_lev('temperature'        ,'t','129',datain,dataout,dire)
df.download_lev('geopotential'       ,'z','130',datain,dataout,dire)
df.download_lev('u_component_of_wind','u','131',datain,dataout,dire)
df.download_lev('v_component_of_wind','v','132',datain,dataout,dire)
df.download_lev('relative_humidity'  ,'r','157',datain,dataout,dire)

df.download_sfc('sea_ice_cover'                 ,'ci'   ,'031',datain,dataout,dire)
df.download_sfc('snow_density'                  ,'rsn'  ,'033',datain,dataout,dire)
df.download_sfc('sea_surface_temperature'       ,'sstk' ,'034',datain,dataout,dire)
df.download_sfc('volumetric_soil_water_layer_1' ,'swvl1','039',datain,dataout,dire)
df.download_sfc('volumetric_soil_water_layer_2' ,'swvl2','040',datain,dataout,dire)
df.download_sfc('volumetric_soil_water_layer_3' ,'swvl3','041',datain,dataout,dire)
df.download_sfc('volumetric_soil_water_layer_4' ,'swvl4','042',datain,dataout,dire)
df.download_sfc('surface_pressure'              ,'sp'   ,'134',datain,dataout,dire)
df.download_sfc('soil_temperature_level_1'      ,'stl1' ,'139',datain,dataout,dire)
df.download_sfc('soil_temperature_level_2'      ,'stl2' ,'170',datain,dataout,dire)
df.download_sfc('soil_temperature_level_3'      ,'stl3' ,'183',datain,dataout,dire)
df.download_sfc('soil_temperature_level_4'      ,'stl4' ,'236',datain,dataout,dire)
df.download_sfc('snow_depth'                    ,'sd'   ,'141',datain,dataout,dire)
df.download_sfc('mean_sea_level_pressure'       ,'msl'  ,'151',datain,dataout,dire)
df.download_sfc('10m_u_component_of_wind'       ,'10u'  ,'165',datain,dataout,dire)
df.download_sfc('10m_v_component_of_wind'       ,'10v'  ,'166',datain,dataout,dire)
df.download_sfc('2m_dewpoint_temperature'       ,'2d'   ,'167',datain,dataout,dire)
df.download_sfc('2m_temperature'                ,'2t'   ,'168',datain,dataout,dire)
df.download_sfc('skin_temperature'              ,'skt'  ,'235',datain,dataout,dire)
