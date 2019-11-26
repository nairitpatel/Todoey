//
//  ViewController.swift
//  Todoey
//
//  Created by Jayesh Patel on 10/13/19.
//  Copyright © 2019 nairit. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController  {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category?
    {
        
        didSet{
            
            loadData()
            
        }
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
       super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadData()
       
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
    
    if itemArray[indexPath.row].done == false {
        
        itemArray[indexPath.row].done = true
        
   }else {
        
       itemArray[indexPath.row].done = false
   }
    
    SaveItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    }

    @IBAction func addItemButton(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            let allItem = Item(context: self.context)
            
            allItem.title = textField.text!
            
            allItem.done = false
            
            self.itemArray.append(allItem)
            
         self.SaveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add a new task"
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func SaveItems () {
        
       do {
        
            try context.save()
        
        } catch {
            
            print("Error")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadData (with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        
     
        do {
            
           itemArray = try context.fetch(request)
            
        } catch {
            
            print("Error in fetching data")
            
        }
    }
    
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] '%@'", searchBar.text!)
        
         request.predicate = predicate
        
        let setDescriptor = NSSortDescriptor(key: "Title", ascending: true)
        
        request.sortDescriptors = [setDescriptor]
        
        loadData(with: request)
        
        
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
