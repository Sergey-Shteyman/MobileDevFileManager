//
//  TextField.swift
//  LessonFileManager
//
//  Created by Сергей Штейман on 06.04.2022.
//

import UIKit

// MARK: - TextField
final class TextField: UITextField {
    
    let bottomLine = CALayer()
    var colorLine: UIColor = .lightGray
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.removeFromSuperlayer()
        addBottomLine(with: colorLine)
    }
}

// MARK: - Public Methods
extension TextField {
    
    func addBottomLine(with color: UIColor) {
        colorLine = color
        bottomLine.backgroundColor = colorLine.cgColor
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height + 12, width: self.frame.width, height: 1)
        layer.addSublayer(bottomLine)
    }
}


