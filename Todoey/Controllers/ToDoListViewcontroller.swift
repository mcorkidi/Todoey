//
//  ViewController.swift
//  Todoey
//
//  Created by Moises Corkidi on 3/28/19.
//  Copyright © 2019 Moises Corkidi. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewcontroller: SwipeTableViewController {

    var  todoItems:Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title

            //Ternary operator --  value = condition ? ValueIfTrue : ValueIfFalse

            cell.accessoryType = item.done ? .checkmark : .none  // ?makes condition if true, first, not true second option
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
        
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //mark a check if item is done
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done  //make the opposite of done
                    
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    func saveItem(newItem: Item) {
        if let currentCategory = self.selectedCategory {
        do {
            try self.realm.write {
                currentCategory.items.append(newItem)
                }
            } catch {
                print("Error saving item \(error)")
            }
        }
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user clicks on add item bnutton on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            self.saveItem(newItem: newItem)
        
            }
        
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)

    }
    
    //MARK - Model Manipulation Methods
    
 
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let deleteItem = self.todoItems?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(deleteItem)
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }
    
}
//MARK: - Searchbar methods

extension ToDoListViewcontroller: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
