#include <iostream>
#include <string>
#include <sys/stat.h> // For stat() in exists()
#include <fstream>
#include <sstream>
#include <cstdlib>
using namespace std;

// Converts an integer to a string 
string toString(int num) {
	ostringstream oss;
	oss << num;
	return oss.str();
}

// Returns true if the folder exists, false otherwise
inline bool exists(const string pathname) {
	struct stat sb;

	if (stat(pathname.c_str(), &sb) == 0 && S_ISDIR(sb.st_mode))
	{
	    return true;
	}
	cout << "Datapath folder " << pathname << " does not exist and will be skipped.\n";
	return false;
}

// Discards x lines in file "file" from current position in file
inline void discardLines(ifstream &file, int x) {
	string temp = "";
	for (int i = 0; i < x; ++i) {
		getline(file, temp);
		cout << i << " " << "< " << x << " " << temp << endl;
	}
}

int main (void) {

	int PULSAR_NUM;
	cout << "Pulsar: ";
	cin >> PULSAR_NUM;
	// First decide how many folders we want to go through
	int FIRST_FOLDER = 11324;
	int LAST_FOLDER = 11360;

	string path_to_folders = "/archive/frames/O1/pulsar/sfts/tukeywin/LHO_C01/H-1_H1_1800SFT_O1_C01-";
	string datafiles = "";
	
	for (int i = FIRST_FOLDER; i <= LAST_FOLDER; ++i){
		string folder_name = path_to_folders + toString(i) + "/"; 
		if (exists(folder_name)) {
			// Last folder should not have a semicolon at the end of the command
			if (i == LAST_FOLDER) datafiles = datafiles + folder_name + "*.sft";	
			else datafiles = datafiles + folder_name + "*.sft;";
		}
	}	
	
    string earthpath = "/home/eilam.morag/opt/lalsuite/share/lalpulsar/earth00-19-DE405.dat.gz";
    string sunpath = "/home/eilam.morag/opt/lalsuite/share/lalpulsar/sun00-19-DE405.dat.gz";

    // Now need to get the relevant parameter values
    string parameter_path = "/home/keithr/public_html/cw/O2_H1_test1_injection_params_O2_H1_test1.html";
    ifstream file;
    file.open("/home/keithr/public_html/cw/O2_H1_test1_injection_params_O2_H1_test1.html", ios_base::in);

    string F0="";
    string ASCENSION="";
    string DECLINATION="";
    string APLUS="";
    string ACROSS="";
    string PSI="";
    
    string line1;
    string line2;
    string line3;
    if (file.is_open()) {
    	// Skip to your pulsar
		for (int i = 0; i < 25 + 20*PULSAR_NUM; ++i){
			getline(file, line1);
		}
		discardLines(file, 1);
    	file >> line1 >> F0 >> line3;
    	//All the calls to discard that have a +1 in the second argument are like that
    	//because for some reason getline doesn't work the first time...
    	discardLines(file, 3+1);
    	file >> line1 >> APLUS >> line3;
    	file >> line1 >> ACROSS >> line3;
    	discardLines(file, 2+1);
    	file >> line1 >> PSI >> line3;
    	// Discard the lines we don't need (lines 5-12)
    	discardLines(file, 2+1);
  //   	for (int j = 0; j <= 11; ++j) {
  //   		getline(file, line1);
		// }
    	file >> line1 >> DECLINATION >> line3;
    	file >> line1 >> ASCENSION >> line3;
    }
    
    else {
    	cout << "File " << parameter_path << " could not be opened.\n";
    }
    file.close();
    

	ofstream outFile;
	string outFilename = "predict_pulsar" + toString(PULSAR_NUM); 
	outFile.open(outFilename.c_str(), std::fstream::out);
	outFile << "#!/bin/bash\n\n";

	outFile <<  "echo \"Running script\"\n\n";
	
	outFile <<  "DATAFILES=\"" + datafiles + "\"\n";
	outFile <<  "EARTH_PATH=\"" + earthpath + "\"\n";
	outFile <<  "SUN_PATH=\"" + sunpath + "\"\n";
	
	outFile <<  "F0=\"" + F0 + "\"\n";
	outFile <<  "ASCENSION=\"" + ASCENSION + "\"\n";
	outFile <<  "DECLINATION=\"" + DECLINATION + "\"\n";

	outFile <<  "APLUS=\"" + APLUS + "\"\n";
	outFile <<  "ACROSS=\"" + ACROSS + "\"\n";
	outFile <<  "PSI=\"" + PSI + "\"\n\n";
	
	
	string outputFstat = "FstatPredicted_" + toString(PULSAR_NUM) + ".txt";
	outFile <<  "lalapps_PredictFstat --DataFiles \"$DATAFILES\" --ephemEarth \"$EARTH_PATH\" --ephemSun \"$SUN_PATH\" --Freq=$F0 --Alpha=$ASCENSION --Delta=$DECLINATION --aPlus=$APLUS --aCross=$ACROSS --psi=$PSI --IFO \"H1\" --outputFstat " << outputFstat;
	outFile.close();

	string genScript = "chmod u+x " + outFilename;	
	system(genScript.c_str());

    return 0;

}

