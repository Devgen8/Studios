
import UIKit

class BookingDetailsViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var fullPriceLabel: UILabel!
    @IBOutlet weak var servicesTableView: UITableView!
    
    var model = BookingDetailsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        configureTableView()
    }
    
    func prepareData() {
        model.convertDictToArray()
        dateLabel.text = model.getDateString()
        surnameLabel.text = model.getSurname()
        nameLabel.text = model.getName()
        phoneNumberLabel.text = model.getPhoneNumber()
        fullPriceLabel.text = model.getFullPrice()
    }
    
    func configureTableView() {
        servicesTableView.dataSource = self
        servicesTableView.delegate = self
        servicesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "serviceCell")
    }
    
    @IBAction func okTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension BookingDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.getNumberOfServices()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell")!
        cell.textLabel?.text = model.getServiceString(for: indexPath.row)
        return cell
    }
}

extension BookingDetailsViewController: UITableViewDelegate {
    
}
