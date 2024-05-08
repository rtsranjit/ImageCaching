//
//  ImageCollectionViewCell.swift
//  ImageCaching
//
//  Created by Mani on 08/05/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var siteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        siteImageView.layer.masksToBounds = true
        siteImageView.layer.cornerRadius = 5
        siteImageView.contentMode = .scaleAspectFill
    }

}
