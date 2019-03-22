//
//  ColorTheme.swift
//  SkyTool
//
//  Created by tree on 2019/3/22.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public enum ColorSchemeType: String {
    case light
    case dark
}

public enum ColorType: String {
    case background
}

public struct ColorItem: Codable, Hashable {
    var name: String
    var color: String
    
    var colorValue: UIColor {
        return UIColor.color(color)
    }
    
    init(_ name: String, colorString: String) {
        self.name = name
        self.color = colorString
    }
}

extension ColorItem: CustomStringConvertible {
    public var description: String {
        return "ColorItem<name:\(self.name), color:\(self.color)>"
    }
}

public struct ColorScheme: Hashable {
    
    // the color info
    var version: String
    
    var identifier: UUID
    
    var originMap: [String: AnyHashable]
    
    var metaMap: [String: ColorItem] = [:]
    
    init(version: String, identifier: UUID, originMap: [String: AnyHashable]) {
        self.version = version
        self.identifier = identifier
        self.originMap = originMap
        if let metas = originMap["metaMap"] as? [[String: Any]] {
            setupMetas(metas)
        }
    }
    
    private mutating func setupMetas(_ metas: [[String: Any]]) {
        metas.forEach { (params) in
            if let name = params["scheme"] as? String,
                let color = params["color"] as? String {
                let item = ColorItem.init(name, colorString: color)
                metaMap.updateValue(item, forKey: name)
            }
        }
    }
    
}

extension ColorScheme {
    public static func == (lhs: ColorScheme, rhs: ColorScheme) -> Bool {
        return lhs.identifier.uuidString == rhs.identifier.uuidString
            && lhs.version == rhs.version
            && NSDictionary(dictionary: lhs.originMap).isEqual(to: rhs.originMap)
    }
    
}

public extension ColorScheme {
    /// load url data to initial a theme
    static func load(from url: URL) -> ColorScheme? {
        let data = try! Data.init(contentsOf: url)
        guard let json = try! JSONSerialization.jsonObject(with: data,
                                                           options: [.allowFragments]) as? [String: AnyHashable] else {
                                                            fatalError()
        }
        let version = json["version"] as? String ?? "0.0.1"
        var uuid: UUID
        if let urlUUID = UUID(uuidString: url.lastPathComponent) {
            uuid = urlUUID
        } else if let mapUUID = UUID(uuidString: json["identifier"] as? String ?? "") {
            uuid = mapUUID
        } else { uuid = UUID.init() }
        let blue = ColorScheme(version: version, identifier: uuid, originMap: json)
        return blue
    }
    
    public func write(to url: URL) throws {
        let data = try JSONSerialization.data(withJSONObject: self.originMap, options: [.prettyPrinted])
        try data.write(to: url, options: [.atomic])
    }
    
    func color(for key: String) -> UIColor {
        return self.color(for: key, fallback: UIColor.white)
    }
    
    func color(for key: String, fallback: UIColor) -> UIColor {
        let item = self.metaMap[key]
        return item?.colorValue ?? fallback
    }
}
