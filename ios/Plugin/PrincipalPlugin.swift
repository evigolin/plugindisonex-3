import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PrincipalPlugin)
public class PrincipalPlugin: CAPPlugin {
    private let implementation = Principal()
    let viewController = MyViewController()

    @objc func echo(_ call: CAPPluginCall) {
        let fileName = "testFile1.txt"
        MyViewController().save(text: "",//
                toDirectory: MyViewController().documentDirectory(),
                  withFileName: fileName)
        
         DispatchQueue.main.async {
             self.bridge?.viewController?.present(MyViewController(), animated: true, completion: nil)
        
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { // Change `2.0` to the desired number of seconds.
           // Code you want to be delayed
            let var_data = MyViewController().read(fromDocumentsWithFileName: fileName)
            //let json = try? JSONSerialization.jsonObject(with: var_data, options: [])
            //print(json)
            if var_data.isEmpty {
                self.method_recursive(call)
            }else{
                
                call.resolve([
                    "value": var_data
                ])
            }
    
        }
    }
    
    func method_recursive(_ call: CAPPluginCall) {
        let fileName = "testFile1.txt"
        let var_data = MyViewController().read(fromDocumentsWithFileName: fileName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Change `2.0` to the desired number of seconds.
            if var_data.isEmpty {
                self.method_recursive(call)
            }else{
                call.resolve([
                    "value": var_data
                ])
            }
        }
    }

    
}
