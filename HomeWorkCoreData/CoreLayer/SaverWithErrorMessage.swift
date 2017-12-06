//
//  SaverWithErrorMessage.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 06.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData

class SaverWithErrorMessage{
    let managedObjectContext: NSManagedObjectContext?
    
    init(managedObjectContext: NSManagedObjectContext){
        self.managedObjectContext = managedObjectContext
    }
    
    func saver(label: String){
        do{
            if managedObjectContext != nil {
                try managedObjectContext!.save()
            }
        } catch {
        print(label)
        }
    }
}
