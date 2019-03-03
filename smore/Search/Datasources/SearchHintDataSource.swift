//
//  SearchHintDataSource.swift
//  smore
//
//  Created by Jing Wei Li on 3/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

/// Note that this class is separate from `SearchDataSource`.
class SearchHintDataSource: NSObject, UITableViewDataSource {
    var searchHints: [String]
    
    override init() {
        searchHints = []
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.identifier,
                                                 for: indexPath)
        
        if let cell = cell as? GenericTableViewCell {
            cell.textLabel?.text = searchHints[indexPath.row]
        }
        
        return cell
    }
}
