
library(RNeo4j)

pswd <- readChar('~/idp_pipeline/data/pswd', file.info('~/idp_pipeline/data/pswd')$size-1)

#Connect to database
conn <- startGraph("http://localhost:7474/db/data/", username="neo4j", password=pswd)

#Read Opioid Related Coalitions file
coal <- read.csv('~/idp_pipeline/data/Opioid Related Coalitions.csv', header = T, stringsAsFactors = F)

coal_fn <- read.csv('~/idp_pipeline/data/op_coal_fullnames.csv')

coalitions <- colnames(coal[6:ncol(coal)])



#Create coalition nodes and connect them to organizations

add_coalitions2 <- function(name, raw_dat, fn){
  
  full_name <- subset(fn[,2], fn[,1] == name)
  
  make_coal_q <- paste0("CREATE (c:coalition{name:'", name, "'})
                          SET c.full_name = '",       full_name, "'")
  
  tryCatch(cypher(conn, make_coal_q), error=function(e){})
  
  
  coal.nm <- which(colnames(raw_dat) == name)
  
  one.coal <- raw_dat[, c(1, 2, coal.nm)]
  
  one.coal <- subset(one.coal[, 1:2], one.coal[, 3] == 1)
  
  one.coal[is.na(one.coal)] <- ""
  
  savi_id <- one.coal$savi_id[one.coal$savi_id != ""]
  
  com_id  <- one.coal$com_id[one.coal$com_id != ""]
  
  for(i in savi_id){
    
   savi_coal_q <- paste0("MATCH (a:organization{savi_id:'", i, "'}),
                                (b:coalition{name:'", name, "'})
                          MERGE (a)-[:MEMBER_OF]->(b)"
                          )
   
    tryCatch(cypher(conn, savi_coal_q), error=function(e){})
    
  }
  
  for(j in com_id){
    
    com_coal_q <- paste0("MATCH (a:organization{com_id:'", j, "'}),
                                 (b:coalition{name:'", name, "'})
                          MERGE (a)-[:MEMBER_OF]->(b)"
    )
    
    tryCatch(cypher(conn, com_coal_q), error=function(e){})
    
  }
  
  return('OK')
}

sapply(coalitions, add_coalitions2, raw_dat = coal, fn = coal_fn, simplify = T)
