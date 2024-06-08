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
enum State : Int {
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
    var worldPlane: SCNNode?
    var worldAnchor: ARPlaneAnchor?
    
    var playerNode: Player?
    
    var state: State = .detectSurface {
        didSet {
            handleGameStateUpdate()
        }
    }
    
    var gameController = GameController()
    
    func handleGameStateUpdate() {
        switch state {
        case .detectSurface:
            showMessage("Please tap on a surface to place the game.")
        case .onboard:
            if (worldPlane == nil) {
                state = .detectSurface
                return
            }
            for (anchor, node) in planes {
                if node == worldPlane {
                    planes.removeValue(forKey: anchor)
                    // set selected plane to be visible
                    print("set a new skin for selected plane")
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor(white: 0.0, alpha: 0.8)
                    node.geometry?.materials = [material]
                    node.isHidden = false
                } else {
                    node.removeFromParentNode()
                }
            }
            showMessage("onboarded. Tap to start game.")
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
                worldPlane = planes[anchor]
                worldAnchor = anchor as? ARPlaneAnchor
                state = .onboard
            }
            break
        case .onboard:
            setup()
            gameController.startGame()
            state = .playing
            break
        case .playing:
            break
        case .gameOver:
            break
        }
    }
    
    private func setup() {
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        config.providesAudioData = false
        config.isLightEstimationEnabled = true
        sceneView.session.run(config)
        
//        sceneView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        worldPlane?.geometry = nil
        worldPlane?.childNodes.forEach { $0.removeFromParentNode() }
        
        playerNode = Player();
//        sceneView.scene.rootNode.addChildNode(playerNode!)
//        playerNode?.position = SCNVector3(worldAnchor!.center.x, worldAnchor!.center.y + 0.5, worldAnchor!.center.z)
        // !!! 一定要把playerNode添加到worldPlane上，否则playerNode的位置会不对
        worldPlane?.addChildNode(playerNode!)
        // placeModel(track: playerNode!.curTrack, location: 0, node: playerNode!)
        
        let floorNode = loadModel(name: "floor")
//        sceneView.scene.rootNode.addChildNode(floorNode)
//        floorNode.position = SCNVector3(worldAnchor!.center)
        worldPlane?.addChildNode(floorNode)
        floorNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 0, 0, 1)

    }
    
    private func loadModel(name: String) -> SCNNode {
        let scene = SCNScene(named: "art.scnassets/" + name + ".scn")!
        let node = scene.rootNode.childNode(withName: name, recursively: true)!
        node.removeFromParentNode()
        return node
    }
    
    // place the model (loaded at the origin of the coordinate) at the specified place
    private func placeModel(track: Int, location: Float, node: SCNNode) {
        var x_offset: Float = 0
        var y_offset: Float = 0
        var z_offset: Float = 0
        
        if track == 0 {
            x_offset = -0.15
        } else if track == 1 {
            x_offset = -0.05
        } else if track == 2 {
            x_offset = 0.05
        } else if track == 3 {
            x_offset = 0.15
        }
        
        let scaleFactor: Float = 0.8
        y_offset = (location - 0.5) * scaleFactor
        
        z_offset = 1.0
        
        let translation = SCNMatrix4MakeTranslation(x_offset, y_offset, z_offset)
        node.transform = translation
    }
    
    private func showMessage(_ message: String, animated: Bool = false, duration: TimeInterval = 1.0) {
        print(message)
        DispatchQueue.main.async {
            self.informationLabel.text = message
        }
    }
    
    @objc private func swipeLeft(_ gesture: UISwipeGestureRecognizer) {
        print("swipe left")
        if state == .playing {
            playerNode?.moveLeft()
        }
    }
    
    @objc private func swipeRight(_ gesture: UISwipeGestureRecognizer) {
        print("swipe right")
        if state == .playing {
            playerNode?.moveRight()
        }
    }
    
    @objc private func swipeUp(_ gesture: UISwipeGestureRecognizer) {
        print("swipe up")
        if state == .playing {
            playerNode?.jump()
        }
    }
    
    private func addGestureRecognizer() {
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedInSceneView)))
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        swipeLeft.direction = .left
        sceneView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        swipeRight.direction = .right
        sceneView.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
        swipeUp.direction = .up
        sceneView.addGestureRecognizer(swipeUp)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // add gestureRecognizer
        addGestureRecognizer()
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        scene.lightingEnvironment.contents = "art.scnassets/Environment_cube.jpg"
        scene.lightingEnvironment.intensity = 2
        scene.physicsWorld.speed = 1
        scene.physicsWorld.timeStep = 1.0 / 60.0
        
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
    func createARPlanePhysics(geometry: SCNGeometry) -> SCNPhysicsBody {
        let physicsBody = SCNPhysicsBody(
            type: .kinematic,
            shape: SCNPhysicsShape(geometry: geometry, options: nil))
        physicsBody.restitution = 0.5
        physicsBody.friction = 0.5
        return physicsBody
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if state == .detectSurface {
            // 1. Check we have detected a plane
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // 2. Create a plane geometry to visualize the plane anchor
            // let planeGeometry = SCNPlane(width: CGFloat(1.0), height:   CGFloat(0.5))
            let planeGeometry = SCNPlane(width: 0.4, height: 1.0)
            let planeMaterial = SCNMaterial()
            planeMaterial.diffuse.contents = UIColor(white: 1.0, alpha: 0.8)
            planeGeometry.materials = [planeMaterial]
            
            // 3. Create a node with the plane geometry
            let planeNode = SCNNode(geometry: planeGeometry)
            // planeNode.physicsBody = createARPlanePhysics(geometry: planeGeometry)
            
            // 4. Position the plane geometry in the correct location
            // planeNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
            
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
            // planeNode?.physicsBody = nil
            // planeNode?.physicsBody = createARPlanePhysics(geometry: planeNode!.geometry!)
            
            // 3. Get the plane geometry and update the position
            // planeNode?.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
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
