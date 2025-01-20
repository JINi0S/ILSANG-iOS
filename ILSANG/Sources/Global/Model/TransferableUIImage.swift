//
//  TransferableUIImage.swift
//  ILSANG
//
//  Created by Lee Jinhee on 10/16/24.
//

import SwiftUI

struct TransferableUIImage: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
    
    public var uiimage: UIImage
    public var image: Image {
        return Image(uiImage: uiimage)
    }
    public var caption: String
}
