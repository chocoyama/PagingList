//
//  CollectionView.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import UIKit

struct CollectionView<Section: Hashable, Item: Hashable, Content>: UIViewControllerRepresentable where Content: View {
    private let sections: [Section]
    private let items: [Item]
    private let collectionViewLayout: CollectionViewLayoutContainer
    private let viewController: UICollectionViewController
    private let onSelect: ((Item) -> Void)?
    private let content: (Item) -> Content
    
    init(
        sections: [Section],
        items: [Item],
        layout: CollectionViewLayoutContainer,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.sections = sections
        self.items = items
        self.collectionViewLayout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: collectionViewLayout.layout)
        self.onSelect = nil
        self.content = content
    }
    
    private init(
        sections: [Section],
        items: [Item],
        layout: CollectionViewLayoutContainer,
        onSelect: ((Item) -> Void)?,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.sections = sections
        self.items = items
        self.collectionViewLayout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: collectionViewLayout.layout)
        self.onSelect = onSelect
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
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems(items, toSection: $0) }
        context.coordinator.dataSource.apply(snapshot)
    }
    
    func onSelect(perform action: @escaping (Item) -> Void) -> Self {
        CollectionView(sections: sections, items: items, layout: collectionViewLayout, onSelect: action, content: content)
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
