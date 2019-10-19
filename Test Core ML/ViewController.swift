//
//  ViewController.swift
//  Test Core ML
//
//  Created by Flavio on 18/10/2019.
//  Copyright © 2019 PedroHenrique. All rights reserved.
//

import UIKit
import CoreML
import Vision



class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    @IBAction func cameraTaped(_ sender: Any) {

        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            
            guard let cgiImage = CIImage(image:image) else {
                fatalError()
            }
            
            
            detectImage(image: cgiImage)
        }
        
       
        imagePicker.dismiss(animated: true, completion: nil)
    }
 
    
    func detectImage(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError()
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                
                fatalError()
            }
            
            if let firstResult = results.first {
                
               self.navigationItem.title = firstResult.identifier
            }
            
        }
        
        
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        
        do {
            try handler.perform([request])
        } catch  {
            print(error)
        }
    }
    
}

