//
//  CategoryIncome+CoreDataProperties.swift
//  Kwasniewska_Kurowski_Projekt
//
//  Created by Patrycja Kwaśniewska on 07/06/2023.
//
//

import Foundation
import CoreData


extension CategoryIncome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryIncome> {
        return NSFetchRequest<CategoryIncome>(entityName: "CategoryIncome")
    }

    @NSManaged public var name: String?
    @NSManaged public var toIncome: NSSet?
    
    public var incomesCategoryArray: [Income] {
        let set = toIncome as? Set<Income> ?? []

        return set.sorted{
            $0.name! < $1.name!
        }
    }

}

// MARK: Generated accessors for toIncome
extension CategoryIncome {

    @objc(addToIncomeObject:)
    @NSManaged public func addToToIncome(_ value: Income)

    @objc(removeToIncomeObject:)
    @NSManaged public func removeFromToIncome(_ value: Income)

    @objc(addToIncome:)
    @NSManaged public func addToToIncome(_ values: NSSet)

    @objc(removeToIncome:)
    @NSManaged public func removeFromToIncome(_ values: NSSet)

}

extension CategoryIncome : Identifiable {

}
