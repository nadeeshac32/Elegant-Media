//
//  BaseTableViewVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxDataSources

/// Base List View Controller functionality.
/// You have to give the inherited subclasses of BaseModel, BaseListVM, BaseTVCell types in the subclass which inherit this class
/// Search functionality is also enabled here.
class BaseTableViewVC<Model:BaseModel, ViewModel: BaseTableViewVM<Model>, TableViewCell: BaseTVCell<Model>>: BaseVC<ViewModel>, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    var tableView                               : UITableView!
    var itemCountLabel                          : UILabel?
    var itemCountString                         : String?
    var isDynemicSectionTitles                  : Bool = true
    var shouldSetRowHeight                      : Bool = true
    
    var searchBar                               = UISearchBar()
    var searchBtn                               = NCUIMaker.makeButtonWith(imageName: "icon_search")
    var searchBarButtonItem                     : UIBarButtonItem?
    
    var multiSelectable                         : Bool = false
    
    /// If the TableViewCell UI is designed in xib file you can register it here.
    var cellLoadFromNib                         : Bool = false
    
    /// Bind the actual UI Outlets with the Base class variables.
    /// - Note: Because from the subclass, IBOutlets cannot be made directly to Base class variables.
    func customiseView(tableView: UITableView!, itemCountLabel: UILabel? = nil, itemCountString: String? = "Item", multiSelectable: Bool = false) {
        self.tableView                          = tableView
        self.itemCountLabel                     = itemCountLabel
        self.itemCountString                    = itemCountString
        super.customiseView()
        
        self.tableView.tableHeaderView          = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView          = UIView(frame: CGRect.zero)
        self.tableView.bounces                  = false
        self.tableView.backgroundColor          = UIColor.clear
        self.tableView.separatorInset           = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        if shouldSetRowHeight {
            self.tableView.rowHeight            = getCellHeight()
        }
        self.tableView.estimatedRowHeight       = getCellHeight()
        
        self.multiSelectable                    = multiSelectable
        if self.multiSelectable {
            let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
            longPressGesture.delegate           = self
            self.tableView.addGestureRecognizer(longPressGesture)
        }
        
        self.searchBar.delegate                 = self
        self.searchBar.searchBarStyle           = .prominent
        self.searchBar.showsCancelButton        = true
        self.searchBtn.addTarget(self, action: #selector(searchButtonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.ended {
            viewModel?.multiSelectable = true
        }
    }

    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
            if cellLoadFromNib {
                tableView.register(UINib(nibName: String(describing: TableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableViewCell.self))
            }
            disposeBag.insert([
                // MARK: - Outputs
                tableView.rx.setDelegate(self),
                
                // MARK: - Inputs
                tableView.rx.modelSelected(Model.self).subscribe(onNext: { (item) in
                    let _ = viewModel.itemSelected(model: item)
                }),
                viewModel.refreshTableView.subscribe(onNext: { [weak self] (_) in
                    self?.tableView.reloadData()
                }),
                viewModel.toSelectableMode.subscribe(onNext: { [weak self] (multiSelectableMode) in
                    self?.setMultiSelectableMode(multiSelectEnabled: multiSelectableMode)
                }),
                viewModel.totalItemsCount.subscribe(onNext: { [weak self] (total) in
                    if total > 0 {
                        self?.itemCountLabel?.text  = "\(total) \(self?.itemCountString ?? "Item")"
                    } else {
                        self?.itemCountLabel?.text  = ""
                    }
                })
            ])
            let isLoading = tableView.rx.isLoading(loadingMessage: getItemsLoadingText(), noItemsMessage: getNoItemsText(), imageName: getNoItemsImageName())
            viewModel.requestLoading.map ({ $0 }).bind(to: isLoading).disposed(by: disposeBag)
        }
    }
    
    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    // MARK: - override in subclasses as needed
    func getItemsLoadingText() -> String {
        return "Items Loading"
    }
    
    func getNoItemsText() -> String {
        return "No Items"
    }
    
    func getNoItemsImageName() -> String? {
        return nil
    }
    
    func getCellHeight() -> CGFloat {
        return 70
    }
    
    // MARK: - setup cell for table view without headers
    func setupCell(row: Int, element: Model, cell: TableViewCell) {
        cell.configureCell(item: element, row: row, selectable: viewModel?.multiSelectable ?? false)
        cell.delegate                           = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat                     = 100
        let bottomEdge                          = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + offset >= scrollView.contentSize.height) {
            viewModel?.paginateNext()
        }
    }
    
    func setMultiSelectableMode(multiSelectEnabled: Bool) {
        self.tableView.allowsMultipleSelection = multiSelectEnabled
        self.tableView.reloadData()
    }
    
    //MARK: - Search bar methods
    @objc func searchButtonPressed(sender: AnyObject) {
        showSearchBar(searchBar: searchBar)
    }
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.searchText                   = ""
        searchBar.text                          = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.searchText                   = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
}

