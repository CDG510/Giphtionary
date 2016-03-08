//
//  ViewController.swift
//  GifJams
//
//  Created by Christian Gonzalez on 1/27/16.
//  Copyright © 2016 Christian Gonzalez. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class searchViewController: UIViewController,
MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
    
    var myMusicPlayer: MPMusicPlayerController?
//    var buttonPickAndPlay: UIButton?
//    var buttonStopPlaying: UIButton?
    var mediaPicker: MPMediaPickerController?
    var nowPlayingItem: MPMediaItem?
    let searchLyrics = SearchModel()
    var gifsArray = NSMutableArray?()
    var counter = 6
    var timer = NSTimer()
    var arrIndex = 0
    
    @IBAction func gameStartButtonPressed(sender: AnyObject) {
        timer.invalidate()
        performSegueWithIdentifier("playGame", sender: self)
    
    }
    @IBAction func JamButtonPressed(sender: AnyObject) {
//        displayMediaPickerAndPlayItem()
        timer.invalidate()
        performSegueWithIdentifier("playMusic", sender: self)
    }
    //MARK: default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "GifJams"
        var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "nextGif", userInfo: nil, repeats: true)
//        let socket = SocketIOClient(socketURL: "http://192.168.1.44:5000")
//        socket.connect()
//        socket.on("connect") { data, ack in
//            print("iOS::WE ARE USING SOCKETS!")
//        
//        }
        searchLyrics.introGifs("lol") {
            (data, response, error) in
            dispatch_async(dispatch_get_main_queue()) {
                if let gifs = data {
                    print(self.parseJSON(gifs), "is what we got back")
                    if let unwrapped = self.parseJSON(gifs) {
                        //here we have the string version of the embed url
                        self.gifsArray = unwrapped
                        let random = Int(arc4random_uniform(25))
                        print(random)
                        let trialURL = unwrapped[random]
                        //here is where we set the view
                        let URL = NSURL(string: trialURL as! String)
                        self.GifView.loadRequest(NSURLRequest(URL: URL!))
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "nextGif", userInfo: nil, repeats: true)
                    }
                }
                
            }
        }

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
    
    @IBOutlet weak var GifView: UIWebView!
//    @IBAction func SearchForMusicButton(sender: UIBarButtonItem) {
//        displayMediaPickerAndPlayItem()
//    }
    
//    @IBAction func previousButtonPressed(sender: UIButton) {
//        myMusicPlayer = MPMusicPlayerController()
//        //check to see if music is already playing
//        if myMusicPlayer!.indexOfNowPlayingItem < 1 {
//            return
//        }
//        else {
//            if let player = myMusicPlayer{ player.skipToPreviousItem()
//                changeGifs()
//        }
//        
//        
//        }
//    }
    
//    @IBAction func playButton(sender: UIButton) {
//        myMusicPlayer = MPMusicPlayerController()
//        //check to see if music is already playing
//        if let player = myMusicPlayer{ player.play()
//        }
//    }
    
//    @IBAction func stopButtonPressed(sender: UIButton) {
//        myMusicPlayer = MPMusicPlayerController()
//        
//        if let player = myMusicPlayer{ player.stop()
//            //eventually stop the gifs from playing
//        }
//    }
//    @IBAction func nextButtonPressed(sender: UIButton) {
//        myMusicPlayer = MPMusicPlayerController()
//        if myMusicPlayer!.indexOfNowPlayingItem == gifsArray?.count {
//            return
//        }
//
//       
//        //check to see if music is already playing
//        
//        
//        if let player = myMusicPlayer{ player.skipToNextItem()
//            changeGifs()
//        }
//    }
    
    
    
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
    
    func homeButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        
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
            picker.prompt = "Pick a song please..."
            self.view.addSubview(picker.view)
            
            presentViewController(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker")
        }
        
    }
    
    
  
    
    func nextGif() {
        --counter
        if counter == 0 {
            print("on to the next one")
            increaseIndex()
            counter = 6
        }
        
    }
    
    func increaseIndex() {
        let random = Int(arc4random_uniform(25))
        print(random)
        arrIndex = random
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

