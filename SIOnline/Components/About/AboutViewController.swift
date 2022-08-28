//
//  AboutViewController.swift
//  SIOnline
//
//  Created by Andrey Dorofeev on 28.08.2022.
//

import UIKit
import ReSwift

private let supportLink = "https://vk.com/topic-135725718_34967839"
private let sourcesLnk = "https://github.com/VladimirKhil/SIOnline"

class AboutViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var dialogView: Dialog = {
        let dialog = Dialog()
        dialog.backgroundColor = R.color.loginBackground()
        return dialog
    }()
    
    private lazy var contentView = UIScrollView()
    
    private lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.about()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var aboutSupportLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 36)
        label.textColor = .white
        label.text = R.string.localizable.aboutSupport()
        return label
    }()
    
    private lazy var supportInfoLabel: LinkedLabel = {
        let label = LinkedLabel()
        label.setUrl(title: R.string.localizable.supportInfo(), url: supportLink)
        return label
    }()
    
    private lazy var aboutAuthorLicense: UILabel = {
        let label = UILabel()
        label.font = R.font.futuraCondensed(size: 36)
        label.textColor = .white
        label.text = R.string.localizable.aboutAuthorLicense()
        return label
    }()
    
    private lazy var authorInfoLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.authorInfo()
        return label
    }()
    
    private lazy var sourcesInfoLabel: LinkedLabel = {
        let label = LinkedLabel()
        label.setUrl(title: R.string.localizable.sourcesInfo(), url: sourcesLnk)
        return label
    }()
    
    private lazy var licenceLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.licence()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var noWarrantyLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.noWarranty()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var usedComponentsLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.usedComponents()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var componentsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var RswiftLabel: LinkedLabel = {
        let label = LinkedLabel()
        label.setListedUrl(title: "R.swift", url: "https://github.com/mac-cain13/R.swift")
        return label
    }()
    
    private lazy var AlamofireLabel: LinkedLabel = {
        let label = LinkedLabel()
        label.setListedUrl(title: "Alamofire", url: "https://github.com/Alamofire/Alamofire")
        return label
    }()
    
    private lazy var PromiseKitLabel: LinkedLabel = {
        let label = LinkedLabel()
        label.setListedUrl(title: "PromiseKit", url: "https://github.com/mxcl/PromiseKit")
        return label
    }()
    
    private lazy var SwiftSignalRClientLabel: LinkedLabel = {
        let label = LinkedLabel()
        label.setListedUrl(title: "SwiftSignalRClient", url: "https://github.com/moozzyk/SignalR-Client-Swift")
        return label
    }()
    
    private lazy var ReSwiftLabel: LinkedLabel = {
        let label = LinkedLabel()
        label.setListedUrl(title: "ReSwift", url: "https://github.com/ReSwift/ReSwift")
        return label
    }()
    
    private lazy var ReSwiftThunkLabel: LinkedLabel = {
        let label = LinkedLabel()
        label.setListedUrl(title: "ReSwiftThunk", url: "https://github.com/ReSwift/ReSwift-Thunk")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup { _ in
        }
        setupLayout()
        
    }

    // MARK: - Setup
    
    func setup(dispatch: @escaping DispatchFunction) {
        dialogView.setup(title: R.string.localizable.aboutTitle(), children: [contentView]) {
            dispatch(ActionCreators.shared.navigateBack())
        }
    }
    
    private func setupLayout() {
        
        self.view.backgroundColor = R.color.loginBackground()
        
        view.addEnclosedSubview(dialogView)
        
        contentView.addSubview(aboutLabel, activateConstraints: [
            aboutLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            aboutLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            aboutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            
            dialogView.widthAnchor.constraint(equalTo: contentView.contentLayoutGuide.widthAnchor)
        ])
        
        contentView.addSubview(aboutSupportLabel, activateConstraints: [
            aboutSupportLabel.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 8),
            aboutSupportLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            aboutSupportLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        ])
        
        contentView.addSubview(supportInfoLabel, activateConstraints: [
            supportInfoLabel.topAnchor.constraint(equalTo: aboutSupportLabel.bottomAnchor, constant: 8),
            supportInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            supportInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        ])
        
        contentView.addSubview(aboutAuthorLicense, activateConstraints: [
            aboutAuthorLicense.topAnchor.constraint(equalTo: supportInfoLabel.bottomAnchor, constant: 8),
            aboutAuthorLicense.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            aboutAuthorLicense.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        ])
        
        contentView.addSubview(authorInfoLabel, activateConstraints: [
            authorInfoLabel.topAnchor.constraint(equalTo: aboutAuthorLicense.bottomAnchor, constant: 8),
            authorInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            authorInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        ])
        
        contentView.addSubview(sourcesInfoLabel, activateConstraints: [
            sourcesInfoLabel.topAnchor.constraint(equalTo: authorInfoLabel.bottomAnchor, constant: 8),
            sourcesInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            sourcesInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        ])
        
        contentView.addSubview(licenceLabel, activateConstraints: [
            licenceLabel.topAnchor.constraint(equalTo: sourcesInfoLabel.bottomAnchor, constant: 8),
            licenceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            licenceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        ])
        
        contentView.addSubview(noWarrantyLabel, activateConstraints: [
            noWarrantyLabel.topAnchor.constraint(equalTo: licenceLabel.bottomAnchor, constant: 8),
            noWarrantyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            noWarrantyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        ])
        
        contentView.addSubview(usedComponentsLabel, activateConstraints: [
            usedComponentsLabel.topAnchor.constraint(equalTo: noWarrantyLabel.bottomAnchor, constant: 8),
            usedComponentsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            usedComponentsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        ])
        
        contentView.addSubview(componentsStack, activateConstraints: [
            componentsStack.topAnchor.constraint(equalTo: usedComponentsLabel.bottomAnchor, constant: 8),
            componentsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            componentsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            componentsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
        
        componentsStack.addArrangedSubview(RswiftLabel)
        componentsStack.addArrangedSubview(AlamofireLabel)
        componentsStack.addArrangedSubview(PromiseKitLabel)
        componentsStack.addArrangedSubview(SwiftSignalRClientLabel)
        componentsStack.addArrangedSubview(ReSwiftLabel)
        componentsStack.addArrangedSubview(ReSwiftThunkLabel)
    }
}
