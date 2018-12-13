library(RNeo4j)

#Read combo.csv
combo <- read.csv('~/idp_pipeline/data/combo.csv', header = T)

#Read password file
pswd <- readChar('~/idp_pipeline/data/pswd', file.info('~/idp_pipeline/data/pswd')$size-1)

#Open Connection to database
conn <- startGraph("http://localhost:7474/db/data/", username="neo4j", password=pswd)



#Add Uniqueness constraints to DB
cypher(conn, 'CREATE CONSTRAINT ON (cat:category)   ASSERT cat.category   IS UNIQUE')
cypher(conn, 'CREATE CONSTRAINT ON (a:asset_savi)   ASSERT a.asset_id     IS UNIQUE')
cypher(conn, 'CREATE CONSTRAINT ON (c:coalition)    ASSERT c.name         IS UNIQUE')
cypher(conn, 'CREATE CONSTRAINT ON (o:organization) ASSERT o.blended_id   IS UNIQUE')
cypher(conn, 'CREATE CONSTRAINT ON (o:lat_lon)      ASSERT o.lat_lon      IS UNIQUE')
cypher(conn, 'CREATE CONSTRAINT ON (o:program)      ASSERT o.name         IS UNIQUE')


#Add indexes to DB for fields searched by web app
cypher(conn, 'CREATE INDEX ON :organization(latitude)')
cypher(conn, 'CREATE INDEX ON :organization(longitude)')
cypher(conn, 'CREATE INDEX ON :organization(opioid_involved)')
cypher(conn, 'CREATE INDEX ON :organization(savi_id)')
cypher(conn, 'CREATE INDEX ON :organization(com_id)')


#Writes csv's to default path. May need to be changed depending on installation

#Create orgs
org.df <- data.frame(master_id          = combo$master_id, 
                     blended_id         = combo$blended_id,
                     savi_id            = combo$savi_id,
                     opioid_involved    = combo$opioid_involved, 
                     workforce_involved = combo$workforce_involved,
                     org_name           = combo$orgname_cap,
                     lat_lon            = combo$lat_lon, 
                     latitude           = combo$lat, 
                     longitude          = combo$long, 
                     com_id             = combo$com_id, 
                     naicsmap           = combo$naicsmap
                     )

write.csv(org.df, '/usr/local/neo4j-community-3.3.0/import/org.csv', row.names = F)

#Create lat_lon
lat_lon.df <- data.frame(lat_lon   = combo$lat_lon,
                         longitude = combo$long,
                         latitude  = combo$lat
                     )

lat_lon.df <- lat_lon.df[!grepl("NA_NA", lat_lon.df$lat_lon),]



write.csv(lat_lon.df, '/usr/local/neo4j-community-3.3.0/import/lat_lon.csv', row.names = F)


#Create org to lat_lon relationships
org_to_lat_lon.df <- data.frame(blended_id = combo$blended_id, 
                                lat_lon    = combo$lat_lon)


org_to_lat_lon.df <- unique(org_to_lat_lon.df[,1:2])

org_to_lat_lon.df <- org_to_lat_lon.df[!grepl("NA_NA", org_to_lat_lon.df$lat_lon),]


write.csv(org_to_lat_lon.df, '/usr/local/neo4j-community-3.3.0/import/org_to_lat_lon.csv', row.names = F)


#Create asset
asset.df <- data.frame(asset_id    = combo$savi_id, 
                       address     = combo$street_address,
                       source_name = combo$SourceName)



write.csv(asset.df, '/usr/local/neo4j-community-3.3.0/import/asset.csv', row.names = F)


#Create org to asset relationships
org_to_asset.df <- data.frame(asset_id   = combo$savi_id, 
                              blended_id = combo$blended_id)

org_to_asset.df <- unique(org_to_asset.df[,1:2])

org_to_asset.df <- org_to_asset.df[!grepl("NA_NA", org_to_asset.df$blended_id),]

write.csv(org_to_asset.df, '/usr/local/neo4j-community-3.3.0/import/org_to_asset.csv', row.names = F)


