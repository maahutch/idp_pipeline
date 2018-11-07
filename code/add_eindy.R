library(RNeo4j)

pswd <- as.character(read.delim("~/idp_pipeline/code/pswd.txt", header = F)[1,1])

#Connect to database
conn <- startGraph("http://localhost:7474/db/data/", username="neo4j", password=pswd)


eindy <- read.csv('~/idp_pipeline/data/eindy.csv', header = T, stringsAsFactors = F)



programs <- colnames(eindy)[12:ncol(eindy)]


add.programs <- function(name, raw_dat){
  
  make_indy_q <- paste0("CREATE (c:program{name:'", name, "'})")
  
  tryCatch(cypher(conn, make_indy_q), error=function(e){})
  
  
  ind.nm <- which(colnames(raw_dat) == name)
  
  one.ind <- raw_dat[, c(1, 2, ind.nm)]
  
  one.ind <- subset(one.ind[, 1:2], one.ind[, 3] == 1)
  
  one.ind[is.na(one.ind)] <- ""
  
  savi_id <- one.ind$savi_id[one.ind$savi_id != ""]
  
  com_id  <- one.ind$com_id[one.ind$com_id != ""]
  
  for(i in savi_id){
    
    savi_coal_q <- paste0("MATCH (a:organization{savi_id:'", i, "'}),
                                 (b:program{name:'", name, "'})
                          MERGE  (a)-[:MEMBER_OF]->(b)"
    )
    
    tryCatch(cypher(conn, savi_coal_q), error=function(e){})
    
  }
  
  for(j in com_id){
    
    com_coal_q <- paste0("MATCH (a:organization{com_id:'", j, "'}),
                                (b:program{name:'", name, "'})
                          MERGE (a)-[:MEMBER_OF]->(b)"
    )
    
    tryCatch(cypher(conn, com_coal_q), error=function(e){})
    
  }
  
  return('OK')
}


sapply(programs, add.programs, raw_dat = eindy, simplify = T)



