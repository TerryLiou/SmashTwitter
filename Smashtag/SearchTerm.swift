//
//  SearchTerm.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/20.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit
import CoreData

class SearchTerm: NSManagedObject {
    class func updateSearchTexts(with searchText: String?, in context: NSManagedObjectContext) throws {
        guard let text = searchText else { return }
        let request: NSFetchRequest<SearchTerm> = SearchTerm.fetchRequest()
        request.predicate = NSPredicate(format: "searchTexts = %@", text)

        do {
            let searchTerm = try context.fetch(request)
            if searchTerm.count > 0 {
                context.delete(searchTerm[0])
            }
        } catch {
            throw error
        }

        let searchTerm = SearchTerm(context: context)
        searchTerm.searchTexts = text
        searchTerm.searchTime = Date() as NSDate
    }
}
