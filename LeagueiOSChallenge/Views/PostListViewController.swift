//
//  PostListViewController.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 06/12/2025.
//

import UIKit

final class PostListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LoadingViewProtocol {
    var loadingViewController: LoadingViewController?
    
    private let viewModel = PostListViewModel()
    private let tableView = UITableView()
    private let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        
        setupClosures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoadingView()
        viewModel.reload()
    }
    
    private func setupView() {
        title = "Posts"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = .init(
            title: viewModel.isGuestUser ? "Exit" : "Logout",
            style: .plain,
            target: self,
            action: #selector(logout)
        )
    }
    
    private func setupTableView() {
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuse)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refresh
        tableView.separatorColor = .clear
        
        refresh.tintColor = .systemMint

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        refresh.addTarget(self, action: #selector(pulled), for: .valueChanged)
    }
    
    private func setupClosures() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.refresh.endRefreshing()
            self?.hideLoadingView(onCompletion: nil)
        }

        viewModel.onError = { [weak self] err in
            self?.hideLoadingView(onCompletion: {
                let alert = UIAlertController(
                    title: "Something went wrong",
                    message: "Couldn't retrieve posts. Try again later.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            print("Fetch posts error:\(err)")
        }
    }
    
    @objc
    private func pulled() {
        showLoadingView()
        viewModel.reload()
    }
    
    @objc
    private func logout() {
        defer {
            viewModel.clearUser()
        }

        guard viewModel.isGuestUser else {
            goToLoginScreen()
            return
        }

        // For guest user we need to show an alert before send it to login screen
        let alert = UIAlertController(
            title: "Thank you for trialing this app",
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "Ok",
                style: .default,
                handler: { [weak self] _ in
                    self?.goToLoginScreen()
                }
            )
        )
        present(alert, animated: true)
    }
    
    private func goToLoginScreen() {
        let loginViewController = LoginViewController(viewModel: LoginViewModel())
        navigationController?.setViewControllers([loginViewController], animated: false)
    }

    // MARK: - UITableViewDataSource && UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuse) as? PostCell else {
            return UITableViewCell()
        }
    
        let post = viewModel.post(at: indexPath)
        let user = viewModel.user(for: post)
        cell.configure(with: post,
                       and: user,
                       onTapUser: { [weak self] in
            
            guard let user = user else {
                return
            }

            let userViewModel = UserProfileViewModel(user: user)
            let userViewController = UserProfileViewController(viewModel: userViewModel)
            self?.navigationController?.present(userViewController,
                                                animated: true,
                                                completion: nil)
        })
    
        return cell
    }
}

