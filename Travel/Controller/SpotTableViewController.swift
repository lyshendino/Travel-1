//
//  SpotTableViewController.swift
//  Travel
//
//  Created by NDHU_CSIE on 2020/10/22.
//  Copyright © 2020 NDHU_CSIE. All rights reserved.
//

import UIKit

class SpotTableViewController: UITableViewController, UISearchResultsUpdating {

    var spots: [Spot] = []
    
    var searchController: UISearchController!
    
    var searchResults: [Spot] = []
    
    
    // MARK: - Table view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSpots()
        if spots.isEmpty {
            Spot.generateData(sourceArray: &spots)
        }

        navigationController?.navigationBar.prefersLargeTitles = true
       
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        //not change the color of the search contents
        searchController.obscuresBackgroundDuringPresentation = false

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive {
            return searchResults.count
        } else {
            return spots.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SpotTableViewCell

        // Configure the cell...
        // Determine if we get the restaurant from search result or the original array
        let spot = (searchController.isActive) ? searchResults[indexPath.row] : spots[indexPath.row]
        
        
        cell.nameLabel.text = spot.name //optioinal chaining
        cell.locationLabel.text = spot.location
        cell.phoneLabel.text = spot.phone
        cell.thumbnailImageView.image = UIImage(named: spot.image)
        
        if spot.isVisited {
        cell.accessoryType = .checkmark
        } else {
        cell.accessoryType = .none
        }

        //cell.accessoryType = restaurantIsVisited[indexPath.row] ? .checkmark : .none
        
         
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    

 //   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        // Create an option menu as an action sheet
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
//
//        if let popoverController = optionMenu.popoverPresentationController {
//            if let cell = tableView.cellForRow(at: indexPath) {
//                popoverController.sourceView = cell
//                popoverController.sourceRect = cell.bounds
//            }
//        }
//
//        // Add Call action
//        let callActionHandler = { (action:UIAlertAction!) -> Void in
//            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the call feature is not available yet. Please retry later.", preferredStyle: .alert)
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertMessage, animated: true, completion: nil)
//        }
//
//        let callAction = UIAlertAction(title: "Call " + "123-000-\(indexPath.row)", style: .default, handler: callActionHandler)
//        optionMenu.addAction(callAction)
//
//        // Check-in action
//        let checkInAction = UIAlertAction(title: "Check in", style: .default, handler: {
//            (action:UIAlertAction!) -> Void in
//
//            let cell = tableView.cellForRow(at: indexPath)
//            cell?.accessoryType = .checkmark
//            self.restaurantIsVisited[indexPath.row] = true
//        })
//        optionMenu.addAction(checkInAction)
//
//        //add undo check-in action
//        let uncheckInAction = UIAlertAction(title: "Undo Check in", style: .default, handler: {
//            (action:UIAlertAction!) -> Void in
//
//            let cell = tableView.cellForRow(at: indexPath)
//            if self.restaurantIsVisited[indexPath.row] {  //if ckecked
//                cell?.accessoryType = .none
//                self.restaurantIsVisited[indexPath.row] = false
//            }
//        })
//        optionMenu.addAction(uncheckInAction)
//
//
//
//        // Add actions to the menu
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        optionMenu.addAction(cancelAction)
//
//        // Display the menu
//        present(optionMenu, animated: true, completion: nil)
//
//        // Deselect a row
//        tableView.deselectRow(at: indexPath, animated: false)
        
        
 //   }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // Delete the row from the data source
            self.spots.remove(at: indexPath.row)
    
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Call completion handler with true to indicate
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at " + self.spots[indexPath.row].name

            let activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        // Set the icon and background color for the actions
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        //deleteAction.image = UIImage(systemName: "trash") //iOS 13
        deleteAction.image = UIImage(named: "delete")  //iOS 12
        
        
        shareAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        //shareAction.image = UIImage(systemName: "square.and.arrow.up")
        shareAction.image = UIImage(named: "share") //iOS 12
        
        return swipeConfiguration
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
    let checkInAction = UIContextualAction(style: .normal, title: "Check-in") { (action, sourceView, completionHandler) in
                
    let cell = tableView.cellForRow(at: indexPath) as! SpotTableViewCell
        self.spots[indexPath.row].isVisited = (self.spots[indexPath.row].isVisited) ? false : true
        cell.accessoryType = self.spots[indexPath.row].isVisited ? .checkmark : .none
                
    completionHandler(true)
    }
            
       // let checkInIcon = restaurants[indexPath.row].isVisited ? "arrow.uturn.left" : "checkmark"
        let checkInIcon = spots[indexPath.row].isVisited ? "undo" : "tick"
    checkInAction.backgroundColor = UIColor(red: 38.0/255.0, green: 162.0/255.0, blue: 78.0/255.0, alpha: 1.0)
    //checkInAction.image = UIImage(systemName: checkInIcon)
    checkInAction.image = UIImage(named: checkInIcon)  //iOS 12
        
    let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
          
            
    return swipeConfiguration
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showSpotDetail" {
        if let indexPath = tableView.indexPathForSelectedRow {
            let destinationController = segue.destination as! SpotDetailViewController
            destinationController.spot = (searchController.isActive) ? searchResults[indexPath.row] : spots[indexPath.row]
        }
      }
      else if segue.identifier == "addSpot" {
        let destinationController = segue.destination as! UINavigationController
        let topView = destinationController.topViewController as! NewSpotController
        topView.addDelegate = self
        }
    }


    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Data saving to the file
      
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Spots.plist")
    }

    
    func saveSpots() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(spots)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding spot array: \(error.localizedDescription)")
        }
    }
    
    func loadSpots() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                spots = try decoder.decode([Spot].self, from: data)
            } catch {
                print("Error decoding spot array: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Search bar none core data version
    
    func filterContent(for searchText: String) {
        
        searchResults = spots.filter({ (spot) -> Bool in
            let name = spot.name
            let isMatch = name.localizedCaseInsensitiveContains(searchText)
            
            return isMatch
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }

    
    

}


extension SpotTableViewController: AddDataDelegate {
    func addSpot(item: Spot) {
        spots.append(item)
        let tableView = view as! UITableView
        tableView.insertRows(at: [IndexPath(row: spots.count-1, section: 0)], with: .automatic)
    }
}
