//
//  Extensions.swift
//  Base Project
//
//  Created by Nadeesha Chandrapala on 9/8/20.
//  Copyright © 2020 Nadeesha Lakmal. All rights reserved.
//

import UIKit
//import SnapKit

public enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

extension UIView {
    func addShadow() {
        self.layer.shadowColor                      = UIColor.black.cgColor
        self.layer.shadowOffset                     = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity                    = 0.4
        self.layer.shadowRadius                     = 2.0
    }
    
    func removeShadow() {
        self.layer.shadowColor                      = UIColor.clear.cgColor
    }
    
    func setConstraintsFor(contentView: UIView, left: Bool = true, top: Bool = true, right: Bool = true, bottom: Bool = true) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        
        var constraints             : [NSLayoutConstraint] = []
        if left {
            let constraintLeft      = NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
            constraints.append(constraintLeft)
        }
        
        if top {
            let constraintTop       = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            constraints.append(constraintTop)
        }
        
        if right {
            let constraintRight     = NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
            constraints.append(constraintRight)
        }
        
        if bottom {
            let constraintBottom    = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            constraints.append(constraintBottom)
        }
        
        self.addConstraints(constraints)
    }
    
    func addGradientWithColors(color1: UIColor, color2: UIColor, direction: GradientDirection) {
        let gradient            = CAGradientLayer()
        gradient.frame          = self.bounds
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .topToBottom:
            gradient.startPoint     = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint       = CGPoint(x: 0.5, y: 1.0)
        }
        
        gradient.colors         = [color1.cgColor, color2.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addBoarder(width: CGFloat, cornerRadius: CGFloat, color: UIColor) {
        self.layer.cornerRadius     = cornerRadius
        self.layer.borderColor      = color.cgColor
        self.layer.borderWidth      = width
        self.clipsToBounds          = true
    }
    
    func removeAllSubViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
//    func addAsPopupView() {
//        self.alpha                  = 0
//        UIApplication.shared.keyWindow?.setConstraintsFor(contentView: self)
//        UIView.animate(withDuration: 0.25) {
//            self.alpha              = 1
//        }
//    }
//
//    func removePopupView(completion: (() -> Void)? = nil) {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.alpha              = 0
//        }) { (completed) in
//            self.removeFromSuperview()
//            completion?()
//        }
//    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat(9999))
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.text = self
        //        label.sizeToFit()
        
        let neededSize = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        //        print("neededSize.height:   \(neededSize.height)")
        return neededSize.height
    }
    
    func width(constraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: height))
        label.numberOfLines = 1
        label.lineBreakMode = .byCharWrapping
        label.text = self
        //        label.sizeToFit()
        
        let neededSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height))
        //        print("neededSize.height:   \(neededSize.height)")
        return neededSize.width
    }
    
    func chopPrefix(_ count: Int = 1) -> String {
    
        let reqIndex = index(startIndex, offsetBy: 3)
        return String(self[..<reqIndex])
        //      return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        let reqIndex = index(endIndex, offsetBy: -count)
        return String(self[reqIndex...])
        //      return substring(to: index(endIndex, offsetBy: -count))
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    var hex: Int? {
        return Int(self, radix: 16)
    }
}

extension Date {
//    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
//        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
//    }
//
//    func isBetweeenExclusiveRange(date date1: Date, andDate date2: Date) -> Bool {
//        return date1.compare(self) == self.compare(date2)
//    }
//
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

extension UIImage {
    func resizeImage(sizeOfImageNeeded_inMb: CGFloat) -> UIImage? {
        let sizeOfMbInByt                           : CGFloat   = 1024 * 1024
        let originalImageSize                       : CGFloat   = CGFloat(self.pngData()!.count) / sizeOfMbInByt
            
        var scalar: CGFloat                         = 1
        if originalImageSize > sizeOfImageNeeded_inMb {
            scalar                                  = sizeOfImageNeeded_inMb / originalImageSize
        }
        let rect                                    = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        

        UIGraphicsBeginImageContextWithOptions(size, false, scalar)
        self.draw(in: rect)
        
        let newImage                                = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize              = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func _resizedTo1MB() -> UIImage? {
        guard let imageData         = self.pngData() else { return nil }

        var resizingImage           = self
        var imageSizeKB             = Double(imageData.count) / 1024.0

        while imageSizeKB > 1024 {
            print("resized start")
            guard let resizedImage  = resizingImage.resized(withPercentage: 0.9), let imageData = resizedImage.pngData() else { return nil }
            print("resized end")
            resizingImage           = resizedImage
            imageSizeKB             = Double(imageData.count) / 1024.0
        }
        
        return resizingImage
    }

    func resizedTo1MB(completionHandler: ((UIImage?) -> Void)? = nil) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let imageData         = self.pngData() else {
                completionHandler?(nil)
                return
            }

            var resizingImage           = self
            var imageSizeKB             = Double(imageData.count) / 1024.0

            while imageSizeKB > 1024 {
                guard let resizedImage  = resizingImage.resized(withPercentage: 0.9), let imageData = resizedImage.pngData() else {
                    completionHandler?(nil)
                    return
                }
                resizingImage           = resizedImage
                imageSizeKB             = Double(imageData.count) / 1024.0
            }
            DispatchQueue.main.async {
                completionHandler?(resizingImage)
            }
        }
    }
}

