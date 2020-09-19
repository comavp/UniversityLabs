#include<iostream>
#include<vector>
#include<algorithm>
#include<random>
#include<ctime>
#include<fstream>
#include<string>
#include<set>

using namespace std;

struct PublicKey {
	int p, h;
	vector<int> c;
};

struct PrivateKey {
	vector<int> g, f, pi, invPi;
	int d;
};

bool polEq(const vector<int>& a, const vector<int>& b) {
	int size1 = 0, size2 = 0;
	for (int i = a.size() - 1; i >= 0; i--) {
		if (a[i] > 0) {
			size1 = i;
			break;
		}
	}
	for (int i = b.size() - 1; i >= 0; i--) {
		if (b[i] > 0) {
			size2 = i;
			break;
		}
	}
	if (size1 != size2) return false;
	for (int i = 0; i <= size1; i++) {
		if (a[i] != b[i]) return false;
	}
	return true;
}

int C(int p, int h) {
	if (p >= 0 && h == 0) return 1;
	if (h > p) return 0;

	int x = 1;
	for (int i = h + 1; i <= p; i++) {
		x *= i;
	}
	int y = 1;
	for (int i = 2; i <= p - h; i++) {
		y *= i;
	}
	return x / y;
}

int getRandomDigit(int k) {
	mt19937 gen;
	gen.seed((unsigned long)time(nullptr));
	std::uniform_int_distribution<> uid(0, k);
	return uid(gen);
}

void getRandomPermutation(vector<int>& a) {
	int n = a.size() - 1;
	for (int i = n; i >= 0; i--) {
		int j = getRandomDigit(i);
		swap(a[i], a[j]);
	}
}

int binPow(long long a, long long n, long long mod) {
	if (n == 0) return 1;
	if (n % 2 == 0) {
		long long b = binPow(a, n / 2, mod) % mod;
		return b * b % mod;
	}
	else {
		return binPow(a, n - 1, mod) * a % mod;
	}
}

int getInv(int a, int p) {
	return binPow(a, p - 2, p);
}

vector<int> polSum(const vector<int>& x, const vector<int>& y, int mod) {
	vector<int> res(max(x.size(), y.size()), 0);
	for (int i = 0; i < res.size(); i++) {
		if (i < x.size())
			res[i] += x[i];
		if (i < y.size())
			res[i] += y[i];
		res[i] %= mod;
	}
	return res;
}

vector<int> polSub(const vector<int>& x, const vector<int>& y, int mod) {
	vector<int> tmpX = x, tmpY = y;
	while (tmpX.size() < tmpY.size()) tmpX.push_back(0);
	for (int i = 0; i < tmpY.size(); i++) {
		if (tmpY[i] % mod != 0) {
			tmpY[i] = (tmpY[i] / mod + 1) * mod - tmpY[i];
		}
		else {
			tmpY[i] = 0;
		}
	}
	return polSum(tmpX, tmpY, mod);
}

vector<int> polMult(const vector<int>& x, const vector<int>& y, int mod) {
	vector<int> res(x.size() + y.size() - 1, 0);
	for (int i = 0; i < x.size(); i++) {
		for (int j = 0; j < y.size(); j++) {
			res[i + j] += x[i] * y[j] % mod;
			res[i + j] %= mod;
		}
	}
	return res;
}

vector<int> polMod(const vector<int>&x, const vector<int>& polyMod, int p) {
	int size1 = 0, size2 = 0;
	for (int i = x.size() - 1; i >= 0; i--) {
		if (x[i] > 0) {
			size1 = i;
			break;
		}
	}
	for (int i = polyMod.size() - 1; i >= 0; i--) {
		if (polyMod[i] > 0) {
			size2 = i;
			break;
		}
	}
	vector<int> res = x;
	if (size1 < size2) {
		while (res[res.size() - 1] == 0 && res.size() > 1) res.pop_back();
		return res;
	}
	vector<int> q(size1 - size2 + 1, 0);
	while (size1 >= size2) {
		int pow = size1 - size2;
		q[pow] = getInv(polyMod[size2], p) * res[size1];
		res = polSub(res, polMult(q, polyMod, p), p);
		q[pow] = 0;
		size1--;
	}
	while (res[res.size() - 1] == 0 && res.size() > 1) res.pop_back();
	return res;
}

vector<int> binPow(const vector<int>& a, int n, const vector<int>& polyMod, int p) {
	if (n == 0) {
		return { 1 };
	}
	if (n % 2 == 0) {
		vector<int> b = binPow(a, n / 2, polyMod, p);
		b = polMod(b, polyMod, p);
		b = polMult(b, b, p);
		b = polMod(b, polyMod, p);
		return b;
	}
	else {
		vector<int> x = binPow(a, n - 1, polyMod, p);
		x = polMult(x, a, p);
		x = polMod(x, polyMod, p);
		return x;
	}
}

