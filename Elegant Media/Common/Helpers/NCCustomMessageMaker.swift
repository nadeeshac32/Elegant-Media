//
//  NCCustomMessageMaker.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import Foundation
import SwiftEntryKit

class NCCustomMessageMaker {
    
    static func showSuccessMessage(text: String, blockScreen: Bool = false, completion: @escaping () -> ()?, duration: Double? = 1.5) {
        let backgroundStyle                 = getGradientBackGroundStypeWith(color: AppConfig.si.colorSuccess)
        showNote(text: text, attributes: getMessageAttribute(withBackground: backgroundStyle, blockScreen: blockScreen, completion: completion, duration: duration!))
    }
    
    static func showWarningMessage(text: String, blockScreen: Bool = false, completion: @escaping () -> ()?, duration: Double? = 1.5) {
        let backgroundStyle                 = getGradientBackGroundStypeWith(color: AppConfig.si.colorWarning)
        showNote(text: text, attributes: getMessageAttribute(withBackground: backgroundStyle, blockScreen: blockScreen, completion: completion, duration: duration!))
    }
    
    static func showErrorMessage(text: String, blockScreen: Bool = false, completion: @escaping () -> ()?, duration: Double? = 1.5) {
        let backgroundStyle                 = getGradientBackGroundStypeWith(color: AppConfig.si.colorError)
        showNote(text: text, attributes: getMessageAttribute(withBackground: backgroundStyle, blockScreen: blockScreen, completion: completion, duration: duration!))
    }
    
    private static func getGradientBackGroundStypeWith(color: UIColor) -> EKAttributes.BackgroundStyle {
        return EKAttributes.BackgroundStyle.gradient(
        gradient: .init(
            colors: [color.ekColor, color.ekColor],
            startPoint: .zero,
            endPoint: CGPoint(x: 1, y: 1)
        ))
    }
    
    private static func getMessageAttribute(withBackground: EKAttributes.BackgroundStyle, blockScreen: Bool, completion: @escaping () -> ()?, duration: Double) -> EKAttributes {
        var attributes: EKAttributes        = .bottomNote
        attributes.displayMode              = EKAttributes.DisplayMode.inferred
        attributes.hapticFeedbackType       = .success
        attributes.shadow                   = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 6
            )
        )
        attributes.lifecycleEvents.didDisappear = {
            completion()
        }
        attributes.displayDuration          = duration
        attributes.entryBackground          = withBackground
        if blockScreen {
            attributes.screenBackground     = .color(color: EKColor.black.with(alpha: 0.2))
            attributes.screenInteraction    = .absorbTouches
        }
        attributes.statusBar                = .light
        return attributes
    }
    
    private static func showNote(text: String, attributes: EKAttributes) {
        let style = EKProperty.LabelStyle(
            font: MainFont.light.with(size: 14),
            color: .white,
            alignment: .center
        )
        let labelContent = EKProperty.LabelContent(
            text: text,
            style: style
        )
        let contentView                     = EKNoteMessageView(with: labelContent)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
