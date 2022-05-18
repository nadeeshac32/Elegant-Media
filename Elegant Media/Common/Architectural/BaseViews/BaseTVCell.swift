//
//  BaseTVCell.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/9/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol BaseTVCellDelegate: class {
    func itemSelected(model: BaseModel) -> Bool?
}

/// Generic base class for TableViewCells. You have to extend from this class in order to enables to use BaseListVC + BaseListVM
class BaseTVCell<Model: BaseModel>: UITableViewCell {
    
    let disposeBag      = DisposeBag()
    var item            : Model?
    var row             : Int?
    var selectable      : Bool?
    
    var tapGesture      : UITapGestureRecognizer?
    weak var delegate   : BaseTVCellDelegate?
    
    /// Once your ViewController and ViewModel is extended from BaseListVC + BaseListVM it will automatically pass the data model into this method. You can override this method in your subclass and configure the cell as you want with your type cased data model.
    /// - Parameters:
    ///   - item: Data object
    ///   - row: Row index
    ///   - selectable: Whether the cell is selectable or not
    func configureCell(item: Model, row: Int, selectable: Bool) {
        self.item       = item
        self.row        = row
        self.selectable = selectable
        
        if let _ = tapGesture {
            self.removeGestureRecognizer(self.tapGesture!)
            self.tapGesture = nil
        }
        
        self.setForMultiSelectMode(enableMultiSelect: selectable)
        if selectable {
            self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
            self.tapGesture?.delegate = self
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
