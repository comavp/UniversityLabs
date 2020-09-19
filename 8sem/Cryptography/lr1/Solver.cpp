#include "Solver.h"
#include "PolygraphicCypher.h"

#include<iostream>
#include<string>
#include<fstream>

Solver::Solver() {

}

Solver::~Solver() {

}

void Solver::start(char* typeOfAction, int n, char* inputName, char* outputName, char* keyName) {
	if (strcmp(typeOfAction, "-e") == 0)
		startEncryption(n, inputName, outputName, keyName);
	else if (strcmp(typeOfAction, "-d") == 0)
		startDecryption(n, inputName, outputName, keyName);
	else
		std::cout << "Wrong type of action!" << std::endl;
}

void Solver::startEncryption(int n, char* inputName, char* outputName, char* keyName) {
	std::ifstream input(inputName);
	if (!input.is_open()) {
		std::cout << "Wrong input file name!" << std::endl;
		return;
	}
	std::streambuf *cinbuf = std::cin.rdbuf();
	std::cin.rdbuf(input.rdbuf());

	std::ofstream key(keyName);
	if (!key.is_open()) {
		std::cout << "Wrong key file name!" << std::endl;
		return;
	}
	std::streambuf *coutbuf = std::cout.rdbuf();
	std::cout.rdbuf(key.rdbuf());

	std::vector<unsigned int> s;
	unsigned char chr;
	chr = std::cin.get();
	while (!std::cin.eof()) {
		s.push_back(chr);
		chr = std::cin.get();		
	}
	//s.pop_back();

	std::cin.rdbuf(cinbuf); 

	PolygraphicCypher cypher;
	std::vector<int> result = cypher.encrypt(n, s);

	std::ofstream output(outputName);
	if (!output.is_open()) {
		std::cout << "Wrong output file name!" << std::endl;
		return;
	}
	std::cout.rdbuf(output.rdbuf());

	for (int i = 0; i < result.size(); i++) {
		std::cout << result[i] << " ";
	}

	std::cout.rdbuf(coutbuf);
}

void Solver::startDecryption(int n, char* inputName, char* outputName, char* keyName) {
	std::vector<unsigned int> s;
	unsigned int chr;
	std::vector<std::vector<int>> cipherKey(n, std::vector<int>(n));

	std::ifstream key(keyName);
	if (!key.is_open()) {
		std::cout << "Wrong key file name!" << std::endl;
		return;
	}
	std::streambuf *cinbuf = std::cin.rdbuf();
	std::cin.rdbuf(key.rdbuf());

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			std::cin >> cipherKey[i][j];
		}
	}

	std::ifstream input(inputName);
	if (!input.is_open()) {
		std::cout << "Wrong input file name!" << std::endl;
		return;
	}
	std::cin.rdbuf(input.rdbuf());

	std::cin >> chr;
	while (!std::cin.eof()) {
		s.push_back(chr);
		std::cin >> chr;
	}
	//s.pop_back();

	std::cin.rdbuf(cinbuf);

	std::ofstream output(outputName);
	if (!output.is_open()) {
		std::cout << "Wrong output file name!" << std::endl;
		return;
	}
	std::streambuf *coutbuf = std::cout.rdbuf();
	std::cout.rdbuf(output.rdbuf());

	PolygraphicCypher decypher;
	std::vector<int> result = decypher.decrypt(n, s, cipherKey);
	for (int i = 0; i < result.size(); i++) {
		std::cout << (unsigned char)result[i];
	}

	std::cout.rdbuf(coutbuf);
}