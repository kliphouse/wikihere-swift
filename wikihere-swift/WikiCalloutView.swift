//
//  WikiCalloutViewViewController.swift
//  wikihere-swift
//
//  Created by Jeremy on 1/3/18.
//  Copyright © 2018 Maurerhouse. All rights reserved.
//

import UIKit

class WikiCalloutView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distLabel: UILabel!
    
    var pageId: String?
    
    

    class var identifier: String{
        struct Static
        {
            static let identifier: String = "WikiCalloutView"
        }
        
        return Static.identifier
    }

}
