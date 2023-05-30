//
//  UsersListView.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 30.05.2023.
//

import UIKit

class UsersListView: UIView {
    
    let usersTableView = UITableView(frame: .zero, style: .plain)
    private var users: [String] = []
    private var login: String = ""
    
    init() {
        super.init(frame: .zero)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        usersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UsersListCell")
        usersTableView.dataSource = self
        usersTableView.delegate = self
        self.addEnclosedSubview(usersTableView)
        usersTableView.backgroundColor = .clear
    }
    
    func newState(state: State) {
        // Update the UI based on the new state
        self.users = state.online.users.sorted(by: >)
        self.login = state.user.login
    }
}

extension UsersListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersListCell", for: indexPath)
        cell.textLabel?.text = user
        cell.textLabel?.font = user == login ? UIFont.boldSystemFont(ofSize: 14) : UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.lineBreakMode = .byTruncatingTail
        cell.indentationWidth = 0
        cell.indentationLevel = 0
    }
}
