//
//  CellViewModel.swift
//  FibonacciTable
//
//  Created by Денис on 06.02.2021.
//

import UIKit

protocol CellViewModelProtocol {
    init(number: Int, indexPath: IndexPath)
    var number: Int { get }
    func getColor() -> UIColor
}

final class CellViewModel: CellViewModelProtocol {
    var indexPath: IndexPath
    var number: Int
    
    init(number: Int, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.number = number
    }
    
    func getColor() -> UIColor {
        let index = indexPath.row % 4
        return index == 0 || index == 3 ? .lightGray : .white
    }
}
