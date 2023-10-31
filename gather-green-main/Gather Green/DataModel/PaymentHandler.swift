/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A shared class for handling payments across an app and its related extensions.
*/
/*
 Reference:
 https://github.com/stephdiep/SweaterShopApp
 */

import UIKit
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

//func getTopMostViewController() -> UIViewController? {
//    var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
//
//    while let presentedViewController = topMostViewController?.presentedViewController {
//        topMostViewController = presentedViewController
//    }
//
//    return topMostViewController
//}


public class PaymentConfiguration {
    /*
     The value of the `OFFERING_APPLE_PAY_BUNDLE_PREFIX` user-defined build
     setting is written to the Info.plist file of every target in Swift
     version of the sample project. Specifically, the value of
     `OFFERING_APPLE_PAY_BUNDLE_PREFIX` is used as the string value for a
     key of `AAPLOfferingApplePayBundlePrefix`. This value is loaded from the
     target's bundle by the lazily evaluated static variable "prefix" from
     the nested "Bundle" struct below the first time that "Bundle.prefix"
     is accessed. This avoids the need for developers to edit both
     `OFFERING_APPLE_PAY_BUNDLE_PREFIX` and the code below. The value of
     `Bundle.prefix` is then used as part of an interpolated string to insert
     the user-defined value of `OFFERING_APPLE_PAY_BUNDLE_PREFIX` into several
     static string constants below.
     */

    private struct MainBundle {
        static var prefix: String = {
            guard let prefix = Bundle.main.object(forInfoDictionaryKey: "AAPLOfferingApplePayBundlePrefix") as? String else {
                return ""
            }
            return prefix
        }()
    }

    struct Merchant {
        static let identifier = "merchant.gather-green"
    }
}



class PaymentHandler: NSObject {

    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler!

    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .discover,
        .masterCard,
        .visa
    ]

    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    // Define the shipping methods.
    func shippingMethodCalculator() -> [PKShippingMethod] {
        // Calculate the pickup date.
        
        let today = Date()
        let calendar = Calendar.current
        
        let shippingStart = calendar.date(byAdding: .day, value: 2, to: today)!
        let shippingEnd = calendar.date(byAdding: .day, value: 3, to: today)!
        
        let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
        let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
         
        let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "0.00"))
        shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
        shippingDelivery.detail = "Ticket sent to you address"
        shippingDelivery.identifier = "DELIVERY"
        
        let shippingCollection = PKShippingMethod(label: "Collection", amount: NSDecimalNumber(string: "0.00"))
        shippingCollection.detail = "Collect product at Gather Green"
        shippingCollection.identifier = "COLLECTION"
        
        return [shippingDelivery, shippingCollection]
    }
    
    func startPayment(completion: @escaping PaymentCompletionHandler) {

        completionHandler = completion
        
        let ticket = PKPaymentSummaryItem(label: "Festival Entry", amount: NSDecimalNumber(string: "9.99"), type: .final)
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "1.00"), type: .final)
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "10.99"), type: .final)
        paymentSummaryItems = [ticket, tax, total]
        
        // Create a payment request.
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = PaymentConfiguration.Merchant.identifier
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        paymentRequest.shippingType = .delivery
        paymentRequest.shippingMethods = shippingMethodCalculator()
        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        #if !os(watchOS)
        paymentRequest.supportsCouponCode = true
        #endif
        
        // Display the payment request.
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
                self.completionHandler(false)
            }
        })
    }
    
    func startPaymentProduct(product: Product, count: Int, completion: @escaping PaymentCompletionHandler) {

        completionHandler = completion
        
        let ticket = PKPaymentSummaryItem(label: product.name, amount: NSDecimalNumber(value: (product.price * Float(count))), type: .final)
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(value: (0.1 * product.price * Float(count))), type: .final)
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(value: (1.1 * product.price * Float(count))), type: .final)
        paymentSummaryItems = [ticket, tax, total]
        
        // Create a payment request.
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = PaymentConfiguration.Merchant.identifier
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        paymentRequest.shippingType = .delivery
        paymentRequest.shippingMethods = shippingMethodCalculator()
        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        #if !os(watchOS)
        paymentRequest.supportsCouponCode = true
        #endif
        
