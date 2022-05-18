//
//  BaseButton.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 10/21/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit

/// Base class that enable views to initialise without xib file
open class BaseButton: UIButton, ConfigurableView {
    
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
