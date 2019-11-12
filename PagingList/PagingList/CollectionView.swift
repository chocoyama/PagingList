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
    private let layout: CollectionViewLayout
    private let viewController: UICollectionViewController
    private let action: ((Item) -> Void)?
    private let content: (Item) -> Content
    
    init(
        sections: [Section],
        items: [Item],
        layout: CollectionViewLayout,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.sections = sections
        self.items = items
        self.layout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: layout.build())
        self.action = nil
        self.content = content
    }
    
    private init(
        sections: [Section],
        items: [Item],
        layout: CollectionViewLayout,
        action: ((Item) -> Void)?,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.sections = sections
        self.items = items
        self.layout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: layout.build())
        self.action = action
        self.content = content
    }
    
    func makeCoordinator() -> CollectionView.Coordinator {
        Coordinator(self, collectionView: viewController.collectionView!, content: content, action: action)
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
    
    func onSelected(perform action: @escaping (Item) -> Void) -> Self {
        CollectionView(sections: sections, items: items, layout: layout, action: action, content: content)
    }
}

extension CollectionView {
    class Coordinator: NSObject, UICollectionViewDelegate {
        let collectionViewController: CollectionView
        let dataSource: UICollectionViewDiffableDataSource<Section, Item>
        let content: (Item) -> Content
        let action: ((Item) -> Void)?
        
        init(
            _ collectionViewController: CollectionView,
            collectionView: UICollectionView,
            content: @escaping (Item) -> Content,
            action: ((Item) -> Void)?
        ) {
            self.collectionViewController = collectionViewController
            self.content = content
            self.action = action
            
            collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
            
            dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { (collectionView, indexPath, element) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
                cell.set(
                    content: UIHostingController(rootView: content(element)).view,
                    size: collectionViewController.layout.itemSize
                )
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
            action?(item)
        }
    }
}
