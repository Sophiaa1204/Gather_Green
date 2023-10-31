//
//  EmailHelper.swift
//  Gather Green
//
//  Created by Sophia Wang on 4/3/23.
//

// This part of code is adapted from: https://thinkdiff.net/how-to-send-email-in-swiftui-5a9047e3442f
// annotated by Sophia Wang

import Foundation
import MessageUI

class EmailHelper: NSObject, MFMailComposeViewControllerDelegate {
    // Singleton Design Pattern
    public static let shared = EmailHelper()
    // the constructor can't be visited outside of the class
    private override init() {
    }
    
    // senfEmail Function
    // the default email address should be changed to "bryce@wegathergreen.com" later.
    // for testing purposes, I use my own email address instead
    func sendEmail(subject: String, body: String, to: String = "GatherGreenApp@gmail.com") -> Bool {
        if !MFMailComposeViewController.canSendMail() {
            print("No mail account found")
            // show an alart at the front end
            return false
        }
        
        // instantiate a new controller object
        let picker = MFMailComposeViewController()
        
        picker.setSubject(subject)
        picker.setMessageBody(body, isHTML: true)
        picker.setToRecipients([to])
        //  the object should use the current object as the delegate
        //  the MFMailComposeViewController object needs to inform another object (the one that presents it) about the result of sending the email
        //  This means that the current object will receive messages from the MFMailComposeViewController object about the progress and status of sending the email, and can respond accordingly.
        //  For example, if the email is sent successfully, the MFMailComposeViewController object will call the mailComposeController(_:didFinishWith:error:) method on its delegate (which is the current object), and the current object can handle the successful completion of the email sending process.
        picker.mailComposeDelegate = self
        
        //  present(_:animated:completion:) is a method on the UIViewController class that presents a view controller modally on top of the current view controller hierarchy.
        EmailHelper.getTopMostViewController()?.present(picker, animated: true, completion: nil)
        
        return true
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailHelper.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        UIApplication.shared.windows.first?.rootViewController
    }
    
    static func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
}


