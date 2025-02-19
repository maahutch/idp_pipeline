#include <iostream>
#include <cstdlib>
#include <fstream>
#include <string>

using namespace std;


int main(){


string pswd;

ifstream psswd_file ("/N/u/maahutch/Karst/idp_pipeline/data/pswd");

if(psswd_file.is_open())
{
  getline(psswd_file, pswd); 
  
   psswd_file.close();
}
else cout << "Unable to open file" << endl; 


string load_idp      = "cat ~/idp_pipeline/code/load_idp.cql | /usr/local/neo4j-community-3.3.0/bin/cypher-shell -u neo4j -p " + pswd;

string add_referrals = "cat ~/idp_pipeline/code/add_referrals.cql | /usr/local/neo4j-community-3.3.0/bin/cypher-shell -u neo4j -p " + pswd;

string add_collab    = "cat ~/idp_pipeline/code/add_collab.cql | /usr/local/neo4j-community-3.3.0/bin/cypher-shell -u neo4j -p " + pswd;

//ifstream src("~/idp_pipeline/data/Opioid_Referral_Listing.csv", ios::binary);
//ofstream dst("/usr/local/neo4j-community-3.3.0/import/Opioid_Referral_Listing.csv", ios::binary);

//dst << src.rdbuf(); 



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

system(load_idp.c_str());

cout << "Done\n" << endl;



cout << "Adding Pathways...\n" << endl;

system("Rscript ~/idp_pipeline/code/add_pathways.R");

cout << "Done\n" << endl;



cout << "Adding Referrals...\n" << endl;

system(add_referrals.c_str());

cout << "Done\n" << endl;



cout << "Adding Coalitions...\n" << endl;

system("Rscript ~/idp_pipeline/code/add_coalitions.R");

cout << "Done\n" << endl;


cout << "Adding EIndy programs...\n" << endl;

system("Rscript ~/idp_pipeline/code/add_eindy.R");

cout << "Done\n" << endl;


cout << "Adding Collaborations...\n" << endl;

system(add_collab.c_str());

cout << "Done\n" << endl;


cout << "Database is ready! (fingers crossed)\n" << endl;

return 0;
}
