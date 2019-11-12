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
                items: (0..<100).map({ "\($0)" }),
                layout: FlowLayoutContainer(size: .init(width: geometry.size.width / 2,
                                                        height: geometry.size.width / 2))
            ) { (item) in
                Text(item)
            }.onSelect { (item) in
                print(item)
            }
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
