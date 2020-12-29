//
//  VideoLaunchController.swift
//  MovieBox
//
//  Created by Akmaral on 12/28/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoLaunchController: UIViewController {

    func setupAVPlayer() {

        let videoURL = Bundle.main.url(forResource: "launchscreen", withExtension: "mp4") // Get video url
        let avAssets = AVAsset(url: videoURL!) // Create assets to get duration of video.
        let avPlayer = AVPlayer(url: videoURL!) // Create avPlayer instance
        let avPlayerLayer = AVPlayerLayer(player: avPlayer) // Create avPlayerLayer instance
        avPlayerLayer.frame = self.view.bounds // Set bounds of avPlayerLayer
        self.view.layer.addSublayer(avPlayerLayer) // Add avPlayerLayer to view's layer.
        avPlayer.play() // Play video

        // Add observer for every second to check video completed or not,
        // If video play is completed then redirect to desire view controller.
        avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1) , queue: .main) { [weak self] time in

            if time == avAssets.duration {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! UITabBarController  //MainViewController
               // self?.navigationController?.pushViewController(vc, animated: true)
                self?.present(vc, animated: true, completion: nil)
            }
        }
    }

    //------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //------------------------------------------------------------------------------

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupAVPlayer()  // Call method to setup AVPlayer & AVPlayerLayer to play video
    }
    
}
