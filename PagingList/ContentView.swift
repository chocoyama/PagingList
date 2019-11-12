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
            CollectionViewController(
                sections: [0],
                items: [0, 1, 2],
                layout: {
                    let layout = UICollectionViewFlowLayout()
                    layout.itemSize = .init(width: geometry.size.width / 2, height: geometry.size.width / 2)
                    layout.sectionInset = .zero
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    return layout
                }(),
                cellProvider: SampleCollectionViewCell.self
            ).frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
