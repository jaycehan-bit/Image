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
        tableView.register(JCTableViewCell.self, forCellReuseIdentifier: JCTableViewControllerData.JCTableViewCellIdentifier)
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var viewModelList: NSArray?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        var array = NSMutableArray.init(array: [])
        for imageName in JCTableViewControllerData.JCImageNameList {
            let viewModel = JCTableViewCellViewModel(title: imageName, subTitle: nil, imageName: imageName)
            array.add(viewModel)
        }
        self.viewModelList = array.copy() as? NSArray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view .addSubview(self.tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
}

extension JCTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

extension JCTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JCTableViewCell = tableView.dequeueReusableCell(withIdentifier: JCTableViewControllerData.JCTableViewCellIdentifier, for: indexPath) as! JCTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModelList?.count ?? 0
    }
}
