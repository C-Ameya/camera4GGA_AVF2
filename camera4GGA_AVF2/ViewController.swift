//
//  ViewController.swift
//  camera4GGA_AVF2
//
//  Created by Chie Takahashi on 2018/03/12.
//  Copyright © 2018年 ctak. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import BWWalkthrough

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, BWWalkthroughViewControllerDelegate {
  
  @IBAction func startWalkthrough(_ sender: Any) {
    print("startWalkthrough")
    let stb = UIStoryboard(name: "Main", bundle: nil)
    let walkthrough = stb.instantiateViewController(withIdentifier: "walk0") as! BWWalkthroughViewController
    let page_one = stb.instantiateViewController(withIdentifier: "walk1") as UIViewController
    let page_two = stb.instantiateViewController(withIdentifier: "walk2") as UIViewController
    let page_three = stb.instantiateViewController(withIdentifier: "walk3") as UIViewController
    
    //マスターにページを追加
    walkthrough.delegate = self
    walkthrough.add(viewController:page_one)
    walkthrough.add(viewController:page_two)
    walkthrough.add(viewController:page_three)
    
    self.present(walkthrough, animated: true, completion: nil)
  }
  
  func walkthroughCloseButtonPressed() {
    print("startWalkthrough")
    self.dismiss (animated: true, completion: nil)
  }
  
  //カメラセッション
  var captureSession: AVCaptureSession!
  var capturePhotoOutput: AVCapturePhotoOutput?
  var previewLayer: AVCaptureVideoPreviewLayer?
  var captureDevice: AVCaptureDevice?
  var ssTimeScale: CMTimeScale = 0
  
  @IBOutlet weak var preView: UIView!
  
  @IBAction func capture(_ sender: Any) {
    let photoSettings : AVCapturePhotoSettings!
    photoSettings = AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    photoSettings.isAutoStillImageStabilizationEnabled = true
    photoSettings.flashMode = .off
    photoSettings.isHighResolutionPhotoEnabled = false
    self.capturePhotoOutput?.capturePhoto(with: photoSettings, delegate: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.captureSession = AVCaptureSession()
    self.captureSession?.sessionPreset = .photo
    self.capturePhotoOutput = AVCapturePhotoOutput()
    self.captureDevice = AVCaptureDevice.default(for: .video)
    
    //ISOの最小値と最大値を設定
    self.isoSlider.minimumValue = self.captureDevice!.activeFormat.minISO
    self.isoSlider.maximumValue = self.captureDevice!.activeFormat.maxISO
    self.isoSlider.value = (self.captureDevice!.activeFormat.minISO + self.captureDevice!.activeFormat.maxISO) / 2.0
    
    //シャッタースピードの最小値と最大値を設定
    let minCMTime = self.captureDevice!.activeFormat.minExposureDuration
    let maxCMTime = self.captureDevice!.activeFormat.maxExposureDuration
    self.ssTimeScale = self.captureDevice!.activeFormat.minExposureDuration.timescale
    self.ssSlider.minimumValue = Float(minCMTime.value)
    self.ssSlider.maximumValue = Float(maxCMTime.value)
    
    //写真をviewに表示
    let input = try! AVCaptureDeviceInput(device: self.captureDevice!)
    self.captureSession?.addInput(input)
    self.captureSession?.addOutput(self.capturePhotoOutput!)
    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
    self.previewLayer?.frame = self.preView.bounds
    self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    self.previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
    self.preView.layer.addSublayer(self.previewLayer!)
    self.captureSession?.startRunning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBOutlet weak var isoSlider: UISlider!
  @IBOutlet weak var ssSlider: UISlider!
  var timerMapping: Float!
  
  //ISOスライダーの設定
  @IBAction func ChangeValue(_ sender: UISlider) {
    let Setting = AVCaptureDevice.default(for: .video)
    do {
      try Setting?.lockForConfiguration()
      let isoSetting: Float = isoSlider.value
      
      timerMapping = ssSlider.value
      
      let StockTime = Int64(timerMapping)
      let SetTime: CMTime = CMTimeMake(StockTime, self.ssTimeScale)
      Setting?.setExposureModeCustom(duration: SetTime, iso: isoSetting, completionHandler: nil)
      
      Setting?.unlockForConfiguration()
    } catch {
      let alertController = UIAlertController(title: "Cheak", message: "False", preferredStyle: .alert)
      
      let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  
  @IBOutlet weak var isoValue: UILabel!
  
  @IBAction func isoValueSlider(_ sender: UISlider) {
    //     isoValue.text = "\(sender.value)"
    self.isoValue.text = String(format: "%.f", (self.captureDevice?.iso)!)
  }
  
  //SSスライダーの設定
  @IBAction func ssChangeValue(_sender: UISlider){
    let Setting = AVCaptureDevice.default(for: .video)
    do {
      try Setting?.lockForConfiguration()
      let isoSetting: Float = isoSlider.value
      
      timerMapping = ssSlider.value
      
      let StockTime = Int64(timerMapping)
      let SetTime: CMTime = CMTimeMake(StockTime, self.ssTimeScale)
      Setting?.setExposureModeCustom(duration: SetTime, iso: isoSetting, completionHandler: nil)
      
      Setting?.unlockForConfiguration()
    } catch {
      let alertController = UIAlertController(title: "Cheak", message: "False", preferredStyle: .alert)
      
      let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  
  
  @IBOutlet weak var ssValue: UILabel!
  
  @IBAction func ssValueSlider(_ sender: UISlider) {
    timerMapping = ssSlider.value
    
    let StockTime = Int64(timerMapping)
    let SetTime: CMTime = CMTimeMake(StockTime, self.ssTimeScale)
    self.ssValue.text = String(format: "1/%.f", 1.0 / SetTime.seconds)
  }
  
  //ホワイトバランスの処理(1):Blue base
  @IBAction func WB(sender: UIButton){
    print("call WB")
    let wbSetting =  AVCaptureDevice.default(for: .video)
    do{
      try wbSetting?.lockForConfiguration()
      var  g:AVCaptureDevice.WhiteBalanceGains = AVCaptureDevice.WhiteBalanceGains(redGain: 0.0, greenGain: 0.0, blueGain: 0.0)
      
      g.blueGain = 2.5
      g.greenGain = 1.3
      g.redGain = 3.0
      
      wbSetting?.setWhiteBalanceModeLocked(with: g, completionHandler: nil )
      wbSetting?.unlockForConfiguration()
    } catch {
      let alertController = UIAlertController(title: "Cheak", message: "False", preferredStyle: .alert)
      
      let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  
  //ホワイトバランスの処理(2): Red base
  @IBAction func WB2(sender: UIButton){
    print("call WB2")
    let wbSetting =  AVCaptureDevice.default(for: .video)
    do{
      try wbSetting?.lockForConfiguration()
      var  g:AVCaptureDevice.WhiteBalanceGains = AVCaptureDevice.WhiteBalanceGains(redGain: 0.0, greenGain: 0.0, blueGain: 0.0)
      
      g.blueGain = 3.0
      g.greenGain = 1.3
      g.redGain = 2.5
      
      wbSetting?.setWhiteBalanceModeLocked(with: g, completionHandler: nil )
      wbSetting?.unlockForConfiguration()
    } catch {
      let alertController = UIAlertController(title: "Cheak", message: "False", preferredStyle: .alert)
      
      let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  
  //ホワイトバランスリセットの処理 : yellow bases
  @IBAction func resetWB(_ sender: UIButton) {
    print("call resetWB")
    let resetWB = AVCaptureDevice.default(for: .video)
    do{
      try resetWB?.lockForConfiguration()
      var  decomp:AVCaptureDevice.WhiteBalanceGains = AVCaptureDevice.WhiteBalanceGains(redGain: 0.0, greenGain: 0.0, blueGain: 0.0)
      
      decomp.blueGain = 2.5
      decomp.greenGain = 1.3
      decomp.redGain = 2.5
      resetWB?.setWhiteBalanceModeLocked(with: decomp, completionHandler: nil )
    } catch {
      let alertController = UIAlertController(title: "Cheak", message: "False", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  
  //写真の保存
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    print("call photoOutput")
    PHPhotoLibrary.shared().performChanges( {
      let creationRequest = PHAssetCreationRequest.forAsset()
      creationRequest.addResource(with: PHAssetResourceType.photo, data: photo.fileDataRepresentation()!, options: nil)
    }, completionHandler: nil)
    
    self.showResultOfSaveImage(_image: nil, didFinishSavingWithError: error, contextInfo: nil)
  }
  
  func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                   didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings,
                   error: Error?) {
    
    guard error == nil else {
      print("Error in capture process: \(String(describing: error))")
      return
    }
  }
  
  //保存した結果をアラートで表示
  func showResultOfSaveImage(_image: UIImage?, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?){
    print("call showResultOfSaveImage")
    var title = "保存完了"
    var message = "フォトライブラリーに保存しました"
    if error != nil{
      title = "エラー"
      message = "保存に失敗しました"
    }
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //OKボタンを追加
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    //UIAlertControllerを表示
    self.present(alert, animated: true, completion: nil)
  }
}



