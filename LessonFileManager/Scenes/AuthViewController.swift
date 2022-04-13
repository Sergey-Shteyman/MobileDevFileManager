//
//  AuthViewController.swift
//  LessonFileManager
//
//  Created by Сергей Штейман on 28.03.2022.
//

import UIKit

// MARK: - AuthViewController
final class AuthViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    let genderArray = ["Мужской", "Женский", "Другое"]

    private lazy var registrLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.font = .preferredFont(forTextStyle: .title1)
        label.font = .systemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nameTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Имя"
        textField.font = .systemFont(ofSize: 26)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    private lazy var phoneTextField: TextField = {
        let textField = TextField()
        textField.placeholder = "Номер телефона"
        textField.font = .systemFont(ofSize: 26)
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш возраст: "
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    private lazy var ageSliderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "6"
        label.textColor = .black
        return label
    }()
    
    private lazy var ageSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 6.0
        slider.maximumValue = 100.0
        return slider
    }()
    
    private lazy var changeSexSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: genderArray)
        segment.selectedSegmentTintColor = UIColor.systemBlue
        segment.selectedSegmentIndex = Int(genderArray[2]) ?? 2
        return segment
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "Получать уведомления по смс"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.font = UIFont.italicSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    private lazy var noticeSwitch: UISwitch = {
        let noticeSwitch = UISwitch()
        noticeSwitch.isOn = true
        return noticeSwitch
    }()
    
    private lazy var accessButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitle("Зарегистрироваться", for: .highlighted)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(UIColor.purple, for: .highlighted)
        button.titleLabel?.textAlignment = .center
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViewController()
        
        let userNameValue = UserDefaultsManager.fetch(type: String.self, for: .userName)
        guard let userNameValue = userNameValue else {
            return
        }
        let userPhoneValue = UserDefaultsManager.fetch(type: String.self, for: .userPhone)
        guard let userPhoneValue = userPhoneValue else {
            return
        }
        let userAgeValue = UserDefaultsManager.fetch(type: String.self, for: .userAge)
        guard let userAgeValue = userAgeValue else {
            return
        }

        let userGenderValue = UserDefaultsManager.fetch(type: String.self, for: .userGender)
        guard let userGenderValue = userGenderValue else {
            return
        }

        let userNoticeValue = UserDefaultsManager.fetch(type: Bool.self, for: .isNoticeEnabled)
        guard let userNoticeValue = userNoticeValue else {
            return
        }

        print(userNameValue, userPhoneValue, userAgeValue, userGenderValue, userNoticeValue)

        navigationController?.pushViewController(DocumentsViewController(), animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViewController()
    }
    
    @objc func isValidNameTextField() -> Bool {
        let validateNameExpression = #"^[А-Я]{1,}[а-я]{1,}$"#
        if self.nameTextField.text?.range(of: validateNameExpression,
                                          options: .regularExpression,
                                          range: nil) != nil {
            nameTextField.addBottomLine(with: .lightGray)
            return true
        } else {
            nameTextField.addBottomLine(with: .red)
            return false
        }
    }
    
    @objc func isValidNumberTextField() -> Bool {
        let validateNumberExpression = #"^[0-9]{11,11}$"#
        if (phoneTextField.text?.count)! == 11 &&
            phoneTextField.text?.range(of: validateNumberExpression,
                                        options: .regularExpression,
                                        range: nil) != nil {
            
            phoneTextField.resignFirstResponder()
            phoneTextField.addBottomLine(with: .lightGray)
            return true
            
        } else {
            phoneTextField.addBottomLine(with: .red)
            return false
        }
    }
    
    @objc func changeValueSlider(sender: UISlider) {
        if sender == ageSlider {
            ageSliderLabel.text = String(Int(sender.value))
        }
    }
    
    @objc func buttonIsTapped() {
        
        if isValidNumberTextField() && isValidNameTextField() {
            let name = nameTextField.text ?? ""
            let phone = phoneTextField.text ?? ""
            let gender = genderArray[changeSexSegment.selectedSegmentIndex]
            let age = ageSliderLabel.text ?? ""
            let isNoticeEnabled = noticeSwitch.isOn
            
            UserDefaultsManager.save(name, for: .userName)
            UserDefaultsManager.save(phone, for: .userPhone)
            UserDefaultsManager.save(gender, for: .userGender)
            UserDefaultsManager.save(age, for: .userAge)
            UserDefaultsManager.save(isNoticeEnabled, for: .isNoticeEnabled)
            
            navigationController?.pushViewController(DocumentsViewController(), animated: true)
            
        } else if isValidNameTextField() && !isValidNumberTextField() {
            phoneTextField.addBottomLine(with: .red)
        } else if !isValidNameTextField() && isValidNumberTextField() {
            nameTextField.addBottomLine(with: .red)
        } else if !isValidNumberTextField() && !isValidNameTextField() {
            phoneTextField.addBottomLine(with: .red)
            nameTextField.addBottomLine(with: .red)
        }
    }
}

