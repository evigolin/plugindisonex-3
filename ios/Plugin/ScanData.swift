//
//  ScanData.swift
//  Scan-Ocr
//
//  Created by David Blanco For VirtualTec
//

import Foundation


struct ScanData:Identifiable {
    var id = UUID()
    let content:String
    
    init(content:String) {
        self.content = content
    }
}
