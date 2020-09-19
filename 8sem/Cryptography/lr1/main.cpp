#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include<cmath>
#include<string>
#include<vector>

#include "Solver.h";

void solve(char* typeOfAction, int n, char* inputName, char* outputName, char* keyName) {
	Solver solver;
	solver.start(typeOfAction, n, inputName, outputName, keyName);
}

void validateInput(int argc, char** argv) {
	if (argc != 6) {
		std::cout << "Wrong number of parameters!" << std::endl;
		return;
	}
	solve(argv[1], atoi(argv[2]), argv[3], argv[4], argv[5]);
}

int main(int argc, char** argv) {
	validateInput(argc, argv);

	return 0;
}