extension BaseTableViewVC: BaseTVCellDelegate {
    func itemSelected(model: BaseModel) -> Bool? {
        if let item = model as? Model {
            return viewModel?.itemSelected(model: item)
        } else {
            return nil
        }
    }
}


/// This class is used to Implement Table VIews when there is no sections. Inherited from BaseListVC
/// Basically this class is to bind proper configuration into table view when there are no section headers.
class BaseListWithoutHeadersVC<Model:BaseModel, ViewModel: BaseTableViewVM<Model>, TableViewCell: BaseTVCell<Model>>: BaseTableViewVC<Model, ViewModel, TableViewCell> {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
            disposeBag.insert([
                // MARK: - Inputs
                viewModel.items.asObservable().bind(to: tableView.rx.items(cellIdentifier: String(describing: TableViewCell.self), cellType: TableViewCell.self)) { [weak self] (row, element, cell) in
                    self?.setupCell(row: row, element: element, cell: cell)
                }
            ])
        }
    }
}



/// This class is used to pass data array for Table Views with sections
struct SectionOfCustomData<Model: BaseModel>: AnimatableSectionModelType {
    var header                                  : String
    var items                                   : [Model]
    
    typealias Item = Model

    var identity: String {
        return header
    }
    
    init(header: String, items: [Item]) {
        self.header                             = header
        self.items                              = items
    }
    
    init(original: SectionOfCustomData, items: [Item]) {
        self                                    = original
        self.items                              = items
    }
}


/// This class is used to Implement Table VIews with multiple Sections. Inherited from BaseListVC
/// Basically this class is to bind proper datasource into table view when there are section headers.
class BaseListWithHeadersVC<Model:BaseModel, ViewModel: BaseTableViewVM<Model>, TableViewCell: BaseTVCell<Model>>: BaseTableViewVC<Model, ViewModel, TableViewCell> {
    
    var dataSource                              : RxTableViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>?
    
    override func customiseView(tableView: UITableView!, itemCountLabel: UILabel? = nil, itemCountString: String? = "Item", multiSelectable: Bool = false) {
        super.customiseView(tableView: tableView, itemCountLabel: itemCountLabel, itemCountString: itemCountString, multiSelectable: multiSelectable)
            
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>(animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                                                                                           reloadAnimation: .none,
                                                                                                                                           deleteAnimation: .left),
                                                                                            configureCell: { [weak self] (ds, tv, ip, item) -> UITableViewCell in
                                                                                                (self?.setupCell(dataSource: ds, tableView: tv, indexPath: ip, dataModel: item) ?? UITableViewCell())
                                                                                            },
                                                                                            titleForHeaderInSection: { [weak self] (ds, index) -> String? in
                                                                                                self?.getHeaderTitle(dataSource: ds, index: index)
                                                                                            })

        dataSource.sectionIndexTitles           = { [weak self] dataSource in
            if (self?.viewModel?.getCalculatedItemsCount() ?? 0) > 0 {
                if self?.isDynemicSectionTitles == true {
                    return dataSource.sectionModels.map { $0.header }
                } else {
                    return self?.getStaticSectionIndexTitles()
                }
            } else {
                return nil
            }
        }
        dataSource.sectionForSectionIndexTitle  = { (dataSource, title, index) in
            return dataSource.sectionModels.map { $0.header }.firstIndex(of: title) ?? 0
        }
        self.dataSource                         = dataSource
    }
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
                
            disposeBag.insert([
                // MARK: - Inputs
                viewModel.itemsWithHeaders.asObservable().bind(to: tableView.rx.items(dataSource: self.dataSource!))
            ])
        }
    }
    
    // MARK: - setup cell for table view with headers
    func getStaticSectionIndexTitles() -> [String] {
        return []
    }
    
    func getHeaderTitle(dataSource: TableViewSectionedDataSource<SectionOfCustomData<Model>>, index: Int) -> String {
        return dataSource.sectionModels[index].header
    }
    
    func setupCell(dataSource: TableViewSectionedDataSource<SectionOfCustomData<Model>>, tableView: UITableView, indexPath: IndexPath, dataModel: Model) -> UITableViewCell {
        let cell                                = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as? TableViewCell ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        if let tableViewCell = cell as? TableViewCell {
            tableViewCell.configureCell(item: dataModel, row: indexPath.row, selectable: viewModel?.multiSelectable ?? false)
            tableViewCell.delegate              = self
            return tableViewCell
        }

        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame                               = CGRect(x: 0, y: 0, width: view.bounds.width, height: 24)
        let headerView                          = UIView(frame: frame)
        headerView.backgroundColor              = #colorLiteral(red: 0.9137254902, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
        
        let sectionLabelFrame                   = CGRect(x: 16, y: 0, width: view.bounds.width - 32, height: 24)
        let sectionLabel                        = UILabel(frame: sectionLabelFrame)
        sectionLabel.text                       = self.dataSource?[section].header ?? ""
        sectionLabel.textColor                  = #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
        sectionLabel.font                       = UIFont.systemFont(ofSize: 12)
        
        headerView.addSubview(sectionLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}
