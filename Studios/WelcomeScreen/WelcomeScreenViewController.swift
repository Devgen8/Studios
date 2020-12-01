
import UIKit

class WelcomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func signInTapped(_ sender: UIButton) {
        let signInViewController = SignInViewController()
        signInViewController.modalPresentationStyle = .fullScreen
        present(signInViewController, animated: true)
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .fullScreen
        present(signUpViewController, animated: true)
    }
}
