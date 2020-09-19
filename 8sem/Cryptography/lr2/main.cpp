#include<vector>
#include<map>
#include<cmath>
#include<iostream>
#include<fstream>
#include<algorithm>

int binPow(int a, int n);

int n = 1e6;
int L = 7;
int Q = 10 * binPow(2, L);

double const EPS = 0.01;
double const DELTA = 0.000001;
double const DELTA1 = 0.05;

double const cumulativeSumsTestExpectedEf = 0.669886;
double const cumulativeSumsTestExpectedPif = 0.628308;
double const cumulativeSumsTestExpectedEr = 0.724265;
double const cumulativeSumsTestExpectedPir = 0.663369;

double const maurerStatisticalTestExpectedPi = 0.669012;
double const maurerStatisticalTestExpectedE =  0.282568;

double const randomExcursionsVariantTestExpectedE = 0.826009;
double const randomExcursionsVariantTestExpectedPi = 0.760966;

class LFSR{
public:
	std::vector<bool> polynom;
	unsigned int state;
	LFSR(std::vector<bool> polynom) {
		this->polynom = polynom;
	}
	LFSR(std::vector<bool> polynom, unsigned int state) {
		this->polynom = polynom;
		this->state = state;
	}

	std::vector<unsigned char> lfsr(int size) {
		std::vector<unsigned char> arr;
		unsigned int s = 19;
		unsigned int x = 1;
		for (int i = 0; i < size; i++) {
			unsigned int tmp = 0;
			for (int j = 0; j < polynom.size(); j++) {
				if (polynom[j])
					tmp ^= s >> j;
			}
			s = ((tmp & x) << polynom.size() - 1) | (s >> 1);

			if (s & x == 1) {
				arr.push_back('1');
			}
			else {
				arr.push_back('0');
			}
		}
		return arr;
	}

	void printInFile(int size) {
		std::vector<unsigned char> arr = lfsr(size);

		std::ofstream output("output.txt");

		for (int i = 0; i < polynom.size() - 1; i++) {
			output << arr[i];
		}
		output << std::endl;
		for (int i = 4, cnt = 0; i < arr.size(); i++, cnt++) {
			if (cnt == binPow(2, polynom.size()) - 1) {
				output << std::endl;
				cnt = 0;
			}
			output << arr[i];
		}
	}
	
	unsigned char getNextSymvol() {
		unsigned int x = 1;
		unsigned int tmp = 0;
		for (int j = 0; j < polynom.size(); j++) {
			if (polynom[j])
				tmp ^= state >> j;
		}
		state = ((tmp & x) << polynom.size() - 1) | (state >> 1);

		if (state & x == 1) {
			return '1';
		}
		else {
			return '0';
		}		
	}
};

int binPow(int a, int n) {
	if (n == 0) return 1;
	if (n % 2 == 1) {
		return binPow(a, n - 1) * a;
	}
	else {
		int b = binPow(a, n / 2);
		return b * b;
	}
}

std::string toString(unsigned char x, int L) {
	if (x == 0) {
		std::string str = "";
		for (int i = 0; i < L; i++) {
			str += "0";
		}
		return str;
	}
	std::string res = "";
	while (x > 0) {
		if (x % 2)
			res += "1";
		else
			res += "0";
		x /= 2;
	}
	reverse(res.begin(), res.end());
	if (res.length() < L) {
		std::string str = "";
		for (int i = 0; i < L - res.length(); i++) {
			str += "0";
		}
		return str + res;
	}
	return res;
}

//Произвольные отклонения (вар. 2)
double randomExcursionsVariantTest(int n, int x, const std::vector<unsigned char>& arr) {
	double p_Value = 0;
	int J = 1, sum = 0, cnt = 0;
	for (int i = 0; i < n; i++) {
		if (arr[i] == '1')
			sum++;
		else
			sum--;
		if (sum == 0)
			J++;
		if (sum == x)
			cnt++;
	}
	p_Value = erfc(abs(cnt - J)/sqrt(2*J*(4*abs(x) - 2)));
	return p_Value;
}

