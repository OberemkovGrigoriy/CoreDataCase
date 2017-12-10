//
//  ChooseCourseTableViewController.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 10.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import UIKit
import CoreData

class ChooseCourseTableViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext?
    weak var pickerDelegate: CoursePickerDelegate?
    var selectedCourse: Course?
    var courses = [Course]()
    var saveCoreData: SaverWithErrorMessage?
    var updateCurses: ReloaderCourseData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = appDelegate?.managedObjectContext
        title = "Course List"
        updateCurses = ReloaderCourseData(managedObjectContext: self.managedObjectContext!, tableView: self.tableView)
        saveCoreData = SaverWithErrorMessage(managedObjectContext: self.managedObjectContext!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        courses = (updateCurses?.reloadData())!
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
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath)
        let course = courses[indexPath.row]
        
        cell.detailTextLabel?.text = course.value(forKey: "teachersName") as? String
        cell.textLabel?.text = course.value(forKey: "courseName") as? String
        
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
            print("pickerDelegate not initial")
        }
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}
