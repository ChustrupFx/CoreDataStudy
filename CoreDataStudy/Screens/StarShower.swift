//
//  StarShower.swift
//  CoreDataStudy
//
//  Created by Victor Soares on 11/08/23.
//

import SwiftUI

struct StarShower: View {
    
    let stars: Int
    let label: String?
    
    init(stars: Int, label: String? = nil) {
        self.stars = stars
        self.label = label
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if let label = self.label {
                Text(label + ": ")
            }
            ForEach(1..<6) {index in
                
                Image(systemName: index > stars ? "star": "star.fill")
            }
        }
        .frame(minHeight: 10)
    }
}

struct StarShower_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StarShower(stars: 5)
            StarShower(stars: 3, label: "asd")
        }
    }
}
