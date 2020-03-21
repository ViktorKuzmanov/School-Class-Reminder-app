//  Created by Viktor Kuzmanov on 10/2/17.

import UIKit
import UserNotifications
import CoreData
import AudioToolbox

class WorkingDaysTableViewController: UITableViewController, UITabBarDelegate {

    var workingDays = [Day(dayName: "Monday"), Day(dayName: "Tuesday"), Day(dayName: "Wednesday"), Day(dayName: "Thursday"), Day(dayName: "Friday"), Day(dayName: "Saturday")]
    var firstNotTime = 0
    var dataFilePath: String?
    var selectedMintuesFromFirstController = 0
    @IBOutlet weak var buttonSettings: UIBarButtonItem!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(true, forKey: "TermsAccepted")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // load saved subject/s for all days
        for day in workingDays {
            setupSubjectForDay(workDay: day)
        }
        
        // Set the table view backhground any time you want
        let imageView = UIImageView(image: UIImage(named: "workDayTVC - BG 2"))
        self.tableView.backgroundView = imageView
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: { self.turnVibrateOnOff() })
    }
    
    // MARK: Functions - custom ones
    
    
    @IBAction func deleteUserDefaultsData(_ sender: UIBarButtonItem) {
        deleteAllUserDefaultsData()
    }
    
    func turnVibrateOnOff() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    @IBAction func getAllPendingNotList(_ sender: UIBarButtonItem) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
        
    }
    func removeAllPendingNotifications() {
        let removedPendingNotifications = UNUserNotificationCenter.removeAllPendingNotificationRequests(UNUserNotificationCenter.current())
        removedPendingNotifications()
    }
    
    func deleteAllSubjects() {
        for day in workingDays {
            day.subjects = []
        }
    }
    
    @IBAction func deleteAllReminders(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Delete all reminders", message: "Are you sure you want to delete all reminders?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.deleteAllSubjects()
            self.deleteAllCoreData()
            self.removeAllPendingNotifications()
            
            alertController.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
        print()
        print("PRINTING ALL NOTIFICATION IN deleteAllReminders() func BRO")
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
        
    }
    // delete userDefaults data
    func deleteAllUserDefaultsData() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
