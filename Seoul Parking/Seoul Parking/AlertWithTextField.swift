
//
//  AlertControlView.swift
//  SwiftUI with UIAlertController
//
//  Created by Nasir Ahmed Momin on 03/05/20.
//  Copyright © 2020 Nasir Ahmed Momin. All rights reserved.
//

import SwiftUI

struct AlertWithTextField: UIViewControllerRepresentable {
    
    @Binding var auxType: AuxViewType
    
    @State var textString = ""

    
    var placeholder : String
    
    var title: String
    var message: String
    
    @State var passwordTextField: UITextField?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWithTextField>) -> UIViewController {
        
        let controller = UIViewController()
        
        if self.auxType.showPasswordCheckAlert {
            
            // Create UIAlertController instance that is gonna present on UIViewController
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert
            
            // Adds UITextField & make sure that coordinator is delegate to UITextField.
            alert.addTextField { textField in
                DispatchQueue.main.async {
                    self.passwordTextField = textField
                    
                    passwordTextField?.placeholder = self.placeholder
                    passwordTextField?.text = self.textString            // setting initial value
                    passwordTextField?.delegate = context.coordinator    // using coordinator as delegate
                    passwordTextField?.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)

                }
            }
            
            
            
            
            // As usual adding actions
            alert.addAction(UIAlertAction(title: NSLocalizedString("취소", comment: "") , style: .destructive) { _ in
                
                // On dismiss, SiwftUI view's two-way binding variable must be update (setting false) means, remove Alert's View from UI
                alert.dismiss(animated: true) {
                    self.auxType.showPasswordCheckAlert = false
                }
            })
            
            let confirmAction = UIAlertAction(title: NSLocalizedString("확인", comment: ""), style: .default) { _ in
                // On submit action, get texts from TextField & set it on SwiftUI View's two-way binding varaible `textString` so that View receives enter response.
                if let textField = alert.textFields?.first, let text = textField.text {
                    self.textString = text
                }
                
                if textString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    
                    return
                }
                
                alert.dismiss(animated: true) {
                    self.auxType.showPasswordCheckAlert = false
                }
                
                guard let url = URL(string: REST_API.USER.CHECK_PASSWORD) else {return}
                
                let params = [
                    "userUniqueId": UserInfo.getInstance.uniqueId,
                    "currentPassword": textString.trimmingCharacters(in: .whitespacesAndNewlines)
                ]
                
                do{
                    let jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
                    
                    var request = URLRequest(url: url)
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    request.httpMethod = "POST"
                    request.httpBody = jsonParams
                    
                    URLSession.shared.dataTask(with: request){(data, response, error) in
                        if data == nil {
                            return
                        }
                        
                        
                        do {
                            if let rawData = data {
                                let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any]
                                
                                if let json = json {
                                    guard let statusCode = json["statusCode"] as? String else {return}
                                    
                                    switch statusCode {
                                    case "200":
                                        
                                        self.auxType.showSettingsView = true
                                        
                                        break
                                        
                                    case "201":
                                        
                                        break
                                        
                                    default:
                                        break
                                    }
                                }
                            }
                        }catch {
                            fatalError(error.localizedDescription)
                        }
                        
                    }.resume()
                }catch{
                    fatalError(error.localizedDescription)
                }
                
            }
            confirmAction.isEnabled = false
        
            
            alert.addAction(confirmAction)
            
            // Most important, must be dispatched on Main thread,
            // Curious? then remove `DispatchQueue.main.async` & find out yourself, Dont be lazy
            DispatchQueue.main.async { // must be async !!
                controller.present(alert, animated: false, completion: {
                    self.auxType.showPasswordCheckAlert = false  // hide holder after alert dismiss
                    context.coordinator.alert = nil

                        
                })
                
            }
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AlertWithTextField>) {
        
        
        //guard context.coordinator.alert == nil else { return }
        
        
    }
    
    func makeCoordinator() -> AlertWithTextField.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        // Holds reference of UIAlertController, so that when `body` of view gets re-rendered so that Alert should not disappear
        var alert: UIAlertController?
        
        // Holds back reference to SwiftUI's View
        var control: AlertWithTextField
        
        init(_ control: AlertWithTextField) {
            self.control = control
        }
        
        
        @objc func textFieldDidChange(_ textField: UITextField){
            print(textField.text)
        }
        
//        func textFieldDidEndEditing(_ textField: UITextField) {
//
//        }
//
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            if let text = textField.text as NSString? {
//
//                self.alert?.actions[1].isEnabled = !text.description.isEmpty
//
//                self.control.textString = text.replacingCharacters(in: range, with: string)
//            } else {
//                self.control.textString = ""
//            }
//
//            return true
//        }
    }
}