//         Display the payment request.
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
                self.completionHandler(true)
            } else {
                debugPrint("Failed to present payment controller")
                self.completionHandler(false)
            }
        })
    }
    
    func startPaymentCheckout(shoppingCart:[ShoppingCartItem], completion: @escaping PaymentCompletionHandler) {

        completionHandler = completion
        
        paymentSummaryItems = []
        var total = 0.0
        shoppingCart.forEach({ item in
            let itemPayment = PKPaymentSummaryItem(label: "\(item.product.name)", amount: NSDecimalNumber(string: "\(item.product.price * item.count)"), type: .final)
            paymentSummaryItems.append(itemPayment)
            total += Double(item.product.price * item.count)
        })
        
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "\(total * 0.1)"), type: .final)
        let totalPayment = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(total * 1.1)"), type: .final)
        paymentSummaryItems.append(tax)
        paymentSummaryItems.append(totalPayment)
        
        // Create a payment request.
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = PaymentConfiguration.Merchant.identifier
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        paymentRequest.shippingType = .delivery
        paymentRequest.shippingMethods = shippingMethodCalculator()
        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        #if !os(watchOS)
        paymentRequest.supportsCouponCode = true
        #endif
        
        // Display the payment request.
        let paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController.delegate = self
        paymentController.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
                self.completionHandler(false)
            }
        })
    }
}

// Set up PKPaymentAuthorizationControllerDelegate conformance.

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        // Perform basic validation on the provided contact information.
        var errors = [Error]()
        var status = PKPaymentAuthorizationStatus.success
        if payment.shippingContact?.postalAddress?.isoCountryCode != "US" {
            let pickupError = PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "Sample App only available in the United States")
            let countryError = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressCountryKey, localizedDescription: "Invalid country")
            errors.append(pickupError)
            errors.append(countryError)
            status = .failure
        } else {
            // Send the payment token to your server or payment provider to process here.
            // Once processed, return an appropriate status in the completion handler (success, failure, and so on).
        }
        
        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // The payment sheet doesn't automatically dismiss once it has finished. Dismiss the payment sheet.
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
    
    #if !os(watchOS)

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didChangeCouponCode couponCode: String,
                                        handler completion: @escaping (PKPaymentRequestCouponCodeUpdate) -> Void) {
        // The `didChangeCouponCode` delegate method allows you to make changes when the user enters or updates a coupon code.
        
        func applyDiscount(items: [PKPaymentSummaryItem]) -> [PKPaymentSummaryItem] {
            let tickets = items.first!
            let couponDiscountItem = PKPaymentSummaryItem(label: "Coupon Code Applied", amount: NSDecimalNumber(string: "-2.00"))
            let updatedTax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "0.80"), type: .final)
            let updatedTotal = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "8.80"), type: .final)
            let discountedItems = [tickets, couponDiscountItem, updatedTax, updatedTotal]
            return discountedItems
        }
        
        completion(PKPaymentRequestCouponCodeUpdate(paymentSummaryItems: paymentSummaryItems))
        
        if couponCode.uppercased() == "FESTIVAL" {
            // If the coupon code is valid, update the summary items.
            let couponCodeSummaryItems = applyDiscount(items: paymentSummaryItems)
            completion(PKPaymentRequestCouponCodeUpdate(paymentSummaryItems: applyDiscount(items: couponCodeSummaryItems)))
            return
        } else if couponCode.isEmpty {
            // If the user doesn't enter a code, return the current payment summary items.
            completion(PKPaymentRequestCouponCodeUpdate(paymentSummaryItems: paymentSummaryItems))
            return
        } else {
            // If the user enters a code, but it's not valid, we can display an error.
            let couponError = PKPaymentRequest.paymentCouponCodeInvalidError(localizedDescription: "Coupon code is not valid.")
            completion(PKPaymentRequestCouponCodeUpdate(errors: [couponError], paymentSummaryItems: paymentSummaryItems, shippingMethods: shippingMethodCalculator()))
            return
        }
    }

    #endif
}

