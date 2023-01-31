//
//  WebService.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import Foundation
import Alamofire
typealias CompletionBlock = ([String : Any]) -> Void
typealias FailureBlock = ([String : Any]) -> Void
typealias ProgressBlock = (Double) -> Void

// ((Swift.Int) -> Swift.Void)? = nil )
// http://fuckingswiftblocksyntax.com
/// https://www.raywenderlich.com/121540/alamofire-tutorial-getting-started
func isConnectedToInternet() ->Bool {
    return NetworkReachabilityManager()!.isReachable
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

class WebServices {
    
    enum ContentType : String {
        case applicationJson = "application/json"
        case textPlain = "text/plain"
    }
    
    
    static var manager = AF.session
    class func postAuth( url : Api,
                         parameters  : [String : Any]  ,
                         method : HTTPMethod? = .post ,
                         contentType: ContentType? = .applicationJson,
                         authorization : (user: String, password: String)? = nil,
                         authorizationToken : String?  = nil,
                         completionHandler: CompletionBlock? = nil,
                         failureHandler: FailureBlock? = nil){
        var headers : HTTPHeaders = [
            "Content-Type": contentType!.rawValue,
            "cache-control": "no-cache",
            "username" : "ajay1@marketsflow.com",
            "password" : "UKengland10"
        ]
        
        if authorizationToken  != nil {
            headers["Authorization"] = "Bearer \(authorizationToken!)"
        }
        let urlString = url.baseURl()
        print("url->",urlString)
        var somString = ""
        
        let dictionary = parameters
        
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
            ), let theJSONText = String(data: theJSONData,
                                        encoding: String.Encoding.ascii) {
            
            somString = theJSONText
        }
        
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.fittingroom.newtimezone.Fitzz")
        configuration.timeoutIntervalForRequest = 60 * 60 * 00
        WebServices.manager = AF.session
        var encodeSting : ParameterEncoding = somString
        
        if method == .get {
            encodeSting = URLEncoding.default
        }
        
        AF.request(urlString, method: method!,parameters: parameters,encoding:encodeSting ,  headers:headers  )
            .responseJSON {
                response in
                switch (response.result) {
                case .success(let value):
                    
                    completionHandler!(value as! [String : Any] )
                case .failure(let error):
                    print(error)
                    failureHandler?([:] )
                }
        }
        .responseString { _ in
        }
        .responseData { response in
            switch response.result {
            case .success(let data):
                if let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
            case .failure(let error) :
                print(error)
            }
            
        }
        
        
    }
    
    class func downloadFile(url :String , completionHandler: CompletionBlock? = nil) {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        AF.download(
            url,
            method: .get,
            parameters: [:],
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                
                //progress closure
            }).response(completionHandler: { (DefaultDownloadResponse) in
                
                print(DefaultDownloadResponse)
                completionHandler?([ : ])
                //here you able to access the DefaultDownloadResponse
                //result closure
            })
        
        
    }
    
    
    
    
    
    
    class func post( url : Api,jsonObject: [String : Any]  ,
                     method : HTTPMethod? = .post ,
                     completionHandler: CompletionBlock? = nil,
                     failureHandler: FailureBlock? = nil ) {
        let urlString = url.baseURl()
        print(urlString)
        
        let headers : HTTPHeaders = [
            "Content-Type": "application/form-data; application/x-www-form-urlencoded; ",
           "cache-control": "no-cache",
        ]
        
        let parameters: Parameters = jsonObject
        
        AF.request(urlString, method: method!, parameters: parameters, headers: headers)
            .responseJSON {
                response in
                print("upload Parameter :- \(parameters)")
                switch (response.result) {
                case .success(let value):
                    completionHandler!(value as! [String : Any] )
                case .failure(let error):
                    print(error)
                    failureHandler?([:] )
                }
        }
        .responseString { _ in
    
        }
        .responseData { response in
            switch response.result {
            case .success(let data):
                if let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    
    class func uploadData(url: Api, jsonObject: [String : Any], method: HTTPMethod = .post, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        let urlString = url.baseURl()
        print(urlString)
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            var params = [String:Any]()
            params["data"] = data.base64EncodedString()
            print(params)
            
            AF.request(urlString, method: method, parameters: params).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    completionHandler!(value as! [String : Any] )
                case .failure(let error):
                    print(error)
                    failureHandler?([:] )
                }
            }
        } catch {
            print("JSON Serialization Error : \(error)")
        }
    }
    
    class func uploadDataWithUserId(url: Api, jsonObject: [String : Any], method: HTTPMethod = .post, userId: Int, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        let urlString = url.baseURl()
        print(urlString)
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            var params = [String:Any]()
            params["data"] = data.base64EncodedString()
            params["user_id"] = userId
            print(params)
            
            AF.request(urlString, method: method, parameters: params).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    completionHandler!(value as! [String : Any] )
                case .failure(let error):
                    print(error)
                    failureHandler?([:] )
                }
            }
        } catch {
            print("JSON Serialization Error : \(error)")
        }
    }
    
    class func uploadDataWithImg(url: Api, jsonObject: [String : Any], image: UIImage, imageKey: String, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        let urlString = url.baseURl()
        print(urlString)
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            var params = [String:Any]()
            params["data"] = data.base64EncodedString()
            
            AF.request(urlString, method: .post, parameters: params).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    completionHandler!(value as! [String : Any] )
                case .failure(let error):
                    print(error)
                    failureHandler?([:] )
                }
            }
        } catch {
            print("JSON Serialization Error : \(error)")
        }
    }
    
    /*class func uploadSingle( url : Api,jsonObject: [String : Any] , profiePic:UIImage , completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        
        let urlString = url.baseURl()
        print(urlString)
        let parameters: Parameters = jsonObject
        AF.upload(multipartFormData: { multipartFormData in
            
            let data = profiePic.jpegData(compressionQuality: 1)
            
            
            //  UIImageJPEGRepresentation(profiePic, 1)!
            
            multipartFormData.append(data!, withName: "image", fileName: "\(NSUUID().uuidString).jpeg", mimeType: "image/jpeg")
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },
                         to: urlString) { result  in
                            switch result {
                            case .success(let upload, _, _):
                                
                                upload.uploadProgress(closure: { _ in
                                    // Print progress
                                    
                                })
                                upload.responseJSON { response in
                                    switch (response.result) {
                                    case .success(let value):
                                        completionHandler!(value as! [String : Any] )
                                    case .failure(let error):
                                        print(error)
                                        failureHandler?([:] )
                                    }
                                    
                                }
                                
                            case .failure(let encodingError):
                                print(encodingError)
                            }
                            
        }
    }
    class func uploadMultile( url : Api,jsonObject: [String : Any] , files :[String] , completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil , progessHandler : ProgressBlock? = nil) {
        let urlString = url.baseURl()
        let parameters: Parameters = jsonObject
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.fittingroom.newtimezone.Fitzz")
        configuration.timeoutIntervalForRequest = 60 * 60 * 00
        WebServices.manager = AF.session
        WebServices.manager.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for (index , file) in files.enumerated() {
                
                let directoryName = ""
                
                var url = URL(fileURLWithPath: directoryName)
                
                let filename = file
                
                url = url.appendingPathComponent(filename)
                
                if FileManager.default.fileExists(atPath: url.path) {
                    
                    if url.pathExtension == "jpg" {
                        
                        if let profiePic =  UIImage(contentsOfFile: url.path) {
                            let data = profiePic.jpegData(compressionQuality: 0.5)
                            
                            
                            multipartFormData.append(data!, withName: "images", fileName: file, mimeType: "image/jpeg")
                            
                            
                            
                        }
                        
                    }else {
                        //     multipartFormData.append( url.path, withName: "File1", fileName: file, mimeType: "video/mp4")
                        // here you can upload any type of video
                        //multipartFormData.append(self.selectedVideoURL!, withName: "File1")
                        
                        
                        multipartFormData.append(url, withName: "images", fileName: file, mimeType: "video/mp4")
                        // here you can upload any type of video
                        //multipartFormData.append(self.selectedVideoURL!, withName: "File1")
                        //  multipartFormData.append(("VIDEO".data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "Type")
                        
                        
                        // multipartFormData.append(("VIDEO".data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "Type")
                        
                    }
                    
                    
                }
                
            }
            
            
        },
                                   to: urlString) { result  in
                                    switch result {
                                    case .success(let upload, _, _):
                                        
                                        upload.uploadProgress(closure: { value in
                                            
                                            
                                            progessHandler?(value.fractionCompleted)
                                            print("uploadProgress---" , value)
                                        })
                                        upload.responseJSON { response in
                                            switch (response.result) {
                                            case .success(let value):
                                                completionHandler!(value as! [String : Any] )
                                            case .failure(let error):
                                                print(error)
                                                failureHandler?([:] )
                                            }
                                            
                                        }
                                        
                                    case .failure(let encodingError):
                                        print(encodingError)
                                        failureHandler?([:] )
                                    }
                                    
        }
        
        
    }
    
    class func uploadFiles(url: Api, jsonObject: [String : Any], files: (key: String, images: [UIImage]), headers: HTTPHeaders?, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
            
            let urlString = url.baseURl()
            let parameters: Parameters = jsonObject
            print("******URL*****\(urlString) *****Parameters*****\(parameters)")
            
        AF.upload(multipartFormData: { multipartFormData in
                
                for image in files.images {
                    let data = image.jpegData(compressionQuality: 0.2)
                    let udidStr = UUID().uuidString + ".jpg"
                    multipartFormData.append(data!, withName: files.key, fileName: udidStr, mimeType: "image/jpg")
                }
                
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                
            },
                             usingThreshold: UInt64.init(), to: urlString, method: .post, headers: headers) { (result) in
                                print(headers)
                                
                                // to: urlString) { result  in
                                switch result {
                                case .success(let upload, _, _):
                                    
                                    upload.uploadProgress(closure: { _ in
                                        // Print progress
                                    })
                                    upload.responseJSON { response in
                                        switch (response.result) {
                                        case .success(let value):
                                            
                                            print("********ddf*" , value)
                                            completionHandler!(value as! [String : Any] )
                                        case .failure(let error):
                                            print(error)
                                            failureHandler?([:] )
                                        }
                                    }
                                    
                                case .failure(let encodingError):
                                    print(encodingError)
                                }
            }
        }*/


    
}
