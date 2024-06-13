//
//  DBManager.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/12.
//

import Foundation
import CoreData

class DBManager {
    let persistenceController = PersistenceController.shared
    var container: NSPersistentContainer!
    
    init() {
        container = persistenceController.container
    }
    
    func insertRecord(record: Record) {
        let context = container.viewContext
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) as! Record
        newRecord.score = record.score
        newRecord.date = record.date
        newRecord.songId = record.songId
        if context.hasChanges {
            do {
                try context.save()
                print("Save success")
            } catch {
                print("\(error)")
            }
        }
    }
    
    func selectRecords(songId: Int) -> [Record] {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Record>(entityName: "Record")
        fetchRequest.predicate = NSPredicate(format: "songId = %d", songId)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        do {
            let records = try context.fetch(fetchRequest)
            return records
        } catch {
            print("\(error)")
            return []
        }
    }
}
