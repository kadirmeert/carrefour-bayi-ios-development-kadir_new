//
//  OTPTextField.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 9.08.2022.
//

import Foundation
import UIKit

public protocol OTPTextFieldDelegate: AnyObject {
    func didUserFinishEnter(the code: String)
}


public class OTPTextField: UITextField {
    // MARK: - PROPERTIES
    //
    /// The default character placed in the text field slots
    public var otpDefaultCharacter = "_"
    /// The default background color of the text field slots before entering a character
    public var otpBackgroundColor: UIColor = .white
    /// The default background color of the text field slots after entering a character
    public var otpFilledBackgroundColor: UIColor = .white
    /// The default corner raduis of the text field slots
    public var otpCornerRaduis: CGFloat = 0
    /// The default border color of the text field slots before entering a character
    public var otpDefaultBorderColor: UIColor = .clear
    /// The border color of the text field slots after entering a character
    public var otpFilledBorderColor: UIColor = .clear
    /// The default border width of the text field slots before entering a character
    public var otpDefaultBorderWidth: CGFloat = 0
    /// The border width of the text field slots after entering a character
    public var otpFilledBorderWidth: CGFloat = 0
    /// The default text color of the text
    public var otpTextColor: UIColor = .primaryTitleBlue
    /// The default font size of the text
    public var otpFontSize: CGFloat = 16
    /// The default font of the text
    public var otpFont: UIFont = UIFont(name: "Montserrat-Bold", size: 16)!
    /// The delegate of the OTPTextFieldDelegate protocol
    public weak var otpDelegate: OTPTextFieldDelegate?

    private var implementation = OTPTextFieldImplementation()
    private var isConfigured = false
    private var digitLabels = [UILabel]()
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    // MARK: - METHODS
    //
    /// This func is used to configure the `OTPTextField`, Usually you need to call this method into `viewDidLoad()`
    /// - Parameter slotCount: the number of OTP slots in the TextField
    public func configure(with slotCount: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        addGestureRecognizer(tapRecognizer)
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Use this func if you need to clear the `OTP` text and reset the `OTPTextField` to the default state
    public func clearOTP() {
        text = nil
        digitLabels.forEach { currentLabel in
            currentLabel.text = otpDefaultCharacter
            currentLabel.layer.borderWidth = otpDefaultBorderWidth
            currentLabel.layer.borderColor = otpDefaultBorderColor.cgColor
            currentLabel.backgroundColor = otpBackgroundColor
        }
    }
}

// MARK: - PRIVATE METHODS
//
private extension OTPTextField {
    func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        borderStyle = .none
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = implementation
        implementation.implementationDelegate = self
    }
    
    func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        for _ in 1 ... count {
            let label = createLabel()
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        return stackView
    }
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = otpBackgroundColor
        label.layer.cornerRadius = otpCornerRaduis
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = otpTextColor
        label.font = label.font.withSize(otpFontSize)
        label.font = otpFont
        label.isUserInteractionEnabled = true
        label.layer.masksToBounds = true
        label.text = otpDefaultCharacter
        return label
    }
    
    @objc
    func textDidChange() {
        guard let text = self.text, text.count <= digitLabels.count else { return }
        for labelIndex in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[labelIndex]
            if labelIndex < text.count {
                
                let index = text.index(text.startIndex, offsetBy: labelIndex)
                currentLabel.text = isSecureTextEntry ? "✱" : String(text[index])
                currentLabel.layer.borderWidth = otpFilledBorderWidth
                currentLabel.layer.borderColor = otpFilledBorderColor.cgColor
                currentLabel.backgroundColor = otpFilledBackgroundColor
                currentLabel.font = UIFont(name: "Montserrat-Bold", size: 24)!
            } else {
                currentLabel.font = UIFont(name: "Montserrat-Bold", size: 16)!
                currentLabel.text = otpDefaultCharacter
                currentLabel.layer.borderWidth = otpDefaultBorderWidth
                currentLabel.layer.borderColor = otpDefaultBorderColor.cgColor
                currentLabel.backgroundColor = otpBackgroundColor
            }
        }
        
        if text.count == digitLabels.count {
            otpDelegate?.didUserFinishEnter(the: text)
        }
    }
}

// MARK: - OTPTextFieldImplementationProtocol Delegate
//
extension OTPTextField: OTPTextFieldImplementationProtocol {
    var digitalLabelsCount: Int {
        digitLabels.count
    }
}
