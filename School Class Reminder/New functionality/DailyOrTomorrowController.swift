//  Created by Viktor Kuzmanov on 12/7/17.

import UIKit
import CoreData

class DailyOrTomorrowController: UITableViewController {

    @IBOutlet weak var dailyNavigationItem: UINavigationItem! // - za da stajme naslov
    @IBOutlet weak var labelSubjectName: UILabel!
    let key = "showSubjectsList"
    var arrayOfSubjects = [Subject]()
    var thereAreSomeSubjectsShowing = false
    static var noSubjectsLabel2 = UILabel()
    
    let today = Date().dayOfWeek() ?? "today"
    let tomorrow = Date().tomorrow.dayOfWeek() ?? "tomorrow"
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // vaa var u viewWillAppear dobiva vrednost false a posle se stava true ako ima nekoj subject
        if thereAreSomeSubjectsShowing == false {
            if UserDefaults.standard.bool(forKey: key) == false {
                DailyOrTomorrowController.noSubjectsLabel2.removeFromSuperview()
                ifNoSubjectsMakeLabel(dayName: tomorrow, changingOrientation: true)
            } else {
                DailyOrTomorrowController.noSubjectsLabel2.removeFromSuperview()
                ifNoSubjectsMakeLabel(dayName: today, changingOrientation: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        thereAreSomeSubjectsShowing = false
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 17)!], for: UIControlState.normal)
        navigationItem.backBarButtonItem = backButton
        
        super.viewWillAppear(true)
        arrayOfSubjects = []

        // ako saka userot za utre da mu se prikazuat subjects
        if UserDefaults.standard.bool(forKey: key) == false {
            dailyNavigationItem.title = tomorrow
            let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
            do {
                let allSavedSubjects = try PersistanceService.context.fetch(fetchRequest)
                if allSavedSubjects.count > 0 {
                    for subject in allSavedSubjects {
                        if subject.dayName == tomorrow {
                            // DailyOrTomorrowController.noSubjectsLabel2.removeFromSuperview()
//                            print("eve u tomorrow append na subject mu pramm subject \(subject.subjectName)")
                            thereAreSomeSubjectsShowing = true
                            arrayOfSubjects += [subject]
                        }
                    }
                }
            } catch let error as NSError {
                print("Error \(error), \(error.userInfo)")
            }
        } else {
            dailyNavigationItem.title = today
            navigationController?.navigationItem.title = today
            let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
            do {
                let allSavedSubjects = try PersistanceService.context.fetch(fetchRequest)
                if allSavedSubjects.count > 0 {
                    for subject in allSavedSubjects {
                        if subject.dayName == today {
                            // DailyOrTomorrowController.noSubjectsLabel2.removeFromSuperview()
//                            print("eve u today append subject")
                            thereAreSomeSubjectsShowing = true
                            arrayOfSubjects += [subject]
                        }
                    }
                }
            } catch let error as NSError {
                print("Error \(error), \(error.userInfo)")
            }
        }
        
        DailyOrTomorrowController.noSubjectsLabel2.removeFromSuperview()
        
