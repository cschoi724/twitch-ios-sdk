//
//  WebSocketClient.swift
//
//
//  Created by cschoi on 12/13/23.
//

import Foundation
import Starscream

protocol WSClient {
    var delegate: WSClientDelegate? { get set }
    
    func connect()
    func disconnect()
    func write(_ string: String)
}

protocol WSClientDelegate: AnyObject {
    func clientConnected(_ client: WSClient)
    func clientDisconnected(_ client: WSClient)
    func clientReconnected(_ client: WSClient)
    func client(_ client: WSClient, message rawMessage: String)
    func client(_ client: WSClient, error: Error?)
}

class DefaultWebSocketClient: WSClient, WebSocketDelegate {
    private let config: WebSocketConfiguration
    private var webSocket: WebSocket!
    weak var delegate: WSClientDelegate?
    
    init(config: WebSocketConfiguration) {
        self.config = config
    }
    
    func connect() {
        guard let url = URL(string: config.serverURL) else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = config.header
        webSocket = WebSocket(request: request, certPinner: FoundationSecurity(allowSelfSigned: true))
        
        webSocket.delegate = self
        webSocket.respondToPingWithPong = true
        webSocket.connect()
    }
    
    func disconnect() {
        guard self.webSocket != nil else { return }
        self.webSocket.disconnect()
        self.webSocket = nil
    }
    
    func write(_ string: String) {
        guard let webSocket = self.webSocket else { return }
        print("send: \(string)")
        webSocket.write(string: string)
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            delegate?.clientConnected(self)
        case .disconnected:
            delegate?.clientDisconnected(self)
        case .text(let string):
            delegate?.client(self, message: string)
        case .error(let error):
            delegate?.client(self, error: error)
        default:
            break
        }
    }
}

