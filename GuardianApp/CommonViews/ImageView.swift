//
//  ImageView.swift
//  GuardianNewsApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import SwiftUI

struct ImageView: View {
    let imageURL: URL
  
    var body: some View {
            
            AsyncImage(url: imageURL) { phase in
                switch phase {
                    // When no image is not available yet
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    
                case .success(let image):
                    // Set The image which gets from the AsyncImage
                    image
                        .resizable()
                 
                case .failure:
              
                        // Otherwise show a placeholder image
                        HStack {
                            Spacer()
                            Image(systemName: "photo")
                                .imageScale(.large)
                            Spacer()
                        }
                    
                   
                    
                @unknown default:
                    fatalError()
                }
            }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageURL: Article.previewData[0].fields.imageURL!)
    }
}
