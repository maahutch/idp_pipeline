library(RNeo4j)


#Connect to DB
conn <- startGraph("http://localhost:7474/db/data/", username="neo4j", password="your password here")


#Build data frame of categories and path steps
entry.points2 <- toupper(c('911 Services',
                           'Clinics', 
                           'Courts',
                           'Emergency Minor Medical Facilities/Svcs', 
                           'Hospitals',
                           'Intermediate Care Facilities',
                           'Police Stations'
))

entry.points2.df <- data.frame(entry.points2, 'Entry Point')
colnames(entry.points2.df) <- c("Cat", "Point")


treatment.points2 <- toupper(c('Comprehensive Outpatient Substance Abuse Treatment',
                               'Detoxification',
                               'General Assessment for Substance Abuse',
                               'Methadone Maintenance'))
treatment.points2.df <- data.frame(treatment.points2, "Treatment Point")
colnames(treatment.points2.df) <- c("Cat", "Point")



recovery.points2 <- toupper(c('General Transitional Substance Abuse Services', 
                              'Mental Health Facilities', 
                              'Relapse Prevention Programs', 
                              'Substance Abuse Counseling' ))
recovery.points2.df <- data.frame(recovery.points2, "Recovery Point")
colnames(recovery.points2.df) <- c("Cat", "Point")


stabilization.points2 <- toupper(c('Alcohol/Substance Abuse Support Groups',
                                   'Family Preservation Programs', 
                                   'General Legal Aid',
                                   'Job Search/Placement', 
                                   'Job Training',
                                   'Mental Health Halfway Houses',
                                   'Mental Health Related Support Groups',
                                   'Mental Illness Support Groups', 
                                   'Supportive Recovery Homes'))
stabilization.points2.df <- data.frame(stabilization.points2, "Stabilization Point")
colnames(stabilization.points2.df) <- c("Cat", "Point")



prevention.points2 <- toupper(c('Pain',
                                'Drug Prescriptions',
                                'Other Public Awareness Programs',
                                'Medical Information Lines',
                                'Community Centers', 
                                'Other Information and Referral Services',
                                'Mental Health/Addictions',
                                'Emergenct Shelters'))
prevention.points2.df <- data.frame(prevention.points2, "Prevention Point")
colnames(prevention.points2.df) <- c("Cat", "Point")


path.df <- rbind(entry.points2.df, treatment.points2.df, recovery.points2.df, stabilization.points2.df, prevention.points2.df)


#Set levels for categories
new.entry.fun <- function(cat2, path.df){
  
  cat <- as.character(path.df[cat2, 1])
  
  point <- as.character(path.df[cat2, 2])
  
  q3 <- paste("MATCH (a:category{category:'",
              cat,
              "'})
              SET a.level = '",
              point ,
              "'",
              sep = "")
  
  cypher(conn, q3)
 
  return('OK')
}


sapply(1:nrow(path.df), new.entry.fun, path.df = path.df)



#Connect Categories of one level to categories for next level

add.rels <- function(cat3, path.df){
  
  one.rec <- path.df[cat3, ]
  
  if(one.rec[,2]=='Entry Point'){
    
    rel.q <- paste("MATCH (a:category{level:'", one.rec[,2], "'}), (b:category)
                      WHERE b.category = 'COMPREHENSIVE OUTPATIENT SUBSTANCE ABUSE TREATMENT' 
                      OR    b.category = 'DETOXIFICATION'
                      OR    b.category = 'GENERAL ASSESSMENT FOR SUBSTANCE ABUSE'
                      OR    b.category = 'METHADONE MAINTENANCE'
                      MERGE (a)-[:TRANSITIONS_TO]-(b)", 
                   sep = "")
    
    cypher(conn, rel.q)
    
  } else if(one.rec[,2]=='Treatment Point'){
    
    rel.q <- paste("MATCH (a:category{level:'", one.rec[,2], "'}), (b:category)
                      WHERE b.category = 'GENERAL TRANSITIONAL SUBSTANCE ABUSE SERVICES' 
                      OR    b.category = 'MENTAL HEALTH FACILITIES'
                      OR    b.category = 'RELAPSE PREVENTION PROGRAMS'
                      OR    b.category = 'SUBSTANCE ABUSE COUNSELING'
                      MERGE (a)-[:TRANSITIONS_TO]-(b)", 
                   sep = "")
    
    cypher(conn, rel.q)
    
  } else if(one.rec[,2]=='Recovery Point'){
    
    rel.q <- paste("MATCH (a:category{level:'", one.rec[,2], "'}), (b:category)
                      WHERE b.category = 'ALCOHOL/SUBSTANCE ABUSE SUPPORT GROUPS' 
                      OR    b.category = 'FAMILY PRESERVATION PROGRAMS'
                      OR    b.category = 'GENERAL LEGAL AID'
                      OR    b.category = 'JOB SEARCH/PLACEMENT'
                      OR    b.category = 'JOB TRAINING'
                      OR    b.category = 'MENTAL HEALTH HALFWAY HOUSES'
                      OR    b.category = 'MENTAL HEALTH RELATED SUPPORT GROUPS'
                      OR    b.category = 'MENTAL ILLNESS SUPPORT GROUPS'
                      OR    b.category = 'SUPPORTIVE RECOVERY HOMES'
                      MERGE (a)-[:TRANSITIONS_TO]-(b)", 
                   sep = "")
    
    cypher(conn, rel.q)
    
    
    
  }
   return('OK')
  
}

sapply(1:nrow(path.df), add.rels, path.df = path.df)





