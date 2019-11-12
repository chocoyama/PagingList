//
//  ContentView.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    typealias Section = Int
    typealias Item = String
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            CollectionView(
                sections: [0],
                items: ["one", "two", "three"],
                layout: .flow(
                    size: .init(width: geometry.size.width / 2, height: geometry.size.width / 2),
                    sectionInset: .zero,
                    minimumLineSpacing: 0,
                    minimumInteritemSpacing: 0
                )
            ) { (item: Item) in
                VStack {
                    Text("hoge")
                    Text(item)
                    HStack {
                        Text("0")
                        Text("1")
                    }
                }
            }.onSelected { (item) in
                print(item)
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
