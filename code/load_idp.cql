//Add organizations
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org.csv" AS org
MERGE (o:organization{blended_id:org.blended_id})
SET o.master_id          = org.`master_id`,
    o.savi_id            = org.`savi_id`,
    o.opioid_involved    = org.`opioid_involved`, 
    o.workforce_involved = org.`workforce_involved`,
    o.org_name           = org.`orgname_cap`,
    o.lat_lon            = org.`lat_lon`,
    o.latitude           = org.`latitude`, 
    o.longitude          = org.`longitude`, 
    o.com_id             = org.`com_id`, 
    o.org_name           = org.`org_name`     
//RETURN "Organization loaded"
;

//Add lat_lon
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///lat_lon.csv" AS lat_lon
MERGE (ll:lat_lon{lat_lon:lat_lon.lat_lon})
SET ll.latitude  = lat_lon.`latitude`,
    ll.longitude = lat_lon.`longitude`
//RETURN "Coordinate loaded"
;


//Add org to lat_lon
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_lat_lon.csv" AS org2ll
MATCH (a:organization{blended_id:org2ll.`blended_id`})
MATCH (b:lat_lon{lat_lon:org2ll.`lat_lon`})
CREATE (a)-[:LOCATED_IN]->(b)
//RETURN "Connected Organization to Coordinate"
;


//Add assets
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///asset.csv" AS asset
MERGE (ast:asset_savi{asset_id:asset.`asset_id`})
SET ast.address     = asset.`address`,
    ast.source_name = asset.`source_name`
//RETURN "Asset loaded"
;


// Add assets to org
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_asset.csv" AS org2a
MATCH (a:organization{blended_id:org2a.`blended_id`})
MATCH (b:asset_savi{asset_id:org2a.`asset_id`})
CREATE (b)-[:OPERATED_BY]->(a)
//RETURN "Connected Organization to Asset"
;


//Add categories
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///cat.csv" AS ct 
MERGE (cat:category{category:ct.`cat`})
//RETURN "Category loaded"
;


//Add categories to organizations

//masterfile categories
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_cat1x.csv" as org2cat
MATCH  (a:organization{blended_id:org2cat.`blended_id`})
MATCH  (b:category{category:org2cat.`cat`})
CREATE (a)-[:PART_OF]->(b)
;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_cat2x.csv" as org2cat
MATCH  (a:organization{blended_id:org2cat.`blended_id`})
MATCH  (b:category{category:org2cat.`cat`})
CREATE (a)-[:PART_OF]->(b)
;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_cat3x.csv" as org2cat
MATCH  (a:organization{blended_id:org2cat.`blended_id`})
MATCH  (b:category{category:org2cat.`cat`})
CREATE (a)-[:PART_OF]->(b)
;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_cat4x.csv" as org2cat
MATCH  (a:organization{blended_id:org2cat.`blended_id`})
MATCH  (b:category{category:org2cat.`cat`})
CREATE (a)-[:PART_OF]->(b)
;


//savifile categories

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_cat1y.csv" as org2cat
MATCH  (a:organization{blended_id:org2cat.`blended_id`})
MATCH  (b:category{category:org2cat.`cat`})
CREATE (a)-[:PART_OF]->(b)
;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_cat2y.csv" as org2cat
MATCH  (a:organization{blended_id:org2cat.`blended_id`})
MATCH  (b:category{category:org2cat.`cat`})
CREATE (a)-[:PART_OF]->(b)
;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_cat3y.csv" as org2cat
MATCH  (a:organization{blended_id:org2cat.`blended_id`})
MATCH  (b:category{category:org2cat.`cat`})
CREATE (a)-[:PART_OF]->(b)
;

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///org_to_cat4y.csv" as org2cat
MATCH  (a:organization{blended_id:org2cat.`blended_id`})
MATCH  (b:category{category:org2cat.`cat`})
CREATE (a)-[:PART_OF]->(b)
//RETURN "Connected Organization to Category"
;




