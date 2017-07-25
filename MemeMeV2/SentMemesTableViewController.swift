//
//  SentMemesTableViewController.swift
//  MemeMeV2
//
//  Created by Yu-Jen Chang on 7/23/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        // udpate the table view
        self.tableView.reloadData()
    }

    
    // number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    
    // table view cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memesTableViewCell", for: indexPath)
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = meme.memedImage!
        cell.textLabel?.text = meme.topText! + "..." + meme.bottomText!

        cell.imageView?.contentMode = .scaleAspectFill
        cell.textLabel?.contentMode = .scaleAspectFill
        
        return cell
    }
 
    
    // select one of memedImages
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        if let navigationVC = self.navigationController {
            navigationVC.pushViewController(detailController, animated: true)
        }
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    

}
