//
//  data.swift
//  demo
//
//  Created by Nishchay Jaiswal on 7/24/22.
//

import Foundation
import Firebase

class DataModel: ObservableObject {
    @Published var list = [cord]()
    @Published var count = 0
    
    func getData() {
        let db = Firestore.firestore()
        db.collection("coordinates").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { d in
                            return cord(id: d.documentID,
                                        lat: d["lat"] as? String ?? "nil",
                                        long: d["long"] as? String ?? "nil")
                    }
                }
            }
        }
            
            else {
                print("an error occurred when fetching data")
            }
        }
    }
    
    func writeData(lat: String, long: String, time: String) {
        let db = Firestore.firestore()
        db.collection("coordinates").document(String(self.count)).setData(["lat": lat, "long": long, "feTimeStamp": time, "serverTimeStamp": FieldValue.serverTimestamp()]) { error in
            if error == nil{
                print("data " + String(self.count) + " has been stored")
                self.getData()
            }
            else {
                print("error occurred in writing data")
            }
        }
        self.count = self.count + 1
    }
}
