//
//  Constants.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import KRProgressHUD

typealias StringAnyObject = [String: AnyObject]
typealias voidCompletion = (()->Void)
typealias boolCompletion = ((_ success: Bool)->Void)
typealias intCompletion = ((_ value: Int)->Void)
typealias backgroundFetchCompletion = ((_ status: UIBackgroundFetchResult)->Void)
typealias indexPathBlock = ((_ indexPath: IndexPath)->Void)
typealias StringAny = [String: Any]
typealias StringArrayBlock = ((_ stringArray: [String])->Void)
typealias StringString = [String: String]
typealias Loading = (showLoader: Bool, showTransparentView: Bool)

typealias CellIdentifiers = Storyboard.CellIdentifiers
typealias SegueIdentifiers = Storyboard.SegueIdentifiers
typealias VCIdentifier = Storyboard.VCIdentifier
typealias Nib = Storyboard.Nib

//let PLACEHOLDER_IMAGE = "ic_dummy".imageWithOriginalMode

enum Storyboard {
        
    enum VCIdentifier {
        
    }
    
    enum SegueIdentifiers {
        
    }
    
    enum CellIdentifiers {
        
    }
    
    enum Nib {
        
    }
    
}


class Constants {
    
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    static func withoutAnimationBlock(block: voidCompletion, completion: voidCompletion?) {
        UIView.setAnimationsEnabled(false)
        block()
        UIView.setAnimationsEnabled(true)
        completion?()
    }
    
    static func getValidImageURL(with rowUrl: String) -> URL? {
        if let stringUrl = rowUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let url = URL(string: stringUrl) {
                return url
            }
        }
        return nil
    }
    
    static func showProgressWithoutBackg(withMessage:String) {
        DispatchQueue.main.async {
            KRProgressHUD
                .set(style: .custom(background: UIColor.clear, text: .white, icon: .white))
                .set(maskType: .white)
                .show(withMessage: withMessage)
            KRProgressHUD.set(activityIndicatorViewColors: [UIColor.appColor])
        }
    }
    
    static func hideProgressIndicator() {
        DispatchQueue.main.async {
            KRProgressHUD.dismiss()
        }
    }
    
}
