//
//  UITableViewCoell.swift
//  LessonFileManager
//
//  Created by Сергей Штейман on 25.03.2022.
//

import UIKit

extension UITableViewCell {
    
    class var myReuseId: String {
        return String(describing: Self.self)
    }
}