//  Delete all data in coreData
    func deleteAllCoreData() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try PersistanceService.context.execute(deleteRequest)
            try PersistanceService.context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Setup saved subjects in CoreData with any day
    func setupSubjectForDay(workDay: Day) {
        print()
        workDay.subjects = []
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        do {
            let allSavedSubjects = try PersistanceService.context.fetch(fetchRequest)
            if allSavedSubjects.count > 0 {
                for subject in allSavedSubjects {
                    if subject.dayName == workDay.dayName {
                        workDay.subjects?.append(subject)
                        print()
                    }
                }
            }
            tableView.reloadData()
        } catch let error as NSError {
            print("Error \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func makeNotificationsForDay(_ sender: UISwitch) {
        
            switch sender.tag {
            case 2: // MARK: Mondat se rabote(testirano-27.11) i se brisat u else notifications
                    if sender.isOn == true {
                        defaults.set(true, forKey: "sender.tag = 2(case)")
                        if workingDays[0].subjects?.count ?? 0 != 0 {
                            showToast(message: "Reminders updated")
                            makeAllFirstNotifications(dayIndex: 0, weekDay: 2)
                            // make other notifications
                            var howManyLeft = workingDays[0].subjects!.count - 1 //za firstNot ne e
                            var actionIndex = 0
                            for index in 1..<workingDays[0].subjects!.count {
                                howManyLeft -= 1
                                actionIndex += 1
                                makeAllNotfications(subjectIndex: index, dayIndex: 0, weekDay: 2, howManyLeft: howManyLeft)
                            }
                        }
                    } else {
                        if workingDays[0].subjects?.count ?? 0 != 0 {
                            var arrayOfIdentifiers = [String]()
                            for index in 0..<workingDays[0].subjects!.count {
                                arrayOfIdentifiers.append("0.23/07/1999.\(index)")
                            }
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrayOfIdentifiers)
                            print()
                        }
                        defaults.set(false, forKey: "sender.tag = 2(case)")
                }
                
            case 3: // MARK: Tuesday - se e ok i da se brisat u else notifications(osven biggest problem)
                if sender.isOn == true {
                    defaults.set(true, forKey: "sender.tag = 3(case)")
                    if workingDays[1].subjects?.count ?? 0 != 0 {
                        showToast(message: "Reminders updated")
                        makeAllFirstNotifications(dayIndex: 1, weekDay: 3)
                        // make other notifications
                        var howManyLeft = workingDays[1].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[1].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 1, weekDay: 3, howManyLeft: howManyLeft)
                        }
                    }
                } else {
                    if workingDays[1].subjects?.count ?? 0 != 0 {
                        var arrayOfIdentifiers = [String]()
                        for index in 0..<workingDays[1].subjects!.count {
                            arrayOfIdentifiers.append("1.23/07/1999.\(index)")
                        }
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrayOfIdentifiers)
                        print()
                    }
                    defaults.set(false, forKey: "sender.tag = 3(case)")
                }
            case 4: // MARK: Wednesday se e ok i da se brisat u else notifications
                if sender.isOn == true {
                    defaults.set(true, forKey: "sender.tag = 4(case)")
                    if workingDays[2].subjects?.count ?? 0 != 0 {
                        showToast(message: "Reminders updated")
                        makeAllFirstNotifications(dayIndex: 2, weekDay: 4)
                        // make other notifications
                        var howManyLeft = workingDays[2].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[2].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 2, weekDay: 4, howManyLeft: howManyLeft)
                        }
                    }
                } else {
                    if workingDays[2].subjects?.count ?? 0 != 0 {
                        var arrayOfIdentifiers = [String]()
                        for index in 0..<workingDays[2].subjects!.count {
                            arrayOfIdentifiers.append("2.23/07/1999.\(index)")
                        }
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrayOfIdentifiers)
                        print()
                    }
                    defaults.set(false, forKey: "sender.tag = 4(case)")
                }
            case 5: // MARK: Thursday bi trebalo se da e ok i da se brisat u else notifications
                if sender.isOn == true {
                    defaults.set(true, forKey: "sender.tag = 5(case)")
                    if workingDays[3].subjects?.count ?? 0 != 0 {
                        showToast(message: "Reminders updated")
                        makeAllFirstNotifications(dayIndex: 3, weekDay: 5)
                        // make other notifications
                        var howManyLeft = workingDays[3].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[3].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 3, weekDay: 5, howManyLeft: howManyLeft)
                        }
                    }
                } else {
                    if workingDays[3].subjects?.count ?? 0 != 0 {
                        var arrayOfIdentifiers = [String]()
                        for index in 0..<workingDays[3].subjects!.count {
                            arrayOfIdentifiers.append("3.23/07/1999.\(index)")
                        }
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrayOfIdentifiers)
                        print()
                    }
                    defaults.set(false, forKey: "sender.tag = 5(case)")
                }
            case 6: // MARK: Friday bi trebalo se da e ok i da se brisat u else notifications
                if sender.isOn == true {
                    defaults.set(true, forKey: "sender.tag = 6(case)")
                    if workingDays[4].subjects?.count ?? 0 != 0 {
                        showToast(message: "Reminders updated")
                        makeAllFirstNotifications(dayIndex: 4, weekDay: 6)
                        // make other notifications
                        var howManyLeft = workingDays[4].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[4].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 4, weekDay: 6, howManyLeft: howManyLeft)
                        }
                    }
                } else {
                    if workingDays[4].subjects?.count ?? 0 != 0 {
                        var arrayOfIdentifiers = [String]()
                        for index in 0..<workingDays[4].subjects!.count {
                            arrayOfIdentifiers.append("4.23/07/1999.\(index)")
                        }
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrayOfIdentifiers)
                        print()
                    }
                    defaults.set(false, forKey: "sender.tag = 6(case)")
                }
            case 7: // MARK: Saturday bi trebalo se da e ok i da se brisat u else notifications
                if sender.isOn == true {
                    defaults.set(true, forKey: "sender.tag = 7(case)")
                    if workingDays[5].subjects?.count ?? 0 != 0 {
                        showToast(message: "Reminders updated")
                        makeAllFirstNotifications(dayIndex: 5, weekDay: 7)
                        // make other notifications
                        var howManyLeft = workingDays[5].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[5].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 5, weekDay: 7, howManyLeft: howManyLeft)
                        }
                    }
                }  else {
                    if workingDays[5].subjects?.count ?? 0 != 0 {
                        var arrayOfIdentifiers = [String]()
                        for index in 0..<workingDays[5].subjects!.count {
                            arrayOfIdentifiers.append("5.23/07/1999.\(index)")
                        }
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrayOfIdentifiers)
                        print()
                    }
                    defaults.set(false, forKey: "sender.tag = 7(case)")
                }

            default:
                fatalError("CAN'T FIND TAG WITH SWITCH STATEMENT")
            }
