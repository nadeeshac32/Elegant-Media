//
//  EMListView_VC.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-18.
//

import UIKit
import RxDataSources

class EMListViewVC: BaseListWithoutHeadersVC<ListViewItem, EMListViewVM, EMTVCell> {
    @IBOutlet weak var usernameLbl              : UILabel!
    @IBOutlet weak var emailLbl                 : UILabel!
    @IBOutlet weak var logoutBtn                : UIButton!
    @IBOutlet weak var _tableView               : UITableView!
    
    override var cellLoadFromNib                : Bool { get { return true } set {} }
    override var shouldSetRowHeight             : Bool { get { return false } set {} }
    
    deinit {
        print("deinit EMListViewVC")
    }
    
    override func getNoItemsText() -> String {
        return "No Items."
    }
    
    override func customiseView() {
        super.customiseView(tableView: _tableView, multiSelectable: false)
        usernameLbl.text                        = UserAuth.si.username
        emailLbl.text                           = UserAuth.si.email
        logoutBtn.layer.cornerRadius            = 3
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {

            disposeBag.insert([
                // MARK: - Inputs
                viewModel.setupTitleViewInViewDidAppear.subscribe(onNext: { [weak self] (_) in
                    guard let self = `self` else { return }
                    self.navigationController?.navigationBar.topItem?.title                 = "List View"
                    self.navigationController?.navigationBar.topItem?.rightBarButtonItem    = nil
                    self.navigationController?.navigationBar.topItem?.leftBarButtonItem     = nil
                }),
                viewModel.removeTitleViewInViewWillDisappear.subscribe(onNext: { [weak self] (_) in
                    self?.navigationController?.navigationBar.topItem?.titleView            = nil
                }),
                
                // MARK: - Outputs
                logoutBtn.rx.tap.bind {
                    viewModel.logoutUser()
                }
            ])
        }
    }
}
    
