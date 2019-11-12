//
//  ContentView.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            CollectionView(
                sections: Section.allCases,
                items: (1...100).map({ Item(name: "No. \($0)") }),
                layout: FlowLayoutContainer(size: .init(width: geometry.size.width / 2,
                                                        height: geometry.size.width / 2))
            ) { (item) in
                Text(item.name)
            }.onSelect { (item) in
                print(item.name)
            }
        }
    }
}

enum Section: Hashable, CaseIterable {
    case items
}

struct Item: Hashable {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
