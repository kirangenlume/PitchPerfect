//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by kirang on 12/24/17.
//  Copyright © 2017 kirang. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    func configuringUI(recordingLabelText: String, stopRecordingButtonState: Bool, recordButtonState: Bool)  {
        recordingLabel.text = recordingLabelText
        stopRecordingButton.isEnabled = stopRecordingButtonState
        recordButton.isEnabled = recordButtonState
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        configuringUI(recordingLabelText: "Tap to record. ", stopRecordingButtonState: false, recordButtonState: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var audioRecorder: AVAudioRecorder!
    @IBAction func recordAudio(_ sender: Any) {
       /* recordingLabel.text = "Recording in progress. "
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false*/
        configuringUI(recordingLabelText: "Recording in progress. ", stopRecordingButtonState: true, recordButtonState: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    // MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

