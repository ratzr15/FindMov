//----------------------------------------------------------------------------------
//  File Name         :  ViewController.swift
//  Description       :  Controller for Movie Search
//                       1. Manages -> View for list /Search Bar/ Recent items
//  Author            :  Rathish Kannan
//  E-mail            :  rathishnk@hotmail.co.in
//  Dated             :  23rd Sep 2018
//  Copyright (c) 2018 Rathish Kannan. All rights reserved.
//-----------------------------------------------------------------------------------

import UIKit

class ViewController: UIViewController {
    var searchBar: UISearchBar {
        guard let sBar = navigationItem.titleView as? UISearchBar else {
            assertionFailure("NavigationController not embedded!")
            return UISearchBar()
        }
        sBar.backgroundColor           = .black
        sBar.placeholder               = "SEARCH"
        sBar.delegate                  = self
        sBar.tintColor                 = .orange
        sBar.textField.textAlignment   = .natural
        sBar.textField.clearButtonMode = .always
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [type(of: sBar)]).tintColor = .black
        return sBar
    }

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let viewModel = MovieViewModel()

    let manager = SearchManager()
    
    var param = SearchQuery(query: "", page: "", id: "", count: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = searchBar
        tableView?.dataSource = viewModel
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.register(NamePictureCell.nib, forCellReuseIdentifier: NamePictureCell.identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ViewController: UISearchBarDelegate {
    /// Requirement(4)
    ///
    /// - Parameter searchBar: UISearchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.cancelButton?.setTitle("CANCEL", for: .normal)
        
        self.viewModel.setUpRecentItems {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    /// Search with Query from User
    ///
    /// - Parameter searchBar: UISearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        manager.searchMovies(query: searchBar.text ?? "", page: ""){  (results) in
            DispatchQueue.main.async {
                self.param = SearchQuery(query: searchBar.text ?? "", page: String(results?.page ?? 1), id: searchBar.text ?? "", count: String(results?.total_pages ?? 1))
                self.viewModel.setUpData(results: results?.results ?? [], forQuery: searchBar.text ?? "")
                self.tableView.reloadData()
            }
        }
    }
    
    /// When user cancels the current search
    ///
    /// - Parameter searchBar: UISearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = nil
        
        self.viewModel.filterMovies {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    /// Selection Support
    ///
    /// - Requirement(5):
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        let item = viewModel.items[indexPath.section]
        if item.type == .recentItems{
            manager.searchMovies(query: item.sectionTitle, page: ""){  (results) in
                self.param = SearchQuery(query: item.sectionTitle, page: String(results?.page ?? 1), id: item.sectionTitle, count: String(results?.total_pages ?? 1))
                DispatchQueue.main.async {
                    self.viewModel.setUpData(results: results?.results ?? [], forQuery: item.sectionTitle)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    /// Pagination Support
    ///
    /// - Requirement(2):
    ///   - details: UIScrollView
    ///   - decelerate: Bool
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= -0.5 && param.count > param.page {
            let increment = Int(param.page) ?? 1
            param.page = String(increment + 1)
            manager.searchMovies(query: param.query, page: String(param.page)){  (results) in
                DispatchQueue.main.async {
                    self.viewModel.setUpData(results: results?.results ?? [], forQuery: self.param.query)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
