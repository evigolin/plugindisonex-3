//
//  TextRecognizer.swift
//  Scan-Ocr
//
//  Created by David Blanco For VirtualTec
//

import Foundation
import Vision
import VisionKit
 var changeSegueId = DataReturn(image: "xd", ocr: "init22")
public var arraInitial: Array<Any> = Array()


final class TextRecognizer{
    let cameraScan: VNDocumentCameraScan
    
    init(cameraScan:VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }
    private let queue = DispatchQueue(label: "scan-codes",qos: .default,attributes: [],autoreleaseFrequency: .workItem)
    func recognizeText(withCompletionHandler completionHandler:@escaping ([String])-> Any) -> Promise<Any> {
        return Promise <Any>{ resolve in
            queue.async {
                let images = (0..<self.cameraScan.pageCount).compactMap({
                    self.cameraScan.imageOfPage(at: $0).cgImage
                })
                var count:Int = 1
                
                let imagesAndRequests = images.map({(image: $0, request:VNRecognizeTextRequest())})
                let textPerPage = imagesAndRequests.map{image,request->String in
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                    do{
                        try handler.perform([request])
                        guard let observations = request.results as? [VNRecognizedTextObservation] else{return ""}
                        let res = observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "\n")
                        print("this is the", res)
                        
                        print("THIS IS THE IMAGE--->", image)
                         let newImage =  UIImage(cgImage: image)
                            if let data = newImage.pngData() {
                                let name = "copi\(count).png"
                                let filename = getDocumentsDirectory().appendingPathComponent(name)
                                count = count + 1
                                print("this is the fileName--->", filename)
                                changeSegueId = DataReturn(image:filename , ocr: res)
                                arraInitial.append(changeSegueId)

                                try? data.write(to: filename)
                            }
                        
                        return res

                    }
                    catch{
                        print(error)
                        return ""
                    }
                }
                DispatchQueue.main.async {
                    print("this is the textInitial--", arraInitial)
                    print("this is the text--", textPerPage.joined(separator:"-"))
                    print("this is the images--->", images)
                    
                    resolve(arraInitial)
                    completionHandler(textPerPage);
                }
            }
        }
        }
      
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
