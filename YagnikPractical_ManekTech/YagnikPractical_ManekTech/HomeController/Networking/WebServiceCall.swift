//
//  WebServiceCall.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import Foundation

class WebService {
    
    static func callAPIWith(completion :@escaping ([Any]) -> ()) {
        
        let url : String = "http://192.249.121.94/~mobile/interview/public/api/restaurants_list"
        let requestUrl = URL(string: url)
        var request : URLRequest = URLRequest(url: requestUrl!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            
            if let data = data {
                
                let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let data = json as? [String:Any] {
                    if let result = data["data"] as? [Any] {
                        DispatchQueue.main.async {
                            completion(result)
                        }
                    }
                }
                
            }
            
            }.resume()
        
    }
}
