//
//  CollectionView.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import UIKit

struct Collection<Section: Hashable, Item: Hashable> {
    let section: Section
    let items: [Item]
}

struct CollectionView<Section: Hashable, Item: Hashable, Content>: UIViewControllerRepresentable where Content: View {
    private let collections: [Collection<Section, Item>]
    private let collectionViewLayout: CollectionViewLayoutContainer
    private let viewController: UICollectionViewController
    private var onSelect: ((Item) -> Void)?
    private let content: (Item) -> Content
    
    init(
        collections: [Collection<Section, Item>],
        layout: CollectionViewLayoutContainer,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.collections = collections
        self.collectionViewLayout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: collectionViewLayout.layout)
        self.onSelect = nil
        self.content = content
    }
    
    func makeCoordinator() -> CollectionView.Coordinator {
        Coordinator(self, collectionView: viewController.collectionView!, content: content, onSelect: onSelect)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CollectionView>) -> UICollectionViewController {
        viewController.collectionView.dataSource = context.coordinator.dataSource
        viewController.collectionView.delegate = context.coordinator
        viewController.collectionView.alwaysBounceVertical = true
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: UIViewControllerRepresentableContext<CollectionView>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(collections.map { $0.section })
        collections.forEach { snapshot.appendItems($0.items, toSection: $0.section) }
        context.coordinator.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func onSelect(perform action: @escaping (Item) -> Void) -> Self {
        var collectionView = CollectionView(collections: collections, layout: collectionViewLayout, content: content)
        collectionView.onSelect = action
        return collectionView
    }
}

extension CollectionView {
    class Coordinator: NSObject, UICollectionViewDelegate {
        let collectionViewController: CollectionView
        let dataSource: UICollectionViewDiffableDataSource<Section, Item>
        let content: (Item) -> Content
        let onSelect: ((Item) -> Void)?
        
        init(
            _ collectionViewController: CollectionView,
            collectionView: UICollectionView,
            content: @escaping (Item) -> Content,
            onSelect: ((Item) -> Void)?
        ) {
            self.collectionViewController = collectionViewController
            self.content = content
            self.onSelect = onSelect
            
            let cellIdentifier = "CollectionViewCell"
            collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, element) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
                let content = UIHostingController(rootView: content(element)).view!
                cell.set(content: content, size: collectionViewController.collectionViewLayout.itemSize)
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
            onSelect?(item)
        }
    }
}
