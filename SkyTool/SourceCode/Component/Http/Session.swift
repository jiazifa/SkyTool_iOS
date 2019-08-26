//
//  Session.swift
//  SkyTool
//
//  Created by tree on 2019/3/19.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

protocol SessionDelegateType: URLSessionDataDelegate {
    func add(_ task: SessionTask)
    func remove(_ task: URLSessionTask)
    func task(for task: URLSessionTask) -> SessionTask?
    func shouldTaskStart(_ task: SessionTask) -> Bool
}

class SessionDelegate: NSObject {
    private var tasks: [Int: SessionTask] = [:]
    private var lock: NSLock = NSLock()
}

extension SessionDelegate: SessionDelegateType {
    
    func add(_ task: SessionTask) {
        lock.lock()
        defer { lock.unlock() }
        tasks[task.task.taskIdentifier] = task
    }
    
    func remove(_ task: URLSessionTask) {
        lock.lock()
        defer { lock.unlock() }
        tasks.removeValue(forKey: task.taskIdentifier)
    }
    
    func task(for task: URLSessionTask) -> SessionTask? {
        lock.lock()
        defer { lock.unlock() }
        return tasks[task.taskIdentifier]
    }
    
    func shouldTaskStart(_ task: SessionTask) -> Bool {
        return true
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let task = tasks[dataTask.taskIdentifier] else { return }
        task.didReceiveData(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let dataTask = task as? URLSessionDataTask,
            let task = self.task(for: dataTask) else {
            return
        }
        task.onResult.call((task.mutableData, dataTask, error))
    }
}

class Session: NSObject {
    
    static let SessionCompleteWithErrorNotification: Notification.Name = .init("SessionCompleteWithErrorNotification")
    
    let session: URLSession
    let delegate: SessionDelegateType
    
    var authenticateAccount: Account?
    
    private lazy var defaultHost: String = {
        return Config.shared.host
    }()
    
    init(configuration: URLSessionConfiguration, queue: OperationQueue?) {
        self.delegate = SessionDelegate()
        self.session = URLSession(configuration: configuration,
                             delegate: delegate,
                             delegateQueue: queue)
        super.init()
    }
    
    @discardableResult
    func send<T: Request>(_ r: T) -> SessionTask? {
        var url: URL
        if r.path.contains("http") {
            url = URL(string: r.path)!
        } else {
            url = URL(string: defaultHost + r.path)!
        }
        var request = URLRequest(url: url, cachePolicy: r.cachePolicy, timeoutInterval: r.timeout)
        request.httpMethod = r.method.rawValue
        do {
            var newParams = r.parmeter
            if let account = self.authenticateAccount,
                let tokenData = account.tokenData,
                let token = String(data: tokenData, encoding: .utf8) {
                newParams.updateValue(token, forKey: "token")
            }
            request = try r.encoding.encode(request, with: newParams)
        } catch { return nil }
        
        let task = SessionTask(session: session, request: request)
        task.onResult.delegate(on: self) { (weakSelf, result) in
            weakSelf.didComplete(request: r, task: result.1, data: result.0, error: result.2)
        }
        
        delegate.add(task)
        task.resume()
        return task
    }
    
    func didComplete(request: Request, task: URLSessionTask, data: Data?, error: Error?) {
        var transportResponse: TransportResponse
        defer {
            request.complete(transportResponse)
            self.delegate.remove(task)
        }
        if let e = error {
            transportResponse = TransportResponse.response(with: e)
            return
        }
        guard let response = task.response as? HTTPURLResponse else {
            let e = NSError.init(domain: "com.sky.url.session", code: 0, userInfo: nil)
            transportResponse = TransportResponse.response(with: e as Error)
            return
        }
        // 请求出错后，发出通知，由 SessionManager 捕获
        transportResponse = TransportResponse.response(with: response, data: data)
        if let error = transportResponse.sessionError {
            NotificationCenter.default.post(name: Session.SessionCompleteWithErrorNotification, object: error)
        }
    }
}

typealias SessionTaskResult = (Data?, URLSessionTask, Error?)

public class SessionTask {
    let request: URLRequest
    
    let session: URLSession
    
    let task: URLSessionTask
    
    var mutableData: Data
    
    let onResult = Delegate<SessionTaskResult, Void>()
    
    init(session: URLSession, request: URLRequest) {
        self.session = session
        self.request = request
        self.task = session.dataTask(with: request)
        self.mutableData = Data()
    }
    
    func resume() {
        task.resume()
    }
}

extension SessionTask {
    func didReceiveData(_ data: Data) {
        mutableData.append(data)
    }
}
