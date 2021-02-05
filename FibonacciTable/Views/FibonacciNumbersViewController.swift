//
//  FibonacciNumbersViewController.swift
//  FibonacciTable
//
//  Created by Денис on 05.02.2021.
//

import UIKit

class FibonacciNumbersViewController: UIViewController {
    
    private var items = getFibbonaciNumbers(50)
    private var loadMore = false

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 2
        layout.itemSize = CGSize(width: width, height: 50)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fibonacci"
        view.backgroundColor = .white
        NumberCollectionViewCell.register(collectionView)
        setupConstraits()
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
    
    private func incrementFibonacciNumbers(_ array: inout[Int], n: Int) {
        guard !array.isEmpty, n > 1 else { return }
        for _ in 0...n - 2 {
            let first = array[array.count - 2]
            let second = array.last!
            if second < Int.max / 2 {
                array.append(second + first)
            }
        }
    }
    
    private func setupConstraits() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func startLoad() {
        loadMore = true
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.incrementFibonacciNumbers(&strongSelf.items, n: 15)
            strongSelf.loadMore = false
            strongSelf.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension FibonacciNumbersViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = NumberCollectionViewCell.dequeue(collectionView, for: indexPath)
        let number = items[indexPath.row]
        cell.configure(with: number, at: indexPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !loadMore {
                startLoad()
            }
        }
    }
}


