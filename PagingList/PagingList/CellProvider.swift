//
//  CellProvider.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

protocol CellProvider {
    associatedtype Element
    static func provide(collectionView: UICollectionView, indexPath: IndexPath, element: Element) -> UICollectionViewCell
}

extension CellProvider {
    static var nibName: String { String(describing: Self.self) }
    static var reuseIdentifier: String { String(describing: Self.self) }
    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Self
    }
}
