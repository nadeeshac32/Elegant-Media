//
//  ReactiveExtensiones.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import RxSwift
import RxCocoa

extension UIViewController: loadingViewable {}
extension Reactive where Base: UIViewController {
    var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
}

extension UIViewController: loadingFreezable {}
extension Reactive where Base: UIViewController {
    var isFreezing: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startFreezeAnimation()
            } else {
                vc.stopFreezeAnimating()
            }
        })
    }
}

extension Reactive where Base: AnimateTextField {
    public var prefixValue: RxCocoa.ControlProperty<String> {
        return base.rx.controlProperty(
            editingEvents: [.allEditingEvents, .valueChanged],
            getter: { textField in
                return textField.prefixValue
            },
            setter: { textField, value in
                // This check is important because setting text value always clears control state
                // including marked text selection which is imporant for proper input
                // when IME input method is used.
                if textField.prefixValue != value {
                    textField.prefixValue = value
                }
            }
        )
    }
}

extension Reactive where Base: UITableView {
    func isLoading(loadingMessage: String, noItemsMessage: String, imageName: String?) -> Binder<Bool> {
        return Binder(base) { tableView, isLoading in
            if isLoading {
                tableView.setNoDataPlaceholder(loadingMessage, nil)
            } else {
                if tableView.numberOfSections > 0 {
                    if tableView.numberOfRows(inSection: 0) <= 0 {
                        tableView.setNoDataPlaceholder(noItemsMessage, imageName)
                    } else {
                        tableView.removeNoDataPlaceholder()
                    }
                } else {
                    tableView.setNoDataPlaceholder(noItemsMessage, imageName)
                }
            }
        }
    }
}


extension Reactive where Base: UICollectionView {
    func isLoading(loadingMessage: String, noItemsMessage: String, imageName: String?) -> Binder<Bool> {
        return Binder(base) { collectionView, isLoading in
            if isLoading {
                collectionView.setNoDataPlaceholder(loadingMessage, nil)
            } else {
                if collectionView.numberOfSections > 0 {
                    if collectionView.numberOfItems(inSection: 0) <= 0 {
                        collectionView.setNoDataPlaceholder(noItemsMessage, imageName)
                    } else {
                        collectionView.removeNoDataPlaceholder()
                    }
                } else {
                    collectionView.setNoDataPlaceholder(noItemsMessage, imageName)
                }
            }
        }
    }
}
