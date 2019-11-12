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
    static func provide<Int>(collectionView: UICollectionView, indexPath: IndexPath, element: Int) -> UICollectionViewCell {
        let sampleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sample", for: indexPath) as! SampleCollectionViewCell
        sampleCell.label.text = "\(element)"
        sampleCell.backgroundColor = .white
        return sampleCell
    }
}
