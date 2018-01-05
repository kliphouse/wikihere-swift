//
//  WebViewController.swift
//  wikihere-swift
//
//  Created by Jeremy on 10/9/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView?
    var webView: WKWebView?
    var pageId: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "http://en.wikipedia.org/wiki/?curid=\(pageId!)"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        webView!.navigationDelegate = self
        webView!.load(request)
        

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.view = self.webView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension WebViewController: WKNavigationDelegate {
    
}
