//
//  LoginViewController.swift
//  geekTime
//
//  Created by swan on 2024/8/5.
//

import UIKit
import SnapKit
// 协议编程：校验电话号码
protocol ValidatesPhoneNumber {
    func validatePhoneNumber(_ phoneNumber: String) -> Bool
}

protocol ValidatesPassword {
    func validatePassword(_ password: String) -> Bool
}

extension ValidatesPhoneNumber {
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.count != 11 {
            return false
        }
        return true
    }
}

extension ValidatesPassword {
    func validatePassword(_ password: String) -> Bool{
        if password.count < 6 || password.count > 12{
            return false
        }
        return true
    }
}

class LoginViewController: BaseViewController, ValidatesPassword, ValidatesPhoneNumber {
    var phoneTextField: UITextField!
    var passworldTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        let logoView = UIImageView(image: R.image.logo())
        view.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            // 距离顶部 30
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()   // 显示在中间
        }
        
        // 手机号
        let phoneIconView = UIImageView(image: R.image.icon_phone())
        phoneTextField = UITextField()
        phoneTextField.leftView = phoneIconView
        phoneTextField.leftViewMode = .always    // 永远显示在左边
        // 设置边框颜色
        phoneTextField.layer.borderColor = UIColor.hexColor(0x333333).cgColor
        phoneTextField.layer.borderWidth = 1
        phoneTextField.textColor = UIColor.hexColor(0x333333)
        // 设置圆角
        phoneTextField.layer.cornerRadius = 5
        phoneTextField.layer.masksToBounds = true
        // 设置占位
        phoneTextField.placeholder = "请输入手机号"
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            // 展示在 logo 下面
            make.top.equalTo(logoView.snp_bottom).offset(20)
            make.height.equalTo(50)
        }
        
        
        // 密码框
        let passIconView = UIImageView(image: R.image.icon_pwd())
        passworldTextField = UITextField()
        passworldTextField.leftView = passIconView
        passworldTextField.leftViewMode = .always    // 永远显示在左边
        // 设置边框颜色
        passworldTextField.layer.borderColor = UIColor.hexColor(0x333333).cgColor
        passworldTextField.layer.borderWidth = 1
        passworldTextField.textColor = UIColor.hexColor(0x333333)
        // 设置圆角
        passworldTextField.layer.cornerRadius = 5
        passworldTextField.layer.masksToBounds = true
        // 设置占位
        passworldTextField.placeholder = "请输入密码"
        passworldTextField.isSecureTextEntry = true
        view.addSubview(passworldTextField)
        passworldTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            // 展示在 logo 下面
            make.top.equalTo(phoneTextField.snp_bottom).offset(15)
            make.height.equalTo(50)
        }
        
        // 登录按钮
        let loginButton = UIButton(type: .custom)
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        loginButton.setBackgroundImage(UIColor.hexColor(0xf8892e).toImage(), for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            // 展示在 logo 下面
            make.top.equalTo(passworldTextField.snp_bottom).offset(20)
            make.height.equalTo(50)
        }
        loginButton.addTarget(self, action: #selector(didClickLoginButton), for: .touchUpInside)
        
    }
    
    // #selector(didClickLoginButton) 回调
    @objc func didClickLoginButton(){
        if validatePhoneNumber(phoneTextField.text ?? "") && validatePassword(passworldTextField.text ?? ""){
            
        } else {
            self.showToast()
        }
    }
    
    func showToast(){
        let alertVC = UIAlertController(title: "提示", message: "用户名密码错误", preferredStyle: .alert)
        present(alertVC, animated: true)
        // 2 秒之后指向
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            alertVC.dismiss(animated: true)
        }
    }

}
