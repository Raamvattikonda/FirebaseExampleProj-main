//
//  ViewController.swift
//  FirebaseExampleProj
//
//  Created by Rama on 22/12/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var lblfoundCount: UILabel!
    
    @IBOutlet weak var tfField: UITextField!
    var allValues:[String] = []
    var count = 0
    var remoteConfig: RemoteConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRemoteConfig()
        // Do any additional setup after loading the view.
    }
    
    func executeTheCondition() {
        for str in allValues {
            if anagramCheck(firstString: tfField.text ?? "", secondString: str) {
                count += 1
            }
        }
        if count == 0{
            lblfoundCount.text = "No Anagrams Found"
        }else{
            lblfoundCount.text = "\(count) Anagrams Found"
        }
    }
    
    func anagramCheck(firstString: String, secondString: String) -> Bool {
        return firstString.lowercased().sorted() == secondString.lowercased().sorted()
    }
}


extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true) // keyboard hiding
        executeTheCondition()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        count = 0
        lblfoundCount.text = ""
        return true
    }
}

extension ViewController {
    
    /// Initializes defaults from `TempData.plist` and sets config's settings to developer mode
    func setupRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig?.setDefaults(fromPlist: "TempData")
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
        self.fetchAndActivateRemoteConfig()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.fetchAndActivateRemoteConfig()
        }
    }
    
    /// Fetches and activates remote config values
    func fetchAndActivateRemoteConfig() {
        remoteConfig?.fetchAndActivate { status, error in
            guard error == nil else { return print( error?.localizedDescription ?? "") }
            print("Remote config successfully fetched & activated!")
            DispatchQueue.main.async {
                if let fetc = (self.remoteConfig?["test"].stringValue ?? "").convertToDictionary() as? [String: String] {
                    self.allValues = fetc.map({$0.value}) 
                }
            }
        }
    }
}
