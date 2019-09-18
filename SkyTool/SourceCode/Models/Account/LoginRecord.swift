//
//  LoginRecord.swift
//  SkyTool
//
//  Created by tree on 2019/9/18.
//  Copyright © 2019 treee. All rights reserved.
//

import UIKit
import CoreData

@objc(LoginRecord)
public class LoginRecord: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginRecord> {
        return NSFetchRequest<LoginRecord>(entityName: "LoginRecord")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var uuid: UUID?
}
