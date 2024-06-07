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
    
    var planes = [ARAnchor: SCNNode]()
    var selectedPlane: SCNNode?
    
    var state: GameState = .detectSurface {
        didSet {
            handleGameStateUpdate()
        }
    }
    
    func handleGameStateUpdate() {
        switch state {
        case .detectSurface:
            showMessage("Please tap on a surface to place the game.")
        case .onboard:
            if (selectedPlane == nil) {
                state = .detectSurface
                return
            }
            for (anchor, node) in planes {
                if node == selectedPlane {
                    planes.removeValue(forKey: anchor)
                    // set selected plane to be visible
                    print("set a new skin for selected plane")
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor(white: 0.0, alpha: 0.8)
                    node.geometry?.materials = [material]
                    node.isHidden = false
                } else {
                    node.removeFromParentNode()
                    // set other planes to be invisible
                    node.isHidden = true
                }
            }
            showMessage("onboarded")
        case .playing:
            showMessage("playing")
        case .gameOver:
            showMessage("game over")
        }
    }
    
    @objc func tappedInSceneView(sender: UIGestureRecognizer) {
        print("tapped")
        switch state {
        case .detectSurface:
            let tappedLocation = sender.location(in: sceneView)
            let hitTestResult = sceneView.hitTest(tappedLocation, types: .existingPlane)
            
            if let optimalResult = hitTestResult.first, let anchor = optimalResult.anchor {
                selectedPlane = planes[anchor]
                state = .onboard
            }
            
            
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
        if state == .detectSurface {
            // 1. Check we have detected a plane
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // 2. Create a plane geometry to visualize the plane anchor
            let planeGeometry = SCNPlane(width: CGFloat(1.0), height:   CGFloat(0.5))
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
            planes[anchor] = planeNode
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if state == .detectSurface {
            // 1. Check we have detected a plane
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // 2. Get the node that contains the plane geometry
            let planeNode = node.childNodes.first
            
            // 3. Get the plane geometry and update the position
            let planeGeometry = planeNode?.geometry as! SCNPlane
            planeNode?.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        }
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
