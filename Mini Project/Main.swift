//
//  Main.swift
//  Mini Project
//
//  Created by ahmad ilyas on 19/03/18.
//  Copyright © 2018 ahmad ilyas. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class Main: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var searchField:SkyFloatingLabelTextField!
    var filter:FilterParameter!

    override func viewDidLoad() {
        super.viewDidLoad()
        filter = FilterParameter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Mini Project - Search"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchField.errorMessage = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.search()
        return true
    }
    
    @IBAction func searchClicked(_ sender:UIButton) {
        self.search()
    }
    
    func search(){
        if let q:String = searchField.text, q.characters.count > 0 {
            searchField.errorMessage = nil
            filter.q = q
            self.performSegue(withIdentifier: "show_serach_list_segue", sender: self)
        }else{
            searchField.errorMessage = "Masukkan Kata Kunci!"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SearchList, segue.identifier == "show_serach_list_segue" {
            vc.filter = self.filter
        }
    }


}

