//
//  SampleCollectionViewCell.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

class SampleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}

extension SampleCollectionViewCell: CellProvider {
    typealias Element = String
    
    static func provide(collectionView: UICollectionView, indexPath: IndexPath, element: String) -> UICollectionViewCell {
        let sampleCell = dequeue(from: collectionView, at: indexPath)
        sampleCell.label.text = element
        sampleCell.backgroundColor = .white
        return sampleCell
    }
}
