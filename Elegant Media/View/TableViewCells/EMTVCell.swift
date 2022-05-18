//
//  EMTVCell.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-18.
//

import UIKit

class EMTVCell: BaseTVCell<ListViewItem> {
    @IBOutlet weak var imageVw          : UIImageView!
    @IBOutlet weak var titleLbl         : UILabel!
    @IBOutlet weak var descLbl          : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle             = .none
        self.backgroundColor            = .white
        self.imageVw.contentMode        = .scaleAspectFill
        self.imageVw.layer.cornerRadius = 20
        self.titleLbl.text              = ""
        self.descLbl.text               = ""
        self.descLbl.numberOfLines      = 0
        
    }
    
    override func configureCell(item: ListViewItem, row: Int, selectable: Bool) {
        super.configureCell(item: item, row: row, selectable: selectable)
        imageVw.setImageWith(imagePath: item.image?.small ?? "", completion: nil)
        titleLbl.text                   = item.title ?? ""
        descLbl.text                    = item.desc
    }
    
}
