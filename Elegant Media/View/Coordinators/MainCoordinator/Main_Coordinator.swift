//
//  Main_Coordinator.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/10/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import RxSwift

class MainCoordinator: BaseCoordinator<Void> {

    private let defaults                        = UserDefaults.standard
    var navigationController                    : UINavigationController!
    
    deinit {
        print("deinit MainCoordinator")
    }
    
    override func start() -> Observable<Void> {
        reStartApplication()

        return Observable.never()
    }
    
    func reStartApplication() {
        if UserAuth.si.signedIn && UserAuth.si.token != "" {
            goToRootVC()
        } else {
            goToSigninVC()
        }
    }
    
    private func goToSigninVC() {
        let viewController                      = SigninVC.initFromStoryboard(name: Storyboards.main.rawValue)
        let viewModel                           = SigninVM()
        viewController.viewModel                = viewModel
        navigationController                    = UINavigationController(rootViewController: viewController)
        
        disposeBag.insert([
            viewModel.showHomeVC.subscribe(onNext: { [weak self] (_) in
                self?.goToRootVC()
            }),
            
        ])
        window.rootViewController               = navigationController
        window.makeKeyAndVisible()
    }
    
    private func goToRootVC() {
        let rootVM                              = EMListViewVM()
        disposeBag.insert([
            rootVM.showSignInVC.subscribe(onNext: { [weak self] (_) in
                let _ = self?.start()
            }),
            rootVM.doWithSelectedItem.subscribe { [weak self] (listViewItem) in
                self?.gotoDetailView(listViewItem: listViewItem)
            }
        ])
        
        let rootNavController                   = EMListViewVC.initFromStoryboardEmbedInNVC(withViewModel: rootVM)
        self.navigationController               = rootNavController
        window.rootViewController               = navigationController
        window.makeKeyAndVisible()
    }
    
    private func gotoDetailView(listViewItem: ListViewItem) {
        let detailVM                            = DetailVM(item: listViewItem)
        detailVM.showLocationVC.subscribe(onNext: { [weak self] (item) in
            self?.gotoLocationView(listViewItem: item)
        }).disposed(by: disposeBag)
        let detailVC                            = DetailVC.initFromStoryboard(name: Storyboards.main.rawValue, withViewModel: detailVM)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func gotoLocationView(listViewItem: ListViewItem) {
        let mapVM                               = MapVM(item: listViewItem)
        let mapVC                               = MapVC.initFromStoryboard(name: Storyboards.main.rawValue, withViewModel: mapVM)
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
}
