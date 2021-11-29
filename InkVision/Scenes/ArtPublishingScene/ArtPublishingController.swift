//
//  ArtPublishingController.swift
//  InkVision
//
//  Created by João Pedro Picolo on 24/11/21.
//

import UIKit
import SnapKit

class ArtPublishingController: UIViewController, UITextFieldDelegate {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
    }()
    
    lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.text = "WE'RE HALF WAY THERE"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22)
        
        return label
    }()

    var artView: UIImageView = UIImageView()
    
    lazy var labelInput: UILabel = {
        let label = UILabel()
        label.text = "Masterpiece's name"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    lazy var textInput: UITextField = {
        let input = UITextField()
        input.backgroundColor = UIColor(named: "inputBackground")
        input.textColor = UIColor(named: "inputText")
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: input.bounds.height))
        input.leftViewMode = .always
        
        return input
    }()
    
    var publishButton: ButtonFilled = .createButton(text: "Publish it!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupConstraints()
        setupNotification()
    }
    
    func setupHierarchy() {
        view.backgroundColor = UIColor(named: "backgroundGray")
        self.navigationController?.isNavigationBarHidden = true

        view.addSubview(scrollView)
        scrollView.addSubview(viewTitle)
        scrollView.addSubview(artView)
        scrollView.addSubview(labelInput)
        scrollView.addSubview(textInput)
        scrollView.addSubview(publishButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        viewTitle.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(24)
            make.leading.equalTo(30)
        }
        
        artView.layer.cornerRadius = 30
        artView.layer.borderWidth = 0.1
        artView.layer.masksToBounds = true
        artView.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(600)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
        }
        
        labelInput.snp.makeConstraints { make in
            make.leading.equalTo(30)
            make.top.equalToSuperview().offset(700)
        }
        
        textInput.layer.cornerRadius = 10
        textInput.layer.borderWidth = 0.1
        textInput.layer.masksToBounds = true
        textInput.snp.makeConstraints { make in
            make.width.equalTo(320)
            make.height.equalTo(46)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(730)
        }
        
        publishButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(800)
        }
    }
    
    func setupNotification() {
        textInput.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textInput.resignFirstResponder()
        return true
    }
}
