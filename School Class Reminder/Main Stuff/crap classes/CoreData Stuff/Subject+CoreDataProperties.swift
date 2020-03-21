//
//  Subject+CoreDataProperties.swift
//  
//
//  Created by Viktor Kuzmanov on 12/13/17.
//
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }

    @NSManaged public var dayName: String
    @NSManaged public var subjectName: String
    @NSManaged public var startsAt: String

}
