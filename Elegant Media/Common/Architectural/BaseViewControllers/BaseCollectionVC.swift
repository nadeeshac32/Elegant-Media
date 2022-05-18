//
//  BaseCollectionVC.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/28/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
import RxDataSources

/// Base List View Controller functionality.
/// You have to give the inherited subclasses of BaseModel, BaseListVM, BaseTVCell types in the subclass which inherit this class
/// Search functionality is also enabled here.
class BaseCollectionVC<Model:BaseModel, ViewModel: BaseCollectionVM<Model>, CollectionViewCell: BaseCVCell<Model>>: BaseVC<ViewModel>, UICollectionViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    var collectionView                              : UICollectionView!
    var itemCountLabel                              : UILabel?
    var itemCountString                             : String?
    
    var searchBar                                   = UISearchBar()
    var searchBtn                                   = NCUIMaker.makeButtonWith(imageName: "icon_search")
    var searchBarButtonItem                         : UIBarButtonItem?
    
    var multiSelectable                             : Bool = false
    
    /// If the CollectionViewCell UI is designed in xib file you can register it here.
    var cellLoadFromNib                             : Bool = false
    var shouldSetCellSize                           : Bool = true
    
    /// Bind the actual UI Outlets with the Base class variables.
    /// - Note: Because from the subclass, IBOutlets cannot be made directly to Base class variables.
    func customiseView(collectionView: UICollectionView!, itemCountLabel: UILabel? = nil, itemCountString: String? = "Item", multiSelectable: Bool = false) {
        self.collectionView                         = collectionView
        self.itemCountLabel                         = itemCountLabel
        self.itemCountString                        = itemCountString
        super.customiseView()
        
        self.collectionView.backgroundColor         = UIColor.clear
        self.collectionView.bounces                 = false
        self.collectionView.collectionViewLayout    = getCellLayout()
        
        self.multiSelectable                        = multiSelectable
        if self.multiSelectable {
            let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
            longPressGesture.delegate               = self
            self.collectionView.addGestureRecognizer(longPressGesture)
        }
        
        self.searchBar.delegate                     = self
        self.searchBar.searchBarStyle               = .prominent
        self.searchBar.showsCancelButton            = true
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
                self.collectionView.register(UINib(nibName: String(describing: CollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: CollectionViewCell.self))
            }
            disposeBag.insert([
                // MARK: - Outputs
                collectionView.rx.setDelegate(self),
                
                // MARK: - Inputs
                collectionView.rx.modelSelected(Model.self).subscribe(onNext: { (item) in
                    let _ = viewModel.itemSelected(model: item)
                }),
                viewModel.refreshTableView.subscribe(onNext: { [weak self] (_) in
                    self?.collectionView.reloadData()
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
            let isLoading = collectionView.rx.isLoading(loadingMessage: getItemsLoadingText(), noItemsMessage: getNoItemsText(), imageName: getNoItemsImageName())
            viewModel.requestLoading.map ({ $0 }).bind(to: isLoading).disposed(by: disposeBag)
        }
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
    
    func getCellLayout() -> UICollectionViewFlowLayout {
        let layout                                  = UICollectionViewFlowLayout()
        layout.headerReferenceSize                  = CGSize(width: collectionView.frame.width, height: getSectionHeaderHeight())
        layout.sectionInset                         = getLayoutInsets().sides
        layout.minimumLineSpacing                   = getLayoutInsets().lineSpacing
        layout.minimumInteritemSpacing              = getLayoutInsets().interItemSpacing
        
        if shouldSetCellSize {
            layout.itemSize                         = getItemSize()
        } else {
            layout.estimatedItemSize                = getItemSize()
        }
        
        return layout
    }
    func getItemSize() -> CGSize {
        let layoutGuide                             = getLayoutInsets()
        let sides                                   = layoutGuide.sides.left + layoutGuide.sides.right
        let totalInterItemSpacing                   = CGFloat(layoutGuide.columnsForRow - 1) * layoutGuide.interItemSpacing
        let width                                   : CGFloat = (collectionView.frame.width - sides - totalInterItemSpacing) / CGFloat(layoutGuide.columnsForRow)
        return CGSize(width: width, height: width * layoutGuide.widthToHeightPropotion)
    }
    func getLayoutInsets() -> (columnsForRow: Int, sides: UIEdgeInsets, lineSpacing: CGFloat, interItemSpacing: CGFloat, widthToHeightPropotion: CGFloat) {
        return (columnsForRow: 3,
                sides: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                lineSpacing: 8,
                interItemSpacing: 8,
                widthToHeightPropotion: 1)
    }
    func getSectionHeaderHeight() -> CGFloat {
        return 0
    }
    // MARK: - setup cell for collection view without headers
    func setupCell(section: Int, row: Int, element: Model, cell: CollectionViewCell) {
        cell.configureCell(item: element, section: section, row: row, selectable: viewModel?.multiSelectable ?? false)
        cell.delegate                               = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset: CGFloat                         = 100
        let bottomEdge                              = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + offset >= scrollView.contentSize.height) {
            viewModel?.paginateNext()
        }
    }
    
    func setMultiSelectableMode(multiSelectEnabled: Bool) {
        self.collectionView.allowsMultipleSelection = multiSelectEnabled
        self.collectionView.reloadData()
    }
    
    //MARK: - Search bar methods
    @objc func searchButtonPressed(sender: AnyObject) {
        showSearchBar(searchBar: searchBar)
    }
    
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.searchText                       = ""
        searchBar.text                              = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.searchText                       = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
}

extension BaseCollectionVC: BaseCVCellDelegate {
    func itemSelected(model: BaseModel) -> Bool? {
        if let item = model as? Model {
            return viewModel?.itemSelected(model: item)
        } else {
            return nil
        }
    }
}


/// This class is used to Implement Table VIews when there is not sections. Inherited from BaseGridVC
/// Basically this class is to bind proper configuration into collection view when there are no section headers.
class BaseGridWithoutHeadersVC<Model:BaseModel, ViewModel: BaseCollectionVM<Model>, CollectionViewCell: BaseCVCell<Model>>: BaseCollectionVC<Model, ViewModel, CollectionViewCell> {
    
    override func setupBindings() {
        super.setupBindings()
        if let viewModel = self.viewModel {
            
            disposeBag.insert([
                // MARK: - Inputs
                viewModel.items.asObservable().bind(to: collectionView.rx.items(cellIdentifier: String(describing: CollectionViewCell.self), cellType: CollectionViewCell.self)) { [weak self] (row, element, cell) in
                    self?.setupCell(section: 0, row: row, element: element, cell: cell)
                }
            ])
        }
    }
}



/// This class is used to Implement Table VIews with multiple Sections. Inherited from BaseGridVC
/// Basically this class is to bind proper datasource into collection view when there are section headers.
class BaseGridWithHeadersVC<Model:BaseModel, ViewModel: BaseCollectionVM<Model>, CollectionViewCell: BaseCVCell<Model>, CollectionViewSectionHeder: BaseCVSectionHeader>: BaseCollectionVC<Model, ViewModel, CollectionViewCell> {
    
    var dataSource                              : RxCollectionViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>?
    
    override func customiseView(collectionView: UICollectionView!, itemCountLabel: UILabel? = nil, itemCountString: String? = "Item", multiSelectable: Bool = false) {
        super.customiseView(collectionView: collectionView, itemCountLabel: itemCountLabel, itemCountString: itemCountString, multiSelectable: multiSelectable)
            
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<SectionOfCustomData<Model>>(animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                                                                                           reloadAnimation: .none,
                                                                                                                                           deleteAnimation: .left),
            configureCell: { [weak self] (ds, cv, ip, item) -> UICollectionViewCell in
                (self?.setupCell(dataSource: ds, collectionView: cv, indexPath: ip, dataModel: item) ?? UICollectionViewCell())
            },
            configureSupplementaryView: { [weak self] (ds, cv, kind, ip) -> UICollectionReusableView in
                (self?.viewForHeaderInSection(dataSource: ds, collectionView: cv, kind: kind, indexPath: ip) ?? UICollectionReusableView())
            })
        
        self.dataSource                         = dataSource
    }
    
    override func setupBindings() {
        super.setupBindings()
        self.collectionView.register(CollectionViewSectionHeder.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: CollectionViewSectionHeder.self))
        if let viewModel = self.viewModel {
            disposeBag.insert([
                // MARK: - Inputs
                viewModel.itemsWithHeaders.asObservable().bind(to: collectionView.rx.items(dataSource: self.dataSource!))
            ])
        }
    }
    
    // MARK: - setup cell for table view with headers
    override func getSectionHeaderHeight() -> CGFloat {
        return 30
    }
    
    func setupCell(dataSource: CollectionViewSectionedDataSource<SectionOfCustomData<Model>>, collectionView: UICollectionView, indexPath: IndexPath, dataModel: Model) -> UICollectionViewCell {
        let cell                                = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath)
        
        if let collectionViewCell = cell as? CollectionViewCell {
            collectionViewCell.configureCell(item: dataModel, section: indexPath.section, row: indexPath.row, selectable: viewModel?.multiSelectable ?? false)
            collectionViewCell.delegate              = self
            return collectionViewCell
        }

        return cell
    }
 
    func viewForHeaderInSection(dataSource: CollectionViewSectionedDataSource<SectionOfCustomData<Model>>, collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CollectionViewSectionHeder.self), for: indexPath) as! CollectionViewSectionHeder
            sectionHeader.configureCell(header: dataSource.sectionModels[indexPath.section].header)
            return sectionHeader
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }
}

