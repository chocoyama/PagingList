//
//  CollectionViewCell.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func set(content: UIView, size: CGSize) {
        contentView.addSubview(content)
        content.frame.size = size
    }
}
