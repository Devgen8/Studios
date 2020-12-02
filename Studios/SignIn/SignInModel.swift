
import Foundation
import FirebaseAuth

class SignInModel {
    
    func authorizeUser(email: String?, password: String?, completion: @escaping (String?) -> ()) {
        guard let email = email,
              let password = password,
              email != "", password != "" else {
            completion("Заполнены не все поля")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion("Пользователь не существует")
            } else {
                completion(nil)
            }
        }
    }
}
