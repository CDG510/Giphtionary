//
//  PlaySongsViewController.swift
//  GifJams
//
//  Created by Christian Gonzalez on 1/29/16.
//  Copyright © 2016 Christian Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import AVFoundation

class PlaySongsViewController: UIViewController,
MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var PlayStopButton: UIButton!
    @IBAction func DoneBarButtonPressed(sender: UIBarButtonItem) {
        timer.invalidate()
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBOutlet weak var GifView: UIWebView!
    var myMusicPlayer: MPMusicPlayerController?

    @IBOutlet weak var StopButtonPressed: UIButton!
    @IBOutlet weak var NextButtonPressed: UIButton!
    @IBOutlet weak var PreviousButtonPressed: UIButton!
    @IBAction func PlayButtonPressed(sender: AnyObject) {
    }
    var buttonStopPlaying: UIButton?
    var mediaPicker: MPMediaPickerController?
    var nowPlayingItem: MPMediaItem?
    let searchLyrics = SearchModel()
    var gifsArray = NSMutableArray?()
    var counter = 10
    var timer = NSTimer()
    var arrIndex = 0
    
//    override func viewDidAppear(animated: Bool) {
//        self.loadView()
//    }
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
    @IBAction func searchSongButtonPressed(sender: UIBarButtonItem) {
        displayMediaPickerAndPlayItem()
       
    }
    
    
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
                                self.GifView.loadRequest(NSURLRequest(URL: URL!))
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    
    
    @IBAction func previousButtonPressed(sender: UIButton) {
        myMusicPlayer = MPMusicPlayerController()
        //check to see if music is already playing
        if myMusicPlayer!.indexOfNowPlayingItem < 1 {
            return
        }
        else {
            if let player = myMusicPlayer{ player.skipToPreviousItem()
                changeGifs()
            }
            
            
        }

    }
        @IBAction func playButtonPressed(sender: UIButton) {
        myMusicPlayer = MPMusicPlayerController()
        //check to see if music is already playing
            print("clicky")
            if PlayStopButton.titleLabel?.text == "Pause" {
                if let player = myMusicPlayer{ player.pause()
                    print("paused")
                }
                PlayStopButton.setTitle("Play", forState: UIControlState.Normal)
                PlayStopButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                print("OK CHANGED")
            }
            if PlayStopButton.titleLabel?.text == "Play" {
                if let player = myMusicPlayer{ player.play()}
                print("resume play")
                PlayStopButton.setTitle("Pause", forState: UIControlState.Normal)
                PlayStopButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                print("changed to pause")
            }
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        myMusicPlayer = MPMusicPlayerController()
        
        if let player = myMusicPlayer{ player.stop()
            //eventually stop the gifs from playing
        }
    }
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        myMusicPlayer = MPMusicPlayerController()
        if myMusicPlayer!.indexOfNowPlayingItem == gifsArray?.count {
            print("NAH MAN")
            return
        } else {
            print("currently at my",  myMusicPlayer!.indexOfNowPlayingItem)
            let checkArr = [MPMediaItemCollection]()
            print("out of ", checkArr.count)
            if let player = myMusicPlayer{ player.skipToNextItem()
                changeGifs()
            }
        }

    }
                //check to see if music is already playing
                
        

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
    
        
        func mediaPicker(mediaPicker: MPMediaPickerController,
            didPickMediaItems mediaItemCollection: MPMediaItemCollection){
                
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
                    //                var items: [MPMediaItem]
                    print( mediaItemCollection.items, "Is our collection of items")
                    
                    player.play()
                    changeGifs()
                    
                    print("Back to the initial page")
                    mediaPicker.dismissViewControllerAnimated(true, completion: nil)
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "nextGif", userInfo: nil, repeats: true)

                }
        }
        
        func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
            /* The media picker was cancelled */
            print("Media Picker was cancelled")
            mediaPicker.dismissViewControllerAnimated(true, completion: nil)
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
                
                
                print("Successfully instantiated a media picker")
                picker.delegate = self
                picker.allowsPickingMultipleItems = true
                picker.showsCloudItems = true
                
//                self.view.addSubview(picker.view)
                
                presentViewController(picker, animated: false, completion: nil)
                
            } else {
                print("Could not instantiate a media picker")
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
                self.GifView.loadRequest(NSURLRequest(URL: URL!))
            }
            
        }

}