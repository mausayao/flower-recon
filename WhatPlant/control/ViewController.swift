//
//  ViewController.swift
//  WhatPlant
//
//  Created by Maurício de Freitas Sayão on 29/06/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import UIKit
import CoreML
import Vision
import SwiftyJSON
import Alamofire
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var flowerInfoLabel: UILabel!
    var imagePicker = UIImagePickerController()
    let wikipidiaUrl = "https://en.wikipedia.org/w/api.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func buttonTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    private func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: FlowersClassifiers().model) else {
            fatalError("Load model failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (req, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            guard let reqResults = req.results as? [VNClassificationObservation] else {
                fatalError("Error on Classifier")
            }
            
            guard let first = reqResults.first  else {
                fatalError("Error on Classifier image")
            }
            
            self.getInfo(flowerName: first.identifier)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }catch{
            print(error)
        }
    }
    
    private func getInfo(flowerName: String) {
        
        let parameters : [String: String] = [
            "format": "json",
            "action": "query",
            "prop": "extracts|pageimages",
            "exintro": "",
            "explaintext": "",
            "titles": flowerName,
            "indexpageids": "",
            "redirects": "1",
            "pithumbsize": "500"
        ]
        
        Alamofire.request(wikipidiaUrl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let flower = self.toObject(json: JSON(response.result.value!))
                
                self.imageView.sd_setImage(with: URL(string: flower.imageUrl), completed: nil)
                self.navigationItem.title = flower.name
                self.flowerInfoLabel.text = flower.description
                
            }
        }
    }
    
    private func toObject(json: JSON) -> Flower {
        let pageId = json["query"]["pageids"][0].stringValue
        
        let flowerName = json["query"]["pages"][pageId]["title"].stringValue
        let flowerInfo = json["query"]["pages"][pageId]["extract"].stringValue
        let flowerImg = json["query"]["pages"][pageId]["thumbnail"]["source"].stringValue
        
        return Flower(name: flowerName, description: flowerInfo, imageUrl: flowerImg)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            guard let imageEdited = CIImage(image: image) else {
                fatalError("Error on convert image!")
            }
            
            detect(image: imageEdited)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: UINavigationControllerDelegate {
    
}

