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
                sections: [0],
                items: ["one", "two", "three"],
                layout: FlowLayoutContainer(size: .init(width: geometry.size.width / 2,
                                                        height: geometry.size.width / 2))
            ) { (item) in
                VStack {
                    Text("hoge")
                    Text(item)
                    HStack {
                        Text("0")
                        Text("1")
                    }
                }
            }.onSelect { (item) in
                print(item)
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct FlowLayoutContainer: CollectionViewLayoutContainer {
    let flowLayout: UICollectionViewFlowLayout
    var layout: UICollectionViewLayout { flowLayout }
    var itemSize: CGSize { flowLayout.itemSize }
    
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
