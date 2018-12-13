library(RNeo4j)

pswd <- readChar('~/idp_pipeline/data/pswd', file.info('~/idp_pipeline/data/pswd')$size-1)

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



cat.wi <- read.csv('~/idp_pipeline/data/workforce_cluster.csv', header = T, stringsAsFactors = F)

cat.wi[cat.wi == "NULL"] = NA


cat.wi$blended_id <- paste0(cat.wi$savi_id, '_', cat.wi$com_id)


add.color.cats <- function(number, data){
  
  blended_id  <- data[number, which(colnames(data) == "blended_id")]

  group_desc <- data[number, which(colnames(data) == "group_desc")]
  
  add.color.q <-
    paste0(
      "MATCH (a:organization)
      WHERE a.blended_id = '",
      blended_id,
      "' SET a.group = '",
      group_desc,
      "'"
    )

  
  cypher(conn, add.color.q)
 
}


sapply(2:nrow(cat.wi), add.color.cats, data = cat.wi)


