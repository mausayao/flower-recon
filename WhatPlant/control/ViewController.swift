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

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    
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
            
            if let first = reqResults.first {
                self.navigationItem.title = first.identifier
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }catch{
            print(error)
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
            
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

