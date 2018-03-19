//
//  ApiService.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import RxSwift
import SwiftyJSON
import ObjectMapper

class APIService {
    static let shared = APIService()
    
    static func forcedToast(_ message:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showToastOnTopViewcontrollers(message)
    }
    
    
    static func fetchProductByCategory(_ filter:FilterParameter) -> Observable<JSON> {
        return Observable.create{ observer in
            
            let requestURL:String = "https://ace.tokopedia.com/search/v2.5/product"
            
            let request = AlamofireManager.manager.request(requestURL, method: .get, parameters: filter.getParameter(), encoding: URLEncoding.queryString)
                .responseJSON{response in
                    
                    switch response.result {
                    case .success:
                        print(response.result.value)
                        let json = JSON(response.result.value)
                        observer.onNext(json)
                        observer.onCompleted()
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
//                            forcedToast("Connection Timeout")
                            return
                        }
                        print(error)
//                        forcedToast(error.localizedDescription)
                        observer.onError(error)
                    }
                    
                    
            }
            
            return Disposables.create(with: {
                
            })
        }
    }
    
    func requestImage(path: String, completionHandler: @escaping (UIImage) -> Void){
        AlamofireManager.manager.request("\(path)").responseImage(imageScale: 1.0, inflateResponseImage: false, completionHandler: {response in
            guard let image = response.result.value else{
                print("download\(path)->\(response.result)")
                return
            }
            DispatchQueue.main.async {
                completionHandler(image)
            }
        })
    }
    
    
    //MARK:==================
    
    
    
}

extension String {
    var isNumeric : Bool {
        get {
            return Double(self) != nil
        }
    }
}

class AlamofireManager{
    class var manager:Alamofire.SessionManager {
        let customManager = Alamofire.SessionManager.default
        customManager.session.configuration.timeoutIntervalForRequest = TimeInterval(Request_Timeout)
        
        //Bypass SSL Cert error
        //remove this in production for security risk
        //start
        customManager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
        //end
        
        return customManager
    }
}
