
import UIKit

class BookingFormViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var instrumentsTableView: UITableView!
    @IBOutlet weak var fullPriceLabel: UILabel!
    
    var model = BookingFormModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillDateLabel()
    }
    
    func fillDateLabel() {
        dateLabel.text = model.getDateString()
    }
    
    @IBAction func bookTapped(_ sender: UIButton) {
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