//Кумулятивных сумм
double cumulativeSumsTest(int reverse, int n, const std::vector<unsigned char>& arr) {
	double p_Value = 0;
	long long cnt = 0;
	long long z = 0;
	if (!reverse) {
		for (int i = 0; i < arr.size(); i++) {
			if (arr[i] == '0')
				cnt--;
			else
				cnt++;
			z = std::max(z, abs(cnt));
		}
	}
	else {
		for (int i = arr.size() - 1; i >= 0; i--) {
			if (arr[i] == '0')
				cnt--;
			else
				cnt++;
			z = std::max(z, abs(cnt));
		}
	}
	double s1 = 0, s2 = 0;
	int k1 = (-n / z + 1) / 4;
	int k2 = (n / z - 1) / 4;
	for (int k = k1; k <= k2; k++) {
		s1 += 0.5 + 0.5 * erf((4 * k + 1) * z / sqrt(2 * n));
		s1 -= 0.5 + 0.5 * erf((4 * k - 1) * z / sqrt(2 * n));
	}
	k1 = (-n / z - 3) / 4;
	k2 = (n / z - 1) / 4;
	for (int k = k1; k <= k2; k++) {
		s2 += 0.5 + 0.5 * erf((4 * k + 3) * z / sqrt(2 * n));
		s2 -= 0.5 + 0.5 * erf((4 * k + 1) * z / sqrt(2 * n));
	}
	p_Value = 1 - s1 + s2;
	return p_Value;
}

// Универсальный Маурера
double maurerStatisticalTest(int L, int Q, int n, const std::vector<unsigned char>& arr) {
	std::map<std::string , int> table;
	double comSum = 0;
	int K = n / L - Q;
	double expectedValue = 6.1962507;
	double variance = 3.125;
	double c = 0.7 - 0.8 / (double)L + (4 + 32 / (double)L) * (pow(K, -3 / (double)L) / 15);
	double q = c * sqrt(variance / K);
	double p_Value = 0;
	for (int i = 0; i < binPow(2, L); i++) {
		table.insert({ toString(i, L) , 0 });
	}
	int b = 0;
	for (int i = 0; i < Q; i++) {
		std::string blockValue = "";
		for (int j = 0; j < L; j++) {
			blockValue += arr[j + b];
		}
		b += L;
		table[blockValue] = i + 1;
	}
	for (int i = Q; i < K + Q; i++) {
		std::string blockValue = "";
		for (int j = 0; j < L; j++) {
			blockValue += arr[j + b];
		}
		b += L;
		comSum += log2(i + 1 - table[blockValue]);
		table[blockValue] = i + 1;
	}
	comSum /= K;
	p_Value = erfc(abs((comSum - expectedValue)/(sqrt(2)*q)));
	return p_Value;
}

std::vector<unsigned char> getE() {
	std::vector<unsigned char> arr;

	std::ifstream input("data.e");
	if (!input.is_open()) {
		std::cout << "Wrong input file name!" << std::endl;
		return arr;
	}
	std::streambuf *cinbuf = std::cin.rdbuf();
	std::cin.rdbuf(input.rdbuf());

	unsigned char chr;
	while (!std::cin.eof()) {
		chr = std::cin.get();
		if (chr == '0' || chr == '1')
			arr.push_back(chr);
	}

	std::cin.rdbuf(cinbuf);
	return arr;
}

std::vector<unsigned char> getPi() {
	std::vector<unsigned char> arr;

	std::ifstream input("data.pi");
	if (!input.is_open()) {
		std::cout << "Wrong input file name!" << std::endl;
		return arr;
	}
	std::streambuf *cinbuf = std::cin.rdbuf();
	std::cin.rdbuf(input.rdbuf());

	unsigned char chr;
	while (!std::cin.eof()) {
		chr = std::cin.get();
		if (chr == '0' || chr == '1')
			arr.push_back(chr);
	}

	std::cin.rdbuf(cinbuf);
	return arr;
}

std::vector<unsigned char> getSequance() {
	std::vector<unsigned char> arr;

	std::ifstream input("sequence.txt");
	if (!input.is_open()) {
		std::cout << "Wrong input file name!" << std::endl;
		return arr;
	}
	std::streambuf *cinbuf = std::cin.rdbuf();
	std::cin.rdbuf(input.rdbuf());

	unsigned char chr;
	while (!std::cin.eof()) {
		chr = std::cin.get();
		if (chr == '0' || chr == '1')
			arr.push_back(chr);
	}

	std::cin.rdbuf(cinbuf);
	return arr;
}

