//
//  JCImageTableViewCell.swift
//  JCImage
//
//  Created by jaycehan on 2023/10/27.
//

import UIKit

class JCImageTableViewCell: UITableViewCell {
    
    let imageContentView: UIImageView = UIImageView.init(frame: CGRect.zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(imageContentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageContentView.frame = self.contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func refreshImage(named: String) {
        self.imageContentView.image = JCImageLoader.image(name: named, downSampling: true, size: self.bounds.size)
    }

}
