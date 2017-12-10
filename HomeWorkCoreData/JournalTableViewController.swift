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
    weak var pickerDelegate: StudentPickerDelegate?
    var saveCoreData: SaverWithErrorMessage?
    var model: NSManagedObjectModel?
    var updateDate: ReloaderJournalData?
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        model = (managedObjectContext.persistentStoreCoordinator?.managedObjectModel)!
        saveCoreData = SaverWithErrorMessage(managedObjectContext: self.managedObjectContext)
        updateDate = ReloaderJournalData(tableView: self.tableView, managedObjectContext: self.managedObjectContext, template: self.templateName!, model: self.model!)
        print(updateDate?.managedObjectContext)
        print(updateDate?.template)
        print(updateDate?.model)
        students = (updateDate?.reloadData())!

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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return pickerDelegate == nil
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let thisIsStudent = students[indexPath.row]
            thisIsStudent.courseName = ""
            thisIsStudent.writtenDownForCourse = nil
            saveCoreData?.saver(label: "sorry can't save")
            students = (updateDate?.reloadData())!
            print(thisIsStudent)
            tableView.reloadData()
        }
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
