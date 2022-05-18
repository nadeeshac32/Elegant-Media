//
//  Detail_VC.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-19.
//

import UIKit

class DetailVC: BaseVC<DetailVM> {
    @IBOutlet weak var imageVw                              : UIImageView!
    @IBOutlet weak var titleLbl                             : UILabel!
    @IBOutlet weak var descLbl                              : UILabel!
    
    var customRightButton                                   = NCUIMaker.makeButtonWith(imageName: "icon_location")
    
    deinit { print("deinit DetailVC") }
        
    override func customiseView() {
        super.customiseView()
        self.title                                          = "Details"
        customRightButton.imageEdgeInsets                   = UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 8)
        let rightBarButtonItem                              = UIBarButtonItem(customView: self.customRightButton)
        self.navigationItem.rightBarButtonItem              = rightBarButtonItem
        imageVw.setImageWith(imagePath: viewModel?.item.image?.small ?? "", completion: nil)
        titleLbl.text                                       = viewModel?.item.title ?? ""
        descLbl.text                                        = viewModel?.item.desc
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
            disposeBag.insert([
                // MARK: Output
                customRightButton.rx.tap.bind {
                    viewModel.locationBtnTapped.onNext(true)
                }
            ])
        }
    }
}