// MARK: - UITextFieldDelegate Impl
extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard isValidNameTextField() else {
            return false
        }
        nameTextField.resignFirstResponder()
        phoneTextField.becomeFirstResponder()
        return true
    }
}

// MARK: - Private Methods
fileprivate extension AuthViewController {

    func setupViewController() {
        view.addTapGestureToHideKeyboard()
        nameTextField.delegate = self
        setupScrollView()
        setupRegistrLabel()
        
        addTargets()
        addSubViews()
        addConstraints()
    }
    
    func setupScrollView() {
        scrollView.backgroundColor = .white
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: 0, height: accessButton.frame.maxY + 10)
    }

    func setupRegistrLabel() {
        registrLabel.attributedText = registrLabel.addLetterSpacing(label: registrLabel, spacing: 5.0)
    }

    func addTargets() {
        nameTextField.addTarget(self, action: #selector(isValidNameTextField), for: UIControl.Event.editingChanged)
        phoneTextField.addTarget(self, action: #selector(isValidNumberTextField), for: UIControl.Event.editingChanged)
        ageSlider.addTarget(self, action: #selector(changeValueSlider), for: .valueChanged)
        accessButton.addTarget(self, action: #selector(buttonIsTapped), for: .touchDown)
    }

    func addSubViews() {
        view.myAddSubView(scrollView)
        let arrayViews = [registrLabel, nameTextField, phoneTextField,
                          ageLabel, ageSliderLabel, ageSlider, changeSexSegment,
                          noticeLabel, noticeSwitch, accessButton]
        scrollView.addSubViewOnScrollVeiw(for: arrayViews, scrollView: scrollView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                                     registrLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
                                     registrLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                                     registrLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
                                     
                                     nameTextField.topAnchor.constraint(equalTo: registrLabel.bottomAnchor, constant: 50),
                                     nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
                                     
                                     phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
                                     phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
                                     
                                     ageLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 50),
                                     ageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     
                                     ageSliderLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 50),
                                     ageSliderLabel.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 5),
                                     
                                     ageSlider.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 20),
                                     ageSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     ageSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                                     
                                     changeSexSegment.topAnchor.constraint(equalTo: ageSlider.bottomAnchor, constant: 30),
                                     changeSexSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     changeSexSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                                     changeSexSegment.heightAnchor.constraint(equalToConstant: 30),
                                     
                                     noticeLabel.topAnchor.constraint(equalTo: changeSexSegment.bottomAnchor, constant: 35),
                                     noticeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     noticeLabel.trailingAnchor.constraint(equalTo: noticeSwitch.leadingAnchor, constant: -10),
                                     
                                     noticeSwitch.topAnchor.constraint(equalTo: changeSexSegment.bottomAnchor, constant: 30),
                                     noticeSwitch.leadingAnchor.constraint(equalTo: noticeLabel.trailingAnchor, constant: 10),
                                     noticeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                                     noticeSwitch.widthAnchor.constraint(equalToConstant: 50),
                                     
                                     accessButton.topAnchor.constraint(equalTo: noticeLabel.bottomAnchor, constant: 50),
                                     accessButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     accessButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                                    ])
    }
}