//Комбинирование с прореживающим генератором
std::vector<unsigned char> sg(std::vector<bool> polynom1, std::vector<bool> polynom2, int size) {
	LFSR g1(polynom1, 19);
	LFSR g2(polynom2, 19);
	std::vector<unsigned char> arr;
	for (int i = 0; i < std::max(polynom1.size() - 1, polynom2.size() - 1); i++) {
		g1.getNextSymvol();
		g2.getNextSymvol();
	}
	while (arr.size() != size) {
		unsigned char a = g1.getNextSymvol();
		unsigned char s = g2.getNextSymvol();
		if (s == '1')
			arr.push_back(a);
	}
	return arr;
}

void checkStatisticTests() {
	double p_Value = 0;
	std::vector<unsigned char> e = getE();
	std::vector<unsigned char> pi = getPi();

	p_Value = maurerStatisticalTest(L, Q, n, e);
	if (abs(p_Value - maurerStatisticalTestExpectedE) <= DELTA) {
		std::cout << "maurerStatisticalTest for e - passed" << std::endl;
	}
	else {
		std::cout << "maurerStatisticalTest for e- failed" << std::endl;
	}
	std::cout << "\tCalculated: " << p_Value << std::endl;
	std::cout << "\tExpected  : " << maurerStatisticalTestExpectedE << std::endl;

	p_Value = maurerStatisticalTest(L, Q, n, pi);
	if (abs(p_Value - maurerStatisticalTestExpectedPi) <= DELTA) {
		std::cout << "maurerStatisticalTest for pi - passed" << std::endl;
	}
	else {
		std::cout << "maurerStatisticalTest for pi- failed" << std::endl;
	}
	std::cout << "\tCalculated: " << p_Value << std::endl;
	std::cout << "\tExpected  : " << maurerStatisticalTestExpectedPi << std::endl;


	p_Value = randomExcursionsVariantTest(n, -1, pi);
	if (abs(p_Value - randomExcursionsVariantTestExpectedPi) <= DELTA) {
		std::cout << "randomExcursionsVariantTest for pi - passed" << std::endl;
	}
	else {
		std::cout << "randomExcursionsVariantTest for pi- failed" << std::endl;
	}
	std::cout << "\tCalculated: " << p_Value << std::endl;
	std::cout << "\tExpected  : " << randomExcursionsVariantTestExpectedPi << std::endl;

	p_Value = randomExcursionsVariantTest(n, -1, e);
	if (abs(p_Value - randomExcursionsVariantTestExpectedE) <= DELTA) {
		std::cout << "randomExcursionsVariantTest for e - passed" << std::endl;
	}
	else {
		std::cout << "randomExcursionsVariantTest for e- failed" << std::endl;
	}
	std::cout << "\tCalculated: " << p_Value << std::endl;
	std::cout << "\tExpected  : " << randomExcursionsVariantTestExpectedE << std::endl;


	p_Value = cumulativeSumsTest(0, n, pi);
	if (abs(p_Value - cumulativeSumsTestExpectedPif) <= DELTA) {
		std::cout << "cumulativeSumsTest (mode = forward) for pi - passed" << std::endl;
	}
	else {
		std::cout << "cumulativeSumsTest (mode = forward) for pi- failed" << std::endl;
	}
	std::cout << "\tCalculated: " << p_Value << std::endl;
	std::cout << "\tExpected  : " << cumulativeSumsTestExpectedPif << std::endl;

	p_Value = cumulativeSumsTest(0, n, e);
	if (abs(p_Value - cumulativeSumsTestExpectedEf) <= DELTA) {
		std::cout << "cumulativeSumsTest (mode = forward) for e - passed" << std::endl;
	}
	else {
		std::cout << "cumulativeSumsTest (mode = forward) for e- failed" << std::endl;
	}
	std::cout << "\tCalculated: " << p_Value << std::endl;
	std::cout << "\tExpected  : " << cumulativeSumsTestExpectedEf << std::endl;

	p_Value = cumulativeSumsTest(1, n, pi);
	if (abs(p_Value - cumulativeSumsTestExpectedPir) <= DELTA1) {
		std::cout << "cumulativeSumsTest (mode = reverse) for pi - passed" << std::endl;
	}
	else {
		std::cout << "cumulativeSumsTest (mode = reverse) for pi- failed" << std::endl;
	}
	std::cout << "\tCalculated: " << p_Value << std::endl;
	std::cout << "\tExpected  : " << cumulativeSumsTestExpectedPir << std::endl;

	p_Value = cumulativeSumsTest(1, n, e);
	if (abs(p_Value - cumulativeSumsTestExpectedEr) <= DELTA1) {
		std::cout << "cumulativeSumsTest (mode = reverse) for e - passed" << std::endl;
	}
	else {
		std::cout << "cumulativeSumsTest (mode = reverse) for e- failed" << std::endl;
	}
	std::cout << "\tCalculated: " << p_Value << std::endl;
	std::cout << "\tExpected  : " << cumulativeSumsTestExpectedEr << std::endl;
}

