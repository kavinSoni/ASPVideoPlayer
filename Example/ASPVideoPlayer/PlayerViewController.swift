//
//  PlayerViewController.swift
//  ASPVideoPlayer
//
//  Created by Andrei-Sergiu Pițiș on 09/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import ASPVideoPlayer
import AVFoundation

class PlayerViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoPlayer: ASPVideoPlayer!

    let firstLocalVideoURL = Bundle.main.url(forResource: "video", withExtension: "mp4")
    let secondLocalVideoURL = Bundle.main.url(forResource: "video2", withExtension: "mp4")

    let firstNetworkURL = URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")
    let secondNetworkURL = URL(string: "http://www.easy-fit.ae/wp-content/uploads/2014/09/WebsiteLoop.mp4")

    var orientation : UIInterfaceOrientationMask = UIInterfaceOrientationMask.portrait
    
    var prefrerredOrientation : UIInterfaceOrientation = UIInterfaceOrientation.portrait
    
    var didFinishVideoBlock:((_ success:Bool) -> Void)?
    
    var isPresented = true
    
    var didEnterBg = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        //
        UIDevice.current.setValue(value, forKey: "orientation")
        
        
        let firstAsset = AVURLAsset(url: firstLocalVideoURL!)
        let secondAsset = AVURLAsset(url: secondLocalVideoURL!)
        let thirdAsset = AVURLAsset(url: firstNetworkURL!)
        let fourthAsset = AVURLAsset(url: secondNetworkURL!)
        //        videoPlayer.videoURLs = [firstLocalVideoURL!, secondLocalVideoURL!, firstNetworkURL!, secondNetworkURL!]
        videoPlayer.videoAssets = [firstAsset, secondAsset, thirdAsset, fourthAsset]
          self.registerBlock()
//        videoPlayer.configuration = ASPVideoPlayer.Configuration(videoGravity: .aspectFit, shouldLoop: true, startPlayingWhenReady: true, controlsInitiallyHidden: true)
        videoPlayer.configuration =  ASPVideoPlayer.Configuration(videoGravity: .aspectFit, shouldLoop: false, startPlayingWhenReady: true, controlsInitiallyHidden: true)
