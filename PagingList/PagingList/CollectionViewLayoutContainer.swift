//
//  CollectionViewLayout.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

protocol CollectionViewLayoutContainer {
    var layout: UICollectionViewLayout { get }
    var itemSize: CGSize { get }
}
