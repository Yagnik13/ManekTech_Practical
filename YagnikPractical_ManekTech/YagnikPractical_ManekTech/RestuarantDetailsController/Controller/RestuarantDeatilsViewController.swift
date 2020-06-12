//
//  RestuarantDeatilsViewController.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit

class RestuarantDeatilsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var detailsTableView: UITableView!
    
    //MARK:- Properties
    var resturantDetails : Resturant?
    var images : [Img] = []
    
    private lazy var backBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBackBarButton(sender:)))
        barButton.tintColor = .black
        return barButton
    }()

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTableView()
        if let resturant = resturantDetails , let arrImages = resturant.img {
            images = arrImages
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarColor()
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateNavigationBarColor(showColor: true)
    }
    
    //MARK:- Custom methods
    func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ImageSliderCollectionViewCell.nib, forCellWithReuseIdentifier: ImageSliderCollectionViewCell.identifier)
    }
    
    func configureTableView() {
        self.detailsTableView.delegate = self
        self.detailsTableView.dataSource = self
        detailsTableView.register(DetailsTableCell.nib, forCellReuseIdentifier: DetailsTableCell.identifier)
    }
    
    func updateNavigationBarColor(showColor: Bool = false) {
        self.navigationController?.navigationBar.isTranslucent = true//showColor ? false : true
        self.navigationController?.navigationBar.shadowImage = showColor ? nil : UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(showColor ? nil : UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barTintColor = showColor ? UIColor.appColor : nil
        self.detailsTableView.contentInsetAdjustmentBehavior = showColor ? .automatic : .never
    }
    
    //MARK: - Handle Events
    @objc private func didTapBackBarButton(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK:- Data Source Delegate methods
extension RestuarantDeatilsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableCell", for: indexPath) as? DetailsTableCell ,let resturant = resturantDetails {
            cell.configureCell(resturant)
            return cell
        }
        return UITableViewCell()
    }
    
}

//MARK:- Collectionview delegate and datasource methods
extension RestuarantDeatilsViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = images.count
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < images.count , let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:String(describing: ImageSliderCollectionViewCell.self),for: indexPath) as? ImageSliderCollectionViewCell {
            if let curRow = images[indexPath.item].image {
                collectionViewCell.configureDataForCell(curRow)
            }else {
                collectionViewCell.sliderImageView.image = UIImage(named: "img")
            }
            return collectionViewCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
