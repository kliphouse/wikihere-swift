//
//  ListViewController.swift
//  wikihere-swift
//
//  Created by Jeremy on 10/2/17.
//  Copyright © 2017 Maurerhouse. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var wikiEntries = Array<WikiEntryItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension ListViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wikiEntries.count
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = wikiEntries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WikiEntryItemTableViewCell", for: indexPath) as! WikiEntryItemListTableViewCell
        
        cell.titleLabel.text = item.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func fetchWikiEntries() {
        
    }
}
