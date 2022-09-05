//
//  demoApp.swift
//  demo
//
//  Created by Nishchay Jaiswal on 7/24/22.
//

import SwiftUI
import Firebase

@main
struct demoApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomePage()
        }
    }
}
