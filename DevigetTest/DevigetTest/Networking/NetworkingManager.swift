//
//  NetworkingManager.swift
//  DevigetTest
//
//  Created by Pablo Javier Bertola on 18/08/2019.
//  Copyright © 2019 Pablo Javier Bertola. All rights reserved.
//

import Foundation

typealias SuccessHandler = ((_ json: [String: Any]?) -> Void)
typealias ErrorHandler = ((_ error: Error?) -> Void)

class NetworkingManager {
    
    
    static let shared = NetworkingManager()
    
    /**
     Private initialization to ensure just one instance is created.
     */
    fileprivate init() { }

        
    func getTopReddit(limit: Int?,
                      before: String?,
                      after: String?,
                      successHandler: @escaping SuccessHandler,
                      errorHandler: @escaping ErrorHandler){
        
        var urlStr = "https://www.reddit.com/top.json"
        var params = "?"
        if let lim = limit {
            params += "limit=\(lim)&"
        }
        if let bef = before {
            params += "before=\(bef)&"
        }
        if let aft = after {
            params += "after=\(aft)"
        }
        urlStr += params
        guard let myUrl = URL(string: urlStr) else {
            errorHandler(nil)
            return
        }
        var request = URLRequest(url: myUrl);
        request.httpMethod = "GET";
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    DispatchQueue.main.async {
                        errorHandler(error)
                    }
                    return
                }
            
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]

                    print("success")
                    successHandler(json)

            } catch {
                DispatchQueue.main.async {
                    print(error)
                    errorHandler(error)
                }
            }
        }
        task.resume()
        
    }
    
}
