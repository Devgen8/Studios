
import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.windows.first?.rootViewController = self
        setupTabBarItems()
    }
    
    func setupTabBarItems() {
        let trainerItem = UITabBarItem(title: "Студии", image: nil, selectedImage: nil)
        let studiosViewController = StudiosViewController()
        studiosViewController.tabBarItem = trainerItem
        
        viewControllers = [studiosViewController]
    }
}

