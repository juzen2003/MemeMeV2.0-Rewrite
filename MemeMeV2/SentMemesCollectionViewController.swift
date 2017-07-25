//
//  SentMemesCollectionViewController.swift
//  MemeMeV2
//
//  Created by Yu-Jen Chang on 7/24/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        // update collection view
        collectionView!.reloadData()
    }

    
    // how many items in collection view
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    
    // cell data
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.collectionViewCellImageView?.image = meme.memedImage!
        
        cell.collectionViewCellImageView?.contentMode = .scaleAspectFill
    
        return cell
    }

    
    // an item is selected
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        if let navigationVC = self.navigationController {
            navigationVC.pushViewController(detailController, animated: true)
        }
    }
    

}