#Create cat 
cat.df <- na.omit(unique(data.frame(cat = c(toupper(as.character(combo$CATEGORY1.x)), 
                                            toupper(as.character(combo$CATEGORY2.x)), 
                                            toupper(as.character(combo$CATEGORY3.x)),
                                            toupper(as.character(combo$CATEGORY4.x)),
                                            toupper(as.character(combo$CATEGORY1.y)), 
                                            toupper(as.character(combo$CATEGORY2.y)), 
                                            toupper(as.character(combo$CATEGORY3.y)),
                                            toupper(as.character(combo$CATEGORY4.y))))))

write.csv(cat.df, '/usr/local/neo4j-community-3.3.0/import/cat.csv', row.names = F )

#Create Cat to Organization

#masterfile org/cat
org_to_cat1x.df <- na.omit(data.frame(blended_id =                      combo$blended_id,
                                      cat        = toupper(as.character(combo$CATEGORY1.x))))

org_to_cat1x.df <- unique(org_to_cat1x.df[,1:2])

write.csv(org_to_cat1x.df, '/usr/local/neo4j-community-3.3.0/import/org_to_cat1x.csv', row.names = F )



org_to_cat2x.df <- na.omit(data.frame(blended_id =              combo$blended_id,
                                      cat        = toupper(as.character(combo$CATEGORY2.x))))

org_to_cat2x.df <- unique(org_to_cat2x.df[,1:2])

write.csv(org_to_cat2x.df, '/usr/local/neo4j-community-3.3.0/import/org_to_cat2x.csv', row.names = F )



org_to_cat3x.df <- na.omit(data.frame(blended_id =              combo$blended_id,
                                      cat        = toupper(as.character(combo$CATEGORY3.x))))

org_to_cat3x.df <- unique(org_to_cat3x.df[,1:2])

write.csv(org_to_cat3x.df, '/usr/local/neo4j-community-3.3.0/import/org_to_cat3x.csv', row.names = F )




org_to_cat4x.df <- na.omit(data.frame(blended_id =              combo$blended_id,
                                      cat        = toupper(as.character(combo$CATEGORY4.x))))

org_to_cat4x.df <- unique(org_to_cat4x.df[,1:2])

write.csv(org_to_cat4x.df, '/usr/local/neo4j-community-3.3.0/import/org_to_cat4x.csv', row.names = F )




#savifile org/cat
org_to_cat1y.df <- na.omit(data.frame(blended_id =              combo$blended_id,
                                      cat        = toupper(as.character(combo$CATEGORY1.y))))

org_to_cat1y.df <- unique(org_to_cat1y.df[,1:2])

write.csv(org_to_cat1y.df, '/usr/local/neo4j-community-3.3.0/import/org_to_cat1y.csv', row.names = F )



org_to_cat2y.df <- na.omit(data.frame(blended_id =              combo$blended_id,
                                      cat        = toupper(as.character(combo$CATEGORY2.y))))

org_to_cat2y.df <- unique(org_to_cat2y.df[,1:2])

write.csv(org_to_cat2y.df, '/usr/local/neo4j-community-3.3.0/import/org_to_cat2y.csv', row.names = F )



org_to_cat3y.df <- na.omit(data.frame(blended_id =              combo$blended_id,
                                      cat        = toupper(as.character(combo$CATEGORY3.y))))

org_to_cat3y.df <- unique(org_to_cat3y.df[,1:2])

write.csv(org_to_cat3y.df, '/usr/local/neo4j-community-3.3.0/import/org_to_cat3y.csv', row.names = F )



org_to_cat4y.df <- na.omit(data.frame(blended_id =              combo$blended_id,
                                      cat        = toupper(as.character(combo$CATEGORY4.y))))

org_to_cat4y.df <- unique(org_to_cat4y.df[,1:2])

write.csv(org_to_cat4y.df, '/usr/local/neo4j-community-3.3.0/import/org_to_cat4y.csv', row.names = F )






