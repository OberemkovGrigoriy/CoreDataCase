//
//  ListStudentTableViewController.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 30.11.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import UIKit
import CoreData

protocol StudentPickerDelegate: class {
    func didSelectStudent(student: Student)
}

class ListStudentTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    var studients = [Student]()
    
    //for select student
    weak var pickerDelegate: StudentPickerDelegate?
    var selectedCourse: Course?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        title = "Student List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ListStudentTableViewController.addStudent(sender:)))
        managedObjectContext = appDelegate.managedObjectContext
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studients.count
    }

    @objc func addStudent(sender: AnyObject?){
        performSegue(withIdentifier: "studentDetail", sender: self)
    }
    
    func reloadData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")

        if managedObjectContext == nil{
            print("fatalerror")
        }
        do{
            if let results = try managedObjectContext.fetch(fetchRequest) as? [Student]{
                studients = results
                tableView.reloadData()
            }
        } catch {
            fatalError("There was an error fetching the list of device")
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return pickerDelegate == nil
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let thisIsStudent = studients[indexPath.row]
            managedObjectContext.delete(thisIsStudent)
            do {
                try managedObjectContext.save()
            } catch {
                print("Sorry, can't save")
            }
            reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let student = studients[indexPath.row]
        

        cell.textLabel?.text = student.value(forKey: "surname") as! String
        cell.detailTextLabel?.text = student.value(forKey: "name") as! String

        
        if let name = student.value(forKey: "name") as? String, let surname = student.value(forKey: "surname") as? String, let email = student.value(forKey: "email") as? String?{
            cell.textLabel?.text = surname
            cell.detailTextLabel?.text = name
        }
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? StudentDetailTableViewController{
            dest.managedObjectContext = managedObjectContext
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                let student = studients[selectedIndexPath.row]
                dest.student = student 
            }
        }
    }
}
