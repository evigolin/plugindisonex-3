//
//  ContentView.swift
//  Scan-Ocr
//
//  Created by David Blanco For VirtualTec
//

import UIKit
import Capacitor
import SwiftUI
class ContentView: UIViewController {
   // private let buttonInsets = EdgeInsets(top: 200, leading: 200, bottom: 200, trailing: 50)
    public let likesLabel : UILabel = {
           
            let label = UILabel()
            label.text = "10 likes"
            label.font = UIFont.boldSystemFont(ofSize: 13)
            return label
            
    }()
    override func viewDidLoad() {
       super.viewDidLoad()
        isShowingScannerSheet = true
     ///  view.makeScannerView()
/*        let viewnew = UIView()
        let button = UIButton(type: .system, primaryAction:UIAction(title: "Button", handler: {[weak self] (action) in
                    guard let view = self?.makeScannerView() else {return}
            viewnew = view
            self?.present(view, animated: true, completion: nil)
            //        return
                }) )

        button.frame = CGRect(x: self.view.frame.size.width  * 0.5 , y: 60, width: 200, height: 50)
         button.backgroundColor = UIColor.red
         button.setTitle("OCR BUTTON", for: .normal)
         
  */
        self.makeScannerView()
        

        //button.addTarget(self, action:#selector(makeScannerView), for: .touchUpInside)
        //button.addTarget(self, action: "makeScannerView", for: .touchUpInside)
        //self.view.addSubview(button)
        self.view.backgroundColor = .white
       // likesLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
   }

    
//    var body: some View {
//        ZStack {
////            Group{
////                self.makeScannerView()
////            }
//            Text("Vision Kit Example")
//            Button(action: openCamera) {
//                Text("Scan").foregroundColor(.white)
//            }.background(Color.green)
//                .cornerRadius(3.0)
//            Text(text).lineLimit(nil)
//        }.background(Color.red)
//            .onAppear(perform: {
//                self.makeScannerView()})
//    }
     
    @State private var isShowingScannerSheet = false
    @State private var text: String = ""
     
    private func openCamera() {
        isShowingScannerSheet = true
    }
     
    func makeScannerView() -> ScannerView {
        ScannerView(completion: { textPerPage in
            if let text = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                self.text = text
            }
            self.isShowingScannerSheet = false
        })
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


