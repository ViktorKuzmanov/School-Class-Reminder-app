///
//  FirstNotificationTime.swift
//  
//
//  Created by Viktor Kuzmanov on 11/18/17.
//

import UIKit

class FirstNotificationTime: UIViewController {

    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var labelDefaultTime: UILabel!
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    var holdTextFieldText = "" // voa e samo vrednosta so se prefrla od workdayVC od userdefaults ako ne e first time launch , inaku firstTimeNot se dedelue na vaa promenliva
    var selectedMinutes: Int? // is nil when view loaded and chages based on selected row sekoj pat kaa ce smenis red u picker
    var saveButtonPressed = false
    var arrayForMinutes = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if holdTextFieldText == "0" {
            labelDefaultTime.text = "Default time"
        }
        textFieldTime.text = holdTextFieldText // updating the textField with the actual time
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        for row in 0...59 {
            arrayForMinutes.append(row)
        }
        createToolbar()
        createMinutePicker()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            if saveButtonPressed != true {
                // here I don't need to execute code the back button is pressed
            } else {
            }
        }
        if let selection = selectedMinutes {
            print()
            print("selection = ",selection)
            print()
            UserDefaults.standard.set(selection, forKey: "selectedRow")
        }
    }
    func createMinutePicker() {
        let minutePicker = UIPickerView()
        minutePicker.delegate = self
        minutePicker.dataSource = self
        textFieldTime.inputView = minutePicker
        minutePicker.selectRow(0, inComponent: 0, animated: false)
        
        var selectedRow: Int? {
            if UserDefaults.standard.object(forKey: "selectedRow") != nil {
                print("Not first launch in selectedRow in createMinutPicker actually bro")
                if let savedSelection = UserDefaults.standard.object(forKey: "selectedRow") as? Int {
                    return savedSelection
                }
            } else {
                print("First lauch, u selectedERow u createMinutePicker")
                UserDefaults.standard.set(0, forKey: "selectedRow")
                return 0
            }
            return 23
        }
        minutePicker.delegate = self
        minutePicker.dataSource = self
        if let row = arrayForMinutes.index(of: selectedRow!) {
            minutePicker.selectRow(row, inComponent: 0, animated: false)
        }
        
        // Customizations
        minutePicker.backgroundColor = #colorLiteral(red: 0, green: 0.3218498528, blue: 0.4239894152, alpha: 1)
    }
    func createToolbar() {
        // Create the toolBar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(FirstNotificationTime.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        textFieldTime.inputAccessoryView = toolBar
        
        // Customizations for toolBar
        toolBar.barTintColor = #colorLiteral(red: 0, green: 0.3218498528, blue: 0.4239894152, alpha: 1)
        toolBar.tintColor = #colorLiteral(red: 0.61177212, green: 0.7757492661, blue: 0.8644698262, alpha: 1) // the color of the text
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension FirstNotificationTime: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayForMinutes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: arrayForMinutes[row]) // tuka ne e vaka kajnego
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMinutes = arrayForMinutes[row]
        textFieldTime.text = String(describing: selectedMinutes!)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 43
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Menlo-Regular", size: 35)
        label.text = String(arrayForMinutes[row])
        
        if row != 0 {
            labelDefaultTime.text = "Custom time"
        } else {
            labelDefaultTime.text = "Default time"
        }
        
        return label
    }
    
    // MARK: Prepare for workDayTVC currently not needed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let workDayTVC = segue.destination as? WorkingDaysTableViewController else {
//            fatalError("segue.destination PROBLEM")
//        }
        saveButtonPressed = true
    }

}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
