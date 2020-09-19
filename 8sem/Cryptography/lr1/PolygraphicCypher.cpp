#include "PolygraphicCypher.h"

#include<iostream>
#include<random>
#include<ctime>
#include<algorithm>

PolygraphicCypher::PolygraphicCypher() {

}

PolygraphicCypher::~PolygraphicCypher() {

}

std::vector<int> PolygraphicCypher::decrypt(int n, std::vector<unsigned int> cipherText, std::vector<std::vector<int>> cipherKey) {
	int det = getDetermenant(cipherKey, cipherKey.size());
	int inverseDet = binPow(det, mod - 2);
	std::vector<std::vector<int>> decipherKey = getInverseMatrix(cipherKey);
	for (auto& row : decipherKey) {
		for (auto& cell : row) {
			cell *= inverseDet;
			cell %= mod;
		}
	}

	std::vector<int>* nextSymvols = nullptr;
	std::vector<int> result(cipherText.size());
	int k = 0;
	while (nextSymvols = getNextSymvols(n, cipherText, k)) {
		if (k == 474) {
			int x = 3 + 3;
		}
		std::vector<int> cur = vectorOnMatrixMultiplication(*nextSymvols, decipherKey);
		for (int i = k; i < k + n; i++) {
			result[i] = cur[i - k];
		}
		k += n;
	}
	return result;
}

std::vector<std::vector<int>> PolygraphicCypher::getInverseMatrix(std::vector<std::vector<int>> cipherKey) {
	int size = cipherKey.size();
	transposeMatrix(cipherKey);
	std::vector<std::vector<int>> decipherKey(size, std::vector<int>(size));
	std::vector<std::vector<int>> minor(size - 1, std::vector<int>(size - 1));
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) {
			getMatrixWihoutRawAndColumn(cipherKey, minor, i, j, size);
			decipherKey[i][j] = binPow(-1, i + j) * getDetermenant(minor, size - 1);
			if (decipherKey[i][j] < 0) decipherKey[i][j] += mod * (-decipherKey[i][j] / mod + 1);
		}
	}
	return decipherKey;
}

void PolygraphicCypher::transposeMatrix(std::vector<std::vector<int>>& matrix) {
	for (int i = 0; i < matrix.size(); i++) {
		for (int j = 0; j < matrix.size(); j++) {
			if (j > i) {
				int x = matrix[i][j], y = matrix[j][i];
				matrix[i][j] ^= matrix[j][i];
				x = matrix[i][j];
				matrix[j][i] ^= matrix[i][j];
				y = matrix[j][i];
				matrix[i][j] ^= matrix[j][i];
				x = matrix[i][j];
			}
		}
	}
}

int PolygraphicCypher::binPow(int a, int n) {
	if (n == 0) return 1;
	if (n % 2 == 0) {
		int b = binPow(a, n / 2);
		return b * b % mod;
	}
	else {
		return binPow(a, n - 1) * a % mod;
	}
}

std::vector<int> PolygraphicCypher::encrypt(int n, std::vector<unsigned int> plainText) {
	if (plainText.size() % n != 0) {
		int cnt = n - plainText.size() % n;
		while (cnt > 0) {
			plainText.push_back(32);
			cnt--;
		}
	}
	std::vector<std::vector<int>> key = generateRandomMatrix(n);
	while (getDetermenantFast(key, n) == 0) {
		key = generateRandomMatrix(n);
	}
	 
	for (int i = 0; i < key.size(); i++) {
		for (int j = 0; j < key[i].size(); j++) {
			std::cout << key[i][j] << " ";
		}
		std::cout << std::endl;
	}
	std::vector<int>* nextSymvols = nullptr;
	std::vector<int> cipherText(plainText.size());
	int k = 0;
	while (nextSymvols = getNextSymvols(n, plainText, k)) {
		std::vector<int> cur = vectorOnMatrixMultiplication(*nextSymvols, key);
		for (int i = k; i < k + n; i++) {
			cipherText[i] = cur[i - k];
		}
		k += n;
	}
	return cipherText;
}