//        videoPlayer.resizeClosure = { [weak self] isExpanded in
//            guard let strongSelf = self else { return }
//            strongSelf.isExpanded = isExpanded
//            strongSelf.rotate()
//        }
        
        /*
         NotificationCenter.default.addObserver(self, selector: #selector(PlayVideoViewController.applicationIsActive(_:)), name: .UIApplicationDidBecomeActive, object: nil)
         NotificationCenter.default.addObserver(self, selector:#selector(PlayVideoViewController.applicationEnteredForeground(_:)), name: .UIApplicationWillEnterForeground, object: nil)
         */
        
        NotificationCenter.default.addObserver(self, selector:#selector(PlayerViewController.applicationEnteredBackground(_:)), name: .UIApplicationDidEnterBackground, object: nil)
    }
    @objc func applicationIsActive(_ notification: Notification?) {
        print("Application Did Become Active")
        // Do any additional setup after loading the view.
        
        /*
         let value = UIInterfaceOrientation.landscapeLeft.rawValue
         //
         UIDevice.current.setValue(value, forKey: "orientation")
         videoPlayer.videoPlayerControls.play()
         */
        
    }
    
    @objc func applicationEnteredForeground(_ notification: Notification?) {
        print("Application Entered Foreground")
        
    }
    @objc func applicationEnteredBackground(_ notification: Notification?) {
        print("Application Entered background")
        /* self.videoPlayer.videoPlayerControls.videoPlayer?.stopVideo()
         self.isPresented = false
         */
//        self.videoPlayer.vid
//        deinitObservers
        didEnterBg = true
        self.videoPlayer.videoPlayerControls.stop()
        self.videoPlayer.videoPlayerControls.deinitObservers()
        self.isPresented = false
        self.dismiss(animated: true, completion: nil)
         NotificationCenter.default.removeObserver(self)
    }
    
    
    func registerBlock()
    {
        videoPlayer.resizeClosure = { [weak self] isExpanded in
            guard let strongSelf = self else { return }
            strongSelf.isExpanded = isExpanded
            strongSelf.rotate()
        }
        videoPlayer.videoPlayerControls.videoPlayer?.newVideo! = {
            
        }
        videoPlayer.videoPlayerControls.videoPlayer?.readyToPlayVideo! = {
            
        }
        videoPlayer.videoPlayerControls.videoPlayer?.startedVideo! = {
            
            print("Video has started playing.")
            
            /*
             self.videoPlayer.videoPlayerControls.videoPlayer?.stopVideo()
             
             if self.didFinishVideoBlock != nil
             {
             self.didFinishVideoBlock!(true)
             }
             self.isPresented = false
             self.dismiss(animated: true, completion: nil)
             return()
             */
            
            
        }
        videoPlayer.videoPlayerControls.videoPlayer?.playingVideo! = { (progress) in
            if progress > 0.0 {
//                HIDE_CUSTOM_LOADER()
            }
            let progressString = String.localizedStringWithFormat("%.2f", progress)
            print("progress: \(progressString) % complete.")
        }
        videoPlayer.videoPlayerControls.videoPlayer?.pausedVideo! = {
            print("Video has paused.")
        }
        videoPlayer.videoPlayerControls.videoPlayer?.finishedVideo! = {
            
            print("Video has finished.")
            
            if self.didEnterBg
            {
                return()
            }
            
            if self.didFinishVideoBlock != nil
            {
                self.didFinishVideoBlock!(true)
            }
            
            self.isPresented = false
            self.dismiss(animated: true, completion: nil)
        }
        videoPlayer.videoPlayerControls.videoPlayer?.stoppedVideo! = {
            print("Video has stopped.")
        }
        videoPlayer.videoPlayerControls.videoPlayer?.seekStarted! = {
            print("Video has seekStarted.")
        }
        videoPlayer.videoPlayerControls.videoPlayer?.seekEnded! = {
            print("Video has seekEnded.")
        }
        videoPlayer.videoPlayerControls.videoPlayer?.error! = { (error) in
            print(error.localizedDescription)
            
//            displayAlertWithMessage(error.localizedDescription)
            self.isPresented = false
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
 
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isMovingToParentViewController {
            
        }
        
        if isMovingFromParentViewController {
            
        }
        
        if isBeingPresented {
            
        }
        
        if isBeingDismissed {
            
        }
        
        
        videoPlayer.videoPlayerControls.interacting!(false)
        videoPlayer.videoPlayerControls.didPressResizeButton!(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hideControlls()
    }
    
    func hideControlls(){
        self.videoPlayer.videoPlayerControls.nextButtonHidden = false
        self.videoPlayer.videoPlayerControls.previousButtonHidden = false
        self.videoPlayer.videoPlayerControls.playPauseButtonHidden = false
        self.videoPlayer.videoPlayerControls.resizeButtonHidden = false
        self.videoPlayer.videoPlayerControls.progressSliderHidden = false
        self.videoPlayer.videoPlayerControls.progressLoaderHidden = false
        self.videoPlayer.videoPlayerControls.currentTimeLabelHidden = false
        self.videoPlayer.videoPlayerControls.lengthLabelHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    var isExpanded: Bool = false
    var previousConstraints: [NSLayoutConstraint] = []

    func rotate() {
        let views: [String:Any] = ["videoPlayer": videoPlayer]

        if isExpanded == false {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.containerView.removeConstraints(self.videoPlayer.constraints)
                self.view.addSubview(self.videoPlayer)

                let padding = (self.view.bounds.height - self.view.bounds.width) / 2.0

                let metrics: [String:Any] = ["padding":padding, "negativePadding":-padding]

                self.videoPlayer.transform = CGAffineTransform(rotationAngle: .pi / 2.0)

                var constraints: [NSLayoutConstraint] = []
                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-(negativePadding)-[videoPlayer]-(negativePadding)-|", options: [], metrics: metrics, views: views))

                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[videoPlayer]-(padding)-|", options: [], metrics: metrics, views: views))

                self.view.addConstraints(constraints)
                self.view.layoutIfNeeded()

                self.previousConstraints = constraints
            }, completion: { finished in
                self.isExpanded = true
            })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.view.removeConstraints(self.previousConstraints)
                self.containerView.addSubview(self.videoPlayer)

                self.videoPlayer.transform = CGAffineTransform(rotationAngle: 0.0)

                var constraints: [NSLayoutConstraint] = []

                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[videoPlayer]|", options: [], metrics: nil, views: views))

                constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[videoPlayer]|", options: [], metrics: nil, views: views))

                self.containerView.addConstraints(constraints)
                self.view.layoutIfNeeded()

                self.previousConstraints = constraints
            }, completion: { finished in
                self.isExpanded = false
            })
        }
    }
    
    @objc func deviceOrientationDidChange(_ notification: Notification) {
        //let orientation = UIDevice.current.orientation
        //print(orientation)
        
        
        
        if UIDevice.current.orientation.isLandscape
        {
            print("Landscape")
            //imageView.image = UIImage(named: const2)
            orientation = UIInterfaceOrientationMask.landscapeLeft
            prefrerredOrientation = UIInterfaceOrientation.landscapeLeft
            
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
        }
        else
        {
            print("Portrait")
            //imageView.image = UIImage(named: const)
            orientation = UIInterfaceOrientationMask.portrait
            prefrerredOrientation = UIInterfaceOrientation.portrait
            
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
        }
    }

    
}