extension UIImageView {
    func setImageWith(imagePath: String, defaultImage: UIImage? = nil, defaultImageName: String? = AppConfig.si.defaultAvatar_ImageName, ignoreCache: Bool? = false, completion: ((UIImage?) -> Void)?) {
        var image                               = defaultImage != nil ? defaultImage : UIImage(named: defaultImageName!)
        if let url = URL(string: imagePath), imagePath.range(of:"https") != nil {
            
//            if ignoreCache == true {
//                URLCache.shared.removeAllCachedResponses()
//            }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("load user image error : \(String(describing: error))")
                }
                
                if let data = data {
                    let imageFromData           = UIImage(data: data)
                    DispatchQueue.main.async(execute: {
                        if imagePath != "" && imageFromData != nil {
                            image               = imageFromData!
                        }
                        self.image              = image
                        completion?(image)
                    })
                }
//                if ignoreCache == true {
//                    URLCache.shared             = AppConfig.si.urlCache
//                }
            }).resume()
        } else {
            self.image                          = image
            if defaultImage != nil {
                completion?(image)
            }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Int {
    func format(f: String) -> String {
//        let someInt = 4, someIntFormat = "03"
//        println("The integer number \(someInt) formatted with \"\(someIntFormat)\" looks like \(someInt.format(someIntFormat))")
//        // The integer number 4 formatted with "03" looks like 004
        return String(format: "%\(f)d", self)
    }
}

extension Double {
    func format(f: String) -> String {
//        let someDouble = 3.14159265359, someDoubleFormat = ".3"
//        println("The floating point number \(someDouble) formatted with \"\(someDoubleFormat)\" looks like \(someDouble.format(someDoubleFormat))")
//        // The floating point number 3.14159265359 formatted with ".3" looks like 3.142
        return String(format: "%\(f)f", self)
    }
}

extension UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init?(hexString: String) {
        guard let hex = hexString.hex else {
            return nil
        }
        self.init(hex: hex)
    }
}

//import Agrume
import AVKit

extension UIViewController {
    func showInputDialog(title: String? = nil,
                         subtitle: String? = nil,
                         actionTitle: String? = "Submit",
                         actionColor: UIColor? = AppConfig.si.colorPrimary,
                         cancelTitle: String? = "Cancel",
                         cancelColor: UIColor? = AppConfig.si.colorPrimary,
                         inputPlaceholder: String? = nil,
                         inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        let submicAction = UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        })
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default, handler: cancelHandler)
        
        alert.addAction(cancelAction)
        alert.addAction(submicAction)
        
        submicAction.setValue(actionColor, forKey: "titleTextColor")
        cancelAction.setValue(cancelColor, forKey: "titleTextColor")
        
        self.present(alert, animated: true, completion: nil)
    }
        
//    func displayMediaFrom(url: String) {
//        let httpService = HTTPService()
//        httpService.downloadImage(imagePath: url) { [weak self] (image) in
//            guard let `self`                = self else { return }
//            if let image = image {
//                let agrume                  = Agrume(image: image)
//                agrume.show(from: self)
//            } else if let url = URL(string: url) {
//                let player                  = AVPlayer(url: url)
//                let playerViewController    = AVPlayerViewController()
//                playerViewController.player = player
//                self.present(playerViewController, animated: true) {
//                    playerViewController.player!.play()
//                }
//            }
//        }
//    }
}