vector<int> gcd(const vector<int>& a, const vector<int>& b, int p) {
	vector<int> tmpA = a, tmpB = b;
	while (tmpA[tmpA.size() - 1] == 0 && tmpA.size() > 1) tmpA.pop_back();
	while (tmpB[tmpB.size() - 1] == 0 && tmpB.size() > 1) tmpB.pop_back();

	if (polEq(tmpA, tmpB)) return{ 1 };
	if (tmpA.size() == 1 && tmpA[0] == 0 || tmpB.size() == 1 && tmpB[0] == 0) return{ 1 };

	while (tmpB.size() != 1 || tmpB[0] != 0) {
		tmpA = polMod(tmpA, tmpB, p);
		swap(tmpA, tmpB);
	}
	while (tmpA[tmpA.size() - 1] == 0 && tmpA.size() > 1) tmpA.pop_back();
	return tmpA;
}

bool testPolForIrreducible(int p, const vector<int>& f_x) {
	bool debugFlag = false;
	int m = f_x.size();
	vector<int> u_x({ 0, 1 }), d_x;
	
	for (int i = 1; i <= m / 2; i++) {
		vector<int> x({ 0, 1 });
		u_x = binPow(u_x, p, f_x, p);
		d_x = gcd(f_x, polSub(u_x, x, p), p);
		
		if (d_x.size() > 1/* || d_x[0] != 1*/) {
			if (debugFlag) {
				cout << "debug: " << i << endl;
				for (int i = 0; i < d_x.size(); i++) {
					cout << d_x[i] << " ";
				}
				cout << endl;
			}
			return false;
		}
	}
	return true;
}

vector<int> genRandomIrreduciblePol(int p, int m) {
	//cout << "Searching for irreducible pollynom" << endl;
	bool debugFlag = false;
	vector<int> f_x(m + 1, 0);
	
	mt19937 gen;
	gen.seed((unsigned long)time(nullptr));
	std::uniform_int_distribution<> uid(0, p - 1);

	do {
		if (debugFlag) {
			for (int i = 0; i < f_x.size(); i++) {
				cout << f_x[i] << " ";
			}		
			cout << " - Reducible" << endl;
		}
		f_x = { 2, 6, 5, 3, 1 };
		return f_x;
		for (int i = 0; i < f_x.size(); i++) {
			int value = uid(gen);
			while (i == f_x.size() - 1 && value == 0)
				value = uid(gen);
			f_x[i] = value;
		}
		if (debugFlag) {
			for (int i = 0; i < f_x.size(); i++) {
				cout << f_x[i] << " ";
			}
			cout << " - testing" << endl;
		}
	} while (!testPolForIrreducible(p, f_x));
	if (debugFlag) {
		for (int i = 0; i < f_x.size(); i++) {
			cout << f_x[i] << " ";
		}
		cout << " - OK" << endl;
	}
	return f_x;
}

vector<int> getGenerator(const vector<int>& f, int p, int h) {
	//cout << "Searching for generator" << endl;
	vector<int> g(h, 0);
	int n = binPow(p, h, LLONG_MAX) - 1;
	vector<int> pr, lp(n + 1, 0);
	set<int> s;

	for (int i = 2; i <= n; i++) {
		if (lp[i] == 0) {
			lp[i] = i;
			pr.push_back(i);
		}
		for (int j = 0; j < pr.size() && pr[j] <= lp[i] && i * pr[j] <= n; j++) {
			lp[pr[j] * i] = pr[j];
		}
	}
	for (int i = n; lp[i] > 0;) {
		s.insert(lp[i]);
		i /= lp[i];
	}

	mt19937 gen;
	gen.seed((unsigned long)time(nullptr));
	std::uniform_int_distribution<> uid(0, p - 1);

	while (true) {
		for (int i = 0; i < g.size(); i++) {
			int value = uid(gen);
			g[i] = value;
		}
		bool flag = false;
		for (auto x : s) {
			if (polEq({ 1 }, binPow(g, n / x, f, p))) {
				flag = true;
				break;
			}
		}
		if (!flag) break;
	}

	return g;
}

int polLog(const vector<int>& g, const vector<int>& x, const vector<int>& f, int p) {
	int ans = 2;
	vector<int> tmp = polMult(g, g, p);
	tmp = polMod(tmp, f, p);
	while (!polEq(tmp, x)) {
		ans++;
		tmp = polMult(tmp, g, p);
		tmp = polMod(tmp, f, p);
	}
	return ans;
}

