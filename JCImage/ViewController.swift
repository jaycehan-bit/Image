//
//  ViewController.swift
//  JCImage
//
//  Created by 智杰韩 on 2023/10/25.
//

import UIKit

struct ViewControllerData {
    static let gJCImageCellIdentifier: String = "gJCImageCellIdentifier"
    static let JCImageNameList = ["Riven.jpg",  "Seraphine.jpg", "Akali.jpg", "Teemo.png", "Katarina.jpg"]
}

class ViewController: UIViewController {
    
    let serialQueue = dispatch_queue_serial_t(label: "com.github.jaycehan.bit.JCImage.serialQueue")
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func loadView() {
        let window = JCCommonUnit.mainWindow()
        self.view = JCView(frame: window.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JCCommonUnit.mainWindow().bounds.size.width / 1.7778
    }
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: JCImageTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerData.gJCImageCellIdentifier) as? JCImageTableViewCell
        if (cell == nil) {
            cell = JCImageTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: ViewControllerData.gJCImageCellIdentifier)
        }
        cell?.refreshImage(named: ViewControllerData.JCImageNameList[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewControllerData.JCImageNameList.count
    }
    
}


extension ViewController : UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        serialQueue.async {
            
        }
    }
}
