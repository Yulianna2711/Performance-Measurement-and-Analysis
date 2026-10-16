#include <iostream>
#include <vector>
#include <cstdlib>

const int N = 30000;

void bubble_sort(std::vector<int>& arr) {
    int n = arr.size();

    for (int i = 0; i < n - 1; ++i) {
        for (int j = 0; j < n - i - 1; ++j) {

            if (arr[j] > arr[j + 1]) {
                std::swap(arr[j], arr[j + 1]);
            }
        }
    }
}

bool check_if_sorted(const std::vector<int>& arr) {
    for (size_t i = 0; i < arr.size() - 1; ++i) {
        if (arr[i] > arr[i + 1]) {
            return false;
        }
    }

    return true;
}

int main() {
    std::vector<int> arr(N);

    for (int i = 0; i < N; ++i) {
        arr[i] = rand() % 100000;
    }

    bubble_sort(arr);

    if (check_if_sorted(arr)) {
        std::cout << "Array is correctly sorted!" << std::endl;
    } else {
        std::cout << "Sorting failed!" << std::endl;
    }

    return 0;
}
