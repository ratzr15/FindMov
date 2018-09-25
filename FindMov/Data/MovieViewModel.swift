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

enum ListViewModelItemType {
    case movieDetails
    case recentItems
    case noResult
}

protocol ListViewModelItem {
    var type: ListViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class MovieViewModel: NSObject {
    var items = [ListViewModelItem]()
    var kImageDomain = "http://image.tmdb.org/t/p/w92"
    let manager = SearchManager()

    override init() {
        super.init()        
    }
    
    /// Requirement (1 & 3)
    ///
    /// - Parameters:
    ///   - results: Results - title, overview, Poster, date
    ///   - query: searched term
    func setUpData(results: [Results?], forQuery query: String){
        items = items.filter { $0.type == .movieDetails }
        if results.count > 0 {
            for result in results {
                if let name = result?.title, let overView = result?.overview, let date = result?.release_date  {
                    let pictureUrl = "http://image.tmdb.org/t/p/w92\(result?.poster_path ?? "")"
                    let nameAndPictureItem = MovieDetailsItem(name: name, pictureUrl: pictureUrl, overView: overView, date: date)
                    items.append(nameAndPictureItem)
                }
            }

            //Pass the recents
            manager.saveRecentSearch(searchString: query)
        }else{
            //Handle no results
            let noResult = NoResultsItem(name:"No Results found for \"\(query)\"")
            items.append(noResult)
            print("❌")
        }
    }
    
    func setUpRecentItems(completion:@escaping () -> ()) -> (){
        items = items.filter { $0.type == .recentItems }
        let recents = manager.retriveRecentSearch() as! [String]
        for recent in recents {
            let nameAndPictureItem = RecentItem(name:recent)
            items.append(nameAndPictureItem)
        }
        completion()
    }
    
    func filterMovies(completion:@escaping () -> ()) -> (){
         items = items.filter { $0.type == .movieDetails }
         completion()
    }
    
}


//MARK: - UITableViewDataSource
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
        case .recentItems:
            let cell: UITableViewCell = {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
                    return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "UITableViewCell")
                }
                return cell
            }()
            cell.selectionStyle = .none
            cell.textLabel?.text = item.sectionTitle
            return cell
        case .noResult:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].type == .recentItems ? "" : items[section].sectionTitle
    }
}

//MARK: - VM
class MovieDetailsItem: ListViewModelItem {
    var type: ListViewModelItemType {
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


class NoResultsItem: ListViewModelItem {
    var type: ListViewModelItemType {
        return .noResult
    }
    
    var sectionTitle: String {
        return self.name
    }
    
    var rowCount: Int {
        return 0
    }
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class RecentItem: ListViewModelItem {
    var type: ListViewModelItemType {
        return .recentItems
    }
    
    var sectionTitle: String {
        return self.name
    }
    
    var rowCount: Int {
        return 1
    }
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
