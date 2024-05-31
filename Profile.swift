//
//  Profile.swift
//  financeApp
//
//  Created by Patrycja Kwaśniewska on 04/06/2023.
//

import SwiftUI
import CoreData

struct Profile: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: [],
        animation: .default)
    private var users: FetchedResults<User>
    
    @State private var author: String = ""
    
    var body: some View {
        VStack {
            Image("user-2")
                .resizable()
                .frame(width: 200, height: 200)
                .padding()
                .onLongPressGesture {
                    author = "Kwaśniewska Patrycja"
                }
            
           
            VStack(alignment: .leading) {
                Text("Jan Kowalski")
                    .font(.title)
                
                Text("jankowalski@gmail.com")
                    .font(.title)
                
                Text("phone number: 534898345")
                    .font(.title)
                
                Text("Autorzy: \(author)")
                    .font(.body)
                
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}



