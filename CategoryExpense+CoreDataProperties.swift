//
//  CategoryExpense+CoreDataProperties.swift
//  Kwasniewska_Kurowski_Projekt
//
//  Created by Patrycja Kwaśniewska on 07/06/2023.
//
//

import Foundation
import CoreData


extension CategoryExpense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryExpense> {
        return NSFetchRequest<CategoryExpense>(entityName: "CategoryExpense")
    }

    @NSManaged public var name: String?
    @NSManaged public var toExpense: NSSet?
    
    public var expensesCategoryArray: [Expense] {
        let set = toExpense as? Set<Expense> ?? []

        return set.sorted{
            $0.name! < $1.name!
        }
    }

}

// MARK: Generated accessors for toExpense
extension CategoryExpense {

    @objc(addToExpenseObject:)
    @NSManaged public func addToToExpense(_ value: Expense)

    @objc(removeToExpenseObject:)
    @NSManaged public func removeFromToExpense(_ value: Expense)

    @objc(addToExpense:)
    @NSManaged public func addToToExpense(_ values: NSSet)

    @objc(removeToExpense:)
    @NSManaged public func removeFromToExpense(_ values: NSSet)

}

extension CategoryExpense : Identifiable {

}