void PolygraphicCypher::getMatrixWihoutRawAndColumn(std::vector<std::vector<int>> matrix, std::vector<std::vector<int>>& res, int i, int j, int n) {
	int ki, kj, di, dj;
	di = 0;
	for (ki = 0; ki < n - 1; ki++) { // проверка индекса строки
		if (ki == i) di = 1;
		dj = 0;
		for (kj = 0; kj < n - 1; kj++) { // проверка индекса столбца
			if (kj == j) dj = 1;
			res[ki][kj] = matrix[ki + di][kj + dj];
		}
	}
}

int PolygraphicCypher::getDetermenant(std::vector<std::vector<int>> matrix, int n) {
	if (n == 0) {
		return 1;
	}
	if (n == 1) {
		return  matrix[0][0];
	}

	int i, j, det, k;
	std::vector<std::vector<int>> res(n - 1, std::vector<int>(n - 1));
	j = 0; det = 0;
	k = 1; //(-1) в степени i	
	if (n == 2) {
		det = matrix[0][0] * matrix[1][1] - matrix[1][0] * matrix[0][1];
		if (det != 0) {
			det = (det > 0) ? det % mod : det + mod * (-det / mod + 1);
		}
		return det;
	}
	if (n > 2) {
		for (i = 0; i < n; i++) {
			getMatrixWihoutRawAndColumn(matrix, res, i, 0, n);
			det += k * matrix[i][0] * getDetermenant(res, n - 1);
			det = (det > 0) ? det % mod : det + mod * (-det / mod + 1);
			k = -k;
		}
	}
	return det;
}

std::vector<std::vector<int>> PolygraphicCypher::generateRandomMatrix(int n) {
	std::vector<std::vector<int>> randomMatrix(n, std::vector<int>(n, 0));
	std::mt19937 gen;
	gen.seed((unsigned long)time(nullptr));
	std::uniform_int_distribution<> uid(0, 256);
	for (auto& row : randomMatrix) {
		for (auto& cell : row) {
			cell = uid(gen);
		}
	}
	return randomMatrix;
}

std::vector<int> PolygraphicCypher::vectorOnMatrixMultiplication(std::vector<int> vect, std::vector<std::vector<int>> matrix) {
	int n = matrix.size();
	std::vector<int> res(n, 0);
	for (int i = 0; i < n; i++) {		
		for (int j = 0; j < n; j++) {			
			res[i] += matrix[j][i] * vect[j] % mod;
			res[i] %= mod;
		}
	}
	return res;
}

std::vector<int>* PolygraphicCypher::getNextSymvols(int n, std::vector<unsigned int> plainText, int k) {
	if (plainText.size() < k + n) {
		return nullptr;
	}
	std::vector<int>* nextSymvols = new std::vector<int>(n);
	for (int i = k; i < k + n; i++) {
		(*nextSymvols)[i - k] = (int)plainText[i];
	}
	return nextSymvols;
}

int PolygraphicCypher::getDetermenantFast(std::vector<std::vector<int>> matrix, int n) {
	int det = 1;
	for (int i = 0; i < n; ++i) {
		int k = i;
		for (int j = i + 1; j < n; ++j)
			if (abs(matrix[j][i]) > abs(matrix[k][i]))
				k = j;
		if (abs(matrix[k][i]) == 0) {
			det = 0;
			break;
		}
		swap(matrix[i], matrix[k]);
		if (i != k)
			det = -det;
		det *= matrix[i][i];
		det = (det >= 0) ? det % mod : det + mod * (-det / mod + 1);
		for (int j = i + 1; j < n; ++j) {
			matrix[i][j] = (matrix[i][j] > 0) ? matrix[i][j] % mod : matrix[i][j] + mod * (-matrix[i][j] / mod + 1);
			matrix[i][j] *= binPow(matrix[i][i], mod - 2);
			matrix[i][j] %= mod;
		}
		for (int j = 0; j < n; ++j) {
			if (j != i && abs(matrix[j][i]) > 0) {
				for (int k = i + 1; k < n; ++k) {
					matrix[j][k] -= matrix[i][k] * matrix[j][i];
					matrix[j][k] = (matrix[j][k] > 0) ? matrix[j][k] % mod : matrix[j][k] + mod * (-matrix[j][k] / mod + 1);
				}
			}
		}
	}
	return det;
}