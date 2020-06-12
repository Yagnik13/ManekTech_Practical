//
//  Extensions.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
import UIKit

typealias imageDownloadCompletionBlock = (Bool, UIImage?)->()
fileprivate let imageCache = NSCache<AnyObject, AnyObject>()
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
let temporaryDirectory = NSTemporaryDirectory()

extension UIColor {
    
    @nonobjc class var appColor: UIColor {
        return UIColor(named: "appColor")!
    }
}

extension String {
    
    func toImage(isRenderingModeTemplate mode: Bool = true) -> UIImage {
        return UIImage(named: self)!.withRenderingMode(mode ? .alwaysTemplate : .alwaysOriginal)
    }
    
    var imageWithTemplatedMode: UIImage {
        return UIImage(named: self)!.withRenderingMode(.alwaysTemplate)
    }
    
    var imageWithOriginalMode: UIImage {
        return UIImage(named: self)!.withRenderingMode(.alwaysOriginal)
    }
    
    func flippedImage(doKeepOriginal: Bool = true) -> UIImage {
        let image = (doKeepOriginal ? imageWithOriginalMode : imageWithTemplatedMode)
        return image
        //return languageOfApp == "ar" ? image.imageFlippedForRightToLeftLayoutDirection() : image
    }
    
    var trim: String {
        mutating get {
            self = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return String(self.filter { !" \n\t\r".contains($0) })
        }
    }
    
    var isNumber: Bool {
        let numberCharacters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
    
    var isPhoneNumber: Bool {
        let numberCharacters = CharacterSet(charactersIn: "+1234567890").inverted
        let isMobileNumber = self.rangeOfCharacter(from: numberCharacters) == nil
        return (!self.isEmpty && isMobileNumber) && self.count <= 12 && self.count >= 6
    }
    
    var isPin: Bool {
        return isNumber && self.count == 6
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){
                
                if self.setMinMaxCount(6, max: 20) {
                    return true
                }
                else {
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    func setMinMaxCount(_ min: Int, max: Int) -> Bool {
        if self.count < min || self.count > max {
            return false
        }
        else {
            return true
        }
    }
    
    mutating func dropLastCharacter() {
        self.remove(at: self.index(before: self.endIndex))
    }
    mutating func dropFirstCharacter() {
        self.remove(at: self.index(after: self.startIndex))
    }
    
    mutating func convertToDateString(convertFormat: String, resultFormat: String) {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = convertFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = resultFormat
            self = dateFormatter.string(from: date)
        }
    }
    
    mutating func convertToDateString(convertFormat: String, resultDateStyle: DateFormatter.Style = .medium) {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = convertFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateStyle = resultDateStyle
            self = dateFormatter.string(from: date)
        }
    }
    
    mutating func convertToDateTimeString(convertFormat: String, resultDateStyle: DateFormatter.Style = .medium, resultTimeStyle: DateFormatter.Style = .medium) {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = convertFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateStyle = resultDateStyle
            dateFormatter.timeStyle = resultTimeStyle
            self = dateFormatter.string(from: date)
        }
    }
    
