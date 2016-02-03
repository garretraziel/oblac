//
//  VpsCellTableViewCell.swift
//  oblac
//
//  Created by Radka Mokrá on 24.10.14.
//  Copyright (c) 2014 GVID. All rights reserved.
//

import UIKit

class VpsCellTableViewCell: UITableViewCell {
    @IBOutlet weak var vpsLabel: UILabel!
    @IBOutlet weak var vpsLogo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(name: String, distro: String) {
        self.vpsLabel.text = name
        let image = UIImage(named: resolveIcon(distro))
        self.vpsLogo.image = image
    }
}

func resolveIcon(distro: String) -> String {
    var lowerstring = distro.lowercaseString
    for distro in ["fedora", "gentoo", "opensuse", "arch", "centos", "debian", "scientific", "ubuntu"] {
        if lowerstring.rangeOfString(distro) != nil {
            return distro
        }
    }
    return "linux"
}