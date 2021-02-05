//
//  ViewController.swift
//  FibonacciTable
//
//  Created by Денис on 05.02.2021.
//

import UIKit

class SimpleNumbersViewController: UIViewController {
    
    private var items = Array(0..<40)
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
        title = "Simple"
        view.backgroundColor = .white
        NumberCollectionViewCell.register(collectionView)
        setupConstraits()
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
            strongSelf.items = (0...strongSelf.items.count + 15).map {
                index in index }
            strongSelf.loadMore = false
            strongSelf.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension SimpleNumbersViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    
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

