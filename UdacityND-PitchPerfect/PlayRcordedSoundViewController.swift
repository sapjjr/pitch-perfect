//
//  PlayRcordedSoundViewController.swift
//  PitchPerfect
//
//  Created by andrew on 14/03/2015.
//  Copyright (c) 2015 Firekite. All rights reserved.
//

import UIKit
import AVFoundation

class PlayRcordedSoundViewController: UIViewController {

    
    // audioPLayer declared here as a global variable
    var audioPlayer : AVAudioPlayer!
    var receivedAudio: RecordedAudio! //also data to be recieved from sender seque

    
    
    //----------------------
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    //----------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //------------------------------------------
    audioEngine = AVAudioEngine()
    //create instance of the audio engine (1)
    audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    //------------------------------------------
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func buttonPlaySlowAudio(sender: UIButton) {
        // audioPLayer is used here
//        audioPlayer.stop()
//        audioPlayer.rate = 0.5
//        audioPlayer.currentTime = 0.0
//        audioPlayer.prepareToPlay()
//        audioPlayer.play()
//         I have left the above as a reminder of the alternate approach
        sharedAudioFunction(0.5, typeOfChange: "rate")
    }

    @IBAction func buittonPlayFast(sender: UIButton) {
        sharedAudioFunction(1.9, typeOfChange: "rate")
    }
    
    
    @IBAction func buttonStopPlayer(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func buttonPlayChipMonk(sender: UIButton) {
        sharedAudioFunction(1000, typeOfChange: "pitch")
        
    }
    
    @IBAction func buttonPlayDarthVadar(sender: UIButton) {
        sharedAudioFunction(-1000, typeOfChange: "pitch")
    }
    
    func sharedAudioFunction(audioValue: Float, typeOfChange: String){
        
        //create instance of a player (2)
        var audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        
        // attach the engine to the player so it is aware of the player (3)
        audioEngine.attachNode(audioPlayerNode)
        
        var audioTimeValue = AVAudioUnitTimePitch()
        
        if (typeOfChange == "rate") {
            
            audioTimeValue.rate = audioValue
            
        } else {
            audioTimeValue.pitch = audioValue
        }
        audioEngine.attachNode(audioTimeValue)
        
        
        audioEngine.connect(audioPlayerNode, to: audioTimeValue, format: nil)
        audioEngine.connect(audioTimeValue, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        // at time 0 means play immediately
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
// end of class
}
