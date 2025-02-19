//
//  MenuViewController.swift
//  SidebarMenu
//
//  Created by 李日杰 on 2021/1/24.
//

import Foundation
import UIKit

protocol MenuDelegate {
    func menuHandler(index: Int)
}

class MenuViewController: UITableViewController {
    
    var delegate: MenuDelegate?
    // FIXME: - Menu header view
    //  var menuHeaderView: UIImageView!
    
    static var menus: [String] = ["Today", "Due", "Finished"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sideMenuItem")
    }
}

extension MenuViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Self.menus.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuItem")!
        
        cell.textLabel?.text = Self.menus[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.menuHandler(index: indexPath.row+1)
    }
}
