//
//  XMLElement.swift
//  SkyTool
//
//  Created by tree on 2019/3/27.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

class XMLElement {
    static let attributesKey = "___ATTRIBUTES"
    static let escapedCharacterSet = [("&", "&amp"), ("<", "&lt;"), (">", "&gt;"), ( "'", "&apos;"), ("\"", "&quot;")]
    
    var key: String
    var value: String? = nil
    var attributes: [String: String] = [:]
    var children: [String: [XMLElement]] = [:]
    
    internal init(key: String, value: String? = nil, attributes: [String: String] = [:], children: [String: [XMLElement]] = [:]) {
        self.key = key
        self.value = value
        self.attributes = attributes
        self.children = children
    }
    
    convenience init(key: String, value: Optional<CustomStringConvertible>, attributes: [String: CustomStringConvertible] = [:]) {
        self.init(key: key, value: value?.description, attributes: attributes.mapValues({ $0.description }), children: [:])
    }
    
    convenience init(key: String, children: [String: [XMLElement]], attributes: [String: CustomStringConvertible] = [:]) {
        self.init(key: key, value: nil, attributes: attributes.mapValues({ $0.description }), children: children)
    }
    
    static func createRootElement(rootKey: String, object: NSObject) -> XMLElement? {
        let element = XMLElement(key: rootKey)
        
        if let object = object as? NSDictionary {
            XMLElement.modifyElement(element: element, parentElement: nil, key: nil, object: object)
        } else if let object = object as? NSArray {
            XMLElement.createElement(parentElement: element, key: rootKey, object: object)
        }
        
        return element
    }
    
    fileprivate static func createElement(parentElement: XMLElement?, key: String, object: NSDictionary) {
        let element = XMLElement(key: key)
        
        modifyElement(element: element, parentElement: parentElement, key: key, object: object)
    }
    
    fileprivate static func modifyElement(element: XMLElement, parentElement: XMLElement?, key: String?, object: NSDictionary) {
        element.attributes = (object[XMLElement.attributesKey] as? [String: Any])?.mapValues({ String(describing: $0) }) ?? [:]
        
        let objects: [(String, NSObject)] = object.compactMap({
            guard let key = $0 as? String, let value = $1 as? NSObject, key != XMLElement.attributesKey else { return nil }
            
            return (key, value)
        })
        
        for (key, value) in objects {
            if let dict = value as? NSDictionary {
                XMLElement.createElement(parentElement: element, key: key, object: dict)
            } else if let array = value as? NSArray {
                XMLElement.createElement(parentElement: element, key: key, object: array)
            } else if let string = value as? NSString {
                XMLElement.createElement(parentElement: element, key: key, object: string)
            } else if let number = value as? NSNumber {
                XMLElement.createElement(parentElement: element, key: key, object: number)
            } else {
                XMLElement.createElement(parentElement: element, key: key, object: NSNull())
            }
        }
        
        if let parentElement = parentElement, let key = key {
            parentElement.children[key] = (parentElement.children[key] ?? []) + [element]
        }
    }
    
    fileprivate static func createElement(parentElement: XMLElement, key: String, object: NSArray) {
        let objects = object.compactMap({ $0 as? NSObject })
        objects.forEach({
            if let dict = $0 as? NSDictionary {
                XMLElement.createElement(parentElement: parentElement, key: key, object: dict)
            } else if let array = $0 as? NSArray {
                XMLElement.createElement(parentElement: parentElement, key: key, object: array)
            } else if let string = $0 as? NSString {
                XMLElement.createElement(parentElement: parentElement, key: key, object: string)
            } else if let number = $0 as? NSNumber {
                XMLElement.createElement(parentElement: parentElement, key: key, object: number)
            } else {
                XMLElement.createElement(parentElement: parentElement, key: key, object: NSNull())
            }
        })
    }
    
    fileprivate static func createElement(parentElement: XMLElement, key: String, object: NSNumber) {
        let element = XMLElement(key: key, value: object.description)
        parentElement.children[key] = (parentElement.children[key] ?? []) + [element]
    }
    
    fileprivate static func createElement(parentElement: XMLElement, key: String, object: NSString) {
        let element = XMLElement(key: key, value: object.description)
        parentElement.children[key] = (parentElement.children[key] ?? []) + [element]
    }
    
    fileprivate static func createElement(parentElement: XMLElement, key: String, object: NSNull) {
        let element = XMLElement(key: key)
        parentElement.children[key] = (parentElement.children[key] ?? []) + [element]
    }
    
    func flatten() -> [String: Any] {
        var node: [String: Any] = attributes
        
        for childElement in children {
            for child in childElement.value {
                if let content = child.value {
                    if let oldContent = node[childElement.key] as? Array<Any> {
                        node[childElement.key] = oldContent + [content]
                        
                    } else if let oldContent = node[childElement.key] {
                        node[childElement.key] = [oldContent, content]
                        
                    } else {
                        node[childElement.key] = content
                    }
                } else if !child.children.isEmpty || !child.attributes.isEmpty {
                    let newValue = child.flatten()
                    
                    if let existingValue = node[childElement.key] {
                        if var array = existingValue as? Array<Any> {
                            array.append(newValue)
                            node[childElement.key] = array
                        } else {
                            node[childElement.key] = [existingValue, newValue]
                        }
                    } else {
                        node[childElement.key] = newValue
                    }
                }
            }
        }
        
        return node
    }
}
