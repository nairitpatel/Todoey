//
//  ViewController.swift
//  Todoey
//
//  Created by Jayesh Patel on 10/13/19.
//  Copyright © 2019 nairit. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [items]()
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        let myItem = items()
        myItem.title = "Madara"
        itemArray.append(myItem)
        
        
        let myItem2 = items()
        myItem2.title = "Goku"
        itemArray.append(myItem2)
        
        
        let myItem3 = items()
        myItem3.title = "Vegeta"
        itemArray.append(myItem3)
        
        
        if let retrievingitem = defaults.array(forKey: "TodoArray") as? [items] {
            
           itemArray = retrievingitem
            
        }
    }
    
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray [indexPath.row].done == true {
            
            cell.accessoryType = .checkmark
            
        }   else  {
                
                cell.accessoryType = .none
            }
         return cell
       
    }
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    print(itemArray[indexPath.row])
    
    
    if itemArray[indexPath.row].done == false {
        
        itemArray[indexPath.row].done = true
        
    }else {
        
        itemArray[indexPath.row].done = false
    }
    
  //  if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        
  //      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    
  //  }else {
  
  //     tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
  //  }
    
    tableView.reloadData()
        
   tableView.deselectRow(at: indexPath, animated: true)
    
   
    
    }

    @IBAction func addItemButton(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let allItem = items()
            
            allItem.title = textField.text!
            
            self.itemArray.append(allItem)
            
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
