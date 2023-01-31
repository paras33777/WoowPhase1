//
//  ReceiptValidator.swift
//  WooW
//
//  Created by Rahul Chopra on 03/07/21.
//

import Foundation
import UIKit
import Alamofire

class ReceiptValidator {
    
    static let sharedInstance = ReceiptValidator()
    
    func checkReceiptValidation(completion: @escaping((Bool?, String, String, String) -> Void)) {
//        DispatchQueue.main.async {
//            Hud.show(message: "Processing...", view: UIApplication.topViewController()!.view)
//        }
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

        if recieptString == nil {
            print("No Receipt found")
            DispatchQueue.main.async {
//                Hud.hide(view: UIApplication.topViewController()!.view)
                completion(true, "", "", "")
            }
            return
        }

        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password": IAPKeys.kSecretKey as AnyObject]

        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData

            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in

                do {
                    guard let data = data else {
                        DispatchQueue.main.async {
//                            Hud.hide(view: UIApplication.topViewController()!.view)
                            completion(true, "", "", "")
                        }
                        return
                    }

                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print("=======>",jsonResponse)
                    
                    
                    if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
                        print(date)
                        
                        guard let dateInZero = date.0 else {
                            completion(true, "", "", "")
                            return
                        }

                        print("TIME : \(date.0!.timeIntervalSinceNow)")
                        UserDefault.saveSubscriptionExpiration(date: date.0!)

                        DispatchQueue.main.async {
//                            Hud.hide(view: UIApplication.topViewController()!.view)
                        }
                        
                        ReceiptValidator.serverTimeReturn { (serverDate) in
                            if let serverDate = serverDate {
                                if serverDate < date.0! {
                                    print("NOT EXPIRED")
                                    completion(false, date.1, date.2, date.3)
                                } else {
                                    print("EXPIRED")
                                    DispatchQueue.main.async {
                                        completion(true, "", "", "")
//                                        let expiredDate = date.0!.changeExpirationTime()
                                    }
                                }
                            }
                        }

                        completion(nil, "", "", "")
                    }  else {
                        DispatchQueue.main.async {
//                            Hud.hide(view: UIApplication.topViewController()!.view)
                            completion(true, "", "", "")
                        }
                    }
                } catch let parseError {
                    DispatchQueue.main.async {
//                        Hud.hide(view: UIApplication.topViewController()!.view)
                        completion(true, "", "", "")
                    }
                    print(parseError)
                }
            })
            task.resume()
        } catch let parseError {
            DispatchQueue.main.async {
//                Hud.hide(view: UIApplication.topViewController()!.view)
                completion(true, "", "", "")
            }
            print(parseError)
        }
    }

    private func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> (Date?, String, String, String) {
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            let lastReceipt = receiptInfo.firstObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            var prodId = ""
            if let productId = lastReceipt["product_id"] as? String {
                print("Purchased Product Id: \(productId)")
                UserDefaults.standard.set(productId, forKey: "PurchasedProductId")
                prodId = productId
            }

            if let expiresDate = lastReceipt["expires_date"] as? String  {
                return (formatter.date(from: expiresDate), prodId, lastReceipt["transaction_id"] as! String, lastReceipt["original_purchase_date"] as! String)
            }
            return (nil, "", "", "")
        }
        else {
            return (nil, "", "", "")
        }
    }
    
    class func serverTimeReturn(completionHandler:@escaping (_ getResDate: Date?) -> Void){
        let url = URL(string: "https://www.google.com")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if let contentType = httpResponse.allHeaderFields["Date"] as? String {
                    
                    let dFormatter = DateFormatter()
                    dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                    dFormatter.locale = Locale(identifier: "en-US")
                    if let serverTime = dFormatter.date(from: contentType) {
                        completionHandler(serverTime)
                    } else {
                        completionHandler(nil)
                    }
                }
            }
        }
        
        task.resume()
    }
    
}


// MARK: - Date Convert Date To String
extension Date {
    func changeExpirationTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let defaultTimeZoneStr = formatter.string(from: self)
        let defaultTimeZoneDate = formatter.date(from: defaultTimeZoneStr)
        
        let convertedFormatter = DateFormatter()
        convertedFormatter.dateFormat = "dd:MM:yyyy hh:mm a"
        let convertedDateStr = convertedFormatter.string(from: defaultTimeZoneDate!)
        return convertedDateStr
    }
}
