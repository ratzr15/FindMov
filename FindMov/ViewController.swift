//
//  ViewController.swift
//  FindMov
//
//  Created by Rathish Kannan on 9/20/18.
//  Copyright © 2018 Rathish Kannan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var searchBar: UISearchBar {
        guard let sBar =  navigationItem.titleView as? UISearchBar else {
            assertionFailure("UINavigationController not embedded!")
            return UISearchBar()
        }
        sBar.backgroundColor           = .black
        sBar.placeholder               = "SEARCH"
        sBar.delegate                  = self
        sBar.tintColor                 = .white
        UITextField.appearance(whenContainedInInstancesOf: [type(of: sBar)]).tintColor = .black
        sBar.textField.textAlignment   = .natural
        sBar.textField.clearButtonMode = .always
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        return sBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.cancelButton?.setTitle("CANCEL", for: .normal)

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = nil

    }
}

