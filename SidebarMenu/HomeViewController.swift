//
//  HomeViewController.swift
//  SidebarMenu
//
//  Created by 李日杰 on 2021/1/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    var delegate: MenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.isToolbarHidden = false
        
        self.view.backgroundColor = .white
        let label = UILabel()
        label.text = "HomeViewController"
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        setNavigation()
    }
    
    func setNavigation() {
        self.navigationItem.title = "HOME"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(handleMenu))
    }

    @objc func handleMenu() {
        delegate?.menuHandler(index: -1)
    }
}

protocol MenuDelegate {
    func menuHandler(index: Int)
}
