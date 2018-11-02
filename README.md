# idp_pipeline
IDP ETL pipeline for MPH

##Summary
This respository contains code to export data from the IBRC-IDP database, combine it with the Savi Assets csv and load the data into a Neo4j graph database running on a localhost. Then it uses a series of additional csv's provided by the Polis center (via Brad Fulton) to add a series of additional relationships based on opioid treatment referrals, pathways to health and opioid treatment coalitions to the database. The current schema of the resulting database is described in the included pdf. 
Once completed, the intention is that the user will edit a configuration file to provide file paths and then run a single .exe file (or shell script) to build a new version of the database with the most current data from IBRC. This process could be set run on a regular basis (once a month, once a week etc.) to keep the graph database in sync with the IBRC data warehouse. It would probably be beneficial to at some point establish a live connection to the coalitions & referrals files, rather than relying on csv's in case the data is revised in the future. 

This pipeline was developed on RHEL 6.10 so file paths etc. follow the conventions of linux OS. 


##Steps to use this code
While this pipeline can be used, it is not yet complete to the extent that a user can clone the repository, compile the executable and run it to rebuild the database. The steps below document the current required to use this code. Hopefully, the number of steps will be reduced as the pipeline is refined. 

**1.** Install Neo4j Community Edition 3.4 or later. *This pipeline does not require 3.4 or later but the database must be this version or later for the web app to function correctly*

**2.**Edit the configuration file for the database to accept traffic on default port and create the bland database into which you will load the data.

**3.** Start the Neo4j server and set a password. *Alternatively disable password authentication if development environment is secure*.

**4.**Review file paths in all scripts. *Currently, all file paths are listed using format ~/ so if you have cloned this repo to your home directory you shoudln't need to make too many changes but you should probably check anyway*.

**5.**Make sure R and the following libraries are installed on your system: `RODBC`, `tidyr`, `stringi` and `RNeo4j`. *RNeo4j is no longer available on CRAN and will need to be installed from* `https://github.com/nicolewhite/RNeo4j`. *See 'To Do' section for more details on this*. 

**6.**Add database password to connection strings in `add_pathways.R`, `add_coalitions.R`, 'build_csv.R` and `idp_build.cpp`.

**7.**Copy file `Opioid_Referral_Listing.csv` from the data folder to the Neo4j impor directory. Default locations for the Neo4j import directory can be found in the [Neo4j documentation](https://neo4j.com/docs/operations-manual/current/configuration/file-locations/)

**8.**Compile idp_build.cpp with something like `g++ -o idp_build idp_build.cpp` *This should probably be replaced with a shell script*

**9.**Run resulting executable. If everything is confougred correctly, this should run the all the code in sequence and build the database in the current active database. 


##Script Summaries##
Here I've tried to provide a short summary of each file in the /code directory in the order they are called by idp_build.cpp

#idp_build.cpp

