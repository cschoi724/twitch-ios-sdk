//
//  TwitchAuth.swift
//
//
//  Created by cschoi on 2023/03/03.
//

import Alamofire
import Foundation
import UIKit
import WebKit

public protocol TwitchAuth {
    var delegate: TwitchAuthDelegate? { get set }
    
    func login(_ presentingViewController: UIViewController)
    func logout()
}

public protocol TwitchAuthDelegate: AnyObject {
    func loggedIn(_ service: TwitchAuth, result: Result<TwitchUser, TwitchSDKError> )
    func canceled(_ service: TwitchAuth)
}

public class TwitchAuthAPI: NSObject, TwitchAuth {
    private let config: TwitchAuthConfigration
    private let repository: TwitchRepository
    public weak var delegate: TwitchAuthDelegate?
    private var viewControlelr: UIViewController!
    private var webView: WKWebView!
    
    public init(config: TwitchAuthConfigration) {
        self.config = config
        self.repository = DefaultTwitchRepository(config: config)
        super.init()
    }
    
    func dismiss(_ compeltion: @escaping () -> Void ) {
        viewControlelr.dismiss(
            animated: true,
            completion: {
                self.webView = nil
                self.viewControlelr = nil
                compeltion()
            }
        )
    }
    
    @objc func swipe() {
        if let webView = self.webView,
           webView.canGoBack {
            webView.goBack()
        } else {
            dismiss { [weak self] in
                guard let self = self else { return }
                self.delegate?.canceled(self)
            }
        }
    }
    
    func createWebView() -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.dataDetectorTypes = WKDataDetectorTypes.all
        webConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.allowsAirPlayForMediaPlayback = true
        webConfiguration.selectionGranularity = WKSelectionGranularity.character
        webConfiguration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypes.all
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.bounces = false
        webView.allowsLinkPreview = false
        return webView
    }
    
    public func logout() {
    }
    
    public func login(_ presentingViewController: UIViewController) {
        guard var urlComponents = URLComponents(string: config.authURL) else {
            self.loginFailure(TwitchSDKError.urlGeneration)
            return
        }
        let queryParameter: [String: String] = [
            "client_id": config.clientId,
            "response_type": "token",
            "redirect_uri": config.redirectUri,
            "force_verify": config.forceVerify,
            "scope": config.scope,
            "state": config.state
        ]
        
        var urlQueryItems: [URLQueryItem] = []
        queryParameter.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        urlComponents.queryItems = urlQueryItems
        
        guard let url = urlComponents.url,
              let urlRequest = try? URLRequest(url: url, method: .get) else {
            self.loginFailure(TwitchSDKError.urlGeneration)
            return
        }
        
        viewControlelr = UIViewController()
        viewControlelr.modalPresentationStyle = .pageSheet
        viewControlelr.presentationController?.delegate = self
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeGesture.direction = .right
        viewControlelr.view.addGestureRecognizer(swipeGesture)
        webView = createWebView()
        viewControlelr.view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: viewControlelr.view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: viewControlelr.view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: viewControlelr.view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: viewControlelr.view.trailingAnchor).isActive = true
        presentingViewController.present(viewControlelr, animated: true) {
            print(urlRequest)
            self.webView.load(urlRequest)
        }
    }
    
    func loginSuccess(_ user: TwitchUser) {
        dismiss { [weak self] in
            guard let self = self else { return }
            self.delegate?.loggedIn(self, result: .success(user))
        }
    }
    
    func loginFailure(_ error: TwitchSDKError) {
        dismiss { [weak self] in
            guard let self = self else { return }
            self.delegate?.loggedIn(self, result: .failure(error))
        }
    }
    
    func getInfo(_ accessToken: String) {
        repository.getInfo(accessToken: accessToken) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dto):
                let user = TwitchUser(
                    token: accessToken,
                    id: dto.id,
                    login: dto.login,
                    displayName: dto.display_name,
                    type: dto.type,
                    broadcasterType: dto.broadcaster_type,
                    profileImageURL: dto.profile_image_url,
                    offlineImageURL: dto.offline_image_url,
                    description: dto.description,
                    viewCount: dto.view_count,
                    email: dto.email,
                    createdAt: dto.created_at
                )
                self.loginSuccess(user)
            case .failure(let error):
                self.loginFailure(error)
            }
        }
    }
    
    func getToken(_ code: String) {
        repository.getToken(code: code) { result in
            switch result {
            case .success(let crendential):
                self.getInfo(crendential.access_token)
            case .failure(let error):
                self.loginFailure(error)
            }
        }
    }
}

extension TwitchAuthAPI: WKNavigationDelegate {
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let requestUrl = navigationAction.request.url else {
            self.loginFailure(TwitchSDKError.urlGeneration)
            return
        }
        // print(requestUrl.absoluteString)
        /*http://localhost:3000/
         #access_token=73d0f8mkabpbmjp921asv2jaidwxn
            &scope=channel%3Amanage%3Apolls+channel%3Aread%3Apolls
            &state=c3ab8aa609ea11e793ae92361f002671
            &token_type=bearer*/
        
        if requestUrl.absoluteString.hasPrefix(config.redirectUri) {
            print(requestUrl.absoluteString)
            let urlStr = requestUrl.absoluteString
                .replacingOccurrences(of: "#", with: "?")
            guard let url = URL(string: urlStr) else {
                self.loginFailure(TwitchSDKError.urlGeneration)
                return
            }
            let queryParameters = url.queryParameters ?? [:]
            print(queryParameters)
            if let accessToken = queryParameters["access_token"] {
                self.getInfo(accessToken)
            } else if let code = queryParameters["code"] {
                self.getToken(code)
            } else {
                self.loginFailure(TwitchSDKError.noResponse)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let javascript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(javascript)
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let exceptions = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, exceptions)
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    }
}

extension TwitchAuthAPI: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.canceled(self)
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
    }
}
