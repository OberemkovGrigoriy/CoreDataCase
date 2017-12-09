//
//  ReloaderJournalData.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 07.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//


import Foundation
import CoreData
import UIKit

class ReloaderJournalData{
    var tableView: UITableView?
    var managedObjectContext: NSManagedObjectContext?
    var template: String?
    var model: NSManagedObjectModel?
    
    init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, template: String, model: NSManagedObjectModel){
        self.tableView = tableView
        self.managedObjectContext = managedObjectContext
        self.template = template
        self.model = model
    }
    
    func reloadData()->[Student]{
        guard let fetchRequest = model?.fetchRequestFromTemplate(withName: "Journal", substitutionVariables: ["courseName" : template!]) as? NSFetchRequest<Student> else {
            assert(false, "No template")
        }
        var result = [Student]()
        do{
            let noNilResult = try self.managedObjectContext?.fetch(fetchRequest)
            result = noNilResult!
        } catch{
            print("can't fetch")
        }
        
        return result
    }
}
