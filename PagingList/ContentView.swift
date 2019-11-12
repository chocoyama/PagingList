//
//  ContentView.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedItem: Item?
    @State var showingSheet = false
    
    private let collections = Section.allCases.map { Collection(section: $0, items: (0..<10).map { Item(name: "\($0)") }) }
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            CollectionView(
                collections: self.collections,
                layout: self.compositionalLayout(for: self.collections, with: geometry.size)
            ) { itemContainer in
                self.view(for: itemContainer)
            }.onSelect { (item) in
                self.selectedItem = item
                self.showingSheet = true
            }.onScroll(perform: { (percent) in
                if percent > 0.8 {
                    print("Should next fetch.")
                } else {
                    print("Ready to fetch.")
                }
            }).sheet(isPresented: self.$showingSheet) {
                Text(self.selectedItem!.name)
            }
        }
    }
    
    private func view(for itemContainer: ItemContainer<Section, Item>) -> some View {
        switch itemContainer.section {
        case .first:
            return AnyView(
                HStack {
                    Text("Section1")
                    Text(itemContainer.item.name)
                }
            )
        case .second:
            return AnyView(
                VStack {
                    Text("Section2")
                    Text(itemContainer.item.name)
                }
            )
        }
    }
    
    private func compositionalLayout(for collections: [Collection<Section, Item>], with geometrySize: CGSize) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let collection = self.collections[sectionIndex]
            
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(collection.section.itemSize(for: geometrySize).height)
            )
            
            // count引数で明確にアイテム数を指定することで、
            // CompositionalLayoutにアイテムの幅を計算させることができる
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: collection.section.columnCount
            )
            group.interItemSpacing = .fixed(CGFloat(10))
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = CGFloat(10)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 10,
                bottom: 0,
                trailing: 10
            )
            
            return section
        }
    }
}

enum Section: Hashable, CaseIterable {
    case first
    case second
    
    var columnCount: Int {
        switch self {
        case .first: return 1
        case .second: return 2
        }
    }
    
    func itemSize(for geometrySize: CGSize) -> CGSize {
        switch self {
        case .first:
            return CGSize(width: (geometrySize.width - 30) / 2, height: (geometrySize.width - 30) / 2)
        case .second:
            return CGSize(width: (geometrySize.width - 30) / 2, height: (geometrySize.width - 30) / 2)
        }
    }
}

struct Item: Hashable {
    let id = UUID()
    let name: String
}

//struct FlowLayoutContainer: CollectionViewLayoutContainer {
//    var layout: UICollectionViewLayout { flowLayout }
//    var itemSize: CGSize { flowLayout.itemSize }
//
//    private let flowLayout: UICollectionViewFlowLayout
//
//    init(size: CGSize) {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = .init(width: size.width, height: size.height)
//        flowLayout.sectionInset = .zero
//        flowLayout.minimumLineSpacing = 0
//        flowLayout.minimumInteritemSpacing = 0
//        self.flowLayout = flowLayout
//    }
//}

//struct CompositionalLayoutContainer: CollectionViewLayoutContainer {
//    var layout: UICollectionViewLayout { compositionalLayout }
//    var itemSize: CGSize
//
//    private let compositionalLayout: UICollectionViewCompositionalLayout
//
//    init(collections: [Collection<Section, Item>]) {
//        compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//            let collection = collections[sectionIndex]
//
//            let itemSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .fractionalHeight(1.0)
//            )
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//            let groupSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .absolute(collection.itemSize.width)
//            )
//
//            // count引数で明確にアイテム数を指定することで、
//            // CompositionalLayoutにアイテムの幅を計算させることができる
//            let group = NSCollectionLayoutGroup.horizontal(
//                layoutSize: groupSize,
//                subitem: item,
//                count: 2
//            )
//            group.interItemSpacing = .fixed(CGFloat(10))
//
//            let section = NSCollectionLayoutSection(group: group)
//            section.interGroupSpacing = CGFloat(10)
//            section.contentInsets = NSDirectionalEdgeInsets(
//                top: 10,
//                leading: 10,
//                bottom: 0,
//                trailing: 10
//            )
//
//            return section
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
