//
//  ListViewModel.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import Foundation
class ListViewModel {
    
    var arrResturants = [Resturant]()
    
    func getDataFromAPI(completion :@escaping (Bool) -> ()) {
        WebService.callAPIWith(completion: { result in
            self.arrResturants = result.map({Resturant($0 as! [String : Any])})
            print(self.arrResturants)
            completion(true)
        })
    }
}
