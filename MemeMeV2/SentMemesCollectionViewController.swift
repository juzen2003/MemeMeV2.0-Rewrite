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

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //modified flowLayout based on main view size
        getFlowLayoutModified(view.frame.size)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        // update collection view
        collectionView!.reloadData()
    }

    
    // respond to the rotation of view
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        getFlowLayoutModified(size)
    }
    
    // get flowLayout modified when device is rotated
    func getFlowLayoutModified(_ size: CGSize) {
        let space: CGFloat = 3
        var dimension: CGFloat
        
        if size.width < size.height {
            // portrait
            dimension = (size.width - (2 * space)) / 3.0
        } else {
            // landscape
            dimension = (size.width - (4 * space)) / 5.0
        }
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
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
        
        cell.collectionViewCellImageView?.contentMode = .scaleAspectFit
        cell.backgroundColor = UIColor.darkGray
    
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
