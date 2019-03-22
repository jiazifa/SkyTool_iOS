//
//  ColorStore.swift
//  SkyTool
//
//  Created by tree on 2019/3/22.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class ColorStore: NSObject {
    private static let directoryName = "Colors"
    
    private let fileManager = FileManager.default
    private let directory: URL
    
    public required init(root: URL) {
        self.directory = root.appendingPathComponent(ColorStore.directoryName)
        super.init()
        fileManager.createAndProtectDirectory(at: self.directory)
    }
    
    func load() -> Set<ColorScheme> {
        return Set<ColorScheme>(loadURLs().compactMap(ColorScheme.load))
    }
    
    func load(_ uuid: UUID) -> ColorScheme? {
        return ColorScheme.load(from: url(for: uuid))
    }
    
    @discardableResult
    func add(_ theme: ColorScheme) -> Bool {
        do {
            try theme.write(to: url(for: theme))
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func remove(_ theme: ColorScheme) -> Bool {
        do {
            guard contains(theme) else { return false }
            try fileManager.removeItem(at: url(for: theme))
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func delete(at root: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: root.appendingPathComponent(directoryName))
            return true
        } catch {
            return false
        }
    }
    
    func contains(_ theme: ColorScheme) -> Bool {
        return fileManager.fileExists(atPath: url(for: theme).path)
    }
    
    private func loadURLs() -> Set<URL> {
        do {
            let uuidName: (String) -> Bool = { UUID(uuidString: $0) != nil }
            let paths = try fileManager.contentsOfDirectory(atPath: directory.path)
            return Set<URL>(paths.filter(uuidName).map(directory.appendingPathComponent))
        } catch {
            return []
        }
    }
    
    private func url(for theme: ColorScheme) -> URL {
        return self.url(for: theme.identifier)
    }
    
    private func url(for uuid: UUID) -> URL {
        return self.directory.appendingPathComponent(uuid.uuidString)
    }
}
