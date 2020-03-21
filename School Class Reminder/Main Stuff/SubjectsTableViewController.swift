//  Created by Viktor Kuzmanov on 10/3/17.

import UIKit
import UserNotifications
import CoreData
import GoogleMobileAds

class SubjectsTableViewController: UITableViewController {
    var workDay: Day?
    @IBOutlet weak var buttonEditRearrangeCells: UIBarButtonItem!
    @IBOutlet weak var buttonAddSubject: UIBarButtonItem!
    static var noSubjectsLabel = UILabel()
    var defaults = UserDefaults.standard
    var alreadyLoadedOnce = false
    var interstitialAd: GADInterstitial!
    
    override func viewWillTransition(to size: CGSize, with coordinator:
        UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        SubjectsTableViewController.noSubjectsLabel.removeFromSuperview()
        if workDay?.subjects?.count ?? 0 == 0 {
            checkIfNoSubjects(changingOrientation: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        SubjectsTableViewController.noSubjectsLabel.removeFromSuperview()
        
        if workDay?.subjects?.count ?? 0 == 0 {
            SubjectsTableViewController.noSubjectsLabel.removeFromSuperview()
            checkIfNoSubjects(changingOrientation: false)
        }
        tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if workDay?.dayName == "Tuesday" || workDay?.dayName == "Thursday" || workDay?.dayName == "Friday" {
            loadTheAd()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: { self.presentAd() })
        }
        
        let backgroundImage = UIImageView(image: UIImage(named: "dailyTVC - BG2"))
        tableView.backgroundView = backgroundImage
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setupDeleteButton()
    }
    // delete all data in coreData
    func deleteAllCoreData() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try PersistanceService.context.execute(deleteRequest)
            try PersistanceService.context.save()
        } catch {
            print ("Ima greska u deleteAllCoreData func")
        }
    }
    
    @objc func GoToBack(){ // za na back button da mu back button
        self.navigationController?.popViewController(animated: true)
    }
    
//    private func loadSubjects() -> [Day]? {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Day.ArchiveURL.path) as? [Day]
//    }
    
    func checkIfNoSubjects(changingOrientation: Bool) {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1)
        let attributedText = NSMutableAttributedString(string: "Reminders are not avaiable.", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24)])
        
        attributedText.append(NSAttributedString(string: """


Please create reminders using the add button in the top right corner.
""", attributes: [NSAttributedStringKey.font: UIFont(name: "Kohinoor Telugu", size: 21) as Any, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7258902192, green: 0.72601372, blue: 0.7258738875, alpha: 1)]))
        // Kohinoor Telugu
        label.attributedText = attributedText
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
            label.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        } else {
            let yConstraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self.tableView, attribute: .centerY, multiplier: 1, constant: -70)
            NSLayoutConstraint.activate([yConstraint])
        }
        
        if !changingOrientation {
            // Make animation
            UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 10.0, initialSpringVelocity: 500.0, options: .curveEaseIn, animations: {(
                label.center.x = self.view.frame.width / 2
                )}, completion: nil)
        }
        
        // za posle da moze da go izbrisime samo tia label kaa ce se add barem 1 subject
        SubjectsTableViewController.noSubjectsLabel = label
    }
    
        // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let subjectsCount = workDay?.subjects?.count {
            return subjectsCount
        } else {
            return 0
        }
    }

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // sozdavame day za da moze negovite subjects da se pretstavat
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as? SubjectTableViewCell else {
                fatalError("can't read the subject cell for some reason")
            }
        
        if let subject = workDay?.subjects?[indexPath.row] {
            cell.labelEndsAtTime.text = subject.startsAt
            cell.subjectNameLabel.text = "\(indexPath.row + 1)." + " " + subject.subjectName
        }
        
        // sreduvanje na font
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            cell.subjectNameLabel.font = cell.subjectNameLabel.font.withSize(19)
            cell.labelEndsAtTime.font = cell.labelEndsAtTime.font.withSize(15)
            
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE": // perfektno
            cell.subjectNameLabel.font = cell.subjectNameLabel.font.withSize(25)
            cell.labelEndsAtTime.font = cell.labelEndsAtTime.font.withSize(16)
            
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8": // perfektno
            cell.subjectNameLabel.font = cell.subjectNameLabel.font.withSize(27)
            cell.labelEndsAtTime.font = cell.labelEndsAtTime.font.withSize(17)
            
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus": // perfektno
            cell.subjectNameLabel.font = cell.subjectNameLabel.font.withSize(29)
            cell.labelEndsAtTime.font = cell.labelEndsAtTime.font.withSize(19)
            
        case "iPhone X": // perfektno
            cell.subjectNameLabel.font = cell.subjectNameLabel.font.withSize(29)
            cell.labelEndsAtTime.font = cell.labelEndsAtTime.font.withSize(19)
            
        default:
            cell.subjectNameLabel.font = cell.subjectNameLabel.font.withSize(50) // so da praam
        }
        
//        if indexPath.row > 0 && indexPath.row <= workDay?.subjects?.count ?? 0 {
//            if let subject = workDay?.subjects?[indexPath.row - 1] {
//                print("subject.startsAt = ",subject.startsAt)
//                print("subject.subjectName = ",subject.subjectName)
//                cell.labelEndsAtTime.text = subject.startsAt
//                cell.subjectNameLabel.text = "\(indexPath.row)." + " " + subject.subjectName
//            }
//        }
//
//        if indexPath.row == 0 {
//            cell.labelEndsAtTime.text = ""
//            cell.subjectNameLabel.text = ""
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            return 40
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE": // ok  e 75
            return 55
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8": // super e 67
            return 67
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus": // ok e 83
            return 70
        case "iPhone X": // ok e 85
            return 70
        default:
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let subjectToDelete = workDay?.subjects![indexPath.row]
            PersistanceService.persistentContainer.viewContext.delete(subjectToDelete!)
            workDay?.subjects?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            PersistanceService.saveContext()
            tableView.reloadData()
            if workDay?.subjects?.count ?? 0 == 0 {
                checkIfNoSubjects(changingOrientation: false)
            }
            print()
