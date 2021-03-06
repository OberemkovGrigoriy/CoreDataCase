//
//  CourseDetailTableViewController.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 03.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import UIKit
import CoreData

class CourseDetailTableViewController: UITableViewController {
    
    var course: Course?
    var managedObjectContext: NSManagedObjectContext!
    var saveCoreData: SaverWithErrorMessage?
    
    @IBOutlet weak var courseNameTextField: UITextField!
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var branchTextField: UITextField!
    @IBOutlet weak var teachersNameTextField: UITextField!
    
    @IBAction func saveCourseDetail(_ sender: Any) {
        if let course = course, let courseName = courseNameTextField.text, let branch = branchTextField.text, let subject = subjectNameTextField.text, let teacher = teachersNameTextField.text{
            course.branch = branch
            course.courseName = courseName
            course.subject = subject
            course.teachersName = teacher
            saveCoreData?.saver(label: "Sorry, can't change")
            
        } else if course == nil{
            if let courseName = courseNameTextField.text, let branch = branchTextField.text, let subject = subjectNameTextField.text, let teacher = teachersNameTextField.text, let entity = NSEntityDescription.entity(forEntityName: "Course", in: managedObjectContext), !courseName.isEmpty && !branch.isEmpty && !subject.isEmpty && !teacher.isEmpty{
                course = Course(entity: entity, insertInto: managedObjectContext)
                course?.branch = branch
                course?.courseName = courseName
                course?.subject = subject
                course?.teachersName = teacher
                saveCoreData?.saver(label: "Sorry, can't change")
                
            }
            
        }
    }
    
    @IBAction func goToJournal(_ sender: Any) {
        print("Go to journal")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveCoreData = SaverWithErrorMessage(managedObjectContext: self.managedObjectContext)
        if let course = course{
            courseNameTextField.text = course.courseName
            subjectNameTextField.text = course.subject
            branchTextField.text = course.branch
            teachersNameTextField.text = course.teachersName
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? JournalTableViewController{
            dest.managedObjectContext = managedObjectContext
            //print(courseNameTextField.text)
            dest.templateName = courseNameTextField.text
        }
    }
}

