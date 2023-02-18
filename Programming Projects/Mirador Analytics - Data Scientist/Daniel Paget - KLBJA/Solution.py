import pandas
import math
import matplotlib.pyplot as plt
import numpy as np

dsta = pandas.read_csv("tasksheetdataa.csv")
dstz = pandas.read_csv("tasksheetdataz.csv")

dstz_columns_new    = dstz.columns.values
dstz_columns_new[1] = 'zcta5'
dstz_columns_new[4] = 'stusab_Z'
dstz.columns        = dstz_columns_new
dsta = dsta.join( dstz.set_index('zcta5'), how='inner', on='zcta5')


states = set(dsta['state'])
c_state = ""

state_zip_counts = {}
while (c_state!=None):
    try:
        c_state = states.pop()
        dsta_zipsPerState = dsta.loc[dsta['state']==c_state, 'zcta5']
        state_zip_counts[c_state] = len(set(dsta_zipsPerState))
    except Exception as e:
        c_state = None

print("     part (A) code answer")
print(max(state_zip_counts, key=state_zip_counts.get))
print(state_zip_counts[max(state_zip_counts, key=state_zip_counts.get)])



index_most_east   = (dsta[dsta['state'].notna()])['longitude'].idxmax()
index_most_west   = (dsta[dsta['state']!='Alaska'])['longitude'].idxmin()
index_most_north  = (dsta[dsta['state']!='Alaska'])['latitude'].idxmax()
dsta_latrow_east  = dsta.loc[index_most_east]
dsta_latrow_west  = dsta.loc[index_most_west]
dsta_latrow_north = dsta.loc[index_most_north]

print("-- # # # -- part (B)")
print(dsta_latrow_east)
print(dsta_latrow_east[20])
print(dsta_latrow_east[27])
print("     -     ")
print("     -     ")
print("     -     ")
print(dsta_latrow_west)
print(dsta_latrow_west[20])
print(dsta_latrow_west[27])
print("     -     ")
print("     -     ")
print("     -     ")
print(dsta_latrow_north)
print(dsta_latrow_north[20])
print(dsta_latrow_north[26])
print("-- # # # --")


print("       part (C) code answer")
dsta['popden_hu'] = dsta['arealand'] / dsta['hu100']
print(dsta[['popden_hu', 'zcta5']])
print(dsta.loc[dsta['popden_hu'].idxmin()][20])
print(dsta.loc[dsta['popden_hu'].idxmin()][29])
print(list(dsta.loc[dsta['popden_hu'].idxmin()]))
print(list(dsta.loc[dsta['popden_hu'].idxmin()].index))



dsta['zcta3'] = (dsta['zcta5'].astype(str)).str.zfill(5).str.slice(0,3)
zips = set(dsta['zcta3'])
c_zip = ""

zip_state_counts = {}
while (c_zip!=None):
    try:
        c_zip = zips.pop()
        dsta_statesPerzip = dsta.loc[dsta['zcta3']==c_zip, 'state']
        if (len(set(dsta_statesPerzip)) > 1): 
            print(c_zip, ":")
            print(len(set(dsta_statesPerzip)))
            print(set(dsta_statesPerzip))
        state_set = set(dsta_statesPerzip)
        zip_state_counts[c_zip] = len(state_set)
    except Exception as e:
        c_zip = None

zips_with_multiple_states = [_zip for _zip,count in zip_state_counts.items() if count > 1]
print(zips_with_multiple_states)
print(zip_state_counts['063'])
print(len(zips_with_multiple_states))
print((dsta[ dsta['zcta3'].isin(zips_with_multiple_states) ])[['zcta3', 'zcta5', 'state', 'arealand']])


small_dst = dsta[['zcta3','state','pop100','arealand']] 
a = small_dst['zcta3']=='063' 
b = small_dst['state']=='New York'
small_dst = small_dst.drop(small_dst[a & b].index)
a = small_dst['zcta3']=='834' 
b = small_dst['state']=='Wyoming'
small_dst = small_dst.drop(small_dst[a & b].index)

