//
//  HomeViewController.swift
//  SidebarMenu
//
//  Created by 李日杰 on 2021/1/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    var delegate: MenuDelegate?
    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelf()
        setNavigation()
    }
    
    func setNavigation() {
        self.navigationItem.title = MenuViewController.menus[0]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(handleMenu))
        self.navigationItem.leftBarButtonItem?.tintColor = .gray
    }
    
    func setupSelf() {
        self.view.backgroundColor = .white
        label.text = MenuViewController.menus[0] + " Page"
        label.font = .systemFont(ofSize: 18)
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        label.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    @objc func handleMenu() {
        delegate?.menuHandler(index: -1)
    }
}
