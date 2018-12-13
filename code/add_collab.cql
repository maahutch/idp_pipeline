//Add Collaborations

USING PERIODIC COMMIT 
LOAD CSV WITH HEADERS FROM "file:///collaborators.csv" AS collab
MATCH (a:organization{savi_id:collab.`BaseOrgID`})
MATCH (b:organization{savi_id:collab.`CollabOrgID`})
CREATE (a)-[:COLLABORATES_WITH]->(b)
