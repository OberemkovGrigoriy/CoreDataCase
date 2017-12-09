//
//  ReloaderStudentData.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 07.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ReloaderStudentData{
    var tableView: UITableView?
    var managedObjectContext: NSManagedObjectContext?
    
    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext){
        self.tableView = tableView
        self.managedObjectContext = managedObjectContext
    }
    
    func reloadData() -> [Student]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        var results = [Student]()
        if managedObjectContext == nil{
            print("Error haven't managedObject Context")
        }
        
        do{
            if let notNilResults = try managedObjectContext?.fetch(fetchRequest) as? [Student]{
                results = notNilResults
            }
        } catch{
            print("Error in fetch executing")
        }
        return results
    }
    
}
