//
//  ContentView.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
  
    var body: some View {
        NavigationView {
           NewsArticleListView()
                .navigationTitle("Top Headlines")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
