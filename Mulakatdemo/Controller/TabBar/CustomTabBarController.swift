//
//  CustomTabBarController.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 2.11.2024.
//

import UIKit

class CustomTabBarController : UITabBarController,UITabBarControllerDelegate {
    
    let plusButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        
        setupPlusButton()
        
        setupViewControllers()
        
        self.delegate = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

        var newTabBarFrame = tabBar.frame
        newTabBarFrame.size.height = 100
        newTabBarFrame.origin.y = view.frame.height - 100
        tabBar.frame = newTabBarFrame
        
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDetailViewAppearance), name: NSNotification.Name("DetailViewAppeared"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDetailViewDisappearance), name: NSNotification.Name("DetailViewDisappeared"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("DetailViewAppeared"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("DetailViewDisappeared"), object: nil)
    }
    
    
    
    private func setupTabBar(){
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor.orange
        tabBar.unselectedItemTintColor = UIColor.gray
        tabBar.layer.cornerRadius = 30
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let cutoutPath = UIBezierPath(rect: tabBar.bounds)
        let cutoutRadius : CGFloat = 65
        let centerX = tabBar.bounds.width / 2
        let cutoutCircle = UIBezierPath(arcCenter: CGPoint(x: centerX, y: 0), radius: cutoutRadius, startAngle: 0, endAngle: .pi, clockwise: true)
        cutoutPath.append(cutoutCircle)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = cutoutPath.cgPath
        maskLayer.fillRule = .evenOdd
        tabBar.layer.mask = maskLayer
        
        
        
        let attributes =  [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8)]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    private func setupPlusButton(){
        let plusImage = UIImage(named: "plus")
        plusButton.setImage(plusImage, for: .normal)
        plusButton.frame.size = CGSize(width: 99, height: 99)
        plusButton.backgroundColor = .white
        plusButton.layer.backgroundColor = UIColor.white.cgColor
        plusButton.layer.cornerRadius = plusButton.frame.size.width / 2
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowOpacity = 0.25
        plusButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        plusButton.layer.shadowRadius = 10
        
        if let tabBarFrame = tabBar.frame as CGRect? {
            plusButton.center = CGPoint(x: tabBarFrame.midX, y: tabBarFrame.minY - plusButton.frame.height / 2)
        }
        
        view.addSubview(plusButton)
        
        
        
    }
    
    @objc private func didTapPlusButton(){
        print("plus butonuna tıklandı")
    }
    
    
    private func setupViewControllers() {
            let kitchenVC = KitchenViewController(nibName: "KitchenViewController", bundle: nil)
            let kitchenNavController = UINavigationController(rootViewController: kitchenVC)
            kitchenVC.tabBarItem = UITabBarItem(title: "Mutfak", image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal), tag: 0)
            
            let searchVC = SearchViewContoller(nibName: "SearchViewController", bundle: nil)
            let searchNavController = UINavigationController(rootViewController: searchVC)
            searchVC.tabBarItem = UITabBarItem(title: "Ara", image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), tag: 1)
            
            let addItemVC = AddItemViewController(nibName: "AddItemViewController", bundle: nil)
            addItemVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), tag: 2)

            let storiesVC = StoriesViewController(nibName: "StoriesViewController", bundle: nil)
            let storiesNavController = UINavigationController(rootViewController: storiesVC)
            storiesVC.tabBarItem = UITabBarItem(title: "Hikayeler", image: UIImage(named: "stories")?.withRenderingMode(.alwaysOriginal), tag: 3)
            
            let nearbyVC = NearbyKitchensViewController(nibName: "NearbyKitchensViewController", bundle: nil)
            let nearbyNavController = UINavigationController(rootViewController: nearbyVC)
            nearbyVC.tabBarItem = UITabBarItem(title: "Yakınımdaki Mutfaklar", image: UIImage(named: "location")?.withRenderingMode(.alwaysOriginal), tag: 4)
            
            viewControllers = [kitchenNavController, searchNavController, addItemVC, storiesNavController, nearbyNavController]
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            if viewController is KitchenViewController {
                print("Mutfak sekmesi seçildi")
            } else {
                tabBarController.selectedIndex = 0
            }
        }
    
    // Detay sayfasında butonu gizle
    @objc func handleDetailViewAppearance() {
        plusButton.isHidden = true
    }

    // Detay sayfasından çıkarken butonu tekrar göster
    @objc func handleDetailViewDisappearance() {
        plusButton.isHidden = false
    }
    
}
