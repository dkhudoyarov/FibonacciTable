//
//  ViewController.swift
//  FibonacciTable
//
//  Created by Денис on 05.02.2021.
//

import UIKit

class NumbersViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: NumbersViewModelProtocol!

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
        
        title = viewModel.getTitle(for: tabBarItem.tag)
        
        view.backgroundColor = .white
        NumberCollectionViewCell.register(collectionView)
        setupConstraits()
    }
    
    // MARK: - Methods
    private func setupConstraits() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension NumbersViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberForRow(for: tabBarItem.tag) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = NumberCollectionViewCell.dequeue(collectionView, for: indexPath)
        let cellViewModel = viewModel.cellViewModel(for: tabBarItem.tag, at: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !viewModel.loadMore {
                viewModel.startLoad(for: tabBarItem.tag) { [weak self] in
                    guard let strongSelf = self else { return }
                    DispatchQueue.main.async {
                        strongSelf.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
