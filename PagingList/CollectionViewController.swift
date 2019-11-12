//
//  CollectionViewController.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import UIKit

protocol CellProvider {
    static func provide<T>(collectionView: UICollectionView, indexPath: IndexPath, element: T) -> UICollectionViewCell
}

struct CollectionViewController<Section: Hashable, Item: Hashable>: UIViewControllerRepresentable {
    private let sections: [Section]
    private let items: [Item]
    private let layout: UICollectionViewLayout
    private let viewController: UICollectionViewController
    private let cellProvider: CellProvider.Type
    
    init(
        sections: [Section],
        items: [Item],
        layout: UICollectionViewLayout,
        cellProvider: CellProvider.Type
    ) {
        self.sections = sections
        self.items = items
        self.layout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: layout)
        self.cellProvider = cellProvider
    }
    
    func makeCoordinator() -> CollectionViewController.Coordinator {
        Coordinator(self, collectionView: viewController.collectionView!)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CollectionViewController>) -> UICollectionViewController {
        viewController.collectionView.dataSource = context.coordinator.dataSource
        viewController.collectionView.alwaysBounceVertical = true
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: UIViewControllerRepresentableContext<CollectionViewController>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems(items, toSection: $0) }
        context.coordinator.dataSource.apply(snapshot)
    }
}

extension CollectionViewController {
    struct Coordinator {
        let collectionViewController: CollectionViewController
        let dataSource: UICollectionViewDiffableDataSource<Section, Item>
        
        init(_ collectionViewController: CollectionViewController, collectionView: UICollectionView) {
            self.collectionViewController = collectionViewController
            collectionView.register(UINib(nibName: String(describing: SampleCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "sample")
            dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: collectionViewController.cellProvider.provide(collectionView:indexPath:element:))
        }
    }
}