//            print("U DELETE COMMIT FUNC OD KAA KJE GO DELETE TIA SUBJECT")
            let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
            do {
                let allSavedSubjects = try PersistanceService.context.fetch(fetchRequest)
                if allSavedSubjects.count > 0 {
                    for subject in allSavedSubjects {
                        if subject.dayName == workDay!.dayName {
                            // workDay!.subjects?.append(subject)
                            print()
//                            print("This is subject's startsAt saved in CoreData \(subject.startsAt)")
//                            print("This is subject's subjectName saved in CoreData \(subject.subjectName)")
                        }
                    }
                }
            } catch {
                
            }
        }
    }
    
    @IBAction func changeIsEditingState(_ sender: UIBarButtonItem) {
        let editing = !tableView.isEditing
        if editing == true {
            buttonEditRearrangeCells.title = "Done"
        } else {
            buttonEditRearrangeCells.title = "Edit"
        }
//         Reload all the sections in table view(instead of reloadData()) with animation
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .fade)
        tableView.setEditing(editing, animated: true)
    }

    // MARK: Prepare func for addSubjectVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? "") {
            
        case "AddSubject":
            let addSubjectController = segue.destination as? AddSubjectController
            addSubjectController?.ifEditingExistingSubject = false
            if workDay != nil && addSubjectController != nil {
                addSubjectController!.workDay = workDay
            } else {
               fatalError("AddSubjectVC or workDay in the SubjectVC is nil")
            }
            
        case "EditExistingSubject":
            guard let addSubjectVC = segue.destination as? AddSubjectController else {
                fatalError("segue.destination is not addSubjectVC")
            }
            guard let selectedSubjectCell = sender as? SubjectTableViewCell else {
                fatalError("sender in not subjectCell")
            }
            
            let indexPath = tableView.indexPath(for: selectedSubjectCell)
            if let IndexPath = indexPath?.row {
                if let subjects = workDay?.subjects {
                    let selectedSubject = subjects[IndexPath]
                    addSubjectVC.workDay = workDay
                    addSubjectVC.subject = selectedSubject
                    addSubjectVC.subjectKaaSoDosolOdSubjectTVC = selectedSubject
                    addSubjectVC.navigationItem.title = "Edit reminder"
                    addSubjectVC.ifEditingExistingSubject = true
                    // Set timePicker2 time for the selectedSubject so it can be presented in addSubjectVC
                    let dateFormatter2 = DateFormatter()
                    dateFormatter2.dateFormat =  "HH:mm"
                    if let date2 = dateFormatter2.date(from: selectedSubject.startsAt) {
                        addSubjectVC.time2 = date2
                    }
                }
            }
        default:
            fatalError("Something doesn't click in prepare func in subjectTVC")
        }
    }
    // MARK: Unwind func to get the subject and add it to the subjects array in workDay
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? AddSubjectController else {
            fatalError("PROBLEM WITH: sourceViewController = sender.source as? AddSubjectController, workDay = sender.workDay! ")
        }
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Update an existing subject.
            workDay!.subjects![selectedIndexPath.row] = sourceViewController.subject!
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            // Add a new subject (tuka neznam dali u newIndexPath e ok toa so ?)
            if workDay?.subjects == nil {
                workDay?.subjects = []
            }
            workDay?.subjects?.append(sourceViewController.subject!)
            let newIndexPath = IndexPath(row: workDay!.subjects!.count - 1 , section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: Functions:
    
    func loadTheAd() {
        // Make an add and load it
        interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-5964354923224585/8848786952")
        let request = GADRequest()
        //        request.testDevices = [kGADSimulatorID]
        interstitialAd.load(request)
    }
    
    func presentAd() {
        if interstitialAd.isReady {
            interstitialAd.present(fromRootViewController: self)
        } else {
            print("Ad is not ready - it is not loaded")
        }
    }
    
    @IBAction func actionThatPresentsAd(_ sender: UIBarButtonItem) {
        presentAd()
    }
    func setupDeleteButton() {
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            buttonEditRearrangeCells.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!], for: UIControlState.normal)
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE": // odlicno e 2.12
            buttonEditRearrangeCells.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 17)!], for: UIControlState.normal)
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8": // ne e 15 19 bese
            buttonEditRearrangeCells.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 19)!], for: UIControlState.normal)
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus": // odlicno e 2.12
            buttonEditRearrangeCells.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 21)!], for: UIControlState.normal)
        case "iPhone X":                                    // odlicno e 2.12
            buttonEditRearrangeCells.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!], for: UIControlState.normal)
        default:
            buttonEditRearrangeCells.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 18)!], for: UIControlState.normal)
        }
    }
}

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        if UIDevice.current.orientation.isLandscape != true {
//            SubjectsTableViewController.noSubjectsLabel.removeFromSuperview()
//            if workDay?.subjects?.count ?? 0 == 0 {
//                checkIfNoSubjects(changingOrientation: true)
//            }
//        }
//    }







