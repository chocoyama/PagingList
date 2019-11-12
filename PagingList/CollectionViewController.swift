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
    associatedtype Element
    static func provide(collectionView: UICollectionView, indexPath: IndexPath, element: Element) -> UICollectionViewCell
}

enum CollectionViewLayout {
    case flow(size: CGSize? = nil, sectionInset: UIEdgeInsets?, minimumLineSpacing: CGFloat?, minimumInteritemSpacing: CGFloat?)
    
    func build() -> UICollectionViewLayout {
        switch self {
        case let .flow(size, sectionInset, minimumLineSpacing, minimumInteritemSpacing):
            let layout = UICollectionViewFlowLayout()
            if let size = size { layout.itemSize = size }
            if let sectionInset = sectionInset { layout.sectionInset = sectionInset }
            if let minimumLineSpacing = minimumLineSpacing { layout.minimumLineSpacing = minimumLineSpacing }
            if let minimumInteritemSpacing = minimumInteritemSpacing { layout.minimumInteritemSpacing = minimumInteritemSpacing }
            return layout
        }
    }
}

struct CollectionViewController<Section: Hashable, Item: Hashable, Cell: CellProvider>: UIViewControllerRepresentable where Cell.Element == Item {
    private let sections: [Section]
    private let items: [Item]
    private let viewController: UICollectionViewController
    
    init(
        sections: [Section],
        items: [Item],
        layout: CollectionViewLayout
    ) {
        self.sections = sections
        self.items = items
        self.viewController = UICollectionViewController(collectionViewLayout: layout.build())
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
            dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: Cell.provide)
        }
    }
}
