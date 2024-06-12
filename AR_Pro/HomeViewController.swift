//
//  HomeViewController.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/11.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logo.image = UIImage(named: "logo")
    }
    @IBOutlet weak var logo: UIImageView!
    @IBAction func startButtonTapped(_ sender: Any) {
        print("start button tapped")
        let gameViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        // self.present(gameViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(gameViewController, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}