extension UITableView {
    func setNoDataPlaceholder(_ message: String,_ imageName: String?) {
        if imageName == nil {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            label.textAlignment = .center
            label.textColor = .lightGray
            label.text = message
            label.numberOfLines = 5
            label.sizeToFit()

            self.isScrollEnabled = false
            self.backgroundView = label
            self.separatorStyle = .none
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            imageView.image = UIImage(named: imageName!)    //?.withRenderingMode(.alwaysTemplate)
            //  imageView.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            view.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview().offset(-60)
                make.centerX.equalToSuperview()
            }
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 200, height: 300))
            label.textAlignment = .center
            label.textColor = .lightGray
            label.text = message
            label.font  = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 5
            label.sizeToFit()
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            self.isScrollEnabled = false
            self.backgroundView = view
            self.separatorStyle = .none
        }
    }
    
    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UICollectionView {
    func setNoDataPlaceholder(_ message: String,_ imageName: String?) {
        if imageName == nil {
            let label               = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            label.textAlignment     = .center
            label.textColor         = .lightGray
            label.text              = message
            label.numberOfLines     = 5
            label.sizeToFit()
            self.isScrollEnabled    = false
            self.backgroundView     = label
            
        } else {
            let view                = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let imageView           = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            imageView.image         = UIImage(named: imageName!)
            view.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview().offset(-60)
                make.centerX.equalToSuperview()
            }
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width - 200, height: 300))
            label.textAlignment     = .center
            label.textColor         = .lightGray
            label.text              = message
            label.font              = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 5
            label.sizeToFit()
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            self.isScrollEnabled    = false
            self.backgroundView     = view
        }
    }
    
    func removeNoDataPlaceholder() {
        self.isScrollEnabled        = true
        self.backgroundView         = nil
    }
}

extension UITableViewCell {
    func showSeparator() {
        DispatchQueue.main.async { [weak self] in
            self?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func hideSeparator() {
        DispatchQueue.main.async { [weak self] in
            self?.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
        }
    }
}

extension Dictionary {
    mutating func update(other: Dictionary?) {
        if other != nil {
            for (key,value) in other! {
                self.updateValue(value, forKey:key)
            }
        }
    }
}

extension CAGradientLayer {
    convenience init(frame: CGRect, colors: [UIColor], direction: GradientDirection) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        
        switch direction {
        case .leftToRight:
            startPoint              = CGPoint(x: 0.0, y: 0.5)
            endPoint                = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            startPoint              = CGPoint(x: 1.0, y: 0.5)
            endPoint                = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            startPoint              = CGPoint(x: 0.5, y: 1.0)
            endPoint                = CGPoint(x: 0.5, y: 0.0)
        case .topToBottom:
            startPoint              = CGPoint(x: 0.5, y: 0.0)
            endPoint                = CGPoint(x: 0.5, y: 1.0)
        }
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UINavigationController {
    func backToViewController(viewController: Swift.AnyClass) {
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
	
	func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
}

extension UINavigationBar {
    func setGradientBackground(colors: [UIColor] = [ #colorLiteral(red: 0.768627451, green: 0.8039215686, blue: 0.8352941176, alpha: 1), AppConfig.si.colorPrimary], direction: GradientDirection) {
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, direction: direction)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}

final class SwipeNavigationController: UINavigationController {
    // MARK: - Lifecycle
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This needs to be in here, not in init
        interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Overrides
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - Private Properties
    fileprivate var duringPushAnimation = false
}

// MARK: - UINavigationControllerDelegate
extension SwipeNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        swipeNavigationController.duringPushAnimation = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension SwipeNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}

// MARK: - Extensions used by NCTabBarController
extension UIView {
    
    func addConstraints(withFormat format: String, arrayOf views: [UIView]) {
        var viewsDictionary = [String: UIView]()
        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    @discardableResult
    public func top(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func bottom(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    public func square() {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1, constant: 0).isActive = true
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerX(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    public func horizontal(toView view: UIView, space: CGFloat = 0) {
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: space).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -space).isActive = true
    }

    public func vertical(toView view: UIView, space: CGFloat = 0) {
        topAnchor.constraint(equalTo: view.topAnchor, constant: space).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -space).isActive = true
    }
    
}

extension UIEdgeInsets {
    init(space: CGFloat) {
        self.init(top: space, left: space, bottom: space, right: space)
    }
}

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager                   = NSLayoutManager()
        let textContainer                   = NSTextContainer(size: CGSize.zero)
        let textStorage                     = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding   = 0.0
        textContainer.lineBreakMode         = label.lineBreakMode
        textContainer.maximumNumberOfLines  = label.numberOfLines
        let labelSize                       = label.bounds.size
        textContainer.size                  = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel          = self.location(in: label)
        let textBoundingBox                 = layoutManager.usedRect(for: textContainer)
        let textContainerOffset             = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                                      y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer  = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                      y: locationOfTouchInLabel.y - textContainerOffset.y);
        var indexOfCharacter                = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                                           in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        indexOfCharacter                    = indexOfCharacter + 4
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
