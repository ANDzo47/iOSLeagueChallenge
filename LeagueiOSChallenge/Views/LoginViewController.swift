//
//  LoginViewController.swift
//  LeagueiOSChallenge
//
//  Copyright © 2024 League Inc. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, LoadingViewProtocol {
    var loadingViewController: LoadingViewController?

    private var viewModel: LoginViewModel

    private var userValidationView: ValidationTextView!
    private var passValidationView: ValidationTextView!
    private var loginButton: UIButton!
    private var guestButton: UIButton!
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Login"
        
        setupEmailValidationView()
        setupPassValidationView()
        setupLoginButton()
        setupGuestButton()
        
        viewModel.onLoginSuccess = { [weak self] user in
            self?.hideLoadingView(onCompletion: {
                let list = PostListViewController()
                self?.navigationController?.setViewControllers([list], animated: true)
            })
        }

        viewModel.onError = { [weak self] error in
            self?.hideLoadingView(onCompletion: {
                let alert = UIAlertController(title: "Something Went Wrong", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
        }
            
    }
    
    private func setupEmailValidationView() {
        userValidationView = ValidationTextView(shouldShowErrorLabel: { [weak self] inputValue in
            guard let self = self else {
                return nil
            }
            self.updateLoginButtonStatus()
            return self.viewModel.isValid(username: inputValue) ? nil : "Please enter a valid username"
        })
        view.addSubview(userValidationView)
        userValidationView.textField.placeholder = "Username"
        userValidationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userValidationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            userValidationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userValidationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupPassValidationView() {
        passValidationView = ValidationTextView(shouldShowErrorLabel: { [weak self] inputValue in
            guard let self = self else {
                return nil
            }
            self.updateLoginButtonStatus()
            return self.viewModel.isValid(password: inputValue) ? nil : "Password must be at least 6 characters"
        })
        view.addSubview(passValidationView)
        passValidationView.textField.placeholder = "Password"
        passValidationView.textField.isSecureTextEntry = true
        passValidationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            passValidationView.topAnchor.constraint(equalTo: userValidationView.bottomAnchor, constant: 8),
            passValidationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passValidationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupLoginButton() {
        loginButton = UIButton(type: .system)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.systemMint.withAlphaComponent(0.5)
        loginButton.layer.cornerRadius = 4
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.systemMint.cgColor
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 48.0),
            loginButton.topAnchor.constraint(equalTo: passValidationView.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])

    }
    
    private func setupGuestButton() {
        guestButton = UIButton(type: .system)
        guestButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guestButton)

        guestButton.setTitle("Continue as Guest", for: .normal)
        guestButton.setTitleColor(.systemMint, for: .normal)
        guestButton.addTarget(self, action: #selector(guestTapped), for: .touchUpInside)

        guestButton.layer.borderColor = UIColor.systemMint.cgColor
        
        NSLayoutConstraint.activate([
            guestButton.heightAnchor.constraint(equalToConstant: 48.0),
            guestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 8),
            guestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guestButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            guestButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func updateLoginButtonStatus() {
        loginButton.isEnabled = validateFields()
        loginButton.backgroundColor = loginButton.isEnabled ? UIColor.systemMint : UIColor.systemMint.withAlphaComponent(0.5)
    }
    
    private func validateFields() -> Bool {
        guard let username = userValidationView.textField.text,
              let password = passValidationView.textField.text else {
            return false
        }
        
        return viewModel.isValid(username: username) && viewModel.isValid(password: password)
    }
    
    @objc private func loginTapped() {
        guard validateFields() else {
            let alert = UIAlertController(title: "Invalid fields", message: "Please fix the highlighted fields before continuing.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        showLoadingView()
        viewModel.login(
            username: userValidationView.textField.text ?? "",
            password: passValidationView.textField.text ?? ""
        )
    }
    
    @objc
    private func guestTapped() {
        showLoadingView()
        viewModel.loginAsGuest()
    }
}
