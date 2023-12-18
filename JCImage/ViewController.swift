//
//  ViewController.swift
//  JCImage
//
//  Created by 智杰韩 on 2023/10/25.
//

import UIKit

struct ViewControllerData {
    static let gJCImageCellIdentifier: String = "gJCImageCellIdentifier"
    static let JCImageNameList = ["JCImage.JCTableViewController",  "JCImage.JCGLViewController", "JCImage.ModuleController"]
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
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let className = ViewControllerData.JCImageNameList[indexPath.row]
        guard let controllerClass = NSClassFromString(className) else {
            JCStackFrameProvider.provideStackFrame {
                JCStackFrameCatcher.run()
            }
            return
        }
        guard let _controllerClass = controllerClass as? UIViewController.Type else {
            return
        }
        let controller = _controllerClass.init(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(controller , animated: true)
    }
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: ViewControllerData.gJCImageCellIdentifier) as? JCImageTableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: ViewControllerData.gJCImageCellIdentifier)
        }
        var configuration = UIListContentConfiguration.cell()
        configuration.text = ViewControllerData.JCImageNameList[indexPath.row]
        configuration.textProperties.font = UIFont.systemFont(ofSize: 18.0)
        cell?.contentConfiguration = configuration
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewControllerData.JCImageNameList.count
    }
    
}
