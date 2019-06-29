//
//  ViewController.swift
//  WhatPlant
//
//  Created by Maurício de Freitas Sayão on 29/06/19.
//  Copyright © 2019 Maurício de Freitas Sayão. All rights reserved.
//

import UIKit

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
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension ViewController: UINavigationControllerDelegate {
    
}

