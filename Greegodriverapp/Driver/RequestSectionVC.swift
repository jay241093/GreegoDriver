//
//  RequestSectionVC.swift
//  GreeGo
//
//  Created by Pish Selarka on 17/04/18.
//  Copyright © 2018 Techrevere. All rights reserved.
//

import UIKit

class RequestSectionVC: UIViewController {

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapLyft(_ sender: Any) {
        if UIApplication.shared.canOpenURL(URL(string: "lyft://")!){
            print("found Uber .. Opening app")
            UIApplication.shared.open(URL(string: "lyft://")!,options: [:], completionHandler: nil)
        }else{
            let alert = AlertBuilder(title: "Uber", message: "App not Installed")
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func tapUber(_ sender: Any) {
        if UIApplication.shared.canOpenURL(URL(string: "uber://")!){
            print("found Uber .. Opening app")
            UIApplication.shared.open(URL(string: "uber://")!,options: [:], completionHandler: nil)
        }else{
            let alert = AlertBuilder(title: "Uber", message: "App not Installed")
            present(alert, animated: true, completion: nil)
        
    }
        }
        
        
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
