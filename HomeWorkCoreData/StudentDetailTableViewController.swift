//
//  StudentDetailTableViewController.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 01.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import UIKit
import CoreData


class StudentDetailTableViewController: UITableViewController {

    var student: Student?
    var managedObjectContext: NSManagedObjectContext!
    var saveCoreData: SaverWithErrorMessage?
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveCoreData = SaverWithErrorMessage(managedObjectContext: self.managedObjectContext)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let student = student {
            nameTextField.text = student.name
            surnameTextField.text = student.surname
            emailTextField.text = student.email
            courseTextField.text = student.courseName
            if let ownCourse = student.writtenDownForCourse{
                courseTextField.text = ownCourse.courseName
            } else{
                courseTextField.text = "ЗАПИШИТЕ СТУДЕНТА НА КУРС!"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let student = student, let name = nameTextField.text, let surname = surnameTextField.text, let email = emailTextField.text, let course = courseTextField.text{
            student.name = name
            student.email = email
            student.surname = surname
            student.courseName = course
            saveCoreData?.saver(label: "Sorry, can't change")
        }else  if student == nil{
            if let name = nameTextField.text, let surname = surnameTextField.text, let email = emailTextField.text, let course = courseTextField.text, let entity = NSEntityDescription.entity(forEntityName: "Student", in: managedObjectContext), !name.isEmpty && !surname.isEmpty && !email.isEmpty  {
                student = Student(entity: entity, insertInto: managedObjectContext)
                student?.name = name
                student?.surname = surname
                student?.email = email
                student?.courseName = course
            }
            saveCoreData?.saver(label: "Sorry, can't change")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0{
            if let studentPicker = storyboard?.instantiateViewController(withIdentifier: "Courses") as? CourseListTableViewController{
                studentPicker.managedObjectContext = managedObjectContext
                
                studentPicker.pickerDelegate = self
                studentPicker.selectedCourse = student?.writtenDownForCourse
                
                navigationController?.pushViewController(studentPicker, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}

extension StudentDetailTableViewController: CoursePickerDelegate{
    func didSelectCourse(course: Course) {
        student?.writtenDownForCourse = course
        
        do{
            try managedObjectContext.save()
        } catch {
            print("ErrorErrorError")
        }
    }
}

