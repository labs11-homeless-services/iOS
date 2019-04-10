//
//  ServiceResultsViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class ServiceResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var subcategoriesTitleLabel: UILabel!
    
    var selectedSubcategory: String!
    
    var networkController: NetworkController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        guard let unwrappedTempCategorySelection = networkController?.tempCategorySelection
        
        //let unwrappedSubcategoryAtIndexPath = networkController?.subcategoryAtIndexPath.rawValue
        else { return }
        
        self.title = "\(unwrappedTempCategorySelection) - \(selectedSubcategory.capitalized)"
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let unwrappedSubcategoryAtIndexPath = networkController?.subcategoryAtIndexPath else { return }
        if (networkController?.subcategoryDetails.count ?? 0) < 1 {
            networkController?.fetchSubcategoryDetails(unwrappedSubcategoryAtIndexPath, completion: { (error) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController?.subcategoryDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServiceResultTableViewCell.reuseIdentifier, for: indexPath) as! ServiceResultTableViewCell
        
        let subcategoryDetail = networkController?.subcategoryDetails[indexPath.row]
        cell.serviceNameLabel.text = subcategoryDetail?.name
        cell.serviceAddressLabel.text = subcategoryDetail?.address
        cell.servicePhoneLabel.text = subcategoryDetail?.phone
        cell.serviceHoursLabel.text = subcategoryDetail?.hours
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        guard let destination = segue.destination as? ServiceDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        let serviceDetail = networkController?.subcategoryDetails[indexPath.row]
        let shelterServiceDetail = networkController?.shelterSubcategoryDetails[indexPath.row]
        
        // Pass the selected object to the new view controller.
        destination.networkController = networkController
        destination.serviceDetail = serviceDetail
        destination.shelterServiceDetail = shelterServiceDetail
        
    }
    

}
