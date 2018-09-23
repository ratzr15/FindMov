//
//  NamePictureCell.swift
//  FindMov
//
//  Created by Rathish Kannan on 9/20/18.
//  Copyright © 2018 Rathish Kannan. All rights reserved.
//

import UIKit

class NamePictureCell: UITableViewCell {

    @IBOutlet weak var overView: UILabel?
    @IBOutlet weak var pictureImageView: UIImageView?
    @IBOutlet weak var title: UILabel!
    
    var item: ProfileViewModelItem? {
        didSet {
            guard let item = item as? ProfileViewModelNamePictureItem else {
                return
            }
            
            title?.text = item.name
            
            pictureImageView?.image = UIImage(url: URL(string: item.pictureUrl))

            overView?.text = item.overView
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pictureImageView?.contentMode = .scaleAspectFit
        pictureImageView?.backgroundColor = UIColor.lightGray
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureImageView?.image = nil
    }    
}
