//
//  ViewController.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/6.
//

import UIKit
import SceneKit
import ARKit

// MARK: - game state
enum GameState : Int {
    case detectSurface = 0
    case onboard
    case playing
    case gameOver
}

// MARK: - game view controller
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var informationLabel: UILabel!
    
    var state: GameState = .detectSurface {
        didSet {
            handleGameStateUpdate()
        }
    }
    
    func handleGameStateUpdate() {
        switch state {
        case .detectSurface:
            showMessage("detecting surface")
        case .onboard:
            showMessage("onboarding")
        case .playing:
            showMessage("playing")
        case .gameOver:
            showMessage("game over")
        }
    }
    
    @objc func tappedInSceneView(sender: UITapGestureRecognizer) {
        print("tapped")
        switch state {
        case .detectSurface:
            state = .onboard
        case .onboard:
            break
        case .playing:
            break
        case .gameOver:
            break
        }
    }
    
    private func showMessage(_ message: String, animated: Bool = false, duration: TimeInterval = 1.0) {
        print(message)
        DispatchQueue.main.async {
//            if animated {
//                UIView.animate(withDuration: duration, animations: {
//                    self.informationLabel.alpha = 0.0
//                    self.informationContainerView.alpha = 0.0
//                }) { _ in
//                    self.informationLabel.text = message
//                    self.informationLabel.alpha = 0.0
//                    self.informationContainerView.alpha = 0.0
//                    UIView.animate(withDuration: duration, animations: {
//                        self.informationLabel.alpha = 1.0
//                        self.informationContainerView.alpha = 1.0
//                    })
//                }
//            } else {
//                self.informationLabel.text = message
//            }
            print(message)
            self.informationLabel.text = message
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // add gestureRecognizer
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedInSceneView)))
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1. Check we have detected a plane
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2. Create a plane geometry to visualize the plane anchor
        let planeGeometry = SCNPlane(width: CGFloat(0.5), height:   CGFloat(1.0))
        // print("width: \(planeAnchor.extent.x), height: \(planeAnchor.extent.z)")
        
        // 3. Create a node with the plane geometry
        let planeNode = SCNNode(geometry: planeGeometry)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor(white: 1.0, alpha: 0.8)
        planeGeometry.materials = [planeMaterial]
        
        // 4. Position the plane geometry in the correct location
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        // 5. SCNPlanes are vertical so we need to rotate 90degrees to match the horizontal orientation
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        // 6. Add the plane node to our node
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1. Check we have detected a plane
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2. Get the node that contains the plane geometry
        let planeNode = node.childNodes.first
        
        // 3. Get the plane geometry and update the position
        let planeGeometry = planeNode?.geometry as! SCNPlane
        planeNode?.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
