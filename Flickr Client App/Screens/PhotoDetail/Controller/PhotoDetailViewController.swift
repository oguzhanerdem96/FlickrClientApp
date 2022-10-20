//
//  PhotoDetailViewController.swift
//  Flickr Client App
//
//  Created by Oğuzhan Erdem on 20.10.2022.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Detail"
        ownerImageView.backgroundColor = .darkGray
        ownerNameLabel.text = "Owner Name"
        descriptionLabel.text = " Description Label Description Label Description Label Description Label Description Label Description Label Description Label Description Label"
    }
    

  

}
