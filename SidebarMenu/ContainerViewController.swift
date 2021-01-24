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
    var centerView: UIViewController!
    var homeView: HomeViewController!
    var isExpandMenu: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeFun()
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpandMenu
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    func setHomeFun() {
        if homeView == nil {
            homeView = HomeViewController()
            homeView.delegate = self
            centerView = UINavigationController(rootViewController: homeView)
            self.view.addSubview(centerView.view)
            addChild(centerView)
            centerView.didMove(toParent: self)
        }
    }
    
    func setHomeFun(index: Int) {
        switch index {
        case 1:
            configureMenu()
        case 2:
            homeView.navigationController?.pushViewController(FirstVC(), animated: true)
        case 3:
            print("Not implement: \(#filePath) - \(#line)")
        default:
            configureMenu()
        }
    }
    
    func configureMenu() {
        if menuView == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            menuView = storyboard.instantiateViewController(identifier: "MenuViewController") as MenuViewController
            menuView.delegate = self
            view.insertSubview(menuView.view, at: 0)
            addChild(menuView)
            menuView.didMove(toParent: self)
            print("configureMenu called")
        }
    }
    
    func configStatusbarAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func showMenu(isExpand: Bool) {
        if isExpand {
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.centerView.view.frame.origin.x = self.centerView.view.frame.width - 200
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.centerView.view.frame.origin.x = 0
            }, completion: nil)
        }
        
        configStatusbarAnimation()
    }
}

class FirstVC: UIViewController {
    
}

extension ContainerViewController: MenuDelegate {
    func menuHandler(index: Int) {
        if !isExpandMenu {
            configureMenu()
        }
        
        isExpandMenu = !isExpandMenu
        showMenu(isExpand: isExpandMenu)
        
        if index > -1 {
            setHomeFun(index: index)
        }
    }
}



