#include <iostream>
#include <cstdlib>
//#include <fstream>

using namespace std;


int main(){


cout << "Retrieiving Master file from IBRC-IDP database...\n" << endl;

//system("Rscript ~/idp_pipeline/code/create_master.R");

cout << "Done\n" << endl;



cout << "Build combo table and write csv...\n" << endl;

system("Rscript ~/idp_pipeline/code/idp_parse_data.R");

cout << "Done\n" << endl;


cout << "Create csv's for loading to database...\n" << endl;

system("Rscript ~/idp_pipeline/code/build_csv.R");

cout << "Done\n" << endl;



cout << "Loading data to database...(This will take a while)\n" << endl;

system("cat ~/idp_pipeline/code/load_idp.cql | /usr/local/neo4j-community-3.3.0/bin/cypher-shell -u neo4j -p microsoft");

cout << "Done\n" << endl;



cout << "Adding Pathways...\n" << endl;

system("Rscript ~/idp_pipeline/code/add_pathways.R");

cout << "Done\n" << endl;



cout << "Adding Referrals...\n" << endl;

system("cat ~/idp_pipeline/code/add_referrals.cql | /usr/local/neo4j-community-3.3.0/bin/cypher-shell -u neo4j -p microsoft");

cout << "Done\n" << endl;



cout << "Adding Coalitions...\n" << endl;

system("Rscript ~/idp_pipeline/code/add_coalitions.R");

cout << "Done\n" << endl;


cout << "Adding EIndy programs...\n" << endl;

system("Rscript ~/idp_pipeline/code/add_eindy.R");

cout << "Done\n" << endl;



cout << "Database is ready! (fingers crossed)\n" << endl;

return 0;
}
