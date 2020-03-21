//  Created by Viktor Kuzmanov on 1/9/18.
// VAA VERSION I E POPRAVENO TOA U FIRST CONTROLLER SO 1 SEA 0 SE POKAZUE

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var textViewWelcome: UITextView!
    @IBOutlet weak var stackViewVertical: UIStackView!
    @IBOutlet weak var textViewFirstSmall: UITextView!
    @IBOutlet weak var buttonContinueHeightConstraint: NSLayoutConstraint!
    
    // tuka bese staven tia glavniot kod za first launch
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "TermsAccepted") {
            print()
            print("Terms have been accepted, proceed as normal")
            let mainST = UIStoryboard(name: "Main", bundle: Bundle.main)
            let VC = mainST.instantiateViewController(withIdentifier: "TabBar39")
            self.present(VC, animated: true, completion: nil)
            print()
        } else {
            print()
            print("Terms have not been accepted. Show terms")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupContinueButtonHeight()
        setupTexFieldAndStack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonContinue.layer.cornerRadius = 9
        textViewWelcome.backgroundColor = .clear
        stackViewVertical.backgroundColor = .clear

    }
    
    fileprivate func setupContinueButtonHeight() {
        
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            buttonContinueHeightConstraint.constant = 100
            
        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE":
            buttonContinueHeightConstraint.constant = 40
            
        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8":
            buttonContinueHeightConstraint.constant = 43
            
        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus":
            buttonContinueHeightConstraint.constant = 45
            
        case "iPhone X":
            buttonContinueHeightConstraint.constant = 44
            
        default:
            buttonContinue.heightAnchor.constraint(equalToConstant: 40)
        }
    }
    
    func setupTexFieldAndStack() {
        
        let attributedText = NSMutableAttributedString(string: "Welcome to ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 40), NSAttributedStringKey.foregroundColor: UIColor.white])

        attributedText.append(NSAttributedString(string: "School Class Reminder", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 46), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0.1631153226, blue: 0.2130636871, alpha: 1)]))

        textViewWelcome.attributedText = attributedText
        textViewWelcome.textAlignment = .center
        
        //        da set up text na textFieldWelcome
        switch UIDevice.current.screenType.rawValue {
        case "iPhone 4 or iPhone 4S":
            textViewWelcome.font = UIFont(name: "Gujarati Sangam MN", size: 23)
            stackViewVertical.spacing = 15

        case "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE":
            textViewWelcome.font = UIFont(name: "Gujarati Sangam MN", size: 23)
            stackViewVertical.spacing = 17
            textViewWelcome.topAnchor.constraint(equalTo: view.topAnchor, constant: 31).isActive = true

        case "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8":
            textViewWelcome.font = UIFont(name: "Gujarati Sangam MN", size: 26)
            stackViewVertical.spacing = 30

        case "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus":
            textViewWelcome.font = UIFont(name: "Gujarati Sangam MN", size: 29)
            stackViewVertical.spacing = 40

        case "iPhone X":
            textViewWelcome.font = UIFont(name: "Gujarati Sangam MN", size: 28)
            stackViewVertical.spacing = 38

        default:
            textViewWelcome.font = UIFont(name: "Gujarati Sangam MN", size: 23)
        }
    }
    
    // To lock the smarthphone only in portrait mode (landscape disabled)
//    override var shouldAutorotate: Bool {
//        return false
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
//
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return .portrait
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



//    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask {
//        return UIInterfaceOrientationMask.portrait
//    }


//extension UINavigationController {
//    public override func shouldAutorotate() -> Bool {
//        return true
//    }
//
//    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return (visibleViewController?.supportedInterfaceOrientations())!
//    }
//}

