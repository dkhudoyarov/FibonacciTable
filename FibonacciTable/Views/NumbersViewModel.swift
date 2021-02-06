//
//  NumbersViewModel.swift
//  FibonacciTable
//
//  Created by Денис on 06.02.2021.
//

import Foundation

protocol NumbersViewModelProtocol {
    var primeNumbers: [Int] { get }
    var fibonacciNumbers: [Int] { get }
    var loadMore: Bool { get }
    func getTitle(for tag: Int) -> String
    func numberForRow(for tag: Int) -> Int?
    func startLoad(for tag: Int, completion: @escaping() -> ())
    func incrementFibonacciNumbers(_ array: inout[Int], n: Int)
    func incrementPrimeNumbers(_ array: inout[Int], n: Int)
    func cellViewModel(for tag: Int, at indexPath: IndexPath) -> CellViewModelProtocol?
    static func getFibbonaciNumbers(_ n: Int) -> [Int]
    static func getPrimeNumbers(n: Int) -> [Int]
}

final class NumbersViewModel: NumbersViewModelProtocol {
    
    var primeNumbers: [Int] = getPrimeNumbers(n: 200)
    var fibonacciNumbers: [Int] = getFibbonaciNumbers(40)
    var loadMore: Bool = false
    
    func numberForRow(for tag: Int) -> Int? {
        switch tag {
        case 0: return primeNumbers.count
        case 1: return fibonacciNumbers.count
        default: return 0
        }
    }
    
    func getTitle(for tag: Int) -> String {
        switch tag {
        case 0: return "Prime"
        case 1: return "Fibonacci"
        default: return ""
        }
    }
    
    func startLoad(for tag: Int, completion: @escaping () -> ()) {
        loadMore = true
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            switch tag {
            case 0:
                strongSelf.incrementPrimeNumbers(&strongSelf.primeNumbers, n: 5000)
            case 1:
                strongSelf.incrementFibonacciNumbers(&strongSelf.fibonacciNumbers, n: 15)
            default: break
            }
            strongSelf.loadMore = false
            completion()
        }
    }
    
    func incrementPrimeNumbers(_ array: inout[Int], n: Int) {
        let startIndex = array.count - 1
        let endIndex = (array.last ?? 0) + n
        for i in startIndex...endIndex {
            if array.allSatisfy({ i % $0 != 0 }) {
                array.append(i)
            }
        }
    }
    
    func incrementFibonacciNumbers(_ array: inout [Int], n: Int) {
        guard !array.isEmpty, n > 1 else { return }
        for _ in 0...n - 2 {
            let first = array[array.count - 2]
            let second = array.last!
            if first < Int.max / 2 {
                array.append(second + first)
            }
        }
    }
    
    func cellViewModel(for tag: Int, at indexPath: IndexPath) -> CellViewModelProtocol? {
        var number: Int
        switch tag {
        case 0: number = primeNumbers[indexPath.row]
        case 1: number = fibonacciNumbers[indexPath.row]
        default: number = 0
        }
        return CellViewModel(number: number, indexPath: indexPath)
    }
    
    static func getFibbonaciNumbers(_ n: Int) -> [Int] {
        var sequence = [0, 1]
        guard n > 1 else { return sequence}
        for _ in 0...n - 2{
            let first = sequence[sequence.count - 2]
            let second = sequence.last!
            sequence.append(first + second)
        }
        return sequence
    }
    
    static func getPrimeNumbers(n: Int) -> [Int] {
        var primes = [Int]()
        for n in 2...n {
            if primes.allSatisfy({ n % $0 != 0 }) {
                primes.append(n)
            }
        }
        return primes
    }
}
