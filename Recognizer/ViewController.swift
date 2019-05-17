//
//  ViewController.swift
//  Recognizer
//
//  Created by George James Manayath on 17/05/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    let resnetModel = Resnet50()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        if let image = imageView.image{
            processImage(image: image )
        }
        
    }
    func processImage(image:UIImage)
    {
        if let model = try? VNCoreMLModel(for: self.resnetModel.model){
            let request = VNCoreMLRequest(model: model,completionHandler: { (request, error) in
                if let results = request.results as? [VNClassificationObservation]
                {
                    for classification in results{
                        print("ID: \(classification.identifier) Confidence: \(classification.confidence)")
                    }
                  //  self.descriptionLabel.text = results.first?.identifier
                    let decp = results.first?.identifier.components(separatedBy: ",")
                    self.descriptionLabel.text = decp?[0]
                    if let confidence = results.first?.confidence{
                        let confval = (confidence * 100.0).rounded()
                        self.confidenceLabel.text = "\(confval)%"
                }
                }
            })
          
                if let imageData = image.pngData()
                {
                    let handler = VNImageRequestHandler(data:imageData, options: [:])
                    try? handler.perform([request])
                }
            
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func photosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        imageView.image = selectedImage
            processImage(image: selectedImage )
        
    }
    picker.dismiss(animated: true, completion: nil)
    }
    
}

