//
//  TableViewController.swift
//  Favorite Places
//
//  Created by Kartik on 2/1/17.
//  Copyright © 2017 Kartik. All rights reserved.
//

import UIKit

var allLocations = [Dictionary<String, String>()]//a dictionary to store the places
var currentRow = -1

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Default entry in the list
        allLocations.append(["name": "Apple Campus", "lat": "37.3320", "long":"-122.0295"])
        
        //Storing the list elements
        if UserDefaults.standard.object(forKey: "allLocations") != nil{
            allLocations = UserDefaults.standard.object(forKey: "allLocations") as! [Dictionary<String, String>]
        }else{
            allLocations.remove(at: 0)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            //if the list element is deleted, remove from the dictionary
            allLocations.remove(at: indexPath.row)
            
            //storing the element of the list
            UserDefaults.standard.set(allLocations, forKey: "allLocations")
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let location = allLocations[indexPath.row]
        cell.textLabel?.text = location["name"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        currentRow = indexPath.row
        return indexPath
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
