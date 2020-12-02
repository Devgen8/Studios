
import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    var blurEffectView = UIVisualEffectView()
    
    private var model = SignInModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderView.hidesWhenStopped = true
        addBlurView()
    }
    
    private func presentNonActionAlert(message: String) {
        let testAlertController = UIAlertController(title: "Ошибка авторизации", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        testAlertController.addAction(ok)
        self.present(testAlertController, animated: true)
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        showLoadingScreen()
        model.authorizeUser(email: emailTextField.text, password: passwordTextField.text) { (problemString) in
            self.hideLoadingScreen()
            if let errorMessage = problemString {
                self.presentNonActionAlert(message: errorMessage)
            } else {
                let tabBarViewController = TabBarViewController()
                tabBarViewController.modalPresentationStyle = .fullScreen
                self.present(tabBarViewController, animated: true)
            }
        }
    }
    
    @IBAction func quitTapped(_ sender: UIButton) {
        dismiss(animated: true)
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
        view.sendSubviewToBack(blurEffectView)
    }
}
