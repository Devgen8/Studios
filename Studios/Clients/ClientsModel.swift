
import Foundation
import FirebaseFirestore

class ClientsModel {
    
    private let clientsReference = Firestore.firestore().collection("clients")
    
    private var clients = [Client]()
    
    func getClients(completion: @escaping () -> Void) {
        clientsReference.getDocuments { (snapshot, error) in
            guard error == nil, let documents = snapshot?.documents else {
                completion()
                return
            }
            for document in documents {
                var client = Client()
                client.name = document.data()["name"] as? String ?? ""
                client.surname = document.data()["surname"] as? String ?? ""
                client.phoneNumber = document.data()["phoneNumber"] as? String ?? ""
                client.creationDate = document.data()["creationDate"] as? String ?? ""
                self.clients.append(client)
            }
            completion()
        }
    }
    
    func getNumberOfClients() -> Int {
        return clients.count
    }
    
    func getClientName(for index: Int) -> String {
        return clients[index].name
    }
    
    func getClientSurname(for index: Int) -> String {
        return clients[index].surname
    }
    
    func getClientPhoneNumber(for index: Int) -> String {
        return clients[index].phoneNumber
    }
    
    func addNewClient(surname: String?,
                      name: String?,
                      phoneNumber: String?,
                      completion: (String?) -> Void) {
        guard let surname = surname, surname.trimmingCharacters(in: .whitespacesAndNewlines) != "",
              let name = name, name.trimmingCharacters(in: .whitespacesAndNewlines) != "",
              let phoneNumber = phoneNumber, phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            completion("Заполнены не все поля")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        let creationDate = dateFormatter.string(from: Date())
        clients.append(Client(creationDate: creationDate, surname: surname, name: name, phoneNumber: phoneNumber))
        clientsReference.document(creationDate).setData(["creationDate" : creationDate,
                                                         "surname" : surname,
                                                         "name" : name,
                                                         "phoneNumber" : phoneNumber])
        completion(nil)
    }
    
    func deleteClient(at index: Int) {
        let deletingClient = clients.remove(at: index)
        clientsReference.document(deletingClient.creationDate).delete()
    }
    
    func getClient(for index: Int) -> Client {
        return clients[index]
    }
    
    func editClient(surname: String?,
                    name: String?,
                    phoneNumber: String?,
                    clientIndex: Int,
                    completion: (String?) -> Void) {
        guard let surname = surname, surname.trimmingCharacters(in: .whitespacesAndNewlines) != "",
              let name = name, name.trimmingCharacters(in: .whitespacesAndNewlines) != "",
              let phoneNumber = phoneNumber, phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            completion("Заполнены не все поля")
            return
        }
        clients[clientIndex].name = name
        clients[clientIndex].surname = surname
        clients[clientIndex].phoneNumber = phoneNumber
        clientsReference.document(clients[clientIndex].creationDate).updateData(["creationDate" : clients[clientIndex].creationDate,
                                                                                 "surname" : surname,
                                                                                 "name" : name,
                                                                                 "phoneNumber" : phoneNumber])
        completion(nil)
    }
}
