//
//  Expense+CoreDataProperties.swift
//  Kwasniewska_Kurowski_Projekt
//
//  Created by Patrycja Kwaśniewska on 07/06/2023.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var date: Date?
    @NSManaged public var details: String?
    @NSManaged public var toCategoryExpense: CategoryExpense?

}

extension Expense : Identifiable {

}