pair<PublicKey, PrivateKey> init(int p, int h) {
	PublicKey publicKey;
	PrivateKey privateKey;

	publicKey.p = p;
	publicKey.h = h;

	privateKey.f = genRandomIrreduciblePol(p, h);
	privateKey.g = getGenerator(privateKey.f, p, h);

	privateKey.invPi.resize(p);
	for (int i = 0; i < p; i++) {
		privateKey.pi.push_back(i);
	}
	getRandomPermutation(privateKey.pi);
	for (int i = 0; i < p; i++) {
		privateKey.invPi[privateKey.pi[i]] = i;
	}
	privateKey.d = getRandomDigit(binPow(p, h, LLONG_MAX) - 2);

	vector<int> x = { 0, 1 };
	vector<int> a;
	for (int i = 0; i < p; i++) {
		x[0] = i;
		int value = polLog(privateKey.g, x, privateKey.f, p);
		a.push_back(value);
	}	
	
	int mod = binPow(p, h, LLONG_MAX) - 1;
	for (int i = 0; i < p; i++) {
		publicKey.c.push_back(a[privateKey.pi[i]] + privateKey.d);
		publicKey.c[i] %= mod;
	}
	return { publicKey, privateKey };
}

void encrypt(PublicKey publicKey) {
	int p = publicKey.p;
	int h = publicKey.h;
	vector<int> c = publicKey.c;

	ifstream input("input.txt");
	ofstream output("enc_output.txt");

	unsigned int m;
	input >> m;
	
	vector<int> M(p);
	int size = (int)log2(C(p, h));
	int res = 0;
	int mod = binPow(p, h, LLONG_MAX) - 1;

	unsigned int tmp = binPow(2, size, LLONG_MAX) - 1;
	unsigned int y = m;
	vector<unsigned int> mArr;

	if (y < tmp)
		mArr.push_back(y);
	while (y >= tmp) {
		int x = y & tmp;
		y >>= size;
		mArr.push_back(x);
		if (y < tmp) mArr.push_back(y);
	} 

	output << mArr.size() << endl;
	for (int j = 0; j < mArr.size(); j++) {
		for (int l = h, i = 1; i <= p; i++) {
			int x = C(p - i, l);
			if (mArr[j] >= x) {
				M[i - 1] = 1;
				mArr[j] -= x;
				l--;
			}
			else {
				M[i - 1] = 0;
			}
		}

		for (int i = 0; i < p; i++) {
			res += M[i] * c[i] % mod;
			res %= mod;
		}

		output << res << endl;
		res = 0;
	}
}

void decrypt(PublicKey publicKey, PrivateKey privateKey) {
	int p = publicKey.p;
	int h = publicKey.h;
	int d = privateKey.d;
	vector<int> pi = privateKey.pi;
	vector<int> invPi = privateKey.invPi;
	vector<int> f = privateKey.f;
	vector<int> g = privateKey.g;
	
	ifstream input("enc_output.txt");
	ofstream output("dec_output.txt");
	
	int inputSize;
	unsigned int ans = 0;
	int wordSize = log2(C(p, h));
	vector<unsigned int> c;
	int mod = binPow(p, h, LLONG_MAX) - 1;
	input >> inputSize;
	for (int i = 0; i < inputSize; i++) {
		int x;
		input >> x;
		c.push_back(x);
	}
	
	for (int j = inputSize - 1; j >= 0; j--) {
		int r = c[j] - h * d;
		if (r > 0)
			r %= mod;
		else
			r = (abs(r) / mod + 1) * mod + r;

		vector<int> u = binPow(g, r, f, p);
		vector<int> s = polSum(u, f, p);
		vector<int> x({ 0, 1 });
		vector<int> t;

		for (int i = 0; i < p; i++) {
			x[0] = i;
			if (polEq(x, gcd(x, s, p))) t.push_back(i);
		}

		if (t.size() != 4) {
			output << "Something bad happend!" << endl;
			return;
		}

		vector<int> M(p, 0);
		for (int i = 0; i < t.size(); i++) {
			M[invPi[t[i]]] = 1;
		}
		int res = 0;
		for (int i = 1, l = h; i <= p; i++) {
			if (M[i - 1]) {
				res += C(p - i, l);
				l--;
			}
		}

		ans += res;
		if (j > 0)
			ans <<= wordSize;
	}	

	output << ans;
}

