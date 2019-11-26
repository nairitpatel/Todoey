//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jayesh Patel on 11/11/19.
//  Copyright © 2019 nairit. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
  
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       loadCategory()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          self.performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         let destinationVC = segue.destination as! TodoListViewController
            
        if let indexpath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexpath.row]
            
        }
        
    }
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let allCategory = Category(context: self.context)
            
            allCategory.name = textField.text!
            
            self.categoryArray.append(allCategory)
            
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
    
    func loadCategory (with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            
            categoryArray = try context.fetch(request)
            
        } catch {
            
            print("Error in fetching data")
            
        }
        
        tableView.reloadData()
    }
    
}

extension CategoryViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let setDescriptor = NSSortDescriptor(key: "Title", ascending: true)
        
        request.sortDescriptors = [setDescriptor]
        
        loadCategory(with: request as! NSFetchRequest<Item> as! NSFetchRequest<Category>)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadCategory()
            
           tableView.reloadData()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
            
        }  else {
            
            searchBarSearchButtonClicked(searchBar)
            
        }
        
}
    
}
