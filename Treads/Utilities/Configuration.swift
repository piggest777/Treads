//
//  Configuration.swift
//  Treads
//
//  Created by Denis Rakitin on 2019-04-25.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import Foundation
import RealmSwift

class RealConfig {
    static var runDataConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 0,
            migrationBlock: {migration, oldSchemaVersion in
                if (oldSchemaVersion < 0) {
                    //nothing to do
                }
        })
     return config
    }
    
}
