//
//  ViewController.swift
//  School Class Scedule
//
//  Created by Viktor Kuzmanov on 10/1/17.
//

import UIKit
import CoreData

class AddSubjectController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    var subject: Subject?
    var workDay: Day?
    var time2: Date?
    var subjectKaaSoDosolOdSubjectTVC: Subject?
    var ifEditingExistingSubject: Bool? // in prepare() to see if it should check for duplicate subjects or not
    @IBOutlet weak var toolBarChangeMinInterval: UIToolbar!
    
    @IBOutlet weak var buttonMinuteInterval: UIButton!
    @IBOutlet weak var textFieldSubjectName: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var timePicker2: UIDatePicker!
    @IBOutlet weak var buttonCancel: UIBarButtonItem!
    
    // Via ako ne gi koristam moze da gi izbrisam i da gi delete connnections
    @IBOutlet weak var labelEndsAt: UILabel!  // ustvari toa e set notification label ??
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if ifEditingExistingSubject != true {
            // set time to timePicker2 to the last added subject
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            if workDay?.subjects?.count ?? 0 != 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                if let startsAt = workDay?.subjects?.last?.startsAt {
                    if let date = dateFormatter.date(from: startsAt) {
                        timePicker2.date = date
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSaveAndCancel()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.textFieldSubjectName.textAlignment = .center
        textFieldSubjectName.font = UIFont(name: "Hiragino Mincho Pron", size: 24)
        tabBarController?.tabBar.isHidden = true
        
        // bojata na timePicker da a stajme
        timePicker2.setValue(UIColor.white, forKey: "textColor")
        // This is like an unwind thing if we are editing an existing subject
        if let subject = subject {
            textFieldSubjectName.text = subject.subjectName
        }
        if let time2 = time2 {
            timePicker2.isHidden = false
            timePicker2.date = time2
            saveButton.isEnabled = true
        } else {
            // timePicker2.isHidden = true
            saveButton.isEnabled = false
        }
        textFieldSubjectName.borderStyle = UITextBorderStyle.roundedRect
        textFieldSubjectName.delegate = self
        self.timePicker2.datePickerMode = .time
        if ifEditingExistingSubject == false {
            self.timePicker2.minuteInterval = 5
        }
    }
    
    // MARK: Create alert func
    func createAlertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: {
            (action) in alertController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: TextFieldDelegateStuff
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if !textField.text!.isEmpty {
            saveButton.isEnabled = true
        }
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeMinuteInterval(_ sender: UIButton) {
        if timePicker2.minuteInterval == 1 {
            self.timePicker2.minuteInterval = 5
        } else {
            self.timePicker2.minuteInterval = 1
        }
    }
    // MARK: shouldPerformSegue Func to check if it should present alert(make transition) or not
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Check if user deleted textField text and still wants to save subject with no name
        if let textInTextField = textFieldSubjectName.text {
            if textInTextField.isEmpty {
                createAlertMessage(title: "Invalid input", message: "Subject reminder has no name")
                return false
            }
        }
        // pise podole najgo e objasnoto zos e vaa array sozdadena za startsAt
        // treba da se sozdade za pred da se dodade imeto na subject da se zeme voa drugoto
        var workDayBezSubject = [Subject]()
        if ifEditingExistingSubject == true {
            if let subjectsInWorkDay = workDay?.subjects {
                workDayBezSubject = subjectsInWorkDay.filter({$0.subjectName != subject!.subjectName})
            }
        }
        let components2 = Calendar.current.dateComponents([.hour, .minute], from: timePicker2.date)
        
        var hours2 = 152512
        var minutes2 = 3525235
        if let hours = components2.hour {
            hours2 = hours
        }
        if let minutes = components2.minute {
            minutes2 = minutes
        }
        var startsAtOnAddingSubject = "initial value"
        
        // Da napraam da ima 2 nuli za da izgleda poubavo u subject TVC - labelEndsAt
        if hours2 >= 0 && hours2 <= 9 && minutes2 >= 0 && minutes2 <= 9 {
            startsAtOnAddingSubject =  "0\(hours2):0\(minutes2)"
        } else if hours2 >= 0 && hours2 <= 9 {
            startsAtOnAddingSubject =  "0\(hours2):\(minutes2)"
        } else if minutes2 >= 0 && minutes2 <= 9 {
            startsAtOnAddingSubject =  "\(hours2):0\(minutes2)"
        } else {
            startsAtOnAddingSubject =  "\(hours2):\(minutes2)"
        }
        
        if ifEditingExistingSubject == false {
            // znaci ne addnujme nov subject,
        }
        
        // Check if existing subject has same startsAt with another subject
        if ifEditingExistingSubject == true {
            // da a napraam taa niza za da moze da se prae check so nea(kaa ce edit existing subject da ne se se sporedue startsAt na tia subject so go kreirame tuka so tia so ne e updated subjec u workDayot(so e od subjectVC) tuka).
            for subject1 in workDayBezSubject {
                if startsAtOnAddingSubject == subject1.startsAt {
                    createAlertMessage(title: "Invalid input", message: "Reminder with that time already exists. Change deliver time and try again")
                    return false
                }
            }
        } else { // check for new adding subject if it has same endsAt with another subject
            if workDay?.subjects?.count ?? 0 != 0 {
                if let subjects = workDay?.subjects {
                    for subject1 in subjects {
                        if startsAtOnAddingSubject == subject1.startsAt {
                            createAlertMessage(title: "Invalid input", message: "Reminder with that time already exists. Change deliver time and try again")
                            return false
                        }
                    }
                }
            }
        }
        
        // ako se editira existing subject togas da go update i tia u coreData soodvetno
        if ifEditingExistingSubject == true {
            let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
            do {
                let allSavedSubjects = try PersistanceService.context.fetch(fetchRequest)
                print("allSavedSubjects.count = \(allSavedSubjects.count)")
                if allSavedSubjects.count > 0 {
                    for coreDataSubject in allSavedSubjects {
                        if coreDataSubject as NSManagedObject == subjectKaaSoDosolOdSubjectTVC {
                            if let textInTextField: String = textFieldSubjectName.text {
                                coreDataSubject.subjectName = textInTextField
                            }
                            coreDataSubject.startsAt = startsAtOnAddingSubject
                        }
                    }
                }
            } catch let error as NSError {
                print("Error \(error), \(error.userInfo)")
            }
        } else if ifEditingExistingSubject == false {
            // ako se add new subject togi i u coreData da dodadam nov
            subject = Subject(context: PersistanceService.context)
            if let dayName = workDay?.dayName {
                subject?.dayName = dayName
            }
            if let textInTextField: String = textFieldSubjectName.text {
                subject?.subjectName = textInTextField
            }
            subject?.startsAt = startsAtOnAddingSubject
        }
        
        PersistanceService.saveContext()
        SubjectsTableViewController.noSubjectsLabel.removeFromSuperview()
        return true
    }
    
//    //MARK:u gornata func se prae voa -Prepare for subjectsTVC - set values for startsAt and endsAt
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let subjectTVC = segue.destination as? SubjectsTableViewController else {
//            fatalError("segue.destination PROBLEM")
//        }
        
        // when the last propery of subject(startsAt) is added save everything to coreData
        PersistanceService.saveContext()
    }
    
    // MARK: Functions
    func setupSaveAndCancel() {
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            buttonCancel.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 15)!], for: UIControlState.normal)
            saveButton.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 15)!], for: UIControlState.normal)
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE": // odlicno e 2.12
            buttonCancel.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!], for: UIControlState.normal)
            saveButton.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 16)!], for: UIControlState.normal)
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8": // odlicno e 2.12
            buttonCancel.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 18)!], for: UIControlState.normal)
            saveButton.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 18)!], for: UIControlState.normal)
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus": // odlicno e 2.12
            buttonCancel.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!], for: UIControlState.normal)
            saveButton.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 20)!], for: UIControlState.normal)
        case "iPhone X":                                    // odlicno e 2.12
            buttonCancel.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 19)!], for: UIControlState.normal)
            saveButton.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Arial", size: 19)!], for: UIControlState.normal)
        default:
            print("DEFAULT")
        }
    }
}

extension UIButton {
    func addBlurEffect() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubview(toFront: imageView)
        }
    }
}


