//
//  LTWebView.swift
//  LMDispatcher
//
//  Created by APPLE on 14/10/20.
//  Copyright © 2020 Letstrack. All rights reserved.
//

import UIKit
import WebKit

class LTWebView: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var viewController: UIView!{
        didSet{
            viewController.layer.cornerRadius = 13.0
            viewController.clipsToBounds=true
        }
    }
    @IBOutlet weak var ltWebView: WKWebView!
     
        lazy var activityIndicator: UIActivityIndicatorView = {
            let ac = UIActivityIndicatorView()
            ac.hidesWhenStopped = true
            ac.color = .black
            return ac
        }()
        var url = ""
        override func viewDidLoad() {
            super.viewDidLoad()
            DispatchQueue.main.async {
                self.setup()
                self.navigationController?.navigationBar.tintColor = UIColor.black
//                self.navigationController?.navigationBar.isTranslucent = false
                if self.url != ""
                {
                    let myRequest = URLRequest(url: URL(string: self.url)!)
                    self.ltWebView.load(myRequest)
                }
            }
        }
//    override func viewWillDisappear(_ animated: Bool) {
////        self.navigationController?.navigationBar.isTranslucent = true
//    }
        
        override func loadView() {
            
            let webConfiguration = WKWebViewConfiguration()
            ltWebView = WKWebView(frame: .zero, configuration: webConfiguration)
            ltWebView.uiDelegate = self
            ltWebView.navigationDelegate = self
            view = ltWebView
        }
        func setup(){
            
            self.view.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerYAnchor.constraint(equalTo: self.ltWebView.centerYAnchor).isActive = true
            activityIndicator.centerXAnchor.constraint(equalTo: self.ltWebView.centerXAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            
        }
        
        func showActivityIndicator(show: Bool) {
            DispatchQueue.main.async {
                if show {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                } }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation:
                        WKNavigation!) {
            showActivityIndicator(show: false)
        }
        
        func webView(_ webView: WKWebView, didFail navigation:
                        WKNavigation!, withError error: Error) {
            showActivityIndicator(show: false)
        }
        
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print(error.localizedDescription)
        }
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if let url = webView.url?.absoluteString{
                debugPrint("url", url)
                showActivityIndicator(show: true)
            }
        }
        
        @objc func close(){
            self.navigationController?.popViewController(animated: true)
        }
    }

