
import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUpModel {
    
    let usersReference = Firestore.firestore().collection("users")
    
    //MARK: - Registration
    
    func createUser(user: NewUser,
                    completion: @escaping (String?) -> ()) {
        if let fieldFillingError = checkUsersData(user: user) {
            completion(fieldFillingError)
            return
        }
        
        guard let email = user.email,
              let password = user.password else {
            completion("Заполнены не все поля")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error != nil {
                completion("Возникли некоторые сложности, попробуйте чуть позже")
            } else {
                self.saveUsersData(user: user)
                completion(nil)
            }
        }
    }
    
    //MARK: - Data saving
    
    private func saveUsersData(user: NewUser) {
        if let userId = Auth.auth().currentUser?.uid {
            usersReference.document(userId).setData(["phoneNumber" : user.phoneNumber ?? "",
                                                     "name" : user.name ?? "",
                                                     "surname" : user.surname ?? "",
                                                     "fathersName" : user.fathersName ?? "",
                                                     "email" : user.email ?? ""])
        }
    }
    
    //MARK: - Data checking
    
    private func checkUsersData(user: NewUser) -> String? {
        guard
            let name = user.name,
            name.trimmingCharacters(in: .whitespacesAndNewlines) != "",
            let surname = user.surname,
            surname.trimmingCharacters(in: .whitespacesAndNewlines) != "",
            let fathersName = user.fathersName,
            fathersName.trimmingCharacters(in: .whitespacesAndNewlines) != "",
            let phoneNumber = user.phoneNumber,
            phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines) != "",
            let email = user.email,
            let password = user.password else {
            return "Заполнены не все поля"
        }
        if let phoneChecking = checkPhoneNumber(phoneNumber) {
            return phoneChecking
        }
        if let emailChecking = checkEmail(email) {
            return emailChecking
        }
        if let passwordChecker = checkPassword(password: password) {
            return passwordChecker
        }
        return nil
    }
    
    private func checkPhoneNumber(_ phoneNumber: String) -> String? {
        let acceptedSymbols = "+-()0123456789"
        for letter in phoneNumber {
            if !acceptedSymbols.contains(letter) {
                return "Номер телефона содержит недопустимые символы. Образец: +7(999)-567-65-89"
            }
        }
        return nil
    }
    
    private func checkEmail(_ email: String) -> String? {
        if !(email.contains("@") && email.contains(".")) ||
           email.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Пожалуйста, заполните почту в соответствии со следующим форматом: example@gmail.com"
        }
        return nil
    }
    
    private func checkPassword(password: String) -> String? {
        if password.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.count < 8 {
            return "Пароль должен быть не менее 8 символов"
        }
        return nil
    }
}