    func convertToDateString(convertFormat: String, resultFormat: String) -> String {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = convertFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = resultFormat
            return dateFormatter.string(from: date)
        }
        return self
    }
    
    var data: Data? {
        return self.data(using: .utf8)
    }
    
    /*func toDisplayDate(convertFormat: AppDateFormat = .date) -> String {
        return self.convertToDateString(convertFormat: convertFormat, resultFormat: .displayDate)
    }*/
    
    var toDouble: Double {
        return (self as NSString).doubleValue
    }
        
}

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) -> Void {
        var viewsDirectory = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDirectory[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDirectory))
    }
    
    func setGradient(forColors colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.masksToBounds = true
        gradientLayer.cornerRadius = self.layer.cornerRadius
        var colorsToCGColor = [CGColor]()
        for color in colors {
            colorsToCGColor.append(color.cgColor)
        }
        gradientLayer.colors = colorsToCGColor
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func estimatedHeight(ofText text: String, forWidth width: CGFloat, withFontSize font: CGFloat, extraPadding: CGFloat = 16) -> CGFloat {
        let height = CGFloat(Float.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: CGSize(width: width, height: height), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font)], context: nil)
        return rect.height + extraPadding
    }
    
    class func estimatedHeight(ofText text: String, forWidth width: CGFloat, withFontSize font: CGFloat, extraPadding: CGFloat = 16) -> CGFloat {
        let height = CGFloat(Float.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: CGSize(width: width, height: height), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font)], context: nil)
        return rect.height + extraPadding
    }
    
    func estimatedTextFrame(ofText text: String, forHeight height: CGFloat, withFont font:UIFont, extraPadding: CGFloat = 16) -> CGRect {
        let width = CGFloat(Float.greatestFiniteMagnitude)
        var rect = text.boundingRect(with: CGSize(width: width, height: height), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:font], context: nil)
        rect.size.width = rect.width + extraPadding
        rect.size.height = rect.height + extraPadding
        return rect
    }
    
    class func estimatedTextFrame(ofText text: String, forHeight height: CGFloat, withFont font:UIFont, extraPadding: CGFloat = 16) -> CGRect {
        let width = CGFloat(Float.greatestFiniteMagnitude)
        var rect = text.boundingRect(with: CGSize(width: width, height: height), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:font], context: nil)
        rect.size.width = rect.width + extraPadding
        rect.size.height = rect.height + extraPadding
        return rect
    }
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: 0, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: 0, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: 0, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: 0, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
    
    func showNoDataFound(withMessage message: String = "No Data Found") {
        removeNoDataFound()
        let label = UILabel()
        label.tag = 12213
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.sizeToFit()
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
    func removeNoDataFound() {
        viewWithTag(12213)?.removeFromSuperview()
    }
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.cornerRadius = CGFloat(newValue)
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            if let bColor = self.layer.borderColor {
                return UIColor(cgColor: bColor)
            }
            return UIColor.black
        }set {
            self.layer.borderColor  = newValue.cgColor
            self.layer.masksToBounds = true
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    private static let kRotationAnimationKey = "rotationanimationkey"
    func startRotation() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = NSNumber(value: Double.pi * 2)
        rotation.toValue = 0.0
        rotation.duration = 0.7
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: UIView.kRotationAnimationKey)
    }
    
    func endRotation() {
        self.layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
    }
    
    func setShdowSpecificCorner(shadowColor: UIColor = UIColor.gray.withAlphaComponent(0.5), borderColor: UIColor, radius: CGFloat, opacity: Float, cornerRadius: CACornerMask, offset: CGSize) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = offset
        layer.masksToBounds = false
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.maskedCorners = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 0.01
    }
}

extension DateFormatter {
    
    ///DateFormatter with current timezone.
    static let MyDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()
}

protocol StoryboardInstantiable: class {
    static var storyboardIdentifier: String {get}
    static func instantiateFromStoryboard(storyboard: UIStoryboard) -> Self
}

extension UIViewController: StoryboardInstantiable {
    static var storyboardIdentifier: String {
        let classString = NSStringFromClass(self)
        let components = classString.components(separatedBy: ".")
        assert(components.count > 0, "Failed extract class name from \(classString)")
        return components.last!
    }
    
    class func instantiateFromStoryboard(storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> Self {
        return instantiateFromStoryboard(storyboard: storyboard, type: self)
    }
    
    private class func instantiateFromStoryboard<T: UIViewController>(storyboard: UIStoryboard, type: T.Type) -> T {
        return storyboard.instantiateViewController(withIdentifier: self.storyboardIdentifier) as! T
    }
    
    
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
    
}

extension UIBarButtonItem {
    
    @IBInspectable var localizableKey: String {
        get {
            return title ?? ""
        }
        set {
            title = newValue
        }
    }
    
    static let flexibleBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
}

extension UITabBarItem {
    
    @IBInspectable var localizableKey: String {
        get {
            return title ?? ""
        }
        set {
            title = newValue
        }
    }
    
}

extension UINavigationItem {
    
