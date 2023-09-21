//
//  SIStorageDialogViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 24.08.2023.
//

import UIKit

class SIStorageDialogViewController: UIViewController {
    
    // MARK: - Public properties
    
    var onClose: (() -> Void)?
    
    // MARK: - Private properties
    
    private let librarySearchAllTagId = SIStorageSelectorOption(key: "null", title: R.string.localizable.librarySearchAll())
    private let librarySearchNotSeTagId = SIStorageSelectorOption(key: "-1", title: R.string.localizable.librarySearchNotSet())
    
    private var selectedTagId: SIStorageSelectorOption?
    
    // MARK: - Views
    
    private lazy var dialogView: Dialog = {
        let dialog = Dialog()
        dialog.backgroundColor = R.color.loginBackground()
        return dialog
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            SIStorageSelectorCell.self,
            forCellReuseIdentifier: SIStorageSelectorCell.reusableIdentifier
        )
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.setup(title: R.string.localizable.libraryTitle(), children: [tableView]) { [weak self] in
            self?.onClose?()
        }
    }
    
    override func loadView() {
        self.view = dialogView
    }
}

extension SIStorageDialogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SIStorageSelectorCell.reusableIdentifier,
            for: indexPath
        ) as? SIStorageSelectorCell else {
            fatalError("incorrect cell type")
        }
        
        cell.fill(
            model: SIStorageSelectorCell.DatalModel(
                selectorName: R.string.localizable.packageSubject(),
                selectedValue: selectedTagId ?? librarySearchAllTagId,
                options: [librarySearchAllTagId, librarySearchNotSeTagId]
            )
        ) {
            print($0)
        }
        return cell
    }
}
