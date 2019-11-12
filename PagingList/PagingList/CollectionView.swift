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

struct ItemContainer<Section: Hashable, Item: Hashable>: Hashable {
    let section: Section
    let item: Item
}

struct CollectionView<Section: Hashable, Item: Hashable, Content>: UIViewControllerRepresentable where Content: View {
    private let collections: [Collection<Section, Item>]
    private let collectionViewLayout: UICollectionViewLayout
    private let viewController: UICollectionViewController
    private var onSelect: ((Item) -> Void)?
    private var onScroll: ((Double) -> Void)?
    private let content: (ItemContainer<Section, Item>) -> Content
    
    init(
        collections: [Collection<Section, Item>],
        layout: UICollectionViewLayout,
        @ViewBuilder content: @escaping (ItemContainer<Section, Item>) -> Content
    ) {
        self.collections = collections
        self.collectionViewLayout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: layout)
        self.onSelect = nil
        self.onScroll = nil
        self.content = content
    }
    
    func makeCoordinator() -> CollectionView.Coordinator {
        Coordinator(self, collectionView: viewController.collectionView!, content: content, onSelect: onSelect, onScroll: onScroll)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CollectionView>) -> UICollectionViewController {
        viewController.collectionView.dataSource = context.coordinator.dataSource
        viewController.collectionView.delegate = context.coordinator
        viewController.collectionView.alwaysBounceVertical = true
        viewController.collectionView.backgroundColor = .systemBackground
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UICollectionViewController, context: UIViewControllerRepresentableContext<CollectionView>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemContainer<Section, Item>>()
        snapshot.appendSections(collections.map { $0.section })
        collections.forEach { collection in
            let itemContainers = collection.items.map { ItemContainer(section: collection.section, item: $0) }
            snapshot.appendItems(itemContainers, toSection: collection.section)
        }
        context.coordinator.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func onSelect(perform action: @escaping (Item) -> Void) -> Self {
        var collectionView = CollectionView(collections: collections, layout: collectionViewLayout, content: content)
        collectionView.onSelect = action
        collectionView.onScroll = onScroll
        return collectionView
    }
    
    func onScroll(perform action: @escaping (Double) -> Void) -> Self {
        var collectionView = CollectionView(collections: collections, layout: collectionViewLayout, content: content)
        collectionView.onSelect = onSelect
        collectionView.onScroll = action
        return collectionView
    }
}

extension CollectionView {
    class Coordinator: NSObject, UICollectionViewDelegate {
        let collectionViewController: CollectionView
        let dataSource: UICollectionViewDiffableDataSource<Section, ItemContainer<Section, Item>>
        let content: (ItemContainer<Section, Item>) -> Content
        let onSelect: ((Item) -> Void)?
        let onScroll: ((Double) -> Void)?
        
        init(
            _ collectionViewController: CollectionView,
            collectionView: UICollectionView,
            content: @escaping (ItemContainer<Section, Item>) -> Content,
            onSelect: ((Item) -> Void)?,
            onScroll: ((Double) -> Void)?
        ) {
            self.collectionViewController = collectionViewController
            self.content = content
            self.onSelect = onSelect
            self.onScroll = onScroll
            
            let cellIdentifier = "CollectionViewCell"
            collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, itemContainer) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
                let content = UIHostingController(rootView: content(itemContainer)).view!
                cell.set(content: content)
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let itemContainer = dataSource.itemIdentifier(for: indexPath) else { return }
            onSelect?(itemContainer.item)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard let collectionView = scrollView as? UICollectionView else { return }
            let height = collectionView.contentSize.height
            let y = collectionView.contentOffset.y + collectionView.frame.height
            let offsetPercentage = y / height
            onScroll?(Double(offsetPercentage))
        }
    }
}
