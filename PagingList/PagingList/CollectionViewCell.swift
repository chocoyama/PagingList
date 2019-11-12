//
//  CollectionViewCell.swift
//  PagingList
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    func set(content: UIView) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: content.leftAnchor),
            contentView.topAnchor.constraint(equalTo: content.topAnchor),
            contentView.rightAnchor.constraint(equalTo: content.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: content.bottomAnchor)
        ])
    }
}
