
//  Created by Leigh McCulloch on 23/11/2013.
//
//  Copyright (c) 2013, Leigh McCulloch
//  All rights reserved.
//
//  BSD-2-Clause License: http://opensource.org/licenses/BSD-2-Clause
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
//  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
//  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
//  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

public class SandboxFileAccessPersist: SandboxFileAccessProtocol {
    
    public func bookmarkData(for url: URL) -> Data? {
        let defaults = UserDefaults.standard
        
        // loop through the bookmarks one path at a time down the URL
        var subURL = url
        while (subURL.path.count) > 1 {
            // give up when only '/' is left in the path
            let key = SandboxFileAccessPersist.keyForBookmarkData(for: subURL)
            let bookmark = defaults.data(forKey: key)
            if bookmark != nil {
                // if a bookmark is found, return it
                return bookmark
            }
            subURL = subURL.deletingLastPathComponent()
        }
        
        // no bookmarks for the URL, or parent to the URL were found
        return nil
    }
    
    public func setBookmark(data: Data?, for url: URL) {
        let defaults = UserDefaults.standard
        let key = SandboxFileAccessPersist.keyForBookmarkData(for: url)
        defaults.set(data, forKey: key)
    }
    
    public func clearBookmarkData(for url: URL) {
        let defaults = UserDefaults.standard
        let key = SandboxFileAccessPersist.keyForBookmarkData(for: url)
        defaults.removeObject(forKey: key)
    }
    
    class func keyForBookmarkData(for url: URL) -> String {
        let urlStr = url.absoluteString
        return String(format: "bd_%1$@", urlStr)
    }
    
    /// Handy dev/debugging option
    public class func deleteAllBookmarkData() {
        let allDefaults = UserDefaults.standard.dictionaryRepresentation()
        
        for key in allDefaults.keys {
            if key.hasPrefix("bd_") {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}
