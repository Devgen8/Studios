
import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var servicesTableView: UITableView!
    private var loaderView = UIActivityIndicatorView()
    private var blurEffectView = UIVisualEffectView()
    
    var model = SettingsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationItem()
        prepareData()
        addBlurView()
        addLoaderView()
    }
    
    func prepareData() {
        showLoadingScreen()
        model.getPriceList {
            DispatchQueue.main.async {
                self.hideLoadingScreen()
                self.servicesTableView.reloadData()
            }
        }
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addService))
        self.navigationItem.rightBarButtonItem  = addButton
    }
    
    @objc func addService() {
        let alertSheet = UIAlertController(title: "Добавление услуги", message: "Куда добавить услугу?", preferredStyle: .actionSheet)
        let instrumentAction = UIAlertAction(title: "Инструмент", style: .default) { (_) in
            self.model.setServiceType(.instrument)
            self.presentAddingAlert()
        }
        let extraServiceAction = UIAlertAction(title: "Дополнительные услуги", style: .default) { (_) in
            self.model.setServiceType(.extraService)
            self.presentAddingAlert()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        alertSheet.addAction(instrumentAction)
        alertSheet.addAction(extraServiceAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true)
    }
    
    private func presentAddingAlert() {
        let alertViewController = UIAlertController(title: "Новая услуга / инструмент", message: "Заполните данные", preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Название"
        }
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Цена"
        }
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (alertAction) in
            self.model.addService(name: alertViewController.textFields?[0].text,
                                    price: alertViewController.textFields?[1].text) { (error) in
                if let error = error {
                    self.presentNonActionAlert(message: error)
                    return
                }
                DispatchQueue.main.async {
                    self.servicesTableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(addAction)
        present(alertViewController, animated: true)
    }
    
    private func presentNonActionAlert(message: String) {
        let testAlertController = UIAlertController(title: "Ошибка добавления", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        testAlertController.addAction(ok)
        self.present(testAlertController, animated: true)
    }
    
    func configureTableView() {
        servicesTableView.delegate = self
        servicesTableView.dataSource = self
        let nibCell = UINib(nibName: "ServiceTableViewCell", bundle: nil)
        servicesTableView.register(nibCell, forCellReuseIdentifier: "ServiceTableViewCell")
    }
    
    //MARK: - Loading Screen
    
    private func showLoadingScreen() {
        view.bringSubviewToFront(blurEffectView)
        view.bringSubviewToFront(loaderView)
        loaderView.startAnimating()
    }
    
    private func hideLoadingScreen() {
        view.sendSubviewToBack(blurEffectView)
        view.sendSubviewToBack(loaderView)
        loaderView.stopAnimating()
    }
    
    private func addBlurView() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    private func addLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loaderView)
        loaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 2).isActive = true
        loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.getNumberOfServices(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableViewCell", for: indexPath) as! ServiceTableViewCell
        cell.serviceNameLabel.text = model.getServiceName(for: indexPath)
        cell.priceLabel.text = model.getPriceString(for: indexPath)
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Инструменты"
        case 1: return "Дополнительные услуги"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let priceString = model.getPriceString(for: indexPath)
        let serviceName = model.getServiceName(for: indexPath)
        let alertViewController = UIAlertController(title: "Изменение данных", message: "Измените данные об услуге / инструменте", preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Название"
            textField.text = serviceName
        }
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Цена"
            textField.text = priceString
        }
        let addAction = UIAlertAction(title: "Изменить", style: .default) { (alertAction) in
            self.model.editService(name: alertViewController.textFields?[0].text,
                                    price: alertViewController.textFields?[1].text,
                                    indexPath: indexPath) { (error) in
                if let error = error {
                    self.presentNonActionAlert(message: error)
                    return
                }
                DispatchQueue.main.async {
                    self.servicesTableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(addAction)
        present(alertViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.deleteService(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