    @IBInspectable var localizableKey: String {
        get {
            return title ?? ""
        }
        set {
            title = newValue
        }
    }
    
}

extension UISearchBar {
    
    @IBInspectable var localizablePlaceHolderKey: String {
        get {
            return placeholder ?? ""
        }
        set {
            placeholder = newValue
        }
    }
    
    // Due to searchTextField property who available iOS 13 only, extend this property for iOS 13 previous version compatibility
    var compatibleSearchTextField: UITextField {
        guard #available(iOS 13.0, *) else { return legacySearchField }
        return self.searchTextField
    }

    private var legacySearchField: UITextField {
        if let textField = self.subviews.first?.subviews.last as? UITextField {
            return textField
        } else if let textField = self.value(forKey: "searchField") as? UITextField {
            return textField
        } else {            
            return UITextField()
        }
    }
    
}

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension UIImageView {
    func downloadImage(forURL imageURL: String, placeHolderImage: UIImage? = "image_placeholder".imageWithOriginalMode, withName imageName: String = "", completion: imageDownloadCompletionBlock? = nil) {
        self.image = placeHolderImage
        if let url = Constants.getValidImageURL(with: imageURL) {
            sd_setImage(with: url, placeholderImage: placeHolderImage) { (img, _, _, _) in
                if let downloadedImage = img {
                    self.image = downloadedImage
                }
                completion?(img != nil, img)
            }
            //sd_setImage(with: url, placeholderImage: placeHolderImage)
        } else {
            completion?(false, nil)
        }
    }
    
    func getImageFromTemporaryDirectory(forImageName imageName: String) -> UIImage? {
        if let cacheImageURL = URL(string: "\(temporaryDirectory)\(imageName)") {
            
            if FileManager.default.fileExists(atPath: cacheImageURL.path) {
                if let data = try? Data(contentsOf: cacheImageURL) {
                    if let img = UIImage(data: data) {
                        return img
                    }
                    return nil
                }
                return nil
            }
        }
        return nil
    }
    
    
}

extension UIImage {
    
    func resize(value: CGFloat) -> UIImage? {
        var imageSize: CGSize!
        if size.width > size.height {
            imageSize = CGSize(width: value, height: CGFloat(ceil(value/size.width * size.height)))
        } else {
            imageSize = CGSize(width: CGFloat(ceil(value/size.height * size.width)), height: value)
        }
        let imageView = UIImageView(frame: CGRect(origin: .zero, size:imageSize))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}


extension UIView {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
}
struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}


extension KeyedDecodingContainer {
    
    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    
    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }
    
    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem as Any, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension NSAttributedString {
    
    /*static func getForegroundFont(color: UIColor, fontType: AppFont, fontSize: CGFloat) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: fontType.getFont(withSize: fontSize)]
    }*/
}

/*static func getForegroundColor(color: UIColor) -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor : color]
}*/

extension UserDefaults {
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    open func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: defaultName)
    }
    
    open func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}

extension UIButton {
    
    func setCornerRadiusWithShadow(radius: CGFloat = 0, opacity: Float = 0, offSet: CGSize = CGSize(width: 0.0, height: 0.0), color: UIColor = .black, cornerRadius: CGFloat = 0.0) {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = offSet
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
extension Collection {
    func toJsonString() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
extension CALayer {

    func colorOfPoint(point:CGPoint) -> UIColor {

        var pixel: [CUnsignedChar] = [0, 0, 0, 0]

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        context!.translateBy(x: -point.x, y: -point.y)

        self.render(in: context!)

        let red: CGFloat   = CGFloat(pixel[0]) / 255.0
        let green: CGFloat = CGFloat(pixel[1]) / 255.0
        let blue: CGFloat  = CGFloat(pixel[2]) / 255.0
        let alpha: CGFloat = CGFloat(pixel[3]) / 255.0

        let color = UIColor(red:red, green: green, blue:blue, alpha:alpha)

        return color
    }
}
