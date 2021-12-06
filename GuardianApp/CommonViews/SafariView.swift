//
//  SafariView.swift
//  XCANews
//
//  Created by Alfian Losari on 6/27/21.
//

import SwiftUI
import SafariServices

/* This view is to use when to open any view in safari */
struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}
