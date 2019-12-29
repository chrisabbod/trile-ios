//
//  FirebaseAuthManager.swift
//  Trile
//
//  Created by Chris Abbod on 12/28/19.
//  Copyright © 2019 Trile. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
        
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
}

//@escape means the closure is allowed to escape. A closer is said to escape a function when
//the closure is passed as an argument of the function but is called after the function returns
//(Bool) -> Void means the closure accepts a boolean and returns nothing (parameters) -> return type
