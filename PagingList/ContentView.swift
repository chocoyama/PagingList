//
//  ContentView.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    private var collections: [Collection<Section, Item>] {
        var collections = [Collection<Section, Item>]()
        collections.append(.init(section: .first, items: (1...10).map({ Item(name: "1-\($0)") })))
        collections.append(.init(section: .second, items: (1...10).map({ Item(name: "2-\($0)") })))
        return collections
    }
    
    @State var selectedItem: Item?
    @State var showingSheet = false
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            CollectionView(
                collections: self.collections,
                layout: CompositionalLayoutContainer(size: .init(width: (geometry.size.width - 30) / 2,
                                                                 height: (geometry.size.width - 30) / 2))
            ) { (item) in
                Text(item.name)
            }.onSelect { (item) in
                self.selectedItem = item
                self.showingSheet = true
            }.sheet(isPresented: self.$showingSheet) {
                Text(self.selectedItem!.name)
            }
        }
    }
}











enum Section: Hashable, CaseIterable {
    case first
    case second
}

struct Item: Hashable {
    let id = UUID()
    let name: String
}

struct FlowLayoutContainer: CollectionViewLayoutContainer {
    var layout: UICollectionViewLayout { flowLayout }
    var itemSize: CGSize { flowLayout.itemSize }
    
    private let flowLayout: UICollectionViewFlowLayout
    
    init(size: CGSize) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: size.width, height: size.height)
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        self.flowLayout = flowLayout
    }
}

struct CompositionalLayoutContainer: CollectionViewLayoutContainer {
    var layout: UICollectionViewLayout { compositionalLayout }
    var itemSize: CGSize
    
    private let compositionalLayout: UICollectionViewCompositionalLayout
    
    init(size: CGSize) {
        self.itemSize = size
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(size.width)
        )

        // count引数で明確にアイテム数を指定することで、
        // CompositionalLayoutにアイテムの幅を計算させることができる
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
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

        compositionalLayout = UICollectionViewCompositionalLayout(section: section)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
