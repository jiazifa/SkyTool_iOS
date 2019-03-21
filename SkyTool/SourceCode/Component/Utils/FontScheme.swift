//
//  FontScheme.swift
//  playground
//
//  Created by tree on 2018/11/5.
//  Copyright © 2018 treee. All rights reserved.
//

import Foundation
import UIKit

public enum FontTextStyle: String {
    case largeTitle
    case inputText
}

public enum FontSize: String {
    case large
    case normal
    case medium
    case small
}

public enum FontWeight: String {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
}

public extension FontWeight {
    
    @available(iOS 8.2, *)
    static let weightMapping: [FontWeight: UIFont.Weight] = [
        .ultraLight: UIFont.Weight.ultraLight,
        .thin: UIFont.Weight.thin,
        .light: UIFont.Weight.light,
        .regular: UIFont.Weight.regular,
        .medium: UIFont.Weight.medium,
        .semibold: UIFont.Weight.semibold,
        .bold: UIFont.Weight.bold,
        .heavy: UIFont.Weight.heavy,
        .black: UIFont.Weight.black
    ]
    
    @available(iOS 8.2, *)
    static let accessibilityWeightMapping: [FontWeight: UIFont.Weight] = [
        .ultraLight: UIFont.Weight.regular,
        .thin: UIFont.Weight.regular,
        .light: UIFont.Weight.regular,
        .regular: UIFont.Weight.regular,
        .medium: UIFont.Weight.medium,
        .semibold: UIFont.Weight.semibold,
        .bold: UIFont.Weight.bold,
        .heavy: UIFont.Weight.heavy,
        .black: UIFont.Weight.black
    ]
    
    @available(iOS 8.2, *)
    public func fontWeight(accessibilityBlodText: Bool? = nil) -> UIFont.Weight {
        let blodTextEnabled = accessibilityBlodText ?? UIAccessibility.isBoldTextEnabled
        
        let mapping = { () -> [FontWeight: UIFont.Weight] in
            if blodTextEnabled {
                return type(of: self).accessibilityWeightMapping
            }
            return type(of: self).weightMapping
        }()
        return mapping[self]!
    }
    
    @available(iOS 8.2, *)
    public init(weight: UIFont.Weight) {
        self = (type(of: self).weightMapping.filter({ $0.value == weight }).first?.key) ?? FontWeight.regular
    }
}

extension UIFont {
    public static func systemFont(ofSize size: CGFloat,
                                  contentSizeCategory: UIContentSizeCategory,
                                  weight: FontWeight) -> UIFont {
        
        let size = round(size * UIFont.preferredContentSizeMultiplier(for: contentSizeCategory))
        if #available(iOSApplicationExtension 8.2, *) {
            if #available(iOS 8.2, *) {
                return UIFont.systemFont(ofSize: size, weight: weight.fontWeight())
            } else {
                return UIFont.systemFont(ofSize: size)
            }
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    @available(iOS 8.2, *)
    @objc public var classyStemFontName: String {
        let weightSpeciifier = { () -> String in
            guard #available(iOSApplicationExtension 8.2, *),
                let traits = self.fontDescriptor.object(forKey: .traits) as? NSDictionary,
                let floatWeight = traits[UIFontDescriptor.TraitKey.weight] as? NSNumber else {
                    return ""
            }
            let fontWeiget = FontWeight.init(weight: .init(rawValue: CGFloat(floatWeight.floatValue)))
            return "-\(fontWeiget.rawValue.capitalized)"
        }()
        return "System\(weightSpeciifier) \(self.pointSize)"
        
    }
}

public struct FontSpec: Hashable {
    public let size: FontSize
    
    public let weight: FontWeight?
    
    public let fontTextStyle: FontTextStyle?
    
    // a optional value has none, some ... types
    public init(_ size: FontSize, _ weight: FontWeight?, _ fontTextStyle: FontTextStyle? = .none) {
        self.size = size
        self.weight = weight
        self.fontTextStyle = fontTextStyle
    }
}

extension FontSpec {
    var fontWithoutDynamicType: UIFont? {
        return FontScheme(contentSizeCategory: .medium).font(for: self)
    }
}

#if !swift(>=4.2)
extension FontSpec {
public var hashValue: Int {
return self.size.hashValue &* 1000 &+ (self.weight?.hashValue ?? 100)
}
}
#endif

extension FontSpec {
    public var font: UIFont? {
        return defaultFontScheme.font(for: self)
    }
}

extension FontSpec: CustomStringConvertible {
    public var description: String {
        var descriptionString = "\(self.size)"
        
        if let weight = self.weight {
            descriptionString += "-\(weight)"
        }
        
        if let fontTextStyle = self.fontTextStyle {
            descriptionString += "-\(fontTextStyle.rawValue)"
        }
        
        return descriptionString
        
    }
}

public func == (left: FontSpec, right: FontSpec) -> Bool {
    return left.size == right.size
        && left.weight == right.weight
        && left.fontTextStyle == right.fontTextStyle
}

@objcMembers public final class FontScheme {
    public typealias FontMapping = [FontSpec: UIFont]
    
    public var fontMapping: FontMapping = [:]
    
