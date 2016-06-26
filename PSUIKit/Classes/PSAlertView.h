//
//  PSAlertView.h
//  PSUIKit
//
//  Created by Steve Kim on 2015. 2. 6..
//  Copyright (c) 2013 ~ 2016 Steve Kim. All rights reserved.
//

public typealias PSAlertViewDismission = (PSAlertView!, Int, Bool) -> Void

public class PSAlertView : PSView, PSButtonBarDelegate {
    public var buttonHeight: CGFloat
    public var headerViewHeight: CGFloat
    public var contentPadding: CGPadding
    public var message: String!
    public var title: String!
    public var contentViewHeight: CGFloat { get }
    public var headerView: UIView!
    public var contentView: UIView!
    public var titleLabel: PSAttributedDivisionLabel! { get }
    public var messageLabel: UILabel! { get }
    public var delegate: PSAlertViewDelegate!
    public /*not inherited*/ init!(contentView: UIView!, cancelButtonTitle: String!, dismission: PSAlertViewDismission!, otherButtonTitles: [String]!)
    public /*not inherited*/ init!(message: String!, cancelButtonTitle: String!, dismission: PSAlertViewDismission!, otherButtonTitles: [String]!)
    public /*not inherited*/ init!(title: String!, contentView: UIView!, cancelButtonTitle: String!, dismission: PSAlertViewDismission!, otherButtonTitles: [String]!)
    public /*not inherited*/ init!(title: String!, message: String!, cancelButtonTitle: String!, dismission: PSAlertViewDismission!, otherButtonTitles: [String]!)
    public class func dismissAll()
    public func dismissWithClickedButtonIndex(buttonIndex: Int, animated: Bool)
    public init!(title: String!, message: String!, delegate: AnyObject!, cancelButtonTitle: String!, otherButtonTitles: [String]!)
    public func show()
    public func showWithDismission(dismission: PSAlertViewDismission!)
}

public protocol PSAlertViewDelegate : NSObjectProtocol {
    
    optional public func PSAlertView(alertView: PSAlertView!, clickedButtonAtIndex buttonIndex: Int)
    optional public func PSAlertViewCancel(alertView: PSAlertView!)
    optional public func willPresentPSAlertView(alertView: PSAlertView!)
    optional public func didPresentPSAlertView(alertView: PSAlertView!)
    optional public func PSAlertView(alertView: PSAlertView!, willDismissWithButtonIndex buttonIndex: Int)
    optional public func PSAlertView(alertView: PSAlertView!, didDismissWithButtonIndex buttonIndex: Int)
    optional public func PSAlertViewShouldEnableFirstOtherButton(alertView: PSAlertView!) -> Bool
}

extension NSString {
    public func MD5() -> String!
}
