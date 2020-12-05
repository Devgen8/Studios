
import UIKit

class ClientsViewController: UIViewController {
    
    @IBOutlet weak var clientsTableView: UITableView!
    private var loaderView = UIActivityIndicatorView()
    private var blurEffectView = UIVisualEffectView()
    
    var model = ClientsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationItem()
        prepareData()
        addBlurView()
        addLoaderView()
    }
    
    private func configureNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClient))
        self.navigationItem.rightBarButtonItem  = addButton
    }
    
    @objc func addClient() {
        let alertViewController = UIAlertController(title: "Новый постоянный клиент", message: "Заполните данные о клиенте", preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Фамилия"
        }
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Имя Отчество"
        }
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Номер телефона"
        }
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (alertAction) in
            self.model.addNewClient(surname: alertViewController.textFields?[0].text,
                                    name: alertViewController.textFields?[1].text,
                                    phoneNumber: alertViewController.textFields?[2].text) { (error) in
                if let error = error {
                    self.presentNonActionAlert(message: error)
                    return
                }
                DispatchQueue.main.async {
                    self.clientsTableView.reloadData()
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
        clientsTableView.dataSource = self
        clientsTableView.delegate = self
        let nibCell = UINib(nibName: "ClientTableViewCell", bundle: nil)
        clientsTableView.register(nibCell, forCellReuseIdentifier: "ClientTableViewCell")
    }
    
    func prepareData() {
        showLoadingScreen()
        model.getClients {
            DispatchQueue.main.async {
                self.hideLoadingScreen()
                self.clientsTableView.reloadData()
            }
        }
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

extension ClientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNumberOfClients()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientTableViewCell", for: indexPath) as! ClientTableViewCell
        
        cell.surnameLabel.text = model.getClientSurname(for: indexPath.row)
        cell.nameLabel.text = model.getClientName(for: indexPath.row)
        cell.phoneNumberLabel.text = model.getClientPhoneNumber(for: indexPath.row)
        
        return cell
    }
}

extension ClientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let selectedClient = model.getClient(for: indexPath.row)
        let alertViewController = UIAlertController(title: "Изменение данных", message: "Измените данные о клиенте", preferredStyle: .alert)
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Фамилия"
            textField.text = selectedClient.surname
        }
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Имя Отчество"
            textField.text = selectedClient.name
        }
        alertViewController.addTextField { (textField) in
            textField.placeholder = "Номер телефона"
            textField.text = selectedClient.phoneNumber
        }
        let addAction = UIAlertAction(title: "Изменить", style: .default) { (alertAction) in
            self.model.editClient(surname: alertViewController.textFields?[0].text,
                                    name: alertViewController.textFields?[1].text,
                                    phoneNumber: alertViewController.textFields?[2].text,
                                    clientIndex: indexPath.row) { (error) in
                if let error = error {
                    self.presentNonActionAlert(message: error)
                    return
                }
                DispatchQueue.main.async {
                    self.clientsTableView.reloadData()
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
            model.deleteClient(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
