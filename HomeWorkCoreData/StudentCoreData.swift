//
//  StudentCoreData.swift
//  HomeWorkCoreData
//
//  Created by Gregory Oberemkov on 04.12.17.
//  Copyright © 2017 Gregory Oberemkov. All rights reserved.
//

import Foundation
import CoreData

class Student: NSManagedObject{
    @NSManaged var name: String
    @NSManaged var surname: String
    @NSManaged var email: String
    @NSManaged var writtenDownForCourse: Course?
}
