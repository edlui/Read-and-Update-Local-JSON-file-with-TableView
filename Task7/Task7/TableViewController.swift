//
//  TableViewController.swift
//  Task7
//
//  Created by Eddie Lui on 14/5/19.
//  Copyright © 2019 Eddie Lui. All rights reserved.
//

import UIKit

var athleteList: [Person] = []
var currentIndex = 0
var fm = FileManager.default
var fresult: Bool = false
var subUrl: URL?
var mainUrl: URL? = Bundle.main.url(forResource: "Athletes", withExtension: "json")

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        // Uncomment below 3 lines and use it for response time calculation
        // Use it to visualize the response time for specfic method
//        let start:TimeInterval = NSDate.timeIntervalSinceReferenceDate
//        let timeResponse:TimeInterval = NSDate.timeIntervalSinceReferenceDate - start
//        print("Start up time: \(timeResponse) \n")
        
        super.viewDidLoad()
        self.title = "Athletes"
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }

    func getData() {
        do {
            let documentDirectory = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            subUrl = documentDirectory.appendingPathComponent("Athletes.json")
            loadFile(mainPath: mainUrl!, subPath: subUrl!)
        } catch {
            print(error)
        }
    }
    
    func loadFile(mainPath: URL, subPath: URL){
        if fm.fileExists(atPath: subPath.path){
            decodeData(pathName: subPath)
            
            if athleteList.isEmpty{
                decodeData(pathName: mainPath)
            }
            
        }else{
            decodeData(pathName: mainPath)
        }
        
        self.tableView.reloadData()
    }
    
    func decodeData(pathName: URL){
        do{
            let jsonData = try Data(contentsOf: pathName)
            let decoder = JSONDecoder()
            athleteList = try decoder.decode([Person].self, from: jsonData)
        } catch {}
    }
    
    func alertMessages (){
        let alert = UIAlertController(title: "Reminder:", message: "No Data has been changed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return athleteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        athleteList.sort{$0.firstname < $1.firstname}
        
        cell.textLabel?.text = athleteList[indexPath.row].firstname + " " + athleteList[indexPath.row].lastname
        
        cell.textLabel?.textColor = UIColor.white
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "details", sender: self)
    }
}
