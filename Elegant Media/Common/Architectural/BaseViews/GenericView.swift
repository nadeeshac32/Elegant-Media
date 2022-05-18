//
//  GenericView.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/7/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

public protocol ConfigurableView {
    func configureView()
}

/// Base class that enable views to initialise without xib file
open class GenericView: UIView, ConfigurableView {
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    public required init() {
        super.init(frame: CGRect.zero)
        configureView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    open func configureView() {}
}
