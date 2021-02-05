//
//  NumberCollectionViewCell.swift
//  FibonacciTable
//
//  Created by Денис on 05.02.2021.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "cell"
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with number: Int = 0, at indexPath: IndexPath) {
        addSubview(numberLabel)
        numberLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        numberLabel.text = "\(number)"
        backgroundColor = checkCell(indexPath) ? .lightGray : .white
    }
    
    private func checkCell(_ indexPath: IndexPath) -> Bool {
        let index = indexPath.row % 4
        return index == 0 || index == 3
    }
    
    static func register(_ colelctionView: UICollectionView) {
        colelctionView.register(self, forCellWithReuseIdentifier: cellId)
    }
    
    static func dequeue(_ colelctionView: UICollectionView, for indexPath: IndexPath) -> NumberCollectionViewCell {
        guard let cell = colelctionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? NumberCollectionViewCell else { return NumberCollectionViewCell() }
        return cell
    }
}
