import cdsapi

import  datetime as dt

c = cdsapi.Client()

def download_lev(var,vname,vnum,datain,dire,lat,lon):

    name   ='e5.oper.an.pl.128_%s_%s.ll025sc.%s'%(vname,vnum,datain) 
    c.retrieve("reanalysis-era5-pressure-levels",
    {
    "variable": var,
    
    "pressure_level": [
                        '1000', '975', '950', '925', '900',
                        '875' , '850', '825', '800', '775',
                        '750' , '700', '650', '600', '550', 
                        '500' , '450', '400', '350', '300',
                        '250' , '225', '200', '175', '150', 
                        '125' , '100', '70' , '50' , '30' , 
                        '20'  , '10' , '7'  , '5'  , '3'  , 
                        '2'   , '1'  ,
                      ],
    #'area': [
    #        15, -90, -60,
    #        -30,
    #    ],
    'area': [
            lat[0], lon[0], lat[1],
            lon[1],
        ],
    "product_type": "reanalysis",
    "year"  : "%s"%(datain[0:4]),
    "month" : "%s"%(datain[4:6]),
    "day"   : "%s"%(datain[6:8]),
    "time"  : "%s:00"%(datain[8:10]),
    "format": "grib"
    }, "%s/%s.grib"%(dire,name))

    return 

def download_sfc(var,vname,vnum,datain,dire,lat,lon):

    name   ='e5.oper.an.sfc.128_%s_%s.ll025sc.%s'%(vname,vnum,datain) 
    c.retrieve("reanalysis-era5-single-levels",
    {
    'area': [
            lat[0], lon[0], lat[1],
            lon[1],
        ],
    "variable": var,
    "product_type": "reanalysis",
    "year"  : "%s"%(datain[0:4]),
    "month" : "%s"%(datain[4:6]),
    "day"   : "%s"%(datain[6:8]),
    "time"  : "%s:00"%(datain[8:10]),
    "format": "grib"
    }, "%s/%s.grib"%(dire,name))

    return 

def dates2download(datain,dataout,nhpull):
    #datein 
    #datefinal
    #nhpull number of hours to pull 
    #2014-02-01T00:00
    date_format ='%Y%m%d%H'##+':00.00000000'
    
    di=dt.datetime.strptime(datain , date_format)

    month   =di.month
    year    =di.year

    df=dt.datetime.strptime(dataout, date_format)
    
    d  =(df-di)

    nh =int(d.total_seconds()//(3600))

    try:
        nd=d.days
    except: 
        nd=0
    
    deltat=dt.timedelta(hours=int(nhpull))
    
    days=di
    
    #if nd==0:
    #    nf=int(nh)
    #else:
    #    nf=int(nd)*24+int(nh)
    
    datetd=[]
    hours =[]

    h0=0
    k =0

    for i in range(0,int(nh)+1,nhpull):   #+1 for the last day 
    
        datetd.append(days.strftime(date_format))

        hours.append(days.hour)

        days =days+deltat

        k+=1

    return datetd,hours 
    
    
