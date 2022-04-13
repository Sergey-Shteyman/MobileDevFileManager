//
//  Router.swift
//  LessonFileManager
//
//  Created by Сергей Штейман on 10.01.2022.
//

import UIKit

// MARK: - RouterMain
protocol RouterMain {
    var navigationController: UINavigationController { get }
}

// MARK: - Router
class Router: RouterMain {
    var navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController(rootViewController: AuthViewController())
    }

}
