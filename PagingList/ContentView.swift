//
//  ContentView.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedItem: SampleItem?
    @State var showingSheet = false
    
    private let collections: [Collection<SampleSection, AnyHashable>] = {
        var collections = [Collection<SampleSection, AnyHashable>]()
        
        let firstItems = (0..<10).map { SampleItem(name: "\($0)") }
        collections.append(Collection(section: .first, items: firstItems))
        
        let secondItems = (0..<10).map { $0 }
        collections.append(Collection(section: .second, items: secondItems))
        
        return collections
    }()

    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            CollectionView(
                collections: self.collections,
                layout: self.compositionalLayout(for: self.collections, with: geometry.size)
            ) { itemContainer in
                self.view(for: itemContainer)
            }.onSelect { (itemContainer) in
                self.handleSelect(itemContainer)
            }.onScroll { (percent) in
                if percent > 0.8 {
                    print("Should next fetch.")
                } else {
                    print("Ready to fetch.")
                }
            }.sheet(isPresented: self.$showingSheet) {
                Text(self.selectedItem!.name)
            }
        }
    }
    
    private func view(for itemContainer: ItemContainer<SampleSection, AnyHashable>) -> some View {
        switch itemContainer.section {
        case .first:
            let item = itemContainer.item as! SampleItem
            return AnyView(
                HStack {
                    Text("Section1")
                    Text(item.name)
                }
            )
        case .second:
            let item = itemContainer.item as! Int
            return AnyView(
                VStack {
                    Text("Section2")
                    Text("\(item)")
                }
            )
        }
    }
    
    private func handleSelect(_ itemContainer: ItemContainer<SampleSection, AnyHashable>) {
        switch itemContainer.section {
        case .first:
            let item = itemContainer.item as! SampleItem
            self.selectedItem = item
            self.showingSheet = true
        case .second:
            let item = itemContainer.item as! Int
            print(item)
        }
    }
    
    private func compositionalLayout(for collections: [Collection<SampleSection, AnyHashable>], with geometrySize: CGSize) -> UICollectionViewCompositionalLayout {
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

enum SampleSection: Hashable, CaseIterable {
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

struct SampleItem: Hashable {
    let id = UUID()
    let name: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
