//
//  ChooseTableViewController.swift
//  School Class Scedule
//
//  Created by Viktor Kuzmanov on 12/17/17.
//

import UIKit
import CoreData

class ChooseTableViewController: UITableViewController {
    
    var todayOrTomorrowArray = ["Today","Tomorrow"]
    let key = "showSubjectsList"
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        print()
//        print("viewWillAppear in ChooseTableViewController")
//        print("UserDefaults.standard.bool(forKey: key) = ",UserDefaults.standard.bool(forKey: key))
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(image: UIImage(named: "SetForTodayBG3"))
        tableView.backgroundView = backgroundImage
        
        title = "Settings"
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChooseOptionCell else {
            fatalError("TUKA IMA NES cell = tableView.dequeueReusableCell(, for: ")
        }
        if UserDefaults.standard.bool(forKey: key) == true {
            if indexPath.row == 1 {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        } else if indexPath.row == 2 {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        // za da bide first cell samo onaka za prazno mesto da ima
        if indexPath.row != 0 {
            cell.labelChooseOption.text = todayOrTomorrowArray[indexPath.row - 1]
        } else {
            cell.labelChooseOption.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            UserDefaults.standard.set(true, forKey: key)
            tableView.cellForRow(at: [0, 1])?.accessoryType = UITableViewCellAccessoryType.checkmark
            tableView.cellForRow(at: [0, 2])?.accessoryType = UITableViewCellAccessoryType.none
        } else if indexPath.row == 2 {
            tableView.cellForRow(at: [0, 2])?.accessoryType = UITableViewCellAccessoryType.checkmark
            tableView.cellForRow(at: [0, 1])?.accessoryType = UITableViewCellAccessoryType.none
            UserDefaults.standard.set(false, forKey: key)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 15
        }
        return 70
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
