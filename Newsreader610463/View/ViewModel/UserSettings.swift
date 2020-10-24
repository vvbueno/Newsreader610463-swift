//
//  UserSettings.swift
//  Newsreader610463
//
//  Created by Vicente on 25/10/2020.
//

import Foundation
import KeychainAccess

class UserSettings: ObservableObject {
    
    static let shared = UserSettings()
    
    private let keychain = Keychain()
    
    private var preflangKeyChainKey = "prefLanguage"
    private var usernameKeyChainKey = "username"
    
    @Published var lang: String = "en"
    
    init() {
        lang = prefLang ?? "en"
    }

    var prefLang: String? {
        get{
            try? keychain.get(preflangKeyChainKey)
        }
        set(newValue){
            guard let lang = newValue else {
                try? keychain.remove(preflangKeyChainKey)
                return
            }
            try? keychain.set(lang, key: preflangKeyChainKey)
            self.lang = lang
        }
    }
    
    var username: String? {
        get{
            try? keychain.get(usernameKeyChainKey)
        }
        set(newValue){
            guard let username = newValue else {
                try? keychain.remove(usernameKeyChainKey)
                return
            }
            try? keychain.set(username, key: usernameKeyChainKey)
        }
    }
    
    func updateLanguage(newLang: String) {
        prefLang = newLang
        lang = newLang
    }
    
    func clearUsername(){
        do {
            try keychain.remove(usernameKeyChainKey)
        } catch let error {
            print("Error deleting accessTokenKeyChainKey: \(error)")
        }
    }
    
}
