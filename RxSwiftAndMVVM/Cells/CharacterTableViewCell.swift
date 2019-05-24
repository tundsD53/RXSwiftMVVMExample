//
//  CharacterTableViewCell.swift
//  RxSwiftAndMVVM
//
//  Created by Tunde on 21/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {

    static let cellId = "CharacterTableViewCell"
    
    @IBOutlet weak var characterImgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    func configure(with character: Character) {
        nameLbl.text = character.name
        characterImgVw.kf.indicatorType = .activity
        characterImgVw.kf.setImage(with: URL(string: character.image ?? ""))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImgVw.image = nil
        nameLbl.text = nil
    }
}
