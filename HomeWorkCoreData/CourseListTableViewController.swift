//
//  CourseListTableViewController.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 03.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import UIKit
import CoreData

protocol CoursePickerDelegate: class {
    func didSelectCourse(course: Course)
}

class CourseListTableViewController: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    var courses = [Course]()
    
    weak var pickerDelegate: CoursePickerDelegate?
    var selectedCourse: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate?.managedObjectContext
        title = "Course List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CourseListTableViewController.addCourse(sender:)))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    @objc func addCourse(sender: AnyObject?){
        performSegue(withIdentifier: "courseDetail", sender: self)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? CourseDetailTableViewController{
            dest.managedObjectContext = managedObjectContext
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                let course = courses[selectedIndexPath.row]
                dest.course = course
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath)
        let course = courses[indexPath.row]
        
        cell.detailTextLabel?.text = course.value(forKey: "teachersName") as! String
        cell.textLabel?.text = course.value(forKey: "courseName") as! String
        
        if selectedCourse == course {
            cell.accessoryType = .checkmark
        } else{
            cell.accessoryType = .none
        }

        return cell 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pickerDelegate = pickerDelegate {
            let course = courses[indexPath.row]
            selectedCourse = course
            pickerDelegate.didSelectCourse(course: course)
            
            tableView.reloadData()
        } else {
            if let coursesTableViewController = storyboard?.instantiateViewController(withIdentifier: "Students") as? ListStudentTableViewController{
                let course = courses[indexPath.row]
                
                coursesTableViewController.managedObjectContext = managedObjectContext
                coursesTableViewController.selectedCourse = course
                navigationController?.pushViewController(coursesTableViewController, animated: true)
                
            }
        }
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return pickerDelegate == nil
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let thisIsCourse = courses[indexPath.row]
            managedObjectContext.delete(thisIsCourse)
            do {
                try managedObjectContext.save()
            } catch {
                print("Sorry, can't save")
            }
            reloadData()
        }
    }
    
    func reloadData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
        if managedObjectContext == nil{
            print("Can't find managedObjectContext!")
        }
        do{
            if let result = try managedObjectContext.fetch(fetchRequest) as? [Course]{
                    courses = result
                    tableView.reloadData()
            }
        } catch{
                print("Can't get result")
        }
    }
    
}