        if UserDefaults.standard.bool(forKey: key) {
            if arrayOfSubjects.count == 0 {
                ifNoSubjectsMakeLabel(dayName: today, changingOrientation: false)
            } else {
                DailyOrTomorrowController.noSubjectsLabel2.removeFromSuperview()
            }
        } else {
            if arrayOfSubjects.count == 0 {
                ifNoSubjectsMakeLabel(dayName: tomorrow, changingOrientation: false)
            } else {
                DailyOrTomorrowController.noSubjectsLabel2.removeFromSuperview()
            }
        }
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .fade)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Set the table view backhground any time you want
        let imageView = UIImageView(image: UIImage(named: "subjectsTVC - BG"))
        self.tableView.backgroundView = imageView
        
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1),
                 NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 16)!]
        
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE":
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1),
                 NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 28)!]
            
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8":
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1),
                 NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 32)!]
            
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus":
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1),
                 NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 33)!]
            
        case "iPhone X":
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1),
                 NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 30)!]
        default:
            self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 28)!]
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayOfSubjects.count != 0 {
            return arrayOfSubjects.count + 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 15
        }
        return 65
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyOrNotCell", for: indexPath) as? DailyOrNotCell else {
            fatalError("IAM NES PROBLEM SO VOA cell = tableView.dequeueReusableCell(")
        }
        
        if indexPath.row == 0 {
            cell.labelSubjectName.text = ""
            cell.labelStartsAt.text = ""
        } else {
            cell.labelSubjectName.text = "\(indexPath.row). " + arrayOfSubjects[indexPath.row - 1].subjectName
            cell.labelStartsAt.text = arrayOfSubjects[indexPath.row - 1].startsAt
        }
        
        // sreduvanje na font
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            cell.labelSubjectName.font = cell.labelSubjectName.font.withSize(19)
            cell.labelStartsAt.font = cell.labelStartsAt.font.withSize(15)
            
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE": // perfektno
            cell.labelSubjectName.font = cell.labelSubjectName.font.withSize(25)
            cell.labelStartsAt.font = cell.labelStartsAt.font.withSize(16)
            
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8": // perfektno
            cell.labelSubjectName.font = cell.labelSubjectName.font.withSize(27)
            cell.labelStartsAt.font = cell.labelStartsAt.font.withSize(17)
            
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus": // perfektno
            cell.labelSubjectName.font = cell.labelSubjectName.font.withSize(29)
            cell.labelStartsAt.font = cell.labelStartsAt.font.withSize(19)
            
        case "iPhone X": // perfektno
            cell.labelSubjectName.font = cell.labelSubjectName.font.withSize(29)
            cell.labelStartsAt.font = cell.labelStartsAt.font.withSize(19)
            
        default:
            cell.labelSubjectName.font = cell.labelSubjectName.font.withSize(27) // so da praam
            cell.labelStartsAt.font = cell.labelStartsAt.font.withSize(17)
        }

        return cell
    }
    
    func ifNoSubjectsMakeLabel(dayName: String, changingOrientation: Bool) {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1)
        
        var localAttributedText = NSMutableAttributedString()
        if dayName == "Sunday" {
            let attributedText = NSMutableAttributedString(string: "Adding reminders for Sunday is unavailable.", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 26)])
            
            attributedText.append(NSAttributedString(string: """
                
                
                Change the settings in top right corner or wait for the day to end.
                """, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 23), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1)]))
            localAttributedText = attributedText
        } else {
            let attributedText = NSMutableAttributedString(string: "Reminders for \(dayName) are not avaiable.", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 26)])
            
            attributedText.append(NSAttributedString(string: """
                
                
                Please create reminders for \(dayName) with the Bell button below.
                """, attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Telugu", size: 23) as Any, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1)]))
            // da mu dodadime
            localAttributedText = attributedText
        }
        
        label.attributedText = localAttributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.addSubview(label)
        
        let margins = view.layoutMarginsGuide
        label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
        
        if UIDevice.current.orientation.isLandscape {
            //prvo so center x praev ama nogu dole bese pa zatoa pocna so y
            //label.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
            let yConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self.tableView, attribute: .centerY, multiplier: 1, constant: -50)
            NSLayoutConstraint.activate([yConstraint])
        } else {
            let yConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self.tableView, attribute: .centerY, multiplier: 1, constant: -80)
            NSLayoutConstraint.activate([yConstraint])
        }
        
        if !changingOrientation {
            // Make animation
            UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 10.0, initialSpringVelocity: 500.0, options: .curveEaseIn, animations: {(
                label.center.x = self.view.frame.width / 2
                )}, completion: nil)
        }
        
        // za posle da moze da go izbrisime samo tia label kaa ce se add barem 1 subject
        DailyOrTomorrowController.noSubjectsLabel2 = label
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

//// voa e za u firstLauchWalkthroughController nekoj ne za u via controller
//    override func viewDidAppear(_ animated: Bool) {
//        if UserDefaults.standard.bool(forKey: "WalkthroughWatched") {
//            print("Walkthrought has been watch get the dailyController and not the walkthrough")
//        } else {
//            print("Walkthrought has not been watch get it now so user can wathc it")
//        }
//    // voa na krajot kaa da go implement ce go pomine Walkthrough da znam za sl. pat da ne se pojavue
//        print("UserDefaults.standard.bool(forKey: walk..) = ",UserDefaults.standard.bool(forKey: "WalkthroughWatched"))
//        UserDefaults.standard.set(true, forKey: "WalkthroughWatched")
//    }

