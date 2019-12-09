//
//  ViewController.swift
//  Todoey
//
//  Created by Jayesh Patel on 10/13/19.
//  Copyright © 2019 nairit. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController  {
    
    var itemArray : Results<Item>?
    let realm = try! Realm()
    var convertedArray: [Date] = []
   
    var dateFormatter = DateFormatter()
    
    
    var selectedCategory : Category?
    {
    
        didSet{
            
            loadData()
            
        }
        
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadData()
       
     }
    
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray?.count ?? 1
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            
            cell.textLabel?.text = item.Title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No items added"
            
        }
         return cell
       
    }
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = itemArray?[indexPath.row] {
        
        do {
            
            try realm.write {
                item.done = !item.done
            }
        }
            
            catch {
                
                print("Error doing done status \(error)")
                
            }
            
        }
    
    tableView.reloadData()
        
    }
    
    @IBAction func addItemButton(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if self.selectedCategory != nil {
                
                do {
                
                    try self.realm.write {
                    
                      let allItem = Item()
                    
                    allItem.Title = textField.text!
                    
                    allItem.done = false
                        
                    allItem.dateCreated = Date()
                        
                        self.selectedCategory?.items.append(allItem)
                      
                }
                } catch {
                    
                    print("Error, \(error)")
                    
                }
          
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add a new task"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
   
    
    func loadData () {
        
     itemArray = selectedCategory?.items.sorted(byKeyPath: "Title", ascending: true)
        
        tableView.reloadData()
        
    }
    
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("Title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadData()
            
              tableView.reloadData()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
            
        } 
        
    }
    
}
