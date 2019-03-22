//
//  ThemeManager.swift
//  SkyTool
//
//  Created by tree on 2019/3/22.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit

public let ThemeManagerDidUpdateThemesNotificationName = Notification.Name("ThemeManagerDidUpdateThemesNotification")

fileprivate extension UserDefaults {
    static let themeManagerSelectedThemeKey = "ThemeManagerSelectedThemeKey"
    
    var selectedThemeIdentifier: UUID? {
        get { return string(forKey: UserDefaults.themeManagerSelectedThemeKey).flatMap(UUID.init) }
        set { set(newValue?.uuidString, forKey: UserDefaults.themeManagerSelectedThemeKey) }
    }
}

public class ThemeManager {
    private static var _shared: ThemeManager?
    public static var shared: ThemeManager {
        return guardSharedProperty(ThemeManager._shared)
    }
    
    private let defaults = UserDefaults.standard
    
    private let store: ColorStore
    
    public private(set) var themes = Set<ColorScheme>()
    
    public private(set) var selectedColorScheme: ColorScheme!
    
    @objc(initWithSharedDirectory:)
    public init(sharedDirectory: URL) {
        store = ColorStore.init(root: sharedDirectory)
        updateThemes()
        ThemeManager._shared = self
    }
    
    public static func delete(at root: URL) {
        AccountStore.delete(at: root)
        UserDefaults.standard.selectedThemeIdentifier = nil
    }
    
    public func addOrUpdate(_ theme: ColorScheme) {
        store.add(theme)
        updateThemes()
    }
    
    public func addAndSelect(_ theme: ColorScheme) {
        addOrUpdate(theme)
        self.select(theme)
    }
    
    public func remove(_ theme: ColorScheme) {
        store.remove(theme)
        if selectedColorScheme == theme {
            defaults.selectedThemeIdentifier = nil
        }
        updateThemes()
    }
    
    public func select(_ theme: ColorScheme) {
        guard themes.contains(theme) == true else {
            fatalError()
        }
        guard theme != selectedColorScheme else { return }
        defaults.selectedThemeIdentifier = theme.identifier
        updateThemes()
    }
    
    public func theme(with id: UUID) -> ColorScheme? {
        return themes.first(where: { $0.identifier == id })
    }
}

extension ThemeManager {
    private func updateThemes() {
        var updatedThemes = Set<ColorScheme>()
        for theme in computeSortedColorScheme() {
            if let existingTheme = self.theme(with: theme.identifier) {
                updatedThemes.update(with: existingTheme)
            } else {
                updatedThemes.insert(theme)
            }
        }
        
        themes = updatedThemes
        
        let cumputedColorScheme = computeSelectedColorScheme()
        if let theme = cumputedColorScheme,
            let exisitingColorScheme = self.theme(with: theme.identifier) {
            self.selectedColorScheme = exisitingColorScheme
        } else {
            self.selectedColorScheme = cumputedColorScheme
        }
        NotificationCenter.default.post(name: ThemeManagerDidUpdateThemesNotificationName, object: self)
    }
    
    public func ColorScheme(with id: UUID) -> ColorScheme? {
        return themes.first(where: { return $0.identifier == id })
    }
    
    private func computeSelectedColorScheme() -> ColorScheme? {
        return defaults.selectedThemeIdentifier.flatMap(store.load)
    }
    
    private func computeSortedColorScheme() -> Set<ColorScheme> {
        let sorted = store.load().sorted(by: { (lhs, rhs) -> Bool in
            return lhs.identifier.uuidString > rhs.identifier.uuidString
        })
        return Set<ColorScheme>(sorted)
    }
}

public extension ThemeManager {
    func color(for usage: ColorType) -> UIColor {
        return self.selectedColorScheme.color(for: usage.rawValue)
    }
}
