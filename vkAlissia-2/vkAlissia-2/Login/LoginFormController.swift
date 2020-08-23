//
//  LoginFormController.swift
//  vkAlissia
//
//  Created by Роман Колосов on 01.07.2020.
//  Copyright © 2020 Roman N. Kolosov. All rights reserved.
//

import UIKit
import WebKit

class LoginFormController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authButton: UIButton!
    
    private let heartLabelA = UILabel()
    private let heartLabelB = UILabel()
    private let heartLabelC = UILabel()
    
    @IBOutlet weak var starView: StarView!
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeCookies()
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7564683"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.122")
        ]
        
        let request = URLRequest(url: components.url!)
        webView.load(request)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        view.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeShown(notification:)), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillBeHiden(notification:)), name:
            UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        
        heartLabelA.text = "❤️"
        heartLabelB.text = "❤️"
        heartLabelC.text = "❤️"
        
        view.addSubview(heartLabelA)
        view.addSubview(heartLabelB)
        view.addSubview(heartLabelC)
        
        heartLabelA.translatesAutoresizingMaskIntoConstraints = false
        heartLabelB.translatesAutoresizingMaskIntoConstraints = false
        heartLabelC.translatesAutoresizingMaskIntoConstraints = false
        
        let heartLabelBConstraints = [
            heartLabelB.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            heartLabelB.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
        ]
        
        let heartLabelCConstraints = [
            heartLabelC.leftAnchor.constraint(equalTo: heartLabelB.rightAnchor),
            heartLabelC.centerYAnchor.constraint(equalTo: heartLabelB.centerYAnchor),
        ]
        
        let heartLabelAConstraints = [
            heartLabelA.rightAnchor.constraint(equalTo: heartLabelB.leftAnchor),
            heartLabelA.centerYAnchor.constraint(equalTo: heartLabelB.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(heartLabelAConstraints + heartLabelBConstraints + heartLabelCConstraints
        )
        
        animateHeartBeats()
        animateTitleAppearing()
        animateFieldAppearing()
        animateAuthButton()
        starView.animate()
    }
    
    // MARK: - @objc funcs
    @objc func onPan (_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            interactiveAnimator?.startAnimation()
            
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                         dampingRatio: 0.5,
                                                         animations: {
                                                            self.authButton.transform = CGAffineTransform(translationX: 0, y: 150)
            })
            
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: view)
            interactiveAnimator.fractionComplete = translation.y / 100
        case .ended:
            interactiveAnimator.stopAnimation(true)
            
            interactiveAnimator.addAnimations {
                self.authButton.transform = .identity
            }
            
            interactiveAnimator.startAnimation()
        default:
            return
        }
    }
    
    @objc func keyboardWillBeShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHiden(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func hideKeyboard(){
        scrollView.endEditing(true)
    }
    
    // MARK: - regular funcs
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeCookies() {
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginSegue" {
            if checkLoginInfo() {
                return true
            } else {
                showLoginError()
                return false
            }
        }
        return true
    }
    
    private func checkLoginInfo() -> Bool {
        guard let loginText = loginField.text else { return false }
        guard let passwordText = passwordField.text else { return false }
        
        if loginText == "", passwordText == "" {
            animateCorrectPassword()
            return true
        } else {
            animateWrongPassword()
            return false
        }
    }
    
    private func showLoginError() {
        let  alert = UIAlertController(title: "Ошибка", message: "Неверный логин и/или пароль", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - animations
    func animateTitleAppearing() {
        let offset = abs (loginLabel.frame.midY - passwordLabel.frame.midY)
        
        loginLabel.transform = CGAffineTransform(translationX: 0, y: offset)
        passwordLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
        titleLabel.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height / 2)
        
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0.3,
                                options: .calculationModeCubicPaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5,
                                                       animations: {
                                                        self.loginLabel.transform = CGAffineTransform(translationX: 150, y: 50)
                                                        self.passwordLabel.transform = CGAffineTransform(translationX: -150, y: -50)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5,
                                                       animations: {
                                                        self.loginLabel.transform = .identity
                                                        self.passwordLabel.transform = .identity
                                    })
        },
                                completion: nil)
        
        let titleAnimator = UIViewPropertyAnimator(duration: 1.6,
                                                   dampingRatio: 0.5,
                                                   animations: {
                                                    self.titleLabel.transform = .identity
        })
        
        titleAnimator.startAnimation(afterDelay: 0.6)
    }
    
    func animateFieldAppearing() {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.stiffness = 200
        scaleAnimation.mass = 2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.8
        animationGroup.beginTime = CACurrentMediaTime() + 1
        animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationGroup.fillMode = CAMediaTimingFillMode.backwards
        animationGroup.animations = [fadeInAnimation, scaleAnimation]
        
        loginField.layer.add(animationGroup, forKey: nil)
        passwordField.layer.add(animationGroup, forKey: nil)
    }
    
    func animateAuthButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        
        animation.duration = 1.6
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        authButton.layer.add(animation, forKey: nil)
    }
    
    func animateCorrectPassword() {
        self.loginField.layer.borderWidth = 1
        self.loginField.layer.borderColor = UIColor.green.cgColor
        self.passwordField.layer.borderWidth = 1
        self.passwordField.layer.borderColor = UIColor.green.cgColor
    }
    
    func animateWrongPassword() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.1,
                       options: [.autoreverse],
                       animations: {
                        self.loginField.layer.borderWidth = 1
                        self.loginField.layer.borderColor = UIColor.red.cgColor
                        self.loginField.layer.frame.origin.x += 1
                        self.loginField.layer.frame.origin.y += 1
                        self.passwordField.layer.borderWidth = 1
                        self.passwordField.layer.borderColor = UIColor.red.cgColor
                        self.passwordField.frame.origin.x += 1
                        self.passwordField.frame.origin.y += 1
                        
        }) { _ in
            self.loginField.layer.frame.origin.x -= 1
            self.loginField.layer.frame.origin.y -= 1
            self.passwordField.frame.origin.x -= 1
            self.passwordField.frame.origin.y -= 1
        }
    }
    
    func animateHeartBeats() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 1.3
        animation.duration = 1.6
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        heartLabelA.layer.add(animation, forKey: nil)
        heartLabelB.layer.add(animation, forKey: nil)
        heartLabelC.layer.add(animation, forKey: nil)
    }
}

// MARK: - WKNavigationDelegate
extension LoginFormController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
                url.path == "/blank.html",
                let fragment = url.fragment else { decisionHandler(.allow); return }
            
            let params = fragment
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce([String: String]()) { result, param in
                    var dict = result
                    let key = param[0]
                    let value = param[1]
                    dict[key] = value
                    return dict
            }
            
            #if DEBUG
            print(params)
            #endif
            
            guard let token = params["access_token"],
                let userIdString = params["user_id"],
                let userID = Int(userIdString) else {
                    decisionHandler(.allow)
                    return
            }
            
            Session.shared.token = token
            Session.shared.userId = userID
            
            //performSegue(withIdentifier: "RunTheApp", sender: nil)
        
            decisionHandler(.cancel)
    }
}
