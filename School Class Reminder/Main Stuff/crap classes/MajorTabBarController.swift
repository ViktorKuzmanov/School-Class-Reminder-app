//
//  MajorTabBarController.swift
//  School Class Scedule
//
//  Created by Viktor Kuzmanov on 1/5/18.
//

import UIKit

class MajorTabBarController: UITabBarController {
    
    var key = "itIsNotfirstLaunchOfTheApp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
        //        Since you just want to blue the tab bar and this class is a tab bar controller, you can do:
        self.tabBar.addSubview(blurView)
        
        //        You also need to change the frame:
        blurView.frame = self.tabBar.bounds
        
        setTabBarItems()
        
    }
    func setTabBarItems() {
        
        // TabBarIcon1Works e 45x45 u sketch napraeno
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "neutralBellIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "highlightedBellIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem1.title = ""
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "neutralRucksackIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "highlightedRucksackIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myTabBarItem2.title = ""
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        //         tuka u itemWidth dane treba mainTabBar namesto view
        //        let itemWidth = self.view.frame.width / 2
        //        let itemHeight = mainTabBar.frame.height
        //        myTabBarItem2.accessibilityFrame = CGRect(x: itemWidth, y: self.view.frame.size.height - itemHeight, width: itemWidth, height: itemHeight)
    }
}


