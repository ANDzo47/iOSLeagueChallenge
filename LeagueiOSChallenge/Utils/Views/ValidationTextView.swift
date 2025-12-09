//
//  ValidationTextView.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import UIKit

final class ValidationTextView: UIView, UITextFieldDelegate {
    
    // Public Properties
    var textField: UITextField!
    var shouldShowErrorLabel: ((String) -> String?)?
        
    // Private Properties
    private var errorLabel: UILabel!
    
    /// Parameters
    /// - validateField: Closure that validates the
    init(shouldShowErrorLabel: @escaping (String) -> String?) {
        super.init(frame: .zero)
        self.initSubviews()
        self.shouldShowErrorLabel = shouldShowErrorLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSubviews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        initTextField()
        initErrorLabel()
    }

    func initTextField() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemMint.cgColor
        textField.tintColor = .systemMint
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        
        self.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 48.0),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func initErrorLabel() {
        errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .systemRed
        errorLabel.isHidden = true
        
        self.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc private func textChanged(_ sender: UITextField) {
        if let errorText =  shouldShowErrorLabel?(textField.text ?? "") {
            errorLabel.text = errorText
            errorLabel.isHidden = false
        } else {
            errorLabel.text = nil
            errorLabel.isHidden = true
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