void runTests() {
	vector<int> g({ 6, 0, 3, 3 });
	vector<int> f({ 2, 6, 5, 3, 1 });
	vector<int> ans({ 5, 2, 3, 1 });
	vector<int> x({ 0, 1 });
	vector<int> a;
	int p = 7;
	int h = 4;
	bool flag = false;
	vector<vector<int>> pols;

	/*if (polEq(binPow(g, 1913, f, p), ans)) {
		cout << "Test1 - passed" << endl;
	}
	else {
		cout << "Test1 - failed" << endl;
	}

	a = { 1028, 1935, 2054, 1008, 379, 1780, 223 };
	flag = false;
	for (int i = 0; i < p; i++) {
		x[0] = i;
		if (!polEq(binPow(g, a[i], f, p), x)) {
			cout << "Test2 - failed on x + " << i << endl;
			flag = true;
			break;
		}
	}
	if (!flag) cout << "Test2 - passed" << endl;*/

	/*a = { 0, 2, 3, 6 };
	vector<int> y = { 0, 1, 1, 4, 1 };
	flag = false;
	for (int i = 0; i < a.size(); i++) {
		x[0] = a[i];
		if (!polEq(x, gcd(x, y, p))) {
			cout << "Test 3 - failed on x + " << a[i] << endl;
			flag = true;
			break;
		}
	}
	if (!flag) cout << "Test3 - passed" << endl;*/

	if (testPolForIrreducible(p, f)) {
		cout << "Test 4 - passed" << endl;
	} else {
		cout << "Test 4 - failed" << endl;
	}

	pols = {
		{ 1, 1 }, { 1, 1, 1 }, { 1, 1, 0, 1 }, { 1, 0, 1, 1 },
		{ 1, 1, 0, 0, 1 },
		{ 1, 0, 1, 0, 0, 1 }, { 1, 0, 0, 1, 0, 1 }, { 1, 1, 1, 1, 0, 1 }, { 1, 1, 1, 0, 1, 1 }, { 1, 1, 0, 1, 1, 1 }, { 1, 0, 1, 1, 1, 1 },
		{ 1, 1, 1, 0, 0, 1, 1 }, {1, 1, 1, 0, 1, 1, 1, 0, 1},
		{ 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 }, {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}
	};
	for (int i = 0; i < pols.size(); i++) {
		if (!testPolForIrreducible(2, pols[i])) {
			cout << "Test 5 - failed" << endl;
			for (int j = 0; j < pols[i].size(); j++) {
				cout << pols[i][j] << " ";
			}
			cout << endl;
			flag = true;
			break;
		}
	}
	if (!flag) cout << "Test5 - passed" << endl;

	pols = {
		{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }, { 0, 1, 1 }
	};
	for (int i = 0; i < pols.size(); i++) {
		if (testPolForIrreducible(2, pols[i])) {
			cout << "Test 6 - failed" << endl;
			for (int j = 0; j < pols[i].size(); j++) {
				cout << pols[i][j] << " ";
			}
			cout << endl;
			flag = true;
			break;
		}
	}
	if (!flag) cout << "Test6 - passed" << endl;

	/*vector<int> tmp1 = polMult(f, g, p);
	tmp1 = polMult(tmp1, ans, p);
	if (polEq(gcd(tmp1, f, p), f) && polEq(gcd(tmp1, g, p), g) && polEq(gcd(tmp1, ans, p), ans))
		cout << "Test7 - passed" << endl;
	else 
		cout << "Test7 - failed" << endl;

	tmp1 = { 0, 1 };
	vector<int> tmp2 = { 0, 1, 1, 1, 1, 1, 1, 1, 1 };
	if (polEq(gcd(tmp1, tmp2, p), tmp1))
		cout << "Test8 - passed" << endl;
	else
		cout << "Test8 - failed" << endl;

	vector<int> gen = getGenerator(f, p, h);
	int ind = polLog(gen, { 5, 1 }, f, p);
	if (polEq({ 5, 1 }, binPow(gen, ind, f, p))) {
		cout << "Test10 - passed" << endl;
	}
	else {
		cout << "Test10 - failed" << endl;
	}*/
	
	vector<int> f11 = genRandomIrreduciblePol(p, h);
	vector<int> g11 = getGenerator(f11, p, h);
	vector<int> x11 = { 0, 6 };
	int ind11 = polLog(g11, x11, f11, p);
	if (polEq(binPow(g11, ind11, f, p), x11)) {
		cout << "Test11 - passed" << endl;
	}
	else {
		cout << "Test11 - failed" << endl;
	}

	system("pause");
}

int main() {
	pair<PublicKey, PrivateKey> p = init(7, 4);
	encrypt(p.first);
	decrypt(p.first, p.second);
	//runTests();
	
	//system("pause");
	return 0;
}