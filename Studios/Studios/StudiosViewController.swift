
import UIKit

class StudiosViewController: UIViewController {

    @IBOutlet weak var studiosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studiosTableView.delegate = self
        studiosTableView.dataSource = self
    }
}

extension StudiosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Good"
        return cell
    }
}

extension StudiosViewController: UITableViewDelegate {
    
}
