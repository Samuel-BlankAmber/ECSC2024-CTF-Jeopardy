#include <Windows.h>
#include <algorithm>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <functional>
#include <fcntl.h>
#include <time.h>
#include <io.h>

#pragma comment(lib, "bcrypt.lib")

#define DEBUG 0

using namespace std;

HANDLE PRIVATE_HEAP = NULL;

string Flag;

[[noreturn]] VOID Die(const string& message)
{
	cout << message << endl;
	exit(1);
}

PVOID PrivateAlloc(size_t size)
{
	if (!PRIVATE_HEAP)
	{
		PRIVATE_HEAP = HeapCreate(0, 0, 0);
		if (!PRIVATE_HEAP)
			Die("HeapCreate failed");
	}

	PVOID ptr = HeapAlloc(PRIVATE_HEAP, 0, size);
	if (!ptr)
		Die("HeapAlloc failed");

	return ptr;
}

VOID PrivateDelete(PVOID ptr, size_t size)
{
	if (!PRIVATE_HEAP)
	{
		return;
	}

	if (!ptr)
		return;

	if (BCryptGenRandom(nullptr, (PUCHAR)ptr, (ULONG)size, BCRYPT_USE_SYSTEM_PREFERRED_RNG) != 0)
		Die("BCryptGenRandom failed");

	if (!HeapFree(PRIVATE_HEAP, 0, ptr))
		Die("HeapFree failed");
}

template <typename T>
class PrivateClass
{
public:
	PVOID operator new(size_t size)
	{
		return PrivateAlloc(size);
	}

	VOID operator delete(PVOID ptr)
	{
		PrivateDelete(ptr, sizeof(T));
	}

	PVOID operator new[](size_t size)
	{
		return PrivateClass::operator new(size);
	}

	VOID operator delete[](PVOID ptr)
	{
		PrivateClass::operator delete(ptr);
	}
};

template <typename T>
class PrivateAllocator
{
public:
	using value_type = T;

	PrivateAllocator() noexcept = default;

	template <typename U>
	PrivateAllocator(const PrivateAllocator<U>&) noexcept {}

	T* allocate(size_t n)
	{
		const size_t size = n * sizeof(T);
		return static_cast<T*>(PrivateAlloc(size));
	}

	VOID deallocate(T* ptr, size_t size) noexcept
	{
		PrivateDelete(ptr, size);
	}
};

using PrivateString = basic_string<char, char_traits<char>, PrivateAllocator<char>>;
template <typename T>
using PrivateVector = vector<T, PrivateAllocator<T>>;

#define MAX_CPUS 100
#define MAX_CORES 2000
#define MAX_LEASE_TIMESTAMP 1798761600
#define MAX_LEASE_DURATION 60 * 60 * 4

class Lease : public PrivateClass<Lease>
{
	static UINT leaseId;

public:
	UINT id;
	PrivateString clientId;
	UINT timestamp;
	UINT duration;
	UINT cores;

	Lease(UINT timestamp, UINT duration, UINT cores) : id(leaseId++), timestamp(timestamp), duration(duration), cores(cores) {}
};

UINT Lease::leaseId = 0;

class CPU : public PrivateClass<CPU>
{
	static UINT cpuId;

public:
	UINT id;
	UINT cores;
	FLOAT pricePerSecond;
	PrivateVector<Lease*> leases;

	CPU(UINT cores, FLOAT pricePerSecond) : id(cpuId++), cores(cores), pricePerSecond(pricePerSecond) {}

	BOOL IsAvailable(UINT timestamp, UINT duration)
	{
		UINT newStart = timestamp;
		UINT newEnd = timestamp + duration;

		for (auto lease : leases)
		{
			UINT start = lease->timestamp;
			UINT end = lease->timestamp + lease->duration;

			if (newStart < end && newEnd > start)
				return FALSE;
		}
		return TRUE;
	}

	FLOAT GetPrice(UINT timestamp, UINT duration)
	{
		return duration * pricePerSecond;
	}
};

UINT CPU::cpuId = 0;

class Cluster : public PrivateClass<Cluster>
{
public:
	PrivateVector<CPU*> cpus;

	Cluster(vector<UINT> cores, vector<FLOAT> pricePerSecond)
	{
		if (cores.size() != pricePerSecond.size())
			Die("Invalid data");

		for (UINT i = 0; i < cores.size(); i++)
		{
			cpus.push_back(new CPU(cores[i], pricePerSecond[i]));
		}
	}
};

Cluster* cluster;

VOID Setup()
{
	if (_setmode(_fileno(stdout), _O_BINARY) == -1) // Just for pwntools to work on Windows
		Die("_setmode failed");
	setvbuf(stdin, (char*)NULL, _IONBF, 0);
	setvbuf(stdout, (char*)NULL, _IONBF, 0);
	setvbuf(stderr, (char*)NULL, _IONBF, 0);

	ifstream infile;

	infile.open("flag");
	if (infile.fail())
		Die("Error reading flag. Please contact support!");

	infile >> Flag;
}