//        print()
//        print("end of original SCHEDULING NOT. function and pringting all notifications")
//        print()
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })

    }
    // MARK: GENERIC FUNCTIONS FOR MAKING NOTIFICATIONS
    func makeAllNotfications(subjectIndex: Int, dayIndex: Int, weekDay: Int, howManyLeft: Int) {
        if workingDays[dayIndex].subjects?.count ?? 0 != 0 {
            var seperated = workingDays[dayIndex].subjects![subjectIndex].startsAt.components(separatedBy: ":")
            
            var dateComponents = DateComponents()
            dateComponents.hour = Int(seperated[0])
            dateComponents.minute = Int(seperated[1])
            dateComponents.weekday = weekDay
            
            // make category add actions to category
            var actionsToAdd = [UNNotificationAction]()
            for index in 1..<workingDays[dayIndex].subjects!.count {
                let action = UNNotificationAction(identifier: "\(index).\(subjectIndex)", title: "\(index + 1). " + workingDays[dayIndex].subjects![index].subjectName, options: .foreground)
                actionsToAdd += [action]
            }
            let category5 = UNNotificationCategory(identifier: "..23/07/1999", actions: actionsToAdd, intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category5])
            
            // If contition is true make notification
            let notification = UNMutableNotificationContent()
            notification.sound = .default()
            if howManyLeft != 0 {
                notification.title = "\(subjectIndex + 1). " + workingDays[dayIndex].subjects![subjectIndex].subjectName
                if howManyLeft == 1 {
                    notification.subtitle = "1 class left"
                } else {
                    notification.subtitle = "\(howManyLeft) classes left"
                }
            } else {
                notification.title = "\(subjectIndex + 1). " + workingDays[dayIndex].subjects![subjectIndex].subjectName
                notification.subtitle = "No more left!"
            }
            notification.categoryIdentifier = "..23/07/1999"
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(dayIndex).23/07/1999.\(subjectIndex)",
                content: notification,
                trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    // // MARK: ALL FIRST NOTIFICATIONS GENERIC FUNCTION
    func makeAllFirstNotifications(dayIndex: Int, weekDay: Int) {
        if workingDays[dayIndex].subjects?.count ?? 0 != 0 {
            var seperated2 = workingDays[dayIndex].subjects!.first!.startsAt.components(separatedBy: ":")
            var hoursOfFirstString = seperated2[0]
            let minutesOfFirstString = seperated2[1]
            let minutesOfFirst = Int(minutesOfFirstString)!
            var minutesForNotification = 0
            var hoursForNotification = 0
            
            if UserDefaults.standard.object(forKey: "selectedRow") != nil {
//                print("UserDefaults.standard.object(forKey:) = ", UserDefaults.standard.object(forKey: "selectedRow")!)
                // Togas ima nes zacuvano pa spored toa napraj first notifications u sekoj den
//                print("IMA ZACUVANO, kje napravam first Notification od toa so e u userDefaults")
                selectedMintuesFromFirstController = UserDefaults.standard.object(forKey: "selectedRow") as! Int
                
                // logikata na toa kako se praat
                if minutesOfFirst >= selectedMintuesFromFirstController {
                    minutesForNotification = minutesOfFirst - selectedMintuesFromFirstController
                    hoursForNotification = Int(hoursOfFirstString)!
                } else {
                    if hoursOfFirstString == "0" || hoursOfFirstString == "00" {
                        // ako e 0 togas da bide 12 za da ne odzema so nulata
                        hoursOfFirstString = String(24)
                        hoursForNotification = Int(hoursOfFirstString)! - 1
                        minutesForNotification = 60 - (selectedMintuesFromFirstController - minutesOfFirst)
                    } else {
                        hoursForNotification = Int(hoursOfFirstString)! - 1
                        minutesForNotification = 60 - (selectedMintuesFromFirstController - minutesOfFirst)
                    }
                }
                var firstComponents = DateComponents()
                firstComponents.weekday = weekDay
                firstComponents.hour = hoursForNotification
                firstComponents.minute = minutesForNotification
                firstComponents.second = 0
                
                // make category add actions to category
                var actionsToAdd = [UNNotificationAction]()
                for index in 0..<workingDays[dayIndex].subjects!.count {
                    if index + 1 >= 0 && index + 1 < workingDays[dayIndex].subjects!.count {
                        let action = UNNotificationAction(identifier: "\(workingDays[dayIndex].subjects![index + 1].subjectName).\(index)", title: "\(index + 1). " + workingDays[dayIndex].subjects![index + 1].subjectName, options: .foreground)
                        actionsToAdd += [action]
                    }
                }
                let category5 = UNNotificationCategory(identifier: "..23/07/1999", actions: actionsToAdd, intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([category5])
                
                // make first notification
                let firstNotification = UNMutableNotificationContent()
                firstNotification.sound = .default()
                firstNotification.title = "1. " + workingDays[dayIndex].subjects!.first!.subjectName
                if workingDays[dayIndex].subjects!.count - 1 == 1 {
                    firstNotification.subtitle = "1 class left"
                } else {
                    firstNotification.subtitle = "\(workingDays[dayIndex].subjects!.count - 1)  classes left"
                }
                firstNotification.categoryIdentifier = "..23/07/1999"
                let trigger1 = UNCalendarNotificationTrigger(dateMatching: firstComponents, repeats: true)
                let request1 = UNNotificationRequest(identifier: "\(dayIndex).23/07/1999.0", content: firstNotification, trigger: trigger1)
                UNUserNotificationCenter.current().add(request1, withCompletionHandler: { (error) in
                    if let error = error {
                        print("SOMETHING IS WRONG WITH THE FIRST NOTIFICATION - \(error)")
                    }
                })
                // Inaku ako e prv launch neka se stave default time - 15min
            } else {
                print("Prv launch nema userDefaults nis zacuvano")
                print(firstNotTime)
                if minutesOfFirst >= firstNotTime {
                    minutesForNotification = minutesOfFirst - firstNotTime
                    hoursForNotification = Int(hoursOfFirstString)!
                } else {
                    if hoursOfFirstString == "0" || hoursOfFirstString == "00" {
                        hoursOfFirstString = "24"
                        if let hours = Int(hoursOfFirstString) {
                            hoursForNotification = hours - 1
                            minutesForNotification = 60 - (firstNotTime - minutesOfFirst)
                        }
                    } else {
                        if let hours = Int(hoursOfFirstString) {
                            hoursForNotification = hours - 1
                            minutesForNotification = 60 - (firstNotTime - minutesOfFirst)
                        }
                    }
                }
                var firstComponents = DateComponents()
                firstComponents.weekday = weekDay
                firstComponents.hour = hoursForNotification
                firstComponents.minute = minutesForNotification
                firstComponents.second = 0
                
                // make category add actions to category
                var actionsToAdd = [UNNotificationAction]()
                for index in 0..<workingDays[dayIndex].subjects!.count {
                    if index + 1 >= 0 && index + 1 < workingDays[dayIndex].subjects!.count {
                        let action = UNNotificationAction(identifier: "\(workingDays[dayIndex].subjects![index + 1].subjectName).\(index)", title:  "\(index + 1). " + workingDays[dayIndex].subjects![index + 1].subjectName, options: .foreground)
                        actionsToAdd += [action]
                    }
                }
                let category5 = UNNotificationCategory(identifier: "..23/07/1999", actions: actionsToAdd, intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([category5])
                
                // make first notification
                let firstNotification = UNMutableNotificationContent()
                firstNotification.sound = .default()
                firstNotification.title = "1." + workingDays[dayIndex].subjects!.first!.subjectName + " (\(workingDays[dayIndex].subjects!.count - 1) left)"
                firstNotification.categoryIdentifier = "..23/07/1999"
                let trigger1 = UNCalendarNotificationTrigger(dateMatching: firstComponents, repeats: true)
                let request1 = UNNotificationRequest(identifier: "\(dayIndex).23/07/1999.0", content: firstNotification, trigger: trigger1)
                
                UNUserNotificationCenter.current().add(request1, withCompletionHandler: { (error) in
                    if let error = error {
                        print("SOMETHING IS WRONG WITH THE FIRST NOTIFICATION - \(error)")
                    }
                })
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workingDays.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            return 63
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE": // ok  e 75
            return 72
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8": // ok e 80
            return 80
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus": // ok e 83
            return 83
        case "iPhone X": // ok e 85
            return 85
        default:
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WorkDayCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkDayCell else {
            fatalError("cell is not as? WorkDayCell for some reason (in tableView func)")
        }
        cell.switchOne.tag = indexPath.row + 2
        
        // da se stavat kaa so bile switchovite posledniot pat kaa izlezil od app userot
        let tag = indexPath.row + 2
        
            if defaults.bool(forKey: "sender.tag = \(tag)(case)") == true {
                cell.switchOne.setOn(true, animated: true)
            } else {
                cell.switchOne.setOn(false, animated: true)
            }

        
        let workDay = workingDays[indexPath.row]
        cell.dayLabel.text = workDay.dayName
        
        switch UIDevice.current.screenType.rawValue {

        case "iPhone 4 or iPhone 4S":
            cell.dayLabel.font = UIFont.boldSystemFont(ofSize: 23)

        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE": // potvrdeno, ok e
            cell.dayLabel.font = UIFont(name: "Courier", size: 27)
            
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5958845615, green: 0.5959874988, blue: 0.5958710313, alpha: 1),
                 NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 28)!]
            
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8": // potvrdeno, ok e
            cell.dayLabel.font = UIFont(name: "Courier", size: 30)
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1),
                 NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 32)!]

        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus": // p  otvrdeno, ok e
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5958845615, green: 0.5959874988, blue: 0.5958710313, alpha: 1),
                 NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 33)!]
            cell.dayLabel.font = UIFont(name: "Courier", size: 33)

        case "iPhone X": // potvrdeno, se e ok
            self.navigationController?.navigationBar.titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.5958845615, green: 0.5959874988, blue: 0.5958710313, alpha: 1),
                 NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoSCITCTT-Book", size: 32)!]
            cell.dayLabel.font = UIFont(name: "Courier", size: 30)
        default:
            cell.dayLabel.font = UIFont.boldSystemFont(ofSize: 25)
        }
    
        return cell
    }

    // MARK: Prepare func kreiranje na selectedWorkDay i negovo dodeluvanje na vrednost
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "DisplaySubjects":
            guard let selectedWorkDayCell = sender as? WorkDayCell else {
                fatalError("unknown sender")
            }
            guard let subjectTableController = segue.destination as? SubjectsTableViewController else {
                fatalError("problem with segue.destination in WorkingDaysTableViewController")
            }
            guard let indexPath = tableView.indexPath(for: selectedWorkDayCell) else {
                fatalError("no index path for WorkDayCell in prepare func in WDT Controller")
            }
            let selectedWorkDay = workingDays[indexPath.row]
            subjectTableController.workDay = selectedWorkDay
            subjectTableController.navigationItem.title = String(selectedWorkDay.dayName)
            setupBackButtonInSubjectVC()
            
        case "FirstNotificationTime":
            guard let firstNotificationTimeVC = segue.destination as? FirstNotificationTime else {
                fatalError("problem with segue.destination in workDatvc prepare func ")
            }
            setupBarButtonsInFirstController(viewController: firstNotificationTimeVC)
            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            if launchedBefore {
                print("Not first launch (checking in workDayTVC).")
                if let savedSelection = UserDefaults.standard.object(forKey: "selectedRow") as? Int {
                    print("getting from userdefaults in prepare func in workDatVC")
                    firstNotificationTimeVC.holdTextFieldText = String(savedSelection) //can't directly(nil)
                    print()
                    print("u workDayVC firstNotificationTimeVC.holdTextFieldText = ",firstNotificationTimeVC.holdTextFieldText)
                }
            } else {
                print()
                print("First launch, setting UserDefaults (in workDayTVC)")
                firstNotificationTimeVC.holdTextFieldText = String(self.firstNotTime) //can't directly(nil)
                print("firstNotTime = \(firstNotTime)")
                UserDefaults.standard.set(true, forKey: "launchedBefore")
            }
            default:
            fatalError("Unexpected Segue identifier")
        }
     }
    
    // MARK: Unwind function from FirstNotificationTime
    @IBAction func unwindToWorkDayTVC(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? FirstNotificationTime else {
            fatalError("PROBLEM WITH: sourceViewController = sender.source as? FirstNotificationTime, workDay = sender.workDay! ")
        }
        // direktno da update deliver time tuka
        if sourceViewController.selectedMinutes != nil {
            UserDefaults.standard.set(sourceViewController.selectedMinutes, forKey: "selectedRow")
        } else {
            // cim ne e updated, togi starata e pa togas da se izvrse toa u else u main first func
            firstNotTime = Int(sourceViewController.holdTextFieldText)!
        }
        // let cells = self.tableView.visibleCel
        for row in 0..<self.tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: NSIndexPath(row: row, section: 0) as IndexPath)
            print()
            switch row {
            case 0: // Monday - se rabote testirano nema crash
                let mondaySwitch = cell?.viewWithTag(2) as? UISwitch
                if workingDays[0].subjects?.count ?? 0 != 0 {
                    if mondaySwitch?.isOn == true {
                        
                        print("UPDATING NOTIFICATIONS FOR MONDAT IN UNWIND FUNC")
                        makeAllFirstNotifications(dayIndex: 0, weekDay: 2)
                        // make other notifications
                        var howManyLeft = workingDays[0].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[0].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 0, weekDay: 2, howManyLeft: howManyLeft)
                        }
                        print("PRINTING ALL NOTIFICATION IN UNWIND ON MONDAY")
                        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
                            for request in requests {
                                print(request)
                            }
                        })
                    }
                }
            case 1: // Tuesday
                let tuesdaySwitch = cell?.viewWithTag(3) as? UISwitch
                if workingDays[1].subjects?.count ?? 0 != 0 {
                    if tuesdaySwitch?.isOn == true {
                        print("UPDATING NOTIFICATIONS FOR Tuesday IN UNWIND FUNC")
                        makeAllFirstNotifications(dayIndex: 1, weekDay: 3)
//                         make other notifications
                        var howManyLeft = workingDays[1].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[1].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 1, weekDay: 3, howManyLeft: howManyLeft)
                        }
                        print("PRINTING ALL NOTIFICATION IN UNWIND ON Tuesday")
                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
                            for request in requests {
                                print(request)
                            }
                        })
                    }
                }
            case 2: // Wednesday - se rabote testirano nema crash
                if workingDays[2].subjects?.count ?? 0 != 0 {
                    let wednesdaySwitch = cell?.viewWithTag(4) as? UISwitch
                    if wednesdaySwitch?.isOn == true {
                        print("UPDATING NOTIFICATIONS FOR WEDNESDAY IN UNWIND FUNC - IF isOn == TRUE")
                        makeAllFirstNotifications(dayIndex: 2, weekDay: 4)
                        // make other notifications
                        var howManyLeft = workingDays[2].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[2].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 2, weekDay: 4, howManyLeft: howManyLeft)
                        }
