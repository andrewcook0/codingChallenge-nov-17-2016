//
//  ViewController.swift
//  photo-api-project
//
//  Created by andrew cook on 11/17/16.
//  Copyright © 2016 andrew cook. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: Variables
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var helpButton : UIBarButtonItem!
    @IBOutlet weak var photosButton : UIBarButtonItem!
    
    var photoCell : PhotoCell!
    var photoArray : NSArray! = NSArray()
    var alertTitle : String!
    var alertMessage : String!
    var selectedPhoto = UIImage()
    var isFromHelpButton : Bool!
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        APICommunicator.sharedManager.getPhotos { (photos) in
            self.photoArray = photos
            self.collectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let tempItem = photoArray.object(at: indexPath.row) as! NSArray
        let tempName = tempItem[1] as! String
        let tempPhotoCell = collectionView.cellForItem(at: (indexPath)) as! PhotoCell
        selectedPhoto = tempPhotoCell.imageView.image!
        alertTitle = "Would you like to save this amazing photo?"
        alertMessage = tempName
        isFromHelpButton = false
        showAlert()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //creates and registers photoCell
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
       
        
        let tempItem = photoArray.object(at: indexPath.row) as! NSArray
        let tempURL = tempItem[0] as! String
        print(tempURL)
        photoCell.imageView.downloadedFrom(url: URL(string: tempURL)!)
        
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width / 3 - 7, height: self.view.frame.size.width / 3 - 7)
    }
    
    //MARK: Actions
    @IBAction func clickedPhotosButton()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickedHelpButton()
    {
        alertTitle = "Needed help eh?"
        alertMessage = "click an image to download it to your camera roll"
        isFromHelpButton = true
        showAlert()
    }
    
    func showAlert()
    {
    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        if isFromHelpButton == true
        {
            alert.addAction(UIAlertAction(title: "Alright", style: UIAlertActionStyle.default, handler: nil))
        }
        else
        {
        alert.addAction(UIAlertAction(title: "Yes! What an image!", style: UIAlertActionStyle.default, handler: { action in
            UIImageWriteToSavedPhotosAlbum(self.selectedPhoto, nil, nil, nil)
        }))
        alert.addAction(UIAlertAction(title: "No! That sounds awful!", style: UIAlertActionStyle.default, handler: nil))
        }
    self.present(alert, animated: true, completion: nil)
    }

}

