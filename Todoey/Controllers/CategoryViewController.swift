//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Moises Corkidi on 4/1/19.
//  Copyright © 2019 Moises Corkidi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
        
        tableView.separatorStyle = .none
        
       
        
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
                
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        
        
        
        cell.backgroundColor = UIColor(hexString: (categories?[indexPath.row].color)!)
        
        
        return cell
        
    }
    
    //MARK: Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!ToDoListViewcontroller
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
        
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let deletedCategory = self.categories?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(deletedCategory)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }

    }
    
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let randomColor = UIColor.randomFlat.hexValue()
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = randomColor
            
            
            
            self.save(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    

    
}




