//
//  JournalTableViewController.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 04.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import UIKit
import CoreData

class JournalTableViewController: UITableViewController {

    var students = [Student]()
    var managedObjectContext: NSManagedObjectContext!
    var templateName: String?
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let model = managedObjectContext.persistentStoreCoordinator?.managedObjectModel
        
        guard let fetchRequest = model?.fetchRequestFromTemplate(withName: "Journal", substitutionVariables: ["courseName" : templateName!]) as? NSFetchRequest<Student> else {
            assert(false, "No template!")
        }
        print(fetchRequest)
        
        do{
            print("start executing")
            let result = try self.managedObjectContext.fetch(fetchRequest)
            students = result
            print(students.count)
            
        } catch {
            print("Error")
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FetchCell", for: indexPath)
        let fetchStudent = students[indexPath.row]
        
        if let surname = fetchStudent.value(forKey: "surname") as? String {
            cell.textLabel?.text = surname
        }
    
        return cell
    }
}
