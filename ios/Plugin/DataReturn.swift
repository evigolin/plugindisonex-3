//
//  DataReturn.swift
//  Scan-Ocr
//
//  Created by Virtual-Tec on 30/09/21.
//

import Foundation


struct DataReturn:Identifiable {
    var id = UUID()
    let image:Any
    let ocr:String
    
    init(image:Any, ocr:String) {
        self.image = image
        self.ocr = ocr
    }
}
