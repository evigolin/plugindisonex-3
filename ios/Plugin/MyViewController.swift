//
//  MyViewController.swift
//  Plugin
//
//  Created by Developer on 10/14/21.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import UIKit
import Vision
import VisionKit
import Capacitor

class MyViewController: UIViewController {

    private var scanButton = ScanButton(frame: .zero)
    private var scanImageView = ScanImageView(frame: .zero)
    private var ocrTextView = OcrTextView(frame: .zero, textContainer: nil)
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    public var varocr = ""
    var arraynew = Array<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        configure()
        configureOCR()
        //showToast(controller: self, message: "mensaje", seconds: 4)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // let scanVC = VNDocumentCameraViewController()
        //scanVC.delegate = self
        //present(scanVC, animated: true)
    }

    
    private func configure() {
        view.addSubview(scanImageView)
        view.addSubview(ocrTextView)
        view.addSubview(scanButton)
        scanButton.isHidden = true

        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        loadingIndicator.center = self.view.center

        view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
          /*  scanButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scanButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            
            ocrTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            ocrTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            ocrTextView.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -padding),
            ocrTextView.heightAnchor.constraint(equalToConstant: 200),
            */
            /*loadingIndicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            loadingIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            loadingIndicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 200),*/
            
        ])
        
       scanButton.addTarget(self, action: #selector(scanDocument), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Change `2.0` to the desired number of seconds.
            //[scanButton sendActionsForControlEvents: UIControlEventTouchUpInside];
            self.scanButton.sendActions(for: .touchUpInside)

        }
    }
    
    
    @objc public func scanDocument() {
        configureOCR()
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
    
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        ocrTextView.text = ""
        scanButton.isEnabled = false
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([self.ocrRequest])
        } catch {
            print("Error procesar image obtener OCR",error)
        }
    }

    
    private func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var ocrText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                ocrText += topCandidate.string + "\n"
            }
            self.varocr = ocrText
            DispatchQueue.main.async {
                self.ocrTextView.text = ocrText
                self.scanButton.isEnabled = true
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        ocrRequest.usesLanguageCorrection = true
    }
}


extension MyViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {

        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        print("contador ", scan.pageCount)
        
        if (scan.pageCount != 1){
            self.showToast(message: "La aplicación solamanete permite una pagina", controller: controller)
            //controller.dismiss(animated: true)
            return
        }
        
        for n in 0...scan.pageCount-1 {
            let img = scan.imageOfPage(at: n)
            processImage(img)
            let date = Date()
            let calendar = Calendar.current

            
           if let data = img.pngData() {
               let name = "copi\(n).png"
               let hour = calendar.component(.hour, from: date)
              let minute = calendar.component(.minute, from: date)
              let second = calendar.component(.second, from: date)
               let nanosecond = calendar.component(.nanosecond, from: date)
               let name_image_send = "\(hour)-\(minute)-\(second)-\(nanosecond)"
               
               let DocumentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
               let DirPath = DocumentDirectory.appendingPathComponent("thesmartnotebook")
               do
               {
                   try FileManager.default.createDirectory(atPath: DirPath!.path, withIntermediateDirectories: true, attributes: nil)
               }
               catch let error as NSError
               {
                   print("Unable to create directory \(error.debugDescription)")
               }
               print("Dir Path = \(DirPath!)")
               
               let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
               let filePath = "\(paths[0])/thesmartnotebook/\(name_image_send).jpg"

               // Save image.
               //UIImageJPEGRepresentation(img, 0.90)?.writeToFile(filePath, atomically: true)
               try? data.write(to: URL(fileURLWithPath: filePath), options: .atomic)

               
               let filename = getDocumentsDirectory().appendingPathComponent(name)
               try? data.write(to: filename)
               let  baseimage = self.convertImageToBase64String(img: img)
               
               
               arraynew += [["name" : name_image_send, "value" : ""]]
               
               print("holaaa aqui imagen ",filePath)
               
               //arraInitial.append(Objeto(image_file: filename, image_ocr: varocr))
               arraInitial.append(filePath)
           }
        }
        
        
        let fileName = "testFile1.txt"
        
        self.save(text: arraynew.description,//
                toDirectory: self.documentDirectory(),
                  withFileName: fileName)
        //self.read(fromDocumentsWithFileName: fileName)
        
       

        //scanImageView.image = scan.imageOfPage(at: 0)
        //processImage(scan.imageOfPage(at: 0))
        controller.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
    }
    
    
    func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }
    
    private func appendt(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    
     func showToast(message: String, controller: UIViewController) {
        
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(14.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])

        UIView.animate(withDuration: 2.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 2.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }

    
    func read(fromDocumentsWithFileName fileName: String)-> String {
        guard let filePath = self.appendt(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return ""
        }
        
        do {
            let savedString = try String(contentsOfFile: filePath)
            
            return savedString
        } catch {
            print("Error reading saved file")
            return ""
        }
    }
    
     func save(text: String,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        guard let filePath = self.appendt(toPath: directory,
                                         withPathComponent: fileName) else {
            return
        }
        
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error guardar archivo", error)
            return
        }
        
        //print("Save successful")
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        //Handle properly error
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

