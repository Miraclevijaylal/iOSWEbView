//
//  ViewController.swift
//  WebVIewProject
//
//  Created by Vijay Lal on 11/11/24.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var progressView: UIProgressView!
    var webSites = ["apple.com", "twitch.com"]
    lazy var webViews: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initview()
        let url = URL(string: "https://" + webSites[0])!
        webViews.load(URLRequest(url: url))
        webViews.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(didTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: webViews, action: #selector(webViews.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        toolbarItems = [progressButton, spacer, reload]
        navigationController?.isToolbarHidden = false
        webViews.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
}
extension ViewController{
    func initview() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(webViews)
        webViews.translatesAutoresizingMaskIntoConstraints = false
        [webViews.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0),
         webViews.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0),
         webViews.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0),
         webViews.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0)
        ].forEach({ $0.isActive = true })
    }
}
extension ViewController {
    @objc func didTapped() {
        let ac = UIAlertController(title: "Open", message: nil, preferredStyle: .actionSheet)
        for webSite in webSites {
            ac.addAction(UIAlertAction(title: webSite, style:.default , handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancle", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}
extension ViewController: WKNavigationDelegate {
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "http://" + actionTitle) else { return }
        webViews.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webViews.estimatedProgress)
        }
    }
}
