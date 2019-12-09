//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jayesh Patel on 11/11/19.
//  Copyright © 2019 nairit. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
       loadCategory()

        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
        
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          self.performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         let destinationVC = segue.destination as! TodoListViewController
            
        if let indexpath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexpath.row]
            
        }
        
    }
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let allCategory = Category()
            
            allCategory.name = textField.text!
            
          self.Save(category: allCategory)
    }
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add a new task"
            
            textField = alertTextField
        }
       
        alert.addAction(action)
        
       present(alert, animated: true, completion: nil)
        
}
    func Save (category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            
            print("Error")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategory () {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
}

extension CategoryViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
      
        
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
