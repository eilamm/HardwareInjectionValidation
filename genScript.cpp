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
		cout << "Folder " << pathname << " exists\n";
	    return true;
	}
	return false;
}

int main (void) {

	// First decide how many folders we want to go through
	int PULSAR_NUM;
	cout << "Pulsar: ";
	cin >> PULSAR_NUM;
	int FIRST_FOLDER = 11324;
	int LAST_FOLDER = 11369;

	string path_to_folders = "/archive/frames/O1/pulsar/sfts/tukeywin/LHO_C01/H-1_H1_1800SFT_O1_C01-";
	string datafiles = "";
	
	for (int i = FIRST_FOLDER; i < LAST_FOLDER; ++i){
		folder_name = path_to_folders + toString(i) + "/"; 
		if (exists(folder_name)) {
			datafiles = datafiles + folder_name + "*.sft;";
		}
	}	
	// Last folder should not have a semicolon at the end of the command
	datafiles = datafiles + path_to_folders + toString(LAST_FOLDER) + "/*.sft";
    string earthpath = "/home/eilam.morag/opt/lalsuite/share/lalpulsar/earth00-19-DE405.dat.gz";
    string sunpath = "/home/eilam.morag/opt/lalsuite/share/lalpulsar/sun00-19-DE405.dat.gz";

    // Now need to get the relevant parameter values
    string parameter_path = "/home/keithr/public_html/cw/O2_H1_test1_injection_params_O2_H1_test1.html";
    ifstream file;
    file.open("/home/keithr/public_html/cw/O2_H1_test1_injection_params_O2_H1_test1.html", ios_base::in);

    string F0="";
    string FREQBAND="0.1";
    string ASCENSION="";
    string DECLINATION="";
    string FDOT="";
    string REFTIME="";
    
    string line1;
    string line2;
    string line3;
    if (file.is_open()) {
	for (int i = 0; i < 25 + 20*PULSAR_NUM; ++i){
	//	file >> line1 >> line2 >> line3;
		getline(file, line1);
	}
	file >> line1 >> REFTIME >> line3;
    	file >> line1 >> F0 >> line3;
    	file >> line1 >> FDOT >> line3;
    	// Discard the lines we don't need (lines 5-12)
    	for (int j = 0; j <= 11; ++j) {
    		getline(file, line1);
	}
    	file >> line1 >> DECLINATION >> line3;
    	file >> line1 >> ASCENSION >> line3;
    }
    
    else {
    	cout << "File " << parameter_path << " could not be opened.\n";
    }
    file.close();
    

	ofstream outFile;
	string outFilename = "recover_pulsar" + toString(PULSAR_NUM) + ".sh"; 
	outFile.open(outFilename.c_str(), std::fstream::out);
	outFile << "#!/bin/bash\n\n";

	outFile <<  "echo \"Running script\"\n\n";
	
	outFile <<  "DATAFILES=\"" + datafiles + "\"\n";
	outFile <<  "EARTH_PATH=\"" + earthpath + "\"\n";
	outFile <<  "SUN_PATH=\"" + sunpath + "\"\n";
	
	outFile <<  "F0=\"" + F0 + "\"\n";
	outFile <<  "FREQBAND=\"" + FREQBAND + "\"\n";
	outFile <<  "ASCENSION=\"" + ASCENSION + "\"\n";
	outFile <<  "DECLINATION=\"" + DECLINATION + "\"\n";
	outFile <<  "FDOT=\"" + FDOT + "\"\n";
	outFile <<  "REFTIME=\"" + REFTIME + "\"\n\n";
	
	
	string hist = "FstatHist_" + toString(PULSAR_NUM) + ".txt";
	string loud = "FstatLoudest_" + toString(PULSAR_NUM) + ".txt";
	string val = "FstatValues_" + toString(PULSAR_NUM) + ".txt";
	outFile <<  "lalapps_ComputeFstatistic_v2 --DataFiles \"$DATAFILES\" --ephemEarth \"$EARTH_PATH\" --ephemSun \"$SUN_PATH\" --Freq=$F0 --FreqBand=$FREQBAND --Alpha=$ASCENSION --Delta=$DECLINATION --f1dot=$FDOT --refTime=$REFTIME --IFO \"H1\" --FstatMethod \"ResampBest\" --outputLoudest " << loud << " --outputFstat " << val << " --outputFstatHist " << hist;
	outFile.close();

	string genScript = "chmod u+x " + outFilename;	
	system(genScript.c_str());

    return 0;

}

