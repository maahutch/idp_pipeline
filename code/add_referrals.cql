//Add referrals

USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///Opioid_Referral_Listing.csv" AS opRL
MATCH (a:organization{savi_id:opRL.`savi_id_source`})
MATCH (b:organization{savi_id:opRL.`savi_id_dest`})
CREATE (a)-[:REFERRED_TO]->(b)
;
