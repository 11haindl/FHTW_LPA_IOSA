//
//  ContentView.swift
//  MyDay
//
//  Created by Stefanie on 25.12.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var showAlert: Bool = false

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Entry.date, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Entry>
    
    var delegate = NotificationDelegate()
    
    init() {
        requestForAuthorization()
        setupNotification()
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink (destination: ShowEntryView(entry: item)) {
                        Text("\(item.date!, formatter: itemFormatter) \(item.name ?? "")")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton().accessibility(
                        label: Text(NSLocalizedString("edit_button", comment: ""))
                    )
                }
                ToolbarItem {
                    NavigationLink(destination: NewEntryView()) {
                        Image(systemName: "plus")
                    }
                    .navigationTitle(NSLocalizedString("overview_title", comment: ""))
                }
            }
            Text("Select an Entry")
        }
    }

    

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func requestForAuthorization() {
        
        UNUserNotificationCenter.current().delegate = delegate
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            
            if success {
                print("Authorized")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setupNotification() {
    
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notification_title", comment: "")
        content.body = NSLocalizedString("notification_body", comment: "")
        content.categoryIdentifier = "categoryID"

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        
        let requestID = "reminderNotification"
        let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)
        
        let actionCategory =
              UNNotificationCategory(identifier: "categoryID",
              actions: [],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([actionCategory])
        
        UNUserNotificationCenter.current().add(request)
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
