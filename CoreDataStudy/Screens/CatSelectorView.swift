//
//  CatSelectorView.swift
//  CoreDataStudy
//
//  Created by Victor Soares on 11/08/23.
//

import SwiftUI
import CoreData
import Alamofire
import SwiftyJSON

struct BreedAPI: Identifiable, Decodable, Hashable{
    
    let id: String
    let name: String
    let energy_level: Int
    let affection_level: Int
    let child_friendly: Int
    let intelligence: Int
    let dog_friendly: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
}

struct ImageAPI: Identifiable, Decodable, Hashable {
    let id: String
    let url: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
    }
}

struct CatSelectorView: View {
    
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var breeds: [BreedAPI] = []
    
    @State var selectedBreed: BreedAPI? {
        didSet {
            setIsFavorite()
        }
    }
    
    @State var breed: BreedAPI?
    
    @State var images: [ImageAPI] = []
    
    @State var isFavorited = false
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0.0) {
                
                Picker("Breed", selection: $selectedBreed) {
                    Text("Choose a breed").tag(nil as BreedAPI?)
                    ForEach(breeds) { breed in
                        Text(breed.name)
                            .tag(breed as BreedAPI?)
                    }
                }
                
                HStack {
                    ScrollView(.horizontal, showsIndicators: true) {
                        
                        HStack(alignment: .center) {
                            ForEach(images) { image in
                                
                                AsyncImage(url: URL(string: image.url)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .aspectRatio(contentMode: .fill)
                            }
                        }
                        
                    }
                    .frame(width: 300, height: 300)
                    Spacer()
                }
                
                VStack {
                    
                    if (breed != nil) {
                        StarShower(stars: breed!.affection_level, label: "Affection Level")
                        StarShower(stars: breed!.dog_friendly, label: "Dog Friendly")
                    }
                    
                }
            }
            .task {
                await fetchBreeds()
            }
            .task(id: selectedBreed) {
                await fetchImages()
                await fetchBreed()
                setIsFavorite()
            }
        }
        .toolbar {
            Button {
            
                if isFavorited {
                    unfavoriteBreed()
                } else {
                    
                    favoriteBreed()
                }
                
            } label: {
                Image(systemName: isFavorited ? "heart.fill" : "heart")
            }
            
        }
    }
    
    func unfavoriteBreed() {
        if let selectedBreed = self.selectedBreed {
            
            let fetchRequest = NSFetchRequest<Breed>(entityName: "Breed")
            
            let predicate = NSPredicate(format: "id = %@", selectedBreed.id)
            
            
            fetchRequest.predicate = predicate
            
            do {
                let values = try viewContext.fetch(fetchRequest)
                
                for value in values {
                    viewContext.delete(value)
                }
                
                try viewContext.save()
                
                isFavorited = false
            } catch {
                print(error)
            }
        }
    }
    
    func favoriteBreed() {
        if let selectedBreed = self.selectedBreed {
            let breed = Breed(context: viewContext)
            
            breed.id = selectedBreed.id
            breed.name = selectedBreed.name
            
            do {
                try viewContext.save()
                
                print("Saved!")
                
                isFavorited = true
            } catch {
                print(error)
            }
        }
    }
    
    func setIsFavorite() {
        guard let selectedBreed = self.selectedBreed else {
            isFavorited = false
            return
        }
        
        let fetchRequest = NSFetchRequest<Breed>(entityName: "Breed")
        
        do {
            let values = try viewContext.fetch(fetchRequest)
            
            isFavorited = values.contains(where: { breed in
                breed.id == selectedBreed.id
            })
        } catch {
            print(error)
        }
    }
    
    func fetchBreed() async {
        guard let selectedBreed = self.selectedBreed else {
            return
        }
        
        
        
        let url  = URL(string: "https://api.thecatapi.com/v1/breeds/\(selectedBreed.id)")
        
        
        
        do {
            let (data, _) = try await  URLSession.shared.data(from: url!)
            
            breed = try JSONDecoder().decode(BreedAPI.self, from: data)
        } catch {
            print(error)
        }
        
        
        
    }
    
    func fetchImages() async  {
        
        guard let selectedBreed = self.selectedBreed else {
            return
        }
        
        
        let url = URL(string: "https://api.thecatapi.com/v1/images/search?breed_ids=\(selectedBreed.id)&limit=10")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            
            images = try   JSONDecoder().decode([ImageAPI].self, from: data)
        } catch {
            
        }
        
        
        
        
    }
    
    func fetchBreeds() async {
        
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.thecatapi.com/v1/breeds")!)
            
            AF.request("https://api.thecatapi.com/v1/breeds").response { response in
                    
                
                let json = JSON(response.data)
                
                debugPrint(json)

            }
            
            let
            
            breeds = try JSONDecoder().decode([BreedAPI].self, from: data)
        } catch {
            print(error)
        }
        
    }
    
}

struct CatSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        CatSelectorView()
    }
}
