//
//  Income+CoreDataProperties.swift
//  Kwasniewska_Kurowski_Projekt
//
//  Created by Patrycja Kwaśniewska on 07/06/2023.
//
//

import Foundation
import CoreData


extension Income {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Income> {
        return NSFetchRequest<Income>(entityName: "Income")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var details: String?
    @NSManaged public var toCategoryIncome: CategoryIncome?

}

extension Income : Identifiable {

}
