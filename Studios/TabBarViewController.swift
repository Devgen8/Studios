
import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
    }
    
    func setupTabBarItems() {
        let studioItem = UITabBarItem(title: "Студия", image: nil, selectedImage: nil)
        let studiosViewController = UINavigationController(rootViewController: StudiosViewController())
        studiosViewController.navigationBar.topItem?.title = "Студия"
        studiosViewController.tabBarItem = studioItem
        
        let clientsItem = UITabBarItem(title: "Клиенты", image: nil, selectedImage: nil)
        let clientsViewController = UINavigationController(rootViewController: ClientsViewController())
        clientsViewController.navigationBar.topItem?.title = "Клиенты"
        clientsViewController.tabBarItem = clientsItem
        
        let servicesItem = UITabBarItem(title: "Настройки", image: nil, selectedImage: nil)
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        settingsViewController.navigationBar.topItem?.title = "Настройки"
        settingsViewController.tabBarItem = servicesItem
        
        viewControllers = [studiosViewController, clientsViewController, settingsViewController]
    }
}

