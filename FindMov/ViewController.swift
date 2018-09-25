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
            assertionFailure("UINavigationController not embedded!")
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
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.cancelButton?.setTitle("CANCEL", for: .normal)
        
        self.viewModel.setUpRecentItems {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        let manager = SearchManager()
        manager.searchMovies(query: searchBar.text ?? "", page: ""){  (results) in
            DispatchQueue.main.async {
                self.viewModel.setUpData(results: results, forQuery: searchBar.text ?? "")
                self.tableView.reloadData()
            }
        }
    }
    
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

