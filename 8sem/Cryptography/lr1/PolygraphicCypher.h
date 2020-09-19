#ifndef __POLYGRAPHIC_CYPHER_H__
#define __POLYGRAPHIC_CYPHER_H__

#include<vector>
#include<string>

class PolygraphicCypher {
public:
	const int mod = 257;
	PolygraphicCypher();
	~PolygraphicCypher();
	std::vector<int> encrypt(int n, std::vector<unsigned int> plainText);
	std::vector<int> decrypt(int n, std::vector<unsigned int> cipherText, std::vector<std::vector<int>> cipherKey);
private:
	std::vector<std::vector<int>> generateRandomMatrix(int n);
	std::vector<int> vectorOnMatrixMultiplication(std::vector<int> vect, std::vector<std::vector<int>> matrix);
	std::vector<int>* getNextSymvols(int n, std::vector<unsigned int> plainText, int k);
	void getMatrixWihoutRawAndColumn(std::vector<std::vector<int>> matrix, std::vector<std::vector<int>>& res, int i, int j, int n);
	int getDetermenant(std::vector<std::vector<int>> matrix, int n);
	int binPow(int a, int n);
	void transposeMatrix(std::vector<std::vector<int>>& matrix);
	std::vector<std::vector<int>> PolygraphicCypher::getInverseMatrix(std::vector<std::vector<int>> cipherKey);
	int getDetermenantFast(std::vector<std::vector<int>> matrix, int n);
};

#endif