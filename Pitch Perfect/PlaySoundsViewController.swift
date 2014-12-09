//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by eadg on 12/6/14.
//  Copyright (c) 2014 eadg. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    // contains NSURL to our recorded voice
    // later we need to convert this NSURL to AVAudioFile to play the sound
    var receivedAudio:RecordedAudio!
    
    // created global object for avaudioengine
    var audioEngine:AVAudioEngine!
    
    // create global variable for AVAudioFile
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        Do any additional setup after loading the view.
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            var filePathUrl = NSURL.fileURLWithPath(filePath)
//            audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
//            audioPlayer.enableRate = true
//        } else {
//            println("the file path is empty")
//        }
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // initialized the object for AVAudioEngine
        audioEngine = AVAudioEngine()
        
        // initialize the variable for AVAudioFile
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowPlay(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    @IBAction func fastPlay(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func chipmunkPlay(sender: UIButton) {
        // method that actually runs when pressed the chipmunk button
        playAudioWithVariablePitch(1300, rate: 1.5)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float, rate: Float = 1){
        // making sure you stop all audio before playing it back again
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // create object for AVAudioPlayerNode
        var audioPlayerNode = AVAudioPlayerNode()
        // attach audioPlayerNode just created to the audioEngine
        audioEngine.attachNode(audioPlayerNode)
        
        // create object of AVAudioUnitTimePitch
        var changePitchEffect = AVAudioUnitTimePitch()
        // updated the effect pitch to the arguement value this function was taking, 1000
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = rate
        // attach pitch effect to the audioEngine
        audioEngine.attachNode(changePitchEffect)
        
        // use audioEngine connect function to connect audioPlayerNode to changePitchEffect
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // and then the pitch effect to the output or the speakers
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // play sound
        // use audioPlayerNode scheduleFile function
        // this function takes in an arguement called file of type AVAudioFile
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        // start the audio engine and play the audio player
        audioPlayerNode.play()
        
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        audioPlayer.stop()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