//                        print("PRINTING NOTIFICATIONS IN UNWIND za Wednesday")
//                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
//                            for request in requests {
//                                print(request)
//                            }
//                        })
                    }
                }
            case 3: // Thursday - se rabote testirano nema crash
                if workingDays[3].subjects?.count ?? 0 != 0 {
                    let thursdaySwitch = cell?.viewWithTag(5) as? UISwitch
                    if thursdaySwitch?.isOn == true {
                        print("UPDATING NOTIFICATIONS FOR Thursday IN UNWIND FUNC - IF isOn == TRUE")
                        makeAllFirstNotifications(dayIndex: 3, weekDay: 5)
                        // make other notifications
                        var howManyLeft = workingDays[3].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[3].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 3, weekDay: 5, howManyLeft: howManyLeft)
                        }
//                        print("PRINTING NOTIFICATIONS IN UNWIND za Thursday")
//                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
//                            for request in requests {
//                                print(request)
//                            }
//                        })
                    }
                }
            case 4: // Friday nz kako e situacijata
                if workingDays[4].subjects?.count ?? 0 != 0 {
                    let fridaySwitch = cell?.viewWithTag(6) as? UISwitch
                    if fridaySwitch?.isOn == true {
                        print("UPDATING NOTIFICATIONS FOR Friday IN UNWIND FUNC - IF isOn == TRUE")
                        makeAllFirstNotifications(dayIndex: 4, weekDay: 6)
                        // make other notifications
                        var howManyLeft = workingDays[4].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[4].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 4, weekDay: 6, howManyLeft: howManyLeft)
                        }
