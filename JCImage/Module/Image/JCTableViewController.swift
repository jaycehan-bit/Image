//
//  JCTableViewController.swift
//  JCImage
//
//  Created by jaycehan on 2023/10/30.
//

import Foundation
import UIKit

struct JCTableViewControllerData {
    static let JCTableViewCellIdentifier = "JCTableViewCellIdentifier"
    static let JCImageNameList = ["Riven.jpg",  "Seraphine.jpg", "Akali.jpg", "Teemo.png", "Katarina.jpg"]
}

class JCTableViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.register(JCImageTableViewCell.self, forCellReuseIdentifier: JCTableViewControllerData.JCTableViewCellIdentifier)
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view .addSubview(self.tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
}

extension JCTableViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JCCommonUnit.mainWindow().bounds.size.width / 1.7778
    }
}

extension JCTableViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: JCImageTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: JCTableViewControllerData.JCTableViewCellIdentifier) as? JCImageTableViewCell
        if (cell == nil) {
            cell = JCImageTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: JCTableViewControllerData.JCTableViewCellIdentifier)
        }
        cell?.refreshImage(named: JCTableViewControllerData.JCImageNameList[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JCTableViewControllerData.JCImageNameList.count
    }
}
