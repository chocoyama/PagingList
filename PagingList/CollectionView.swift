//
//  CollectionView.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI

struct CollectionView: View {
    typealias Section = Int
    typealias Item = String
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            CollectionViewController<Section, Item, SampleCollectionViewCell>(
                sections: [0],
                items: ["one", "two", "three"],
                layout: {
                    let layout = UICollectionViewFlowLayout()
                    layout.itemSize = .init(width: geometry.size.width / 2, height: geometry.size.width / 2)
                    layout.sectionInset = .zero
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    return layout
                }()
            ).frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
