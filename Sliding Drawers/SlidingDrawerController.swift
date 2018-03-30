//
//  SlidingDrawerController.swift
//  Sliding Drawers
//
//  Created by Kevin Scardina on 3/30/18.
//  Copyright © 2018 popmedic. All rights reserved.
//

import UIKit

/*
 To use simply instantiate SlidingDrawerController as your root view in your AppDelegate, or in the
 StoryBoard.
 Once SlidingDrawerController is instantiated, set the drawerSize of the SlidingDrawerController,
 and its leftViewControllerIdentifier, centerViewControllerIdentifier, and
 rightViewControllerIdentifier to the Storyboard Identifier of the UIViewController
 you want in the different locations.
 */

class SlidingDrawerController: UIViewController {
    
    // This is where you set the drawer size (i.e. for 1/3rd use 3.0, for 1/5 use 5.0)
    var drawerSize:CGFloat = 4.0
    var leftViewControllerIdentifier:String = "leftViewController"
    var centerViewControllerIdentifier:String = "centerViewController"
    var rightViewControllerIdentifier:String = "rightViewController"
    
    private var _leftViewController:UIViewController?
    var leftViewController:UIViewController {
        get{
            if let vc = _leftViewController {
                return vc;
            }
            return UIViewController();
        }
    }
    private var _centerViewController:UIViewController?
    var centerViewController:UIViewController {
        get{
            if let vc = _centerViewController {
                return vc;
            }
            return UIViewController();
        }
    }
    private var _rightViewController:UIViewController?
    var rightViewController:UIViewController {
        get{
            if let vc = _rightViewController {
                return vc;
            }
            return UIViewController();
        }
    }
    
    static let SlidingDrawerNoneOpen = 0
    static let SlidingDrawerOpenLeft = 1
    static let SlidingDrawerOpenRight = 2
    var openSide:Int {
        get{
            return _openSide;
        }
    }
    private var _openSide:Int = SlidingDrawerNoneOpen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Instantiate VC's with storyboard ID's
        self._leftViewController = self.instantiateViewControllers(storyboardID: self.leftViewControllerIdentifier)
        self._centerViewController = self.instantiateViewControllers(storyboardID: self.centerViewControllerIdentifier)
        self._rightViewController = self.instantiateViewControllers(storyboardID: self.rightViewControllerIdentifier)
        
        // Call configDrawers() and pass the drawerSize variable.
        self.drawDrawers(size: UIScreen.main.bounds.size)
        
        self.view.addSubview(self.leftViewController.view)
        self.view.addSubview(self.centerViewController.view)
        self.view.addSubview(self.rightViewController.view)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: self.view, animation: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            // This is for beginning of transition
            self.drawDrawers(size: size)
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            // This is for after transition has completed.
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Drawing View
    
    func drawDrawers(size:CGSize) {
        // Calculate Center View's Size
        let centerWidth = (size.width/drawerSize) * (drawerSize - 1)
        // Left Drawer
        self.leftViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: size.width/self.drawerSize, height: size.height)
        
        // Center Drawer
        self.centerViewController.view.frame = CGRect(x: self.leftViewController.view.frame.width, y: 0.0, width: centerWidth, height: size.height)
        
        // Right Drawer
        self.rightViewController.view.frame = CGRect(x: self.centerViewController.view.frame.origin.x + self.centerViewController.view.frame.size.width, y: 0.0, width: size.width/self.drawerSize, height: size.height)
        
        // Capture the Swipes
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRightAction(rec:)))
        swipeRight.direction = .right
        centerViewController.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeftAction(rec:)))
        swipeLeft.direction = .left
        centerViewController.view.addGestureRecognizer(swipeLeft)
        
        if(openSide == SlidingDrawerController.SlidingDrawerOpenLeft){
            openLeftDrawer()
        } else if openSide == SlidingDrawerController.SlidingDrawerOpenRight {
            openRightDrawer()
        }
    }
    
    // MARK: - Open Drawers
    
    func openLeftDrawer() {
        DispatchQueue.main.async {
            self._openSide = SlidingDrawerController.SlidingDrawerOpenLeft
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations:
                { () -> Void in
                    // move views here
                    self.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion:
                { finished in
            })
        }
    }
    
    func openRightDrawer() {
        DispatchQueue.main.async {
            self._openSide = SlidingDrawerController.SlidingDrawerOpenRight
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations:
                { () -> Void in
                    // move views here
                    self.view.frame = CGRect(x: self.view.bounds.origin.x - self.leftViewController.view.bounds.size.width, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion:
                { finished in
            })
        }
    }
    
    // MARK: - Swipe Handling
    
    @objc func swipeRightAction(rec: UISwipeGestureRecognizer){
        self.openLeftDrawer()
    }
    
    @objc func swipeLeftAction(rec:UISwipeGestureRecognizer){
        self.openRightDrawer()
    }
    
    // MARK: - Helpers
    
    func instantiateViewControllers(storyboardID: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "\(storyboardID)")

    }
}
