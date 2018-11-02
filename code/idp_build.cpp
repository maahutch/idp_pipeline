#include <iostream>
#include <cstdlib>
//#include <fstream>

using namespace std;


int main(){


cout << "Retrieiving Master file from IBRC-IDP database...\n" << endl;

//system("Rscript /N/u/maahutch/Karst/idp_db/create_master.R");

cout << "Done\n" << endl;



cout << "Build combo table and write csv...\n" << endl;

system("Rscript /N/u/maahutch/Karst/idp_db/idp_parse_data.R");

cout << "Done\n" << endl;


cout << "Create csv's for loading to database...\n" << endl;

system("Rscript /N/u/maahutch/Karst/idp_db/build_csv.R");

cout << "Done\n" << endl;



cout << "Loading data to database...(This will take a while)\n" << endl;

system("cat /N/u/maahutch/Karst/idp_db/load_idp.cql | /usr/local/neo4j-community-3.3.0/bin/cypher-shell -u neo4j -p microsoft");

cout << "Done\n" << endl;



cout << "Adding Pathways...\n" << endl;

system("Rscript /N/u/maahutch/Karst/idp_db/add_pathways.R");

cout << "Done\n" << endl;



cout << "Adding Referrals...\n" << endl;

//system("Rscript /N/u/maahutch/Karst/idp_db/add_referrals.R");

system("cat /N/u/maahutch/Karst/idp_db/add_referrals.cql | /usr/local/neo4j-community-3.3.0/bin/cypher-shell -u neo4j -p microsoft");

cout << "Done\n" << endl;



cout << "Adding Coalitions...\n" << endl;

system("Rscript /N/u/maahutch/Karst/idp_db/add_coalitions.R");

cout << "Done\n" << endl;



cout << "Database is ready! (fingers crossed)\n" << endl;

return 0;
}
