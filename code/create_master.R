library(RODBC)

dbhandle <- odbcDriverConnect('driver={SQL Server};server=in-ibrc-db6.ads.iu.edu\\IDP;database=IDP; schema=dbo;')

dbhandle <- odbcDriverConnect('driver={SQL Server};
                              server=in-ibrc-db6.ads.iu.edu\\IDP;
                              database=IDP;
                              schema=dbo;
                              uid=iupui;
                              pwd=data@iupui;
                              trusted_connection=true')

master <- sqlQuery(dbhandle, 
                   "select ROW_NUMBER() OVER (ORDER BY a.source_type) AS master_id, a.source_type, b.irs_id, a.com_id, null as 'e1_id', b.sos_id, b.parcel_id, b.savi_id,
                      c.opioid_involved, d.workforce_involved, a.org_name, null as 'owner_name', null as 'dba', e.ContactFirst, e.ContactLast, f.in_care_of_name as 'in_care_of',
                     e.ParentId, e.HeadquartersId, e.Telephone, e.WebSite, e.BusDesc, e.PrimaryNaics, e.Naics2, e.Employment, e.SalesValue,
                     f.asset_amount, f.income_amount, f.form_990_Revenue_amount, null as purpose, null as 'total_funds', null as 'govt_funds',
                     h.AV_TOTAL_LAND_AND_IMPROVEMENTS, h.taxes_due, h.sq_feet, h.LEGALLY_DEEDED_ACREAGE, h.Property_Class_code,
                     d.congregation, d.childcare, d.substance_abuse,
                     i.CATEGORY1, i.CATEGORY2, i.CATEGORY3, i.CATEGORY4, 
                     a.street_address, a.city, a.zip, a.lat, a.long, a.census_tract, a.census_bg
                     from CORE_Entities a left join match_key b on isnull(a.com_id, 'null') = isnull(b.com_id, 'null') and isnull(a.savi_id, 'null') = isnull(b.savi_id, 'null') and isnull(a.misc_id, 'null') = isnull(b.misc_id, 'null')
                     left join polis.IDENTIFY_Initial_Requests c on isnull(a.com_id, 'null') = isnull(c.com_id, 'null') and isnull(a.savi_id, 'null') = isnull(c.savi_id, 'null') and isnull(a.misc_id, 'null') = isnull(c.misc_id, 'null')
                     left join ibrc.IDENTIFY_Initial_Requests d on isnull(a.com_id, 'null') = isnull(d.com_id, 'null') and isnull(a.savi_id, 'null') = isnull(d.savi_id, 'null') and isnull(a.misc_id, 'null') = isnull(d.misc_id, 'null')
                     left join ibrc.DATA_Com e on a.com_id = e.com_id
                     left join ibrc.DATA_IRS f on b.irs_id = f.irs_id
                     left join ibrc.DATA_Parcel h on b.parcel_id = h.Parcel_number
                     left join polis.Orgs_wCats i on b.savi_id = i.GroupNum
                     ")

file.name <- paste0("~idp_pipeline/data/master_", format(Sys.Date(), "%m_%d_%y"), ".csv")


write.csv(master, file.name, row.names = F)