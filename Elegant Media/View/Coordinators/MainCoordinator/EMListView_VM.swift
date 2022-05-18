//
//  EMListView_VM.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-18.
//

import Foundation
import RxSwift
import ObjectMapper

class EMListViewVM: BaseTableViewVM<ListViewItem> {
    
    override var dataLoadIn         : DataLoadIn? { get { return .ViewWillAppear } set {} }
    override var shouldSortFromKey  : Bool { get { return false } set {} }
    
    deinit {
        print("deinit EMListViewVM")
    }
    
    // MARK: - Network request
    override func perfomrGetItemsRequest(loadPage: Int, limit: Int) {
        let httpService             = HTTPService()
        showSpiner()
        httpService.getHotels(onSuccess: { [weak self] (hotels) in
            self?.requestLoading.onNext(false)
            self?.handleResponse(items: hotels, total: hotels.count, page: loadPage)
        }) { [weak self] (error) in
            self?.handleRestClientError(error: error)
        }
    }
}
