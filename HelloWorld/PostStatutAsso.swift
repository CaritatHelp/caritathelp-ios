//
//  PostStatutAsso.swift
//  Caritathelp
//
//  Created by Jeremy gros on 24/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class PostStatutAssoController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var Statut: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        Statut.text = "Exprimez-vous..."
        Statut.textColor = UIColor.lightGrayColor()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Exprimez-vous..."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}