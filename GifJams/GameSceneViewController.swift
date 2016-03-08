//
//  GameSceneViewController.swift
//  GifJams
//
//  Created by Christian Gonzalez on 1/28/16.
//  Copyright © 2016 Christian Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import AVFoundation

class GameSceneViewController: UIViewController,
MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
//    , MPMediaPickerControllerDelegate, AVAudioPlayerDelegate
    
    @IBOutlet weak var answerResultLabel: UILabel!
    @IBOutlet weak var gifGameView: UIWebView!
    @IBOutlet weak var OverLayView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        OverLayView.hidden = true
        displayMediaPickerAndPlayItem()
        answerResultLabel.hidden = true
        answer1.hidden = true
        answer2.hidden = true
        answer3.hidden = true
    }
    
    //MARK: TO ADD
    
    //3 button labels
    //actions when chosen right answer (show correct answer + play music)
    //transition to new media/ next in queue, refresh front end and continue game
    
//    @IBAction func BeginGamePlayPressed(sender: AnyObject) {
//        displayMediaPickerAndPlayItem()
//        
//    }
    
//    @IBAction func goHomeButton(sender: UIButton) {
//        performSegueWithIdentifier("goHome")
//    }
 
    @IBAction func answer1ButtonPressed(sender: AnyObject) {
    }
    @IBAction func answer2ButtonPressed(sender: AnyObject) {
    }
    @IBAction func answer3ButtonPressed(sender: AnyObject) {
    }
    
    
    @IBOutlet weak var gifViewer: UIWebView!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer1: UIButton!
    var myMusicPlayer: MPMusicPlayerController?
    weak var delegate: MPMediaPickerControllerDelegate?
    var mediaPicker: MPMediaPickerController?
    var nowPlayingItem: MPMediaItem?
    let searchLyrics = SearchModel()
    var gifsArray = NSMutableArray?()
    var counter = 10
    var timer = NSTimer()
    var arrIndex = 0

    func changeGifs(){
        if let player = myMusicPlayer {
            //            myMusicPlayer = MPMusicPlayerController()
            if let songtitle = player.nowPlayingItem!.title {
                print("Taking", songtitle, "to the backend")
                searchLyrics.findSongLyrics(String(songtitle)) {
                    (data, response, error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        if let gifs = data {
                            print(self.parseJSON(gifs), "is what we got back")
                            if let unwrapped = self.parseJSON(gifs) {
                                //here we have the string version of the embed url
                                self.gifsArray = unwrapped
                                print(unwrapped)
                                
                                let trialURL = unwrapped[0]
                                //here is where we set the view
                                
                                let URL = NSURL(string: trialURL as! String)
                                self.gifGameView.loadRequest(NSURLRequest(URL: URL!))
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    
    
    func musicPlayerStateChanged(notification: NSNotification){
        
        print("Player State Changed")
        
        /* Let's get the state of the player */
        let stateAsObject =
        notification.userInfo!["MPMusicPlayerControllerPlaybackStateKey"]
            as? NSNumber
        
        if let state = stateAsObject{
            
            /* Make your decision based on the state of the player */
            switch MPMusicPlaybackState(rawValue: state.integerValue)!{
            case .Stopped:
                /* Here the media player has stopped playing the queue. */
                print("Stopped")
            case .Playing:
                /* The media player is playing the queue. Perhaps you
                can reduce some processing that your application
                that is using to give more processing power
                to the media player */
                print("Paused")
            case .Paused:
                /* The media playback is paused here. You might want
                to indicate by showing graphics to the user */
                print("Paused")
            case .Interrupted:
                /* An interruption stopped the playback of the media queue */
                print("Interrupted")
            case .SeekingForward:
                /* The user is seeking forward in the queue */
                print("Seeking Forward")
            case .SeekingBackward:
                /* The user is seeking backward in the queue */
                print("Seeking Backward")
            }
            
        }
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        print("Playing Item Is Changed")
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID =
        notification.userInfo![key] as? NSString
        
        if let id = persistentID{
            /* Do something with Persistent ID */
            print("Persistent ID = \(id)")
            
        }
        
    }
    
    func volumeIsChanged(notification: NSNotification){
        print("Volume Is Changed")
        /* The userInfo dictionary of this notification is normally empty */
    }
    
    func mediaPicker(var mediaPicker: MPMediaPickerController,
        didPickMediaItems mediaItemCollection: MPMediaItemCollection){
//            init(mediaTypes: MPMediaType)
//            var songs: [MPMediaItemCollection]
            print("Media Picker returned")
            
            /* Instantiate the music player */
            
            myMusicPlayer = MPMusicPlayerController()
            
            if let player = myMusicPlayer{
                player.beginGeneratingPlaybackNotifications()
                
                /* Get notified when the state of the playback changes */
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: "musicPlayerStateChanged:",
                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification,
                    object: nil)
                
                /* Get notified when the playback moves from one item
                to the other. In this recipe, we are only going to allow
                our user to pick one music file */
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: "nowPlayingItemIsChanged:",
                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
                    object: nil)
                
                /* And also get notified when the volume of the
                music player is changed */
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: "volumeIsChanged:",
                    name: MPMusicPlayerControllerVolumeDidChangeNotification,
                    object: nil)
                
                /* Start playing the items in the collection */
                player.setQueueWithItemCollection(mediaItemCollection)
                print("we live with" , mediaItemCollection)
                
                print( mediaItemCollection.items, "Is our collection of items")
//                var songs = [mediaItemCollection.items]
                MPMusicShuffleMode.Songs
                player.play()
                changeGifs()
                
                print("Back to the initial page")
                answer1.setTitle(String(player.nowPlayingItem?.title), forState: UIControlState.Normal)
                //                answer2.setTitle(String(songs[randomSong]), forState: UIControlState.Normal)
                //                answer3.setTitle(String(songs[randomSong]), forState: UIControlState.Normal)
//                player.pause()
                mediaPicker.dismissViewControllerAnimated(false, completion: nil)
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "nextGif", userInfo: nil, repeats: true)
                answer1.hidden = false
                answer2.hidden = false
                answer3.hidden = false
            }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        /* The media picker was cancelled */
        print("Media Picker was cancelled")
        mediaPicker.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func stopPlayingAudio(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if let player = myMusicPlayer{
            player.stop()
        }
        
    }
    
    func displayMediaPickerAndPlayItem(){
        
        mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
        
        if let picker = mediaPicker{
            
            

            picker.delegate = self

            picker.allowsPickingMultipleItems = true
            picker.showsCloudItems = true
            picker.prompt = "Pick a song please..."


            presentViewController(picker, animated: false, completion: nil)

            
        } else {
            print("Could not instantiate a media picker")
        }
        
    }
    
    
    
    func afterRequest(data: NSData?, response: NSURLResponse?, error: NSError?) {
        print("WE DID IT")
    }
    
    func parseJSON(inputData: NSData) -> NSMutableArray? {
        do {
            let arrOfObjects = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)
            return arrOfObjects as? NSMutableArray
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func nextGif() {
        --counter
        if counter == 0 {
            print("on to the next one")
            increaseIndex()
            counter = 10
        }
        
    }
    
    func increaseIndex() {
        ++arrIndex
        
        if let  checkArray = self.gifsArray {
            if arrIndex == checkArray.count {
                arrIndex = 0
            }
            let trialURL = checkArray[arrIndex]
            let URL = NSURL(string: trialURL as! String)
            self.gifGameView.loadRequest(NSURLRequest(URL: URL!))
        }
        
    }
    
    //MARK: To add
    
    //make youtube api call to find song chosen
    
    //have video start playing (or just load) once an answer is chosen
    
    //have a nav option for next but not back
    

    
    
}