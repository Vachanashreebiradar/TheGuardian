//
//  ImageView.swift
//  GuardianNewsApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import SwiftUI

struct ImageView: View {
    let imageURL: URL
    let cache = ImageCache.getImageCache()
    var body: some View {
        
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    
                case .success(let image):
                    image
                        .resizable()
                        .onAppear {
                            cache.set(forKey: "\(imageURL)", image: image.asUIImage())
                        }
                 
                case .failure:
                   let img = cache.get(forKey: "\(imageURL)")
                    if let img = img {
                        Image(uiImage: img)
                            .resizable()
                    } else {
                        HStack {
                            Spacer()
                            Image(systemName: "photo")
                                .imageScale(.large)
                            Spacer()
                        }
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
