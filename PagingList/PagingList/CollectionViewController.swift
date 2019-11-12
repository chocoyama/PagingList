//
//  CollectionViewController.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import UIKit

struct CollectionViewController<Section: Hashable, Item: Hashable, Cell: CellProvider>: UIViewControllerRepresentable where Cell.Element == Item {
    private let sections: [Section]
    private let items: [Item]
    private let layout: CollectionViewLayout
    private let viewController: UICollectionViewController
    private let action: ((Item) -> Void)?
    
    init(
        sections: [Section],
        items: [Item],
        layout: CollectionViewLayout
    ) {
        self.sections = sections
        self.items = items
        self.layout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: layout.build())
        self.action = nil
    }
    
    private init(
        sections: [Section],
        items: [Item],
        layout: CollectionViewLayout,
        action: ((Item) -> Void)?
    ) {
        self.sections = sections
        self.items = items
        self.layout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: layout.build())
        self.action = action
    }
    
    func makeCoordinator() -> CollectionViewController.Coordinator {
        Coordinator(self, collectionView: viewController.collectionView!, action: action)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CollectionViewController>) -> UICollectionViewController {
        viewController.collectionView.dataSource = context.coordinator.dataSource
        viewController.collectionView.delegate = context.coordinator
        viewController.collectionView.alwaysBounceVertical = true
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: UIViewControllerRepresentableContext<CollectionViewController>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems(items, toSection: $0) }
        context.coordinator.dataSource.apply(snapshot)
    }
    
    func onSelected(perform action: @escaping (Item) -> Void) -> Self {
        CollectionViewController(sections: sections, items: items, layout: layout, action: action)
    }
}

extension CollectionViewController {
    class Coordinator: NSObject, UICollectionViewDelegate {
        let collectionViewController: CollectionViewController
        let dataSource: UICollectionViewDiffableDataSource<Section, Item>
        let action: ((Item) -> Void)?
        
        init(
            _ collectionViewController: CollectionViewController,
            collectionView: UICollectionView,
            action: ((Item) -> Void)?
        ) {
            self.collectionViewController = collectionViewController
            self.action = action
            collectionView.register(UINib(nibName: Cell.nibName, bundle: nil), forCellWithReuseIdentifier: Cell.reuseIdentifier)
            dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: Cell.provide)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
            action?(item)
        }
    }
}