zip3list = set(small_dst['zcta3'])
c_zip = ""
small_zip_count = 0
small_zips_list = []
while c_zip != None:
    try:
        c_zip = zip3list.pop()
        c_pop_sum = small_dst.loc[ small_dst['zcta3'] == c_zip, 'pop100' ].sum()
        if c_pop_sum < 20000 and c_pop_sum > 10:
            small_zip_count += 1
            small_zips_list.append(c_zip)
    except:
        c_zip = None
    
    
print("Small zip count: ", small_zip_count)



small_dst['popden_area'] = small_dst['pop100'] / (small_dst['arealand']/(1600*1600))

small_zips_arealand    = [] 
small_zips_pop100      = [] 
small_zips_popden_area = [] 

zip3list = set((small_dst[ small_dst['zcta3'].isin(small_zips_list) ])['zcta3'])
print("                 /", len(zip3list))
c_zip = ""
small_zip_count = 0
actual_zips     = []
three_zip_pops  = []
three_zip_areas = []
while c_zip != None:
    try:
        c_zip = zip3list.pop()
        c_pop_sum      = small_dst.loc[ small_dst['zcta3'] == c_zip, 'pop100' ].sum()
        c_arealand_sum = small_dst.loc[ small_dst['zcta3'] == c_zip, 'arealand' ].sum()
        small_zips_pop100.append(c_pop_sum)
        small_zips_arealand.append(c_arealand_sum)
        small_zips_popden_area.append(c_pop_sum / (c_arealand_sum/(1600*1600)))
        actual_zips.append(c_zip)
    except:
        c_zip = None

c = zip(small_zips_popden_area, small_zips_arealand, small_zips_pop100, actual_zips)
c = sorted(c)
small_zips_popden_area, small_zips_arealand, small_zips_pop100, actual_zips = zip(*c)

plt.plot(small_zips_popden_area, 'r.')
plt.plot(small_zips_arealand, 'g.')
plt.plot(small_zips_pop100, 'b.')
plt.plot(small_zips_popden_area, 'r-', label="Population Density")
plt.plot(small_zips_arealand, 'g-', label="Land Area")
plt.plot(small_zips_pop100, 'b-', label="Population")
plt.yscale('log')
plt.title("Population distribution and land area")
plt.legend()
plt.savefig("small_zcta3_pop_dist.png")
plt.close() 



print(small_zips_popden_area[0], actual_zips[0])
print( dsta[ dsta['zcta3']=="821" ]['pop100'].to_string() )

zips_arealand    = list(dsta['arealand'])
zips_pop100      = list(dsta['pop100'])

c = zip(zips_pop100, zips_arealand)
c = sorted(c)
zips_pop100, zips_arealand = zip(*c)

plt.plot(zips_arealand, '.', markersize=1 , label="Land Area")
plt.plot(zips_pop100, '.', markersize=1, label="Population")
plt.yscale('log')
plt.title("Population distribution and land area for zcta5")
plt.legend()
plt.ylabel("Population / Land area (meters squared)")
plt.xlabel("Zip codes index in sorted order")
plt.savefig("zcta5_pop_vs_area_dist.png")
plt.close() 



small_dst = dsta[['zcta3','state','pop100','arealand']] 

zip3list = set(small_dst['zcta3'])
c_zip = ""
small_zip_count = 0
three_zip_pops  = []
three_zip_areas = []
while c_zip != None:
    try:
        c_zip = zip3list.pop()
        c_pop_sum      = small_dst.loc[ small_dst['zcta3'] == c_zip, 'pop100' ].sum()
        c_arealand_sum = small_dst.loc[ small_dst['zcta3'] == c_zip, 'arealand' ].sum()
        three_zip_pops.append(c_pop_sum)
        three_zip_areas.append(c_arealand_sum)
    except:
        c_zip = None


c = zip(three_zip_pops, three_zip_areas)
c = sorted(c)
three_zip_pops, three_zip_areas = zip(*c)
plt.plot(three_zip_areas, 'g.', markersize=3 , label="Land Area")
plt.plot(three_zip_pops, 'k.', markersize=3, label="Population")
plt.yscale('log')
plt.title("Population distribution and land area for zcta3")
plt.legend()
plt.ylabel("Population / Land area (meters squared)")
plt.xlabel("Zip codes index in sorted order")
plt.savefig("zcta3_pop_vs_area_dist.png")
plt.close() 






