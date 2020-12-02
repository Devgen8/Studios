
import UIKit
import FSCalendar

class StudiosViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var scheduleCollectionView: UICollectionView!
    @IBOutlet weak var timePickingSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigationItem()
        timePickingSegmentedControl.isHidden = true
    }
    
    private func configureNavigationItem() {
        let bookButton = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(bookTapped))
        self.navigationItem.rightBarButtonItem  = bookButton
    }
    
    @objc private func bookTapped() {
        
    }
    
    private func configureCollectionView() {
        let nibCell = UINib(nibName: "TimeCollectionViewCell", bundle: nil)
        scheduleCollectionView.register(nibCell, forCellWithReuseIdentifier: "TimeCollectionViewCell")
        scheduleCollectionView.collectionViewLayout = getCellsLayout()
        scheduleCollectionView.delegate = self
        scheduleCollectionView.dataSource = self
    }
    
    @IBAction func statusDetailsTapped(_ sender: UIButton) {
    }
    
    func getCellsLayout() -> UICollectionViewFlowLayout {
        let itemSize = UIScreen.main.bounds.width / 3 - 23
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: 60)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        return layout
    }
}

extension StudiosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCollectionViewCell", for: indexPath) as! TimeCollectionViewCell
        cell.timeLabel.text = "\(indexPath.row + 8):00"
        cell.backgroundColor = .blue
        return cell
    }
}

extension StudiosViewController: UICollectionViewDelegate {
    
}
