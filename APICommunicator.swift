//
//  APICommunicator.swift
//  photo-api-project
//
//  Created by andrew cook on 11/17/16.
//  Copyright © 2016 andrew cook. All rights reserved.
//

import UIKit
import Alamofire

class APICommunicator {
    
    static let sharedManager = APICommunicator()
    
    func getPhotos(_ completion:@escaping (_ photos: NSArray) -> Void)
    {
        let array = NSMutableArray()
        Alamofire.request("http://jsonplaceholder.typicode.com/photos", parameters: ["":""], encoding: URLEncoding.default) .responseJSON { response in
            
            if response.result.isFailure
            {
                print(response.result)
            }
            else
            {
                if let photos = response.result.value
                {
                    for photo in photos as! NSArray
                    {
                        let photoURL = (photo as AnyObject).object(forKey: "thumbnailUrl")
                        let photoName = (photo as AnyObject).object(forKey: "title")
                        array.add([photoURL!,photoName!])
                    }
                }
                completion(array)
            }
        }
    }
}

