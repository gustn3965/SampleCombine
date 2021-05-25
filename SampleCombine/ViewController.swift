//
//  ViewController.swift
//  SampleCombine
//
//  Created by hyunsu on 2021/05/16.
//

import UIKit
import Combine


class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var createButton: CustomButton!
    
    @IBOutlet weak var idImage: UIImageView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var checkPasswordImage: UIImageView!
    
    // MARK: - Publisher
    @Published var id: String = ""
    @Published var password: String = ""
    @Published var checkPassword: String = ""
    var validatePasswordsPublisher: AnyPublisher<Bool, Never>?
    
    // MARK: - Subscriber
    var validatePasswords: AnyCancellable?
    var validateCredentials: AnyCancellable?
    
    // MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        createPasswordPublisher()
        validatePassword()
        validateCredential()
    }

    func createPasswordPublisher() {
        validatePasswordsPublisher =  Publishers.CombineLatest($password, $checkPassword)
            .map { pass, check  -> String in
                guard pass == check, pass.count > 8 else { return "" }
                return pass
            }
            .map{ !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    func validatePassword() {
        validatePasswords = validatePasswordsPublisher!
            .sink(receiveValue: { [weak self] success in
                self?.checkPasswordImage.tintColor = success ? .systemGreen : .white
            })
    }
    
    func validateCredential() {
        validateCredentials = Publishers.CombineLatest($id, validatePasswordsPublisher!)
            .map { $0.count > 3 && $1 }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: createButton)
    }
}

// MARK: - IBAction
extension ViewController {

    @IBAction func idChanged(_ sender: UITextField) {
        id = sender.text ?? ""
        if id.count > 3 {
            idImage.tintColor = .systemGreen
        } else {
            idImage.tintColor = .white
        }
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        password = sender.text ?? ""
        if password.count > 8 {
            passwordImage.tintColor = .systemGreen
        } else {
            passwordImage.tintColor = .white
        }
    }
    
    @IBAction func checkPasswordChanged(_ sender: UITextField) {
        checkPassword = sender.text ?? ""
    }
    
    // MARK: - 키보드에 따른 반응
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    @IBAction func touchCreateButton(_ sender: UIButton) {
        self.view.endEditing(true)
    }
}



