//
//  MemeDetailViewController.swift
//  MemeMeV2
//
//  Created by Yu-Jen Chang on 7/23/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var memeDetailImageView: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memeDetailImageView.image = self.meme.memedImage
        memeDetailImageView.contentMode = .scaleAspectFill
        tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "MemedImage"
    }
    
}
