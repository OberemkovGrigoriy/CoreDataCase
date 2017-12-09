//
//  ReloaderCourseData.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 07.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ReloaderCourseData{
    var managedObjectContext: NSManagedObjectContext?
    var tableView: UITableView?
    
    init(managedObjectContext: NSManagedObjectContext, tableView: UITableView){
        self.managedObjectContext = managedObjectContext
        self.tableView = tableView
    }
    
    func reloadData()->[Course]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Course")
        var results = [Course]()
        if managedObjectContext == nil{
            print("Can't find managedObjectContext!")
        }
        do {
            if let fetchResults = try self.managedObjectContext?.fetch(fetchRequest) as? [Course]{
                results = fetchResults
            }
        } catch{
            print("Can't fatch request ")
        }
        
        return results
    }
}
