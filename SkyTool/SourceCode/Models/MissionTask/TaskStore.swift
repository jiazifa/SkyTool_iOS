//
//  TaskStore.swift
//  SkyTool
//
//  Created by tree on 2019/4/14.
//  Copyright © 2019 treee. All rights reserved.
//

import Foundation

public protocol UUIDStore {
    associatedtype Item
    var fileManager: FileManager { get }
    var directoryName: String { get }
    
    func load() -> [Item]
    func load(_ uuid: UUID) -> Item?
    func loadURLs() -> Set<URL>
    
    func add(_ item: Item) -> Bool
    func remove(_ item: Item) -> Bool
    
    func contains(_ item: Item) -> Bool
    func url(_ item: Item) -> URL
    func url(_ uuid: UUID) -> URL
}

final class TaskStore: UUIDStore {
    
    public typealias Item = MissionBaseTask
    
    var fileManager: FileManager = FileManager.default
    
    var directoryName: String = "Mission"
    
    var directory: URL
    
    public static var shared: TaskStore {
        guard let sharedContainerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            preconditionFailure("Unable to get shared container URL")
        }
        return TaskStore.init(root: sharedContainerURL)
    }
    
    private init(root: URL) {
        self.directory = root.appendingPathComponent(directoryName)
        fileManager.createAndProtectDirectory(at: self.directory)
    }
    
    public func load() -> [MissionBaseTask] {
        return loadURLs().compactMap(MissionBaseTask.load) as? [MissionBaseTask] ?? []
    }
    
    public func load(_ uuid: UUID) -> MissionBaseTask? {
        return MissionBaseTask.load(from: url(uuid)) as? MissionBaseTask
    }
    
    func loadURLs() -> Set<URL> {
        do {
            let uuidName: (String) -> Bool = { UUID(uuidString: $0) != nil }
            let paths = try fileManager.contentsOfDirectory(atPath: directory.path)
            return Set<URL>(paths.filter(uuidName).map(directory.appendingPathComponent))
        }catch {
            return []
        }
    }
    
    @discardableResult
    public func add(_ item: MissionBaseTask) -> Bool {
        do {
            try item.write(to: url(item))
            return true
        } catch {
            return false
        }
    }
    
    public func remove(_ item: MissionBaseTask) -> Bool {
        do {
            try fileManager.removeItem(at: url(item))
            return true
        }catch {
            return false
        }
    }
    
    public func contains(_ item: MissionBaseTask) -> Bool {
        return fileManager.fileExists(atPath: url(item).path)
    }
    
    public func url(_ item: MissionBaseTask) -> URL {
        return url(item.identifier)
    }
    
    func url(_ uuid: UUID) -> URL {
        return self.directory.appendingPathComponent(uuid.uuidString)
    }
}


