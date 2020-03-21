//
//  WalkthroughController.swift
//  School Class Scedule
//
//  Created by Viktor Kuzmanov on 11/25/17.
//

import UIKit

class WalkthroughController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // za kaa ce svrtis od portrait u landscape se da bide ok e voa mora da se implement
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        }) { (_) in
        }
    }
    
    let pages = [
        Page(imageName: "mondayAndTuesday - ok all devices", headerText: "Make subject reminders for every day and activate/deactivate them on the switch on the right", bodyText: "If you make changes to reminders to update them just turn them on and off again"),
        Page(imageName: "secondImage", headerText: "In the Detail List you can see subjects that you have for today or tomorrow", bodyText: "Customize this feature in Settings"),
        Page(imageName: "navBarSettingsImage", headerText: "You can customize how much minutes you want your first reminder of the day to be delivered before its deliver time", bodyText: ""),
        Page(imageName: "viewButtonFromX", headerText: "Swipe left and press View on reminder to see all reminders for that day", bodyText: "For this to work you need to update reminders  before the first one gets delivered.Come back on this walkthrough in settings")
    ]

    
    private let buttonPrevious: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BACK", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // enable autolayout constraints
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(#colorLiteral(red: 0.677467823, green: 0.7337928414, blue: 0.8285800219, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(cancelWalkthroughtController), for: .touchUpInside)
        return button
    }()
    
    private let buttonNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false // enable autolayout constraints
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(#colorLiteral(red: 0.7667652965, green: 0.8475571871, blue: 0.9928130507, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.7667652965, green: 0.8475571871, blue: 0.9928130507, alpha: 1)
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.324044615, green: 0.4596852064, blue: 0.6928163171, alpha: 1)
        return pc
    }()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {   
        super.viewDidLoad()
        
        let tabBarImitation = UIView()
        tabBarImitation.backgroundColor = UIColor.red
        
        
//        collectionView?.backgroundColor = #colorLiteral(red: 0.2278245687, green: 0.3880195618, blue: 0.6711142659, alpha: 1)
        
        collectionView?.backgroundView = UIImageView(image: UIImage(named: "walkthroughBG"))
        
        setupBottomControls()
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        // Make scrollDirection of this horizontal
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView?.isPagingEnabled = true
    }
    
    fileprivate func setupBottomControls() {
        
        let stackViewBottomConstrols = UIStackView(arrangedSubviews: [buttonPrevious,pageControl,buttonNext])
        stackViewBottomConstrols.translatesAutoresizingMaskIntoConstraints = false
        stackViewBottomConstrols.distribution = .fillEqually
        view.addSubview(stackViewBottomConstrols)
        
        stackViewBottomConstrols.heightAnchor.constraint(equalToConstant: 50)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                stackViewBottomConstrols.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                stackViewBottomConstrols.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                stackViewBottomConstrols.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                ])
        } else {
            NSLayoutConstraint.activate([
                stackViewBottomConstrols.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
                stackViewBottomConstrols.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackViewBottomConstrols.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
        }
    }
    
    // MARK: CollectionView methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
//        cell.logo.image = UIImage(named: page.imageName)
//        cell.descriptionTextView.text = page.headerText
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
    // MARK: Kaa userot samo scroll prave
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width) // -> toa e kaa ce scroll na koa page sme
        
        // ako e na vtorata neka se pojave PREV button oti kje ni treba
        if pageControl.currentPage == 1 {
            buttonPrevious.removeTarget(nil, action: nil, for: .allEvents)
            buttonPrevious.setTitle("PREV", for: .normal)
            buttonPrevious.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        }
        // ako e na prvata ne ni treba back button
        if pageControl.currentPage == 0 {
            buttonPrevious.setTitle("BACK", for: .normal)
            buttonPrevious.addTarget(self, action: #selector(cancelWalkthroughtController), for: .touchUpInside)
        }
        // ako e momentalno na poslednata neka se prave finish action i title
        if pageControl.currentPage == pages.count - 1 {
            buttonNext.setTitle("DONE", for: .normal)
            buttonNext.addTarget(self, action: #selector(cancelWalkthroughtController), for: .touchUpInside) // na fishish kopceto mu daame action da ispadne
        }
        // ako e na predposlednata strana pa da bide next za da moze da otide na poslednata
        if pageControl.currentPage == pages.count - 2 {
            buttonNext.removeTarget(self, action: #selector(cancelWalkthroughtController), for: .touchUpInside)
            buttonNext.setTitle("NEXT", for: .normal)
        }
    }
    
    
    // MARK: Other functions (previous, next, cancel)
    @objc private func handlePrevious() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        if pageControl.currentPage == pages.count - 1 {
            buttonNext.removeTarget(self, action: #selector(cancelWalkthroughtController), for: .touchUpInside)
            buttonNext.setTitle("NEXT", for: .normal)
        }
        pageControl.currentPage = nextIndex
        if nextIndex == 0 {
            buttonPrevious.setTitle("BACK", for: .normal)
            buttonPrevious.addTarget(self, action: #selector(cancelWalkthroughtController), for: .touchUpInside)
        }
        print("nextIndex u handlePrevious = \(nextIndex)")
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        // ako slednata page e poslednata (predposledna = pages.count - 2) togi na slednata DONE da ima
        if pageControl.currentPage == pages.count - 2 {
            buttonNext.setTitle("DONE   ", for: .normal)
            buttonNext.addTarget(self, action: #selector(cancelWalkthroughtController), for: .touchUpInside) // na fishish kopceto mu daame action da ispadne
        }
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        if nextIndex == 1 {
            buttonPrevious.removeTarget(nil, action: nil, for: .allEvents)
            buttonPrevious.setTitle("PREV", for: .normal)
            buttonPrevious.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        }
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        print("nextIndex u handleNext = \(nextIndex)")
    }
    
    @objc private func cancelWalkthroughtController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
