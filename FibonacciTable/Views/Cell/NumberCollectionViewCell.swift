//
//  NumberCollectionViewCell.swift
//  FibonacciTable
//
//  Created by Денис on 05.02.2021.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "cell"
    
    var viewModel: CellViewModelProtocol!
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraits()
        self.numberLabel.text = String(describing: viewModel.number)
        self.backgroundColor = viewModel.getColor()
    }

    func setupConstraits() {
        addSubview(numberLabel)
        numberLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    }
    
    static func register(_ colelctionView: UICollectionView) {
        colelctionView.register(self, forCellWithReuseIdentifier: cellId)
    }
    
    static func dequeue(_ colelctionView: UICollectionView, for indexPath: IndexPath) -> NumberCollectionViewCell {
        guard let cell = colelctionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? NumberCollectionViewCell else { return NumberCollectionViewCell() }
        return cell
    }
}