    fileprivate static func mapFontTextStyleAndFontSizeAndPoint(
        fintSizeTuples allFontSizes: [(fontSize: FontSize, point: CGFloat)],
        mapping: inout [FontSpec: UIFont],
        fontTextStyle: FontTextStyle,
        contentSizeCategory: UIContentSizeCategory) {
        
        let allFontWeights: [FontWeight] = [.ultraLight,
                                            .thin,
                                            .light,
                                            .regular,
                                            .medium,
                                            .semibold,
                                            .bold,
                                            .heavy,
                                            .black]
        for fontWeight in allFontWeights {
            for fontSizeTuple in allFontSizes {
                let fontspec = FontSpec(fontSizeTuple.fontSize, .none, fontTextStyle)
                mapping[fontspec] = UIFont.systemFont(ofSize: fontSizeTuple.point,
                                                      contentSizeCategory: contentSizeCategory,
                                                      weight: .light)
                
                let fontspecWithWeight = FontSpec(fontSizeTuple.fontSize, fontWeight, fontTextStyle)
                mapping[fontspecWithWeight] = UIFont.systemFont(ofSize: fontSizeTuple.point,
                                                                contentSizeCategory: contentSizeCategory,
                                                                weight: fontWeight)
            }
        }
    }
    
    public static func defaultFontMapping(with contentSizeCategory: UIContentSizeCategory) -> FontMapping {
        var mapping: FontMapping = [:]
        // the ratio is following 11:13:16:24, same as default case
        // swiftlint:disable line_length
        let largeTitleFontSizeTuples: [(fontSize: FontSize, point: CGFloat)] = [(fontSize: .large, point: 40),
                                                                                (fontSize: .normal, point: 26),
                                                                                (fontSize: .medium, point: 22),
                                                                                (fontSize: .small, point: 18)]
        mapFontTextStyleAndFontSizeAndPoint(fintSizeTuples: largeTitleFontSizeTuples,
                                            mapping: &mapping, fontTextStyle: .largeTitle,
                                            contentSizeCategory: contentSizeCategory)
        
        let inputTextFontSizeTuples: [(fontSize: FontSize, point: CGFloat)] = [(fontSize: .large, point: 21),
                                                                               (fontSize: .normal, point: 14),
                                                                               (fontSize: .medium, point: 12),
                                                                               (fontSize: .small, point: 10)]
        mapFontTextStyleAndFontSizeAndPoint(fintSizeTuples: inputTextFontSizeTuples,
                                            mapping: &mapping, fontTextStyle: .inputText,
                                            contentSizeCategory: contentSizeCategory)
        
        // fontTextStyle: none
        mapping[FontSpec(.large, .none, .none)]      = UIFont.systemFont(ofSize: 24,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .light)
        mapping[FontSpec(.large, .medium, .none)]    = UIFont.systemFont(ofSize: 24,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .medium)
        mapping[FontSpec(.large, .semibold, .none)]  = UIFont.systemFont(ofSize: 24,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .semibold)
        mapping[FontSpec(.large, .regular, .none)]   = UIFont.systemFont(ofSize: 24,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .regular)
        mapping[FontSpec(.large, .light, .none)]     = UIFont.systemFont(ofSize: 24,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .light)
        mapping[FontSpec(.large, .thin, .none)]      = UIFont.systemFont(ofSize: 24,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .thin)
        
        mapping[FontSpec(.normal, .none, .none)]     = UIFont.systemFont(ofSize: 16,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .light)
        mapping[FontSpec(.normal, .light, .none)]    = UIFont.systemFont(ofSize: 16,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .light)
        mapping[FontSpec(.normal, .thin, .none)]     = UIFont.systemFont(ofSize: 16,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .thin)
        mapping[FontSpec(.normal, .regular, .none)]  = UIFont.systemFont(ofSize: 16,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .regular)
        mapping[FontSpec(.normal, .semibold, .none)] = UIFont.systemFont(ofSize: 16,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .semibold)
        mapping[FontSpec(.normal, .medium, .none)]   = UIFont.systemFont(ofSize: 16,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .medium)
        
        mapping[FontSpec(.medium, .none, .none)] = UIFont.systemFont(ofSize: 13,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .light)
        mapping[FontSpec(.medium, .medium, .none)] = UIFont.systemFont(ofSize: 13,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .medium)
        mapping[FontSpec(.medium, .semibold, .none)] = UIFont.systemFont(ofSize: 13,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .semibold)
        mapping[FontSpec(.medium, .regular, .none)]  = UIFont.systemFont(ofSize: 13,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .regular)
        
        mapping[FontSpec(.small, .none, .none)] = UIFont.systemFont(ofSize: 11,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .light)
        mapping[FontSpec(.small, .medium, .none)]    = UIFont.systemFont(ofSize: 11,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .medium)
        mapping[FontSpec(.small, .semibold, .none)]  = UIFont.systemFont(ofSize: 11,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .semibold)
        mapping[FontSpec(.small, .regular, .none)]   = UIFont.systemFont(ofSize: 11,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .regular)
        mapping[FontSpec(.small, .light, .none)]     = UIFont.systemFont(ofSize: 11,
                                                                         contentSizeCategory: contentSizeCategory,
                                                                         weight: .light)
        // swiftlint:enable line_length
        return mapping
    }
    
    convenience init(contentSizeCategory: UIContentSizeCategory) {
        self.init(fontMapping: type(of: self).defaultFontMapping(with: contentSizeCategory))
    }
    
    public init(fontMapping: FontMapping) {
        self.fontMapping = fontMapping
    }
    
    public func font(for fontType: FontSpec) -> UIFont? {
        return self.fontMapping[fontType]
    }
}

public var defaultFontScheme: FontScheme = {
    return FontScheme.init(contentSizeCategory: UIApplication.shared.preferredContentSizeCategory)
}()
