//
//  SampleHandler.swift
//  ScreenRecord
//
//  Created by Darshil Gada on 29/11/21.
//  Copyright © 2021 BrowserStack. All rights reserved.
//

import ReplayKit
import Photos
import UIKit

@available(iOSApplicationExtension 10.0, *)
class SampleHandler: RPBroadcastSampleHandler {
    
    var avWriter:AVAssetWriter? = nil;
    var videoWriterInput:AVAssetWriterInput? = nil;
    var videoOutputURL:URL? = nil;

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else {
          fatalError("Error while checking documents dir exist or not")
        }
        
        videoOutputURL = documentDirectory.appendingPathComponent("OutputVideo.mp4")
        
        if fileManager.fileExists(atPath: videoOutputURL!.path) {
          do {
            NSLog("Darshil: deleting preexisting video file")
            try FileManager.default.removeItem(atPath: videoOutputURL!.path)
          } catch {
            NSLog("Error while deleting video file \(error) : \(#function)")
            fatalError("Unable to delete video file: \(error) : \(#function).")
          }
        }

        do {
          avWriter = try AVAssetWriter(outputURL: videoOutputURL!, fileType: AVFileType.mp4)
        } catch  {
          NSLog("Error while creating avassetwriter object \(error) : \(#function)")
          fatalError("Error while creating avassetwriter object")
        }

        let audioOutputSettings = [
            AVVideoCodecKey : AVVideoCodecH264,
          AVVideoWidthKey : 824,
          AVVideoHeightKey : 380
          ] as [String : Any]

        self.videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: audioOutputSettings);

        self.videoWriterInput!.expectsMediaDataInRealTime = true

        if avWriter!.canAdd(videoWriterInput!) {
          NSLog("Darshil: Adding videoWriterInput to avwriter")
          avWriter!.add(videoWriterInput!)
        } else {
          NSLog("Darshil: Was not able to add videoWriterInput to avwriter")
        }

        let presentationStartTime = CMTimeMakeWithSeconds(CACurrentMediaTime(), preferredTimescale: 240)

        avWriter?.startWriting()
        avWriter!.startSession(atSourceTime: presentationStartTime)
        
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        closeWriter()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // Handle video sample buffer
            
            if(videoWriterInput!.isReadyForMoreMediaData) {
              videoWriterInput?.append(sampleBuffer)
              NSLog("Darshil: appended video")
            } else {
              NSLog("Darshil: skipping video")
            }
            
            break
        case RPSampleBufferType.audioApp:
            // Handle audio sample buffer for app audio
            break
        case RPSampleBufferType.audioMic:
            // Handle audio sample buffer for mic audio
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
    
    func closeWriter() {
        NSLog("Darshil: initiating closewriter")
        self.videoWriterInput!.markAsFinished()
        NSLog("Darshil: markedFinished")
        
        let presentationStartTime = CMTimeMakeWithSeconds(CACurrentMediaTime(), preferredTimescale: 240)
        
        self.avWriter!.endSession(atSourceTime: presentationStartTime)
        NSLog("Darshil: endSession finished")
        
        self.avWriter!.finishWriting(completionHandler: {
            NSLog("Darshil: finishWriting")

            self.avWriter?.cancelWriting()

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: self.videoOutputURL!.path))
            }) { saved, error in
                if saved {
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                    alertController.addAction(defaultAction)
                }
            }
        })
    }
}
