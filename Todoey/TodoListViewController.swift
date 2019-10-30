//
//  ViewController.swift
//  Todoey
//
//  Created by Jayesh Patel on 10/13/19.
//  Copyright © 2019 nairit. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [""]
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        if let item = defaults.array(forKey: "TodoArray") as? [String] {
            
            itemArray = item
            
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
       
    }
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    print(itemArray[indexPath.row])
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    
    }else {
        
       tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
        
    tableView.deselectRow(at: indexPath, animated: true)
    
    }

    @IBAction func addItemButton(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoArray")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add a new task"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
