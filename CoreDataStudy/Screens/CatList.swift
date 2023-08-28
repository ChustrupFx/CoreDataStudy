//
//  CatList.swift
//  CoreDataStudy
//
//  Created by Victor Soares on 14/08/23.
//

import SwiftUI
import CoreData

struct CatList: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var breeds: [Breed] = []
    
    var body: some View {
        VStack {
            
            List {
                ForEach(breeds) { breed in
                    Text(breed.name!)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        
                        let breed = breeds[index]
                        
                        viewContext.delete(breed)
                        
                        do {
                            try viewContext.save()
                            
                            breeds.remove(at: index)
                        } catch {
                            
                        }
                        
                    }
                }
            }
            
            
        }
        .toolbar {
            
        }
        .onAppear {
            let fetchRequest = NSFetchRequest<Breed>(entityName: "Breed")
            
            do {
                let values = try viewContext.fetch(fetchRequest)
                
                breeds = values
            } catch {
                print(error)
            }
        }
    }
    
}

struct CatList_Previews: PreviewProvider {
    static var previews: some View {
        CatList()
    }
}
