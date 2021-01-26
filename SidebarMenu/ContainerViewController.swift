//
//  ContainerViewController.swift
//  SidebarMenu
//
//  Created by 李日杰 on 2021/1/24.
//

import Foundation
import UIKit

class ContainerViewController: UIViewController {
    var menuView: MenuViewController!
    var centerView: UINavigationController!
    var homeView: HomeViewController!
    var ifMenuShowUp: Bool = false
    
    let menuWidth: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeView()
    }
    
    func setupHomeView() {
        if homeView == nil {
            homeView = HomeViewController()
            homeView.delegate = self
            centerView = UINavigationController(rootViewController: homeView)
            self.view.addSubview(centerView.view)
            addChild(centerView)
            centerView.didMove(toParent: self)
        }
    }
    
    func homeViewSwitchToPage(at index: Int) {
        switch index {
        case 1:
            setupMenuView()
        case 2:
            homeView.navigationController?.pushViewController(FirstVC(), animated: true)
        case 3:
            print("Not implement: \(#filePath) - \(#line)")
        default:
            setupMenuView()
        }
    }
    
    func setupMenuView() {
        if menuView == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            menuView = storyboard.instantiateViewController(identifier: "MenuViewController") as MenuViewController
            menuView.delegate = self
            view.insertSubview(menuView.view, at: 0)
            addChild(menuView)
            menuView.didMove(toParent: self)
            self.menuView.view.frame.origin.x = -menuWidth
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return ifMenuShowUp
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func configStatusbarAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func hasNotch() -> Bool {
        return self.view.safeAreaInsets.bottom > 20
    }
    
    func showOrHideMenu(show: Bool) {
        
        if show {
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.centerView.view.frame.origin.x = self.centerView.view.frame.width - self.menuWidth
                self.menuView.view.frame.origin.x = 0
                
                // IMPORTANT: The code below fix status bar shrink when device has no notch.
                if !self.hasNotch() {
                    self.additionalSafeAreaInsets.top = 20
                }
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.centerView.view.frame.origin.x = 0
                self.menuView.view.frame.origin.x = -self.menuWidth
                
                // IMPORTANT: The code below fix status bar shrink when device has no notch.
                if !self.hasNotch() {
                    self.additionalSafeAreaInsets.top = 0
                }
            }, completion: nil)
        }
        
        // Indicates system to hide status bar.
        configStatusbarAnimation()
    }

}

class FirstVC: UIViewController {
    
}

extension ContainerViewController: MenuDelegate {
    func menuHandler(index: Int) {
        if !ifMenuShowUp {
            setupMenuView()
        }
        
        ifMenuShowUp = !ifMenuShowUp
        showOrHideMenu(show: ifMenuShowUp)
        
        if index > -1 {
            homeViewSwitchToPage(at: index)
        }
    }
}



