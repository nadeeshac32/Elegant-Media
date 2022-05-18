//
//  BaseCVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/28/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol BaseCVCellDelegate: class {
    func itemSelected(model: BaseModel) -> Bool?
}


/// Generic base class for TableViewCells. You have to extend from this class in order to enables to use BaseListVC + BaseListVM
class BaseCVCell<Model: BaseModel>: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    let disposeBag          = DisposeBag()
    var item                : Model?
    var section             : Int?
    var row                 : Int?
    var selectable          : Bool?    
    
    var tapGesture          : UITapGestureRecognizer?
    weak var delegate       : BaseCVCellDelegate?
    
    
    /// Once your ViewController and ViewModel is extended from BaseCollectionVC + BaseCollectionVM it will automatically pass the data model into this method. You can override this method in your subclass and configure the cell as you want with your type cased data model.
    /// - Parameters:
    ///   - item: Data object
    ///   - row: Row index
    ///   - selectable: Whether the cell is selectable or not
    func configureCell(item: Model, section: Int, row: Int, selectable: Bool) {
        self.item           = item
        self.section        = section
        self.row            = row
        self.selectable     = selectable
        
        if let _ = tapGesture {
            self.removeGestureRecognizer(self.tapGesture!)
            self.tapGesture = nil
        }
        
        self.setForMultiSelectMode(enableMultiSelect: selectable)
        if selectable {
            self.tapGesture             = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
            self.tapGesture?.delegate   = self
            self.addGestureRecognizer(tapGesture!)
            self.multiSelectHighlighted(highlighted: item.isSelected)
        }
    }
    
    @objc func tap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == UIGestureRecognizer.State.ended {
            if selectable == true, let item = self.item, let itemSelected = delegate?.itemSelected(model: item) {
                self.multiSelectHighlighted(highlighted: itemSelected)
            }
        }
    }
    
    func setForMultiSelectMode(enableMultiSelect: Bool) { }
    
    func multiSelectHighlighted(highlighted: Bool) { }
    
}


class BaseCVSectionHeader: UICollectionReusableView {
     var label: UILabel     = {
         let label: UILabel = UILabel()
         label.textColor    = .gray
         label.font         = UIFont.systemFont(ofSize: 16, weight: .semibold)
         label.sizeToFit()
         return label
     }()

     override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor    = #colorLiteral(red: 0.9153285623, green: 0.905608356, blue: 0.9056202173, alpha: 1)
        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(header: String) {
        label.text          = header
    }
    
}
