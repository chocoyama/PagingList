//
//  CollectionViewLayout.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

enum CollectionViewLayout {
    case flow(size: CGSize? = nil, sectionInset: UIEdgeInsets?, minimumLineSpacing: CGFloat?, minimumInteritemSpacing: CGFloat?)
    
    func build() -> UICollectionViewLayout {
        switch self {
        case let .flow(size, sectionInset, minimumLineSpacing, minimumInteritemSpacing):
            let layout = UICollectionViewFlowLayout()
            if let size = size { layout.itemSize = size }
            if let sectionInset = sectionInset { layout.sectionInset = sectionInset }
            if let minimumLineSpacing = minimumLineSpacing { layout.minimumLineSpacing = minimumLineSpacing }
            if let minimumInteritemSpacing = minimumInteritemSpacing { layout.minimumInteritemSpacing = minimumInteritemSpacing }
            return layout
        }
    }
}
