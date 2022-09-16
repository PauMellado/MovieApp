//
//  DeploymentViewController.swift
//  MovieApp
//
//  Created by Paulina Mellado Mateos on 11/09/22.
//

import UIKit
import UserNotifications

class DeploymentViewController: UIViewController{
    
    

    @IBOutlet weak var imgD: UIImageView!
    @IBOutlet weak var nameD: UILabel!
    @IBOutlet weak var descriptionD: UITextView!
    
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    
    
    var des: String?
    var name: String?
    var img: String?
    
    var originalLangua: String?
    var originalTitle: String?
    var popularaty: Double?
    var releaseData: String?
    var voteCount: Int?
    
    
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    var delegateImp : NotificationAlert!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        descriptionD.text = des
        nameD.text = name
        if let img = img {
            imagen(imageName: img)
        }
        
        lb1.text = originalLangua
        lb2.text = originalTitle
        if let popularaty = popularaty {
            lb3.text = String(popularaty)
        }
        
        lb4.text = releaseData
        if let voteCount = voteCount {
            lb5.text = String(voteCount)
        }
        
    }
    
        func imagen(imageName : String){
            let cacheString = NSString(string: imageName)
        if let cacheImage = self.cache.object(forKey: cacheString) {
            imgD.image = cacheImage
        } else {
            self.loadImage(from: URL(string: imageName)) { [weak self] (image) in
                guard let self = self, let image = image else { return }
                self.imgD.image = image
                self.cache.setObject(image, forKey: cacheString)
            }
        }
    
    }
    
    @IBAction func returnBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        scheduleNotifications()
        delegateImp?.didSelectString(name ?? "Name Error")
        
    }
    
    
    func scheduleNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Success")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Gracias por tu compra"
        
        if let name = name {
            content.body = "La Pelicula" + name + " comienza pronto"
        }

            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
           
        
        
    }
    
    
    
    
    // MARK: - Image Loading
    private func loadImage(from url: URL?, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let data = try? Data(contentsOf: url!) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

}

