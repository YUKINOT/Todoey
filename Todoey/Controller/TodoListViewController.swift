//
//  ViewController.swift
//  Todoey
//
//  Created by 冨樫由城乃 on 2019/06/02.
//  Copyright © 2019 Yukino Togashi. All rights reserved.
//

// Plistが保存されている場所がわからない。Angelaの言う通りにMackintosh HDの階層を降りていったが見当たらなかった。

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]() 
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath)
        
        loadItems()

    }
    
    //Mark - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        //value = condition ? valueifTrue : valueifFalse
        
        // cell.accessoryType = item.done == true ? .checkmark : .none でも良いが、== true は省略可能
        
        cell.accessoryType = item.done ? .checkmark : .none
 
        //下のコードを簡略化したのが上のコード
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //Mark - Tableview delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
//
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey New Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the Add item button on UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()

        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New Item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    }
    
    
    //Mark - Model Manuplation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding itemArray, \(error)")
        }
        self.tableView.reloadData() //ここのselfはなぜ必要なのか？
        
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){ // try ?って？tryはdo catchとセットで使うのではないの？
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data) //なぜここでselfが入るのか、、closureじゃないのに？
            } catch {
                print("error decoding itemArray, \(error)")
            }
        }
    }

}
