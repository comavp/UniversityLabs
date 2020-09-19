#ifndef __SOLVER_H__
#define __SOLVER_H__

class Solver {
public:
	Solver();
	~Solver();
	void startEncryption(int n, char* inputName, char* outputName, char* keyName);
	void startDecryption(int n, char* inputName, char* outputName, char* keyName);
	void start(char* typeOfAction, int n, char* inputName, char* outputName, char* keyName);
private:
};

#endif