//
//  SearchViewController.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var histoyTableView: SearchHistoryTableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewBottomLine: UIImageView!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleViewTopMargin: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        histoyTableView.setData(strArr: [], initial: false)
        histoyTableView.setData(searchText: "12", strArr: ["34","12","123","124","5678","1234"])
        
        setupUI()
    }
 
    func setupUI() {
        searchBar.setValue("취소", forKey:"cancelButtonText")
        searchBar.delegate = self
        
        histoyTableView.searchHistoryTableViewDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension SearchViewController: SearchHistoryTableViewDelegate {
    func select(index: Int) {
        print("index = ", index)
        
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }
    @IBAction func xButtonClick(_ sender: Any) {
        searchTextField.text = ""
    }
}

extension SearchViewController: UITextFieldDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        keyboardUp()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyboardDown()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        keyboardDown()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        keyboardUp()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardDown()
    }
     
    func keyboardUp() {
        titleViewTopMargin.constant = -titleView.frame.height
        searchBar.showsCancelButton = true
        
        UIView.animate(withDuration: 0.2) {
            self.titleView.isHidden = true
            self.topViewBottomLine.isHidden = false
            if #available(iOS 13.0, *) {
                self.topView.backgroundColor = .systemGray6
            } else {
                // Fallback on earlier versions
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardDown() {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        titleViewTopMargin.constant = 0
        searchBar.showsCancelButton = false
        
        UIView.animate(withDuration: 0.2) {
            self.titleView.isHidden = false
            self.topViewBottomLine.isHidden = true
            self.topView.backgroundColor = .white
            self.view.layoutIfNeeded()
        }
    }
     
}

