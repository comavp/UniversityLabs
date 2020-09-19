#include<iostream>
#include<vector>
#include<algorithm>
#include<ctime>

using namespace std;

const int N = 1e6;

vector<bool> prime(N + 1, true);

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

std::vector<unsigned char> sg(std::vector<bool> polynom1, std::vector<bool> polynom2, int size) {
	LFSR g1(polynom1, (unsigned int)time(nullptr));
	LFSR g2(polynom2, (unsigned int)time(nullptr));
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

void sieve(int n) {
	int size = min(n, N);
	prime[0] = false;
	prime[1] = false;
	for (int i = 2; i * i <= size; i++) {
		if (prime[i]) {
			if (i * 1ll * i <= size) {
				for (int j = i * i; j <= size; j += i) {
					prime[j] = false;
				}
			}
		}
	}
}

int binPow(int a, int n, int m) {
	if (n == 0) return 1;
	if (n % 2 == 1) {
		return binPow(a, n - 1, m) * a % m;
	}
	else {
		int b = binPow(a, n / 2, m) % m;

		return b * b % m;
	}
}

int getLargestFactor(int x) {
	int ans = 1;
	for (int i = 2; i < prime.size() && i < x; i++) {
		if (prime[i] && x % i == 0) {
			ans = i;
		}
	}
	return ans;
}

int gcd(int a, int b) {
	while (b) {
		a %= b;
		swap(a, b);
	}
	return a;
}

bool detectPerfectPowers(int n) {
	for (double i = 2; i <= log2(n); i++) {
		double a = pow(n, 1 / i);
		double b = int(a);
		if (a == b) {
			return true;
		}
	}
	return false;
}

bool aks(int n) {
	if (detectPerfectPowers(n)) return false;
	int r, x = 2;
	for (r = 2; r < n; r++) {
		if (gcd(r, n) != 1) return false;
		if (r <= N && prime[r] && r > 2) {
			int q = getLargestFactor(r - 1);
			double first = 4 * sqrt(r) * log2(n);
			int second = binPow(n, (r - 1)/q, r);
			if (q > first && second != 1) break;
		}
	}
	int limit = (int)(2.0 * sqrt(r) * log2(n)) + 1;
	for (int a = 1; a < limit; a++) {
		int left = binPow(x + a, n, n);
		int right = (binPow(x, n, n) + a) % n;
		if (left != right) 
			return false;
	}
	return true;
}

unsigned int getRandomNumber(int p) {
	std::vector<bool> pol1({ true, false, true, false, false, false, false, false, false, false, false }); // x^11 + x^9 + 1;
	std::vector<bool> pol2({ true, true, true, false, false, false, false, false, true, false, false, false }); // x^12 + x^11 + x^10 + x^4 + 1;
	vector<unsigned char> arr = sg(pol1, pol2, p);
	unsigned int ans = 0;
	arr[0] = arr[p - 1] = '1';
	for (int i = 0; i < p; i++) {
		if (arr[i] == '1') {
			ans += binPow(2, p - 1 - i, INT_MAX);
		}
	}
	return ans;
}

int main() {
	int n, p = 2, t, maxNumber = 0, minNumber = 0, firstNumber = 0;
	cout << "Enter number of bits: ";
	cin >> p;

	while (p > 1) {		
		cout << endl;
		n = getRandomNumber(p);
		sieve(n);
		maxNumber = binPow(2, p, INT_MAX) - 1;
		minNumber = binPow(2, p - 1, INT_MAX) + 1;
		t = 1;
		firstNumber = n;

		/*while (!aks(n)) {
			cout << "Round number " << t << ") " << n << " - composite" << endl;
			n += 2;
			if (n > maxNumber) {
				n = minNumber;
			}
			if (n == firstNumber) {
				system("pause");
				return 0;9
			}
			t++;
		}
*/
		cout << "Round number " << t << ") " << n << " - prime" << endl;

		// system("pause");

		cout << endl <<  "Enter number of bits: ";
		cin >> p;
	}

	system("pause");
	return 0;
}