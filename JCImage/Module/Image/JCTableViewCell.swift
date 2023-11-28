//
//  JCTableViewCell.swift
//  JCImage
//
//  Created by jaycehan on 2023/10/30.
//

import Foundation
import UIKit

class JCTableViewCell: UITableViewCell {
    private var viewModel: JCTableViewCellViewModel?
    func bind(viewModel: JCTableViewCellViewModel?) {
        self.viewModel = viewModel
    }
}
