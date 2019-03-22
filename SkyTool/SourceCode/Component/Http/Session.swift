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
        remove(dataTask)
        task.onResult.call((task.mutableData, dataTask.response, error))
    }
}

class Session: NSObject {
    
    private static var _shared: Session?
    public static var shared: Session {
        return guardSharedProperty(_shared)
    }
    
    let session: URLSession
    let delegate: SessionDelegateType
    
    override init() {
        self.delegate = SessionDelegate()
        self.session = URLSession(configuration: URLSessionConfiguration.default,
                             delegate: delegate,
                             delegateQueue: nil)
        super.init()
        Session._shared = self
    }
    
    func send<T: Request>(_ r: T, handler: ((Result<T.Response, SkyNetworkError>) -> Void)? = nil) -> SessionTask? {
        let url = URL(string: r.path)!
        var request = URLRequest(url: url, cachePolicy: r.cachePolicy, timeoutInterval: r.timeout)
        request.httpMethod = r.method.rawValue
        do {
            request = try r.encoding.encode(request, with: r.parmeter)
        } catch { return nil }
        
        let task = SessionTask(session: session, request: request)
        task.onResult.delegate(on: self) { (weakSelf, result) in
            switch result {
            case (_, _, let error?):
                let  reson = SkyNetworkError.ResponseErrorReason.URLSessionError(error)
                handler?(.failure(SkyNetworkError.responseFailed(reason: reson)))
                break
            case (let data?, _, .none):
                do {
                    if let res = try T.Response.parse(data: data) {
                        handler?(.success(res))
                    } else {
                        let reson = SkyNetworkError.ResponseErrorReason.nonHTTPURLResponse
                        handler?(.failure(SkyNetworkError.responseFailed(reason: reson)))
                    }
                } catch {
                    let reson = SkyNetworkError.ResponseErrorReason.dataParsingFailed(T.Response.self, data, error)
                    handler?(.failure(SkyNetworkError.responseFailed(reason: reson)))
                }
                break
            default:
                break
            }
        }
        delegate.add(task)
        task.resume()
        return task
    }
}

typealias SessionTaskResult = (Data?, URLResponse?, Error?)

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