//                        print("PRINTING NOTIFICATIONS IN UNWIND za Friday")
//                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
//                            for request in requests {
//                                print(request)
//                            }
//                        })
                    }
                }
            case 5: // Saturday nz kako e situacijata
                if workingDays[5].subjects?.count ?? 0 != 0 {
                    let saturdaySwitch = cell?.viewWithTag(7) as? UISwitch
                    if saturdaySwitch?.isOn == true {
                        print("UPDATING NOTIFICATIONS FOR Saturday IN UNWIND FUNC - IF isOn == TRUE")
                        makeAllFirstNotifications(dayIndex: 5, weekDay: 7)
                        // make other notifications
                        var howManyLeft = workingDays[5].subjects!.count - 1
                        var actionIndex = 0
                        for index in 1..<workingDays[5].subjects!.count {
                            howManyLeft -= 1
                            actionIndex += 1
                            makeAllNotfications(subjectIndex: index, dayIndex: 5, weekDay: 7, howManyLeft: howManyLeft)
                        }
//                        print("PRINTING NOTIFICATIONS IN UNWIND za Saturday")
//                UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
//                            for request in requests {
//                                print(request)
//                            }
//                        })
                    }
                }
            default:
                // fatalError("DIDN'T FIND ROW IN SWITCH IN UNWING FUNC IN WORKDAY NAJDOLE")
                print("")
            }
        } // od swithot e izgleda
    } // od for loop
    
    // MARK: Functions
    func setupBarButtonsInFirstController(viewController: FirstNotificationTime) {
        // set up font on bar buttons in firstController
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 15)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
            viewController.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 14)!], for: UIControlState.normal)
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
            viewController.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!], for: UIControlState.normal)
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 18)!], for: UIControlState.normal)
            viewController.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 18)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
            viewController.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!], for: UIControlState.normal)
        case "iPhone X":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 19)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
            viewController.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 19)!], for: UIControlState.normal)
        default:
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 14.5)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
        }
    }
    
    func setupBackButtonInSubjectVC() {
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 15)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 18)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
        case "iPhone X":
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 19)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
        default:
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
            backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 17)!], for: UIControlState.normal)
            navigationItem.backBarButtonItem = backButton
        }

    }
}

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 15.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 7
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }


