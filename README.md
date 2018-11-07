# idp_pipeline
IDP ETL pipeline for MPH

## Summary
This respository contains code to export data from the IBRC-IDP database, combine it with the Savi Assets csv and load the data into a Neo4j graph database running on a localhost. Then it uses a series of additional csv's provided by the Polis center (via Brad Fulton) to add a series of additional relationships based on opioid treatment referrals, pathways to health and opioid treatment coalitions to the database. The current schema of the resulting database is described in the included pdf. 
Once completed, the intention is that the user will edit a configuration file to provide file paths and then run a single .exe file (or shell script) to build a new version of the database with the most current data from IBRC. This process could be set run on a regular basis (once a month, once a week etc.) to keep the graph database in sync with the IBRC data warehouse. It would probably be beneficial to at some point establish a live connection to the coalitions & referrals files, rather than relying on csv's in case the data is revised in the future. 

This pipeline was developed on RHEL 6.10 so file paths etc. follow the conventions of linux OS. 


## Steps to use this code
While this pipeline can be used, it is not yet complete to the extent that a user can clone the repository, compile the executable and run it to rebuild the database. The steps below document the current required to use this code. Hopefully, the number of steps will be reduced as the pipeline is refined. 

**1.** Install Neo4j Community Edition 3.4 or later. *This pipeline does not require 3.4 or later but the database must be this version or later for the web app to function correctly*

**2.** Edit the configuration file for the database to accept traffic on default port and create the bland database into which you will load the data.

**3.** Start the Neo4j server and set a password. *Alternatively disable password authentication if development environment is secure*.

**4.** Review file paths in all scripts. *Currently, all file paths are listed using format ~/ so if you have cloned this repo to your home directory you shoudln't need to make too many changes but you should probably check anyway*.

**5.** Make sure R and the following libraries are installed on your system: `RODBC`, `tidyr`, `stringi` and `RNeo4j`. *RNeo4j is no longer available on CRAN and will need to be installed from* [nicolewhite/RNeo4j](https://github.com/nicolewhite/RNeo4j). *See 'To Do' section for more details on this*. 

**6.** Add database password to connection strings in `add_pathways.R`, `add_coalitions.R`, 'build_csv.R` and `idp_build.cpp`.

**7.** Copy file `Opioid_Referral_Listing.csv` from the data folder to the Neo4j impor directory. Default locations for the Neo4j import directory can be found in the [Neo4j documentation](https://neo4j.com/docs/operations-manual/current/configuration/file-locations/)

**8.** Compile idp_build.cpp with something like `g++ -o idp_build idp_build.cpp` *This should probably be replaced with a shell script*

**9.** Run resulting executable. If everything is configured correctly, this should run the all the code in sequence and build the database in the current active database. 


## Script Summaries
Here I've tried to provide a short summary of each file in the /code directory in the order they are called by idp_build.cpp

#### idp_build.cpp
This is the control script that calls all the other scripts sequentially. Simply issues system commands and prints status messages. Can be replaced with a shell script. 

#### create_master.R
This script sends a query to the IBRC database and writes the result to the 'data' folder as a csv called 'master' followed by today's date. Currently, this script only works on my windows machine since it share's my credentials with SQL Server. I have contacted the IBRC data warehouse team to create a username/password login to use but not progress yet. Need to follow-up. Also, IBRC said they would create a stored procideure which I could call instead of relying on the query in this script. Since the database continues to change, they can maintain the stored procedure to make sure it remains consistent with the database modifications. Again, no progress yet,need to follow up. Right now, I run this script on my laptop and manually copy the resulting file to the Red Hat server. 

#### idp_parse_data.R
This script reads the 'master' csv created by create_master.R and combines it with the Savi Asset csv as well as splitting up the 6 digit NAICS codes and standardizing the character encoding. Writes the results to 'combo.csv'.

#### build_csv.R
Creates indices in the database. Reads combo.csv and reshapes it into node and edge list to be loaded into the database. Writes the csv's to Neo4j import directory. 

#### load_idp.cql
Cypher code to load files produced by build_csv.R into the database

#### add_pathways.R
Add's levels to certain categories identified as steps in the pathways to recovery. Categories are listed in script - no csv. These levels are used in the 'Pathways Map' in the web app. 

#### add_referrals.cql
Cypher script to add referrals from the 'Opioid_Referral_Listing.csv'. 

#### add_coalitions.R
Reads coalition information from Opioid Related Coalitions.csv. Loads coalition nodes in the database and connects them to the organizations. 

#### add_eindy.R
Adds workforce programs from eindy.csv


## To Do

**1.** Communicate with IBRC team about database connecteion and stored procedure. 

**2.** Since RNeo4j is no longer supported (and slow) to improve efficiency of load process swith to py2neo or similar. Write library of python functions for each cypher query sent to DB by RNeo4j then use R library `reticulate` to call python functions from R. Will require pandas for data frame support but python api substantially faster and supported by Neo4j. 

**3.** Replace C++ code with shell script. Or re-write more of the R code in C++ to improve performance. Easiest part would be csv manipulation.