VOID Banner()
{
	cout << "____________________________________________________________________________________" << endl;
	cout << "                                                       ____  ____  ____  ____  ____ " << endl;
	cout << "         __________  ___    ________  __  __          |====||====||====||====||====|" << endl;
	cout << "        /_  __/ __ \\/ _ \\  / ___/ _ \\/ / / /          |****||****||****||****||****|" << endl;
	cout << "         / / / /_/ / ___/ / /__/ ___/ /_/ /           |====||====||====||====||====|" << endl;
	cout << "        /_/  \\____/_/     \\___/_/   \\____/            |    ||    ||    ||    ||    |" << endl;
	cout << " _  ____  ____  _  _  _  _  _  ____  _  _  _  ____  _ |= = ||= = ||= = ||= = ||= = |" << endl;
	cout << "|=||====||====||=||=||=||=||=||====||=||=||=||====||=||^*^*||^*^*||^*^*||^*^*||^*^*|" << endl;
	cout << "|_||____||____||_||_||_||_||_||____||_||_||_||____||_||____||____||____||____||____|" << endl;
	cout << "													                                 " << endl;
	cout << "____________________________________________________________________________________" << endl;
	cout << "													                                 " << endl;
	cout << "                   Welcome to our cluster management service." << endl;
	cout << "													                                 " << endl;
}

VOID Menu()
{
	cout << "1. Get a lease" << endl;
	cout << "2. Cancel a lease" << endl;
	cout << "3. List leases" << endl;
	cout << "> ";
}

VOID GetLease()
{
	UINT timestamp, duration, cores;

	cout << "Timestamp: ";
	cin >> timestamp;
	cout << "Duration: ";
	cin >> duration;
	cout << "Cores: ";
	cin >> cores;

	if (timestamp < (UINT)_time32(NULL) || timestamp > MAX_LEASE_TIMESTAMP || duration > MAX_LEASE_DURATION || cores > MAX_CORES)
		Die("Invalid timestamp or duration!");

	for (auto cpu : cluster->cpus)
	{
		if (cpu->cores < cores)
			continue;

		if (!cpu->IsAvailable(timestamp, duration))
			continue;

		Lease* lease = new Lease(timestamp, duration, cores);
		cout << "Client id: ";
		getline(cin >> ws, lease->clientId);
		cpu->leases.push_back(lease);
		cout << "Lease created! Lease id: " << lease->id << ", total price: " << cpu->GetPrice(timestamp, duration) << "." << endl;
		return;
	}

	vector<CPU*> availableCPUs;
	UINT availableCores = 0;
	for (auto cpu : cluster->cpus)
	{
		if (cpu->IsAvailable(timestamp, duration))
		{
			availableCPUs.push_back(cpu);
			availableCores += cpu->cores;
		}
	}

	if (availableCores < cores)
	{
		cout << "No CPUs available!" << endl;
		return;
	}

	sort(availableCPUs.begin(), availableCPUs.end(), [](CPU* lhs, CPU* rhs)
		{ return lhs->cores > rhs->cores; });

	Lease* lease = new Lease(timestamp, duration, cores);
	cout << "Client id: ";
	getline(cin >> ws, lease->clientId);
	UINT reservedCores = 0;
	FLOAT totalPrice = 0;
	for (auto cpu : availableCPUs)
	{
		if (reservedCores >= lease->cores)
			break;

		cpu->leases.push_back(lease);
		reservedCores += cpu->cores;
		totalPrice += cpu->GetPrice(timestamp, duration);
	}
	cout << "Lease created! Lease id: " << lease->id << ", total price: " << totalPrice << "." << endl;
	return;
}

VOID CancelLease()
{
	UINT id;

	cout << "Lease id: ";
	cin >> id;

	for (auto cpu : cluster->cpus)
	{
		for (auto iterator = cpu->leases.begin(); iterator != cpu->leases.end(); iterator++)
		{
			if ((*iterator)->id == id)
			{
				delete* iterator;
				cpu->leases.erase(iterator);
				cout << "Lease canceled!" << endl;
				return;
			}
		}
	}
	cout << "Lease not found!" << endl;
	return;
}

VOID ListLeases()
{
	for (auto cpu : cluster->cpus)
	{
		if (cpu->leases.empty())
			continue;
		cout << "| CPU " << cpu->id << " | cores " << cpu->cores << " |" << endl;
		for (auto lease : cpu->leases)
		{
			cout << "|-  | Lease " << lease->id << " | client id " << lease->clientId << " | cores " << lease->cores << " | "
				"timestamp "
				<< lease->timestamp << " | duration " << lease->duration << " |" << endl;
		}
	}
	return;
}

INT main()
{
	Setup();
	Banner();

	UINT nCPUs;
	vector<UINT> cores;
	vector<FLOAT> pricesPerSecond;

	cout << "Welcome to our cluster management service." << endl;

	cout << "Please, enter the number of CPUs in your cluster: ";
	cin >> nCPUs;
	if (nCPUs > MAX_CPUS)
		Die("Invalid number of CPUs!");

	cout << "Please, enter the number of cores and price per second for each CPU: ";
	for (UINT i = 0; i < nCPUs; i++)
	{
		UINT c;
		FLOAT p;
		cin >> c;
		cin >> p;
		if (c > MAX_CORES)
			Die("Invalid number of cores!");
		cores.push_back(c);
		pricesPerSecond.push_back(p);
	}

	cout << "Initializing cluster";
	cluster = new Cluster(cores, pricesPerSecond);
	cout << endl
		<< "Cluster initialized successfully!" << endl;

	cout << "Warming it up";
	for (UINT i = 0; i < 18; i++)
	{
		HeapAlloc(PRIVATE_HEAP, 0, sizeof(Lease));
		cout << ".";
	}
	cout << endl
		<< "Your cluster is ready!" << endl;

	while (TRUE)
	{
		Menu();

		UINT choice;
		cin >> choice;

		switch (choice)
		{
		case 1:
		{
			GetLease();
			break;
		}
		case 2:
		{
			CancelLease();
			break;
		}
		case 3:
		{
			ListLeases();
			break;
		}
		default:
		{
			Die("Invalid choice!");
		}
		}
	}
	return 0;
}
