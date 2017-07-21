//
//  SearchTermTableViewController.swift
//  Smashtag
//
//  Created by 劉洧熏 on 2017/7/20.
//  Copyright © 2017年 劉洧熏. All rights reserved.
//

import UIKit
import CoreData

class SearchTermTableViewController: FetchedResultsTableViewController {
    private var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    fileprivate var fetchedResultsController: NSFetchedResultsController<SearchTerm>? {
        didSet { fetchedResultsController?.delegate = self }
    }

    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<SearchTerm> = SearchTerm.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "searchTime", ascending: false)]

            fetchedResultsController = NSFetchedResultsController<SearchTerm>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchText Cell", for: indexPath)

        if let searchText = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = searchText.searchTexts
            if let created = searchText.searchTime {
                let formatter = DateFormatter()
                if Date().timeIntervalSince(created as Date) > 24*60*60 {
                    formatter.dateStyle = .short
                } else {
                    formatter.timeStyle = .short
                }
                cell.detailTextLabel?.text = formatter.string(from: created as Date)
            } else {
                cell.detailTextLabel?.text = nil
            }
        }

        return cell
    }

    //MARK: UITableViewDateSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
}

