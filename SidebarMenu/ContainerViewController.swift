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
    var menuShowUp: Bool = false
    
    let menuWidth: CGFloat = 200
    let panGestureSensitivity: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeView()
        setupGesture()
    }
    
    func setupGesture() {
        let panGuesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        centerView.view.addGestureRecognizer(panGuesture)
    }
    
    @objc func panGestureAction(_ recognizer: UIPanGestureRecognizer) {
        
        let screenCenterX = recognizer.view!.frame.width / 2
        let screenCenterXMenuShowUp = recognizer.view!.frame.width / 2 + menuWidth
        
        switch(recognizer.state) {
        case .began:
            setupMenuView()
        case .changed:
            let moveDistance = recognizer.translation(in: centerView.view).x
            if !menuShowUp {
                
                let newPosition = (recognizer.view?.center.x)! + moveDistance
                if moveDistance > 0 {
                    if newPosition >= screenCenterX
                    && recognizer.view!.center.x <= screenCenterXMenuShowUp {
                        recognizer.view?.center.x = newPosition
                        menuView.view.frame.origin.x = menuView.view.frame.origin.x + moveDistance
                        recognizer.setTranslation(.zero, in: centerView.view)
                    }
                }
            } else {
                let newPosition = (recognizer.view?.center.x)! + moveDistance
                if moveDistance < 0 {
                    if newPosition <= screenCenterXMenuShowUp
                    && recognizer.view!.center.x >= screenCenterX {
                        recognizer.view?.center.x = newPosition
                        menuView.view.frame.origin.x = menuView.view.frame.origin.x + moveDistance
                        recognizer.setTranslation(.zero, in: centerView.view)
                    }
                }
            }
        case .ended:
            if !menuShowUp {
                let endedCenter = recognizer.view!.center.x
                if abs(endedCenter - screenCenterX) > panGestureSensitivity {
                    menuHandler(index: -1)
                } else {
                    showOrHideMenu(show: false)
                }
            } else {
                let endedCenter = recognizer.view!.center.x
                if abs(endedCenter - screenCenterXMenuShowUp) > panGestureSensitivity {
                    menuHandler(index: -1)
                } else {
                    showOrHideMenu(show: true)
                }
            }
        default:
            break
        }
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
        return menuShowUp
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

extension ContainerViewController: MenuDelegate {
    func menuHandler(index: Int) {
        if !menuShowUp {
            setupMenuView()
        }
        
        menuShowUp = !menuShowUp
        showOrHideMenu(show: menuShowUp)
        
        if index > -1 {
            homeViewSwitchToPage(at: index)
        }
    }
}

extension ContainerViewController {
    func homeViewSwitchToPage(at index: Int) {
        if index < 0 {
            setupMenuView()
        } else {
            let currentTitle = MenuViewController.menus[index-1]
            homeView.label.text = currentTitle + " Page"
            homeView.navigationItem.title = currentTitle
        }
    }
}

