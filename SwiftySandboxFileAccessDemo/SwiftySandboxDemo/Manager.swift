//
//  Manager.swift
//  SwiftySandboxDemo
//
//  Created by Rob Jonson on 01/06/2020.
//  Copyright © 2020 HobbyistSoftware. All rights reserved.
//

import Foundation
import SwiftySandboxFileAccess

class Manager {
    static let shared = Manager()
    
    /// Persist URL when a file is dropped on the dock (so permission is implicitly given)
    func persist(_ urls:[URL]){
        let access = AppSandboxFileAccess()
        for url in urls {
            _ = access.persistPermission(url:url)
            lastOpenedPath = url.path
        }
    }
    
    func clearStoredPermissions() {
        AppSandboxFileAccessPersist.deleteAllBookmarkData()
    }
    
    func pickFile(from window:NSWindow){
        let access = AppSandboxFileAccess()
        access.access(fileURL: urlToRequest,
                      fromWindow: window,
                      persistPermission: true) {
                        print("access the URL here")
        }
    }
    
    func pickFile() {
        let access = AppSandboxFileAccess()
        let success = access.access(fileURL: urlToRequest,
                                    askIfNecessary: true,
                                    persistPermission: true) {
                                        print("access the URL here")
        }
        print("success: \(success)")
    }
    
    func checkAccessToLastPath() {
        guard let lastOpenedPath = lastOpenedPath else {
            return
        }
        
        let access = AppSandboxFileAccess()
        let success = access.access(path: lastOpenedPath,
                                       askIfNecessary: false)
        
        print("access status : \(success)")
    }
    
    //MARK: Utilities
    
    let urlToRequest:URL = {
        return FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Pictures")
    }()
    
    
    static let lastOpenedPathKey = "lastOpenedPath"
    var lastOpenedPath:String? {
        get {
            return UserDefaults.standard.string(forKey: Manager.lastOpenedPathKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Manager.lastOpenedPathKey)
        }
    }
}

