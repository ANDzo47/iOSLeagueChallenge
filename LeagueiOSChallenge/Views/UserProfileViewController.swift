//
//  UserProfileViewController.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import UIKit

final class UserProfileViewController: UIViewController {

    private let viewModel: UserProfileViewModel

    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let emailLabel = UILabel()
    private let emailWarningImageView = UIImageView()
    
    
    // Task to known if view disappears
    private var avatarTask: Task<Void, Never>?

    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAvatar()
        setupUsername()
        setupEmail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        avatarTask?.cancel()
        avatarTask = nil
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupAvatar() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = UIColor.systemMint.cgColor
        avatarImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        if let url = viewModel.avatarURL {
            avatarTask?.cancel()
            avatarTask = Task { [weak self] in
                guard let self = self else {
                    return
                }

                let image = await ImageLoader.shared.load(url: url)

                await MainActor.run {
                    guard !Task.isCancelled else { return }
                    self.avatarImageView.image = image
                }
            }
        }
    }
    
    private func setupUsername() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)

        usernameLabel.text = viewModel.username
        usernameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupEmail() {
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailWarningImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        view.addSubview(emailWarningImageView)
        
        emailLabel.text = viewModel.email
        emailLabel.font = .systemFont(ofSize: 15, weight: .regular)
        
        emailWarningImageView.isHidden = viewModel.isValidEmail()
        emailWarningImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailWarningImageView.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor),
            emailWarningImageView.heightAnchor.constraint(equalToConstant: 24),
            emailWarningImageView.widthAnchor.constraint(equalToConstant: 24),
            emailWarningImageView.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 8)
        ])
        
        emailWarningImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
    }

}


