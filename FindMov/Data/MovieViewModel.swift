//----------------------------------------------------------------------------------
//  File Name         :  MovieViewModel
//  Description       :  Datasource for ViewController
//                       1. Manages -> Data to display
//  Architecture      :  Uncle Bob's Clean Architecture {MVVM}
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  23rd Sep 2018
//  Copyright (c) 2018 Rathish Kannan. All rights reserved.
//-----------------------------------------------------------------------------------

import Foundation
import UIKit

enum ProfileViewModelItemType {
    case movieDetails
}

protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class MovieViewModel: NSObject {
    var items = [ProfileViewModelItem]()
    
    var results : [Results] = [] {
        didSet {
            //Equate if needed±
        }
    }

    override init() {
        super.init()
        if results.count > 0{
            items.removeAll()
            for result in results {
                if let name = result.title, let overView = result.overview, let date = result.release_date {
                    let pictureUrl = "http://image.tmdb.org/t/p/w92\(result.poster_path ?? "")"
                    let nameAndPictureItem = ProfileViewModelNamePictureItem(name: name, pictureUrl: pictureUrl, overView: overView, date: date)
                    items.append(nameAndPictureItem)
                }
            }
        }else{
            return
        }
    }
    
    func setUpData(results: [Results?]){
        items.removeAll()
        for result in results {
            if let name = result?.title, let overView = result?.overview, let date = result?.release_date  {
                let pictureUrl = "http://image.tmdb.org/t/p/w92\(result?.poster_path ?? "")"
                let nameAndPictureItem = ProfileViewModelNamePictureItem(name: name, pictureUrl: pictureUrl, overView: overView, date: date)
                items.append(nameAndPictureItem)
            }
        }
    }
    
}

extension MovieViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .movieDetails:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {
                cell.item = item
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}


class ProfileViewModelNamePictureItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .movieDetails
    }
    
    var sectionTitle: String {
        return self.date
    }
    
    var rowCount: Int {
        return 1
    }
    
    var name: String
    var pictureUrl: String
    var overView: String
    var date: String

    init(name: String, pictureUrl: String, overView: String, date: String) {
        self.name = name
        self.pictureUrl = pictureUrl
        self.overView = overView
        self.date = date
    }
}