// SETUP BUTTON IN FIRST CONTROLLER
//// set up font on bar buttons in firstController
//switch UIDevice.current.screenType.rawValue {
//case "iPhone 4 or iPhone 4S":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 15)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//    firstNotificationTimeVC.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 14)!], for: UIControlState.normal)
//case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//    firstNotificationTimeVC.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!], for: UIControlState.normal)
//case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 18)!], for: UIControlState.normal)
//    firstNotificationTimeVC.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 18)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//    firstNotificationTimeVC.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!], for: UIControlState.normal)
//case "iPhone X":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 19)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//    firstNotificationTimeVC.buttonSave.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 19)!], for: UIControlState.normal)
//default:
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 14.5)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//}

//// U DISPALY SUBJECTS CASEOT BESE
//switch UIDevice.current.screenType.rawValue {
//case "iPhone 4 or iPhone 4S":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 15)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 18)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//case "iPhone X":
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 19)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//default:
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: nil)
//    backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 17)!], for: UIControlState.normal)
//    navigationItem.backBarButtonItem = backButton
//}





// REMOVING ALL PENDING NOTIFICATIONS
//                let removedPendingNotifications = UNUserNotificationCenter.removeAllPendingNotificationRequests(UNUserNotificationCenter.current())
//                removedPendingNotifications()
//                print()
//                print("I DID REMOVE NOTIFICATIONS")
//                print()

//                    let actionsForCategory = category5.actions.filter({$0 != category5.actions.first})

// let dayCell = tableView.dequeueReusableCell(withIdentifier: "WorkDayCell") as! WorkDayCelL

//        print("userdefaults.count = ")
//        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
//        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//            print("\(key) = \(value) \n")
//        }

// how to delete user defaults data
// UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)

//        // boja na actual bar
//        navigationController?.navigationBar.barTintColor = UIColor.blue
//        // boja na site kopcinja na tia bar
//        navigationController?.navigationBar.tintColor = UIColor.red

        
        
        
        
        
        
        