void checkGeneratedSequence() {
	double p_Value = 0;
	std::vector<unsigned char> arr = getSequance();

	p_Value = maurerStatisticalTest(L, Q, n, arr);
	if (p_Value >= EPS) {
	std::cout << "maurerStatisticalTest for sequence - passed" << std::endl;
	}
	else {
	std::cout << "maurerStatisticalTest for sequence - failed" << std::endl;
	}
	std::cout << "\tp-Value: " << p_Value << std::endl;
	p_Value = cumulativeSumsTest(0, n, arr);
	if (p_Value >= EPS) {
	std::cout << "cumulativeSumsTest (mode = forward) for sequence - passed" << std::endl;
	}
	else {
	std::cout << "cumulativeSumsTest (mode = forward) for sequence - failed" << std::endl;
	}
	std::cout << "\tp-Value: " << p_Value << std::endl;

	p_Value = cumulativeSumsTest(1, n, arr);
	if (p_Value >= EPS) {
		std::cout << "cumulativeSumsTest (mode = reverse) for sequence - passed" << std::endl;
	}
	else {
		std::cout << "cumulativeSumsTest (mode = reverse) for sequence- failed" << std::endl;
	}
	std::cout << "\tp-Value: " << p_Value << std::endl;

	p_Value = randomExcursionsVariantTest(n, -1, arr);
	if (p_Value >= EPS) {
	std::cout << "randomExcursionsVariantTest for sequence - passed" << std::endl;
	}
	else {
	std::cout << "randomExcursionsVariantTest for sequence - failed" << std::endl;
	}
	std::cout << "\tp-Value: " << p_Value << std::endl;
}

void printSG(std::vector<unsigned char>& arr, std::vector<bool>& pol1, std::vector<bool>& pol2) {
	std::ofstream output("output_SG.txt");

	for (int i = 0, cnt = 0; i < arr.size(); i++, cnt++) {
		if (cnt == (binPow(2, pol1.size()) - 1) * (binPow(2, pol2.size() - 1))) {
			output << std::endl << std::endl;
			cnt = 0;
		}
		output << arr[i];
	}
}

int main() {	
	std::vector<bool> firstPol({ true, false, false, true, false }); // x^5 + x^2 + 1
	std::vector<bool> secondPol({ true, true, true, true, false }); // x^5 + x^4 + x^3 + x^2 + 1
	std::vector<bool> thirdPol({ true, false, false, false, false }); // x^5 + 1
	std::vector<bool> fourthPol({ true, false, false, false, false, false, true });// x^7 + x + 1
	std::vector<bool> fifthPol({ true, true });// x^2 + x + 1
	std::vector<bool> sixthPol({ true, false, true }); // x^3 + x + 1;
	std::vector<bool> seventhPol({ true, false, true, false, false, false, false, false, false, false, false }); // x^11 + x^9 + 1;
	std::vector<bool> eighthPol({ true, true, true, false, false, false, false, false, true, false, false, false }); // x^12 + x^11 + x^10 + x^4 + 1;
	std::vector<unsigned char> arr;
	
	arr = sg(firstPol, fourthPol, 1e4);
	printSG(arr, firstPol, fourthPol);

	LFSR g(firstPol);
	g.printInFile(1000);
	 

	checkStatisticTests();
	checkGeneratedSequence();

	system("pause");
	return 0;
}