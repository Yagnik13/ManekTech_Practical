//
//  HomeController.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var listTableView: UITableView!
    
    //MARK:- Properties
    let viewModel = ListViewModel()
    var isDataSaved = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureAndregisterCell()
        
        if let isDataSaved = UserDefaults.standard.value(forKey: "isDataSaved") as? Bool , isDataSaved {
            if self.viewModel.arrResturants.count > 0 {
                self.viewModel.arrResturants.removeAll()
            }
            Constants.showProgressWithoutBackg(withMessage: "")
            self.fetchDetailFromCoreData()
            Constants.hideProgressIndicator()
        }else {
            //Handle API CALL response
            Constants.showProgressWithoutBackg(withMessage: "")
            viewModel.getDataFromAPI { (isFatched) in
                Constants.hideProgressIndicator()
                if isFatched {
                    DispatchQueue.main.async {
                        self.listTableView.reloadData()
                    }
                    if self.viewModel.arrResturants.count > 0 {
                        for (_,singleItem) in self.viewModel.arrResturants.enumerated() {
                            self.saveInCoreData(resturant: singleItem)
                        }
                        UserDefaults.standard.set(true, forKey: "isDataSaved")
                        UserDefaults.standard.synchronize()
                    }else {
                        UserDefaults.standard.set(false, forKey: "isDataSaved")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    
    private func configureAndregisterCell() {
        self.listTableView.tableFooterView = UIView()
        listTableView.register(ListTableCell.nib, forCellReuseIdentifier: ListTableCell.identifier)
    }
    
    private func pushToDetailsController(resturant : Resturant) {
        let vc = RestuarantDeatilsViewController.instantiateFromStoryboard()
        vc.resturantDetails = resturant
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- Data Source Delegate methods
extension HomeController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrResturants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as? ListTableCell {
            let curRow = viewModel.arrResturants[indexPath.row]
            cell.configureCell(curRow)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curRow = viewModel.arrResturants[indexPath.row]
        pushToDetailsController(resturant: curRow)
    }
    
}

//MARK:- Core Data Save Method
extension HomeController {
    
    func fetchDetailFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CdResturant")
        do {
            let restaurants = try managedContext.fetch(fetchRequest)
            
            if restaurants.count < 0 {
                return
            }
            
            for obj in restaurants {
                let id = obj.value(forKey: "id") as? Int
                let title = obj.value(forKey: "title") as? String
                let phone_no = obj.value(forKey: "phone_no") as? Int
                let description = obj.value(forKey: "desc") as? String
                let rating = obj.value(forKey: "rating") as? Int
                let address = obj.value(forKey: "address") as? String
                let city = obj.value(forKey: "city") as? String
                let state = obj.value(forKey: "state") as? String
                let country = obj.value(forKey: "country") as? String
                let pincode = obj.value(forKey: "pincode") as? Int
                let long = obj.value(forKey: "long") as? String
                let lat = obj.value(forKey: "lat") as? String
//                let created_at = obj.value(forKey: "created_at") as? String
//                let updated_at = obj.value(forKey: "updated_at") as? String
                
                let objRestautant = [
                    "id" : id as Any  ,
                    "title" : title as Any ,
                    "phone_no" : phone_no as Any ,
                    "description" : description as Any ,
                    "rating" : rating as Any ,
                    "address" : address as Any ,
                    "city" : city as Any ,
                    "state" : state as Any ,
                    "country" : country as Any ,
                    "pincode" : pincode as Any ,
                    "long" : long as Any ,
                    "lat" : lat as Any
                    //                "created_at" : created_at as Any ,
                    //                "updated_at" : updated_at
                    ] as [String : Any]
                
                let tempObj = Resturant(objRestautant)
                self.viewModel.arrResturants.append(tempObj)
            }
            print(restaurants)
            self.listTableView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveInCoreData(resturant : Resturant) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CdResturant", in: managedContext)!
        
        let objResturant = NSManagedObject(entity: entity,insertInto: managedContext)
        objResturant.setValue(resturant.id, forKey: "id")
        objResturant.setValue(resturant.title, forKey: "title")
        objResturant.setValue(resturant.phone_no, forKey: "phone_no")
        objResturant.setValue(resturant.description, forKey: "desc")
        objResturant.setValue(resturant.rating, forKey: "rating")
        objResturant.setValue(resturant.address, forKey: "address")
        objResturant.setValue(resturant.city, forKey: "city")
        objResturant.setValue(resturant.state, forKey: "state")
        objResturant.setValue(resturant.country, forKey: "country")
        objResturant.setValue(resturant.pincode, forKey: "pincode")
        objResturant.setValue(resturant.long, forKey: "long")
        objResturant.setValue(resturant.lat, forKey: "lat")
//        objResturant.setValue(resturant.created_at, forKey: "created_at")
//        objResturant.setValue(resturant.updated_at, forKey: "updated_at")
        
//        if let images = resturant.img , images > 0{
//            for i in 0..<images.count {
//
//            }
//        }
        
        do {
            try context.save()
            print("saved successfully")
        } catch {
            print("Failed saving")
        }
    }
    
}
