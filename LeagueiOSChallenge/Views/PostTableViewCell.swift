//
//  PostTableViewCell.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import UIKit

final class PostCell: UITableViewCell {
    static let reuse = "PostCell"

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()

    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let customSeparatorView = UIView()
    
    // Track current avatar load to handle reuse/cancellation
    private var currentAvatarURL: URL?
    private var currentAvatarTask: Task<Void, Never>?
    
    private var onTapUserCallback: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        
        setupAvatar()
        setupContentStackView()
        setupUsername()
        setupTitle()
        setupDescription()
        setupCustomSeparator()
    }

    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        avatarImageView.image = nil

        currentAvatarTask?.cancel()
        currentAvatarTask = nil
        currentAvatarURL = nil
    }

    // MARK: - Public methods
    func configure(with post: PostsResponse, and user: UserResponse?, onTapUser: (() -> Void)?) {
        usernameLabel.text = user?.username ?? "Anonymous"
        titleLabel.text = post.title
        descriptionLabel.text = post.body
        onTapUserCallback = onTapUser
        
        // Cancel previous task and start a new one for this URL
        currentAvatarTask?.cancel()
        avatarImageView.image = nil
        
        guard let urlString = user?.avatar,
              let url = URL(string: urlString) else {
            return
        }
        
        currentAvatarURL = url
        currentAvatarTask = Task { [weak self] in
            guard let self = self else { return }
            let image = await ImageLoader.shared.load(url: url)
            
            // Ensure we are on main actor and the url requested is the same
            // that the cell expects
            await MainActor.run {
                guard !Task.isCancelled else { return }
                if self.currentAvatarURL == url {
                    self.avatarImageView.image = image
                }
            }
        }
    }
    
    // MARK: - Private methods
    private func setupAvatar() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarImageView)
        
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 24
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = UIColor.systemMint.cgColor
        avatarImageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleUserTap)
        )
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupContentStackView() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupUsername() {
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleUserTap)
        )
        usernameLabel.addGestureRecognizer(tapGestureRecognizer)
        
        contentStackView.addArrangedSubview(usernameLabel)
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        titleLabel.numberOfLines = 0
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    private func setupDescription() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .light)
        descriptionLabel.numberOfLines = 0
        contentStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupCustomSeparator() {
        customSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        customSeparatorView.backgroundColor = .systemMint
        contentView.addSubview(customSeparatorView)
        
        NSLayoutConstraint.activate([
            customSeparatorView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 0),
            customSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            customSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
    }
    
    @objc
    private func handleUserTap() {
        onTapUserCallback?()
    }
}

