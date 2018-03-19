//
//  EffectViewController.swift
//  camera4GGA_AVF2
//
//  Created by Chie Takahashi on 2018/03/18.
//  Copyright © 2018年 ctak. All rights reserved.
//

import UIKit

class EffectViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 画面遷移時に元の画像を表示
    effectImage.image = originalImage
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func photoSelect(_ sender: UIButton) {
    let alertController = UIAlertController(title: "確認", message: "選択して下さい", preferredStyle: .actionSheet)
    
    //フォトライブラリーが利用可能かチェック
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
      //フォトライブラリーを起動するための選択肢を定義
      let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: {(action:UIAlertAction) in
        //フォトライブラリーを起動
        let ipc : UIImagePickerController = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(ipc, animated: true, completion: nil)
      })
      alertController.addAction(photoLibraryAction)
    }
    //キャンセルの選択肢を定義
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    //iPadで落ちてしまう対策
    alertController.popoverPresentationController?.sourceView = view
    
    //選択肢を画面に表示
    present(alertController, animated: true, completion: nil)
  }
  
  @IBOutlet weak var effectImage: UIImageView!
  
  let filterArray = [
    "CIPhotoEffectMono"
    ,"CIPhotoEffectNoir"
    ,"CIPhotoEffectTonal"
    ,"CISepiaTone"
  ]
  
  //選択中のエフェクト添字
  var filterSelectNumber = 0
  
  // エフェクト前画像
  // 前の画面より画像を設定
  var originalImage : UIImage?
  
  @IBAction func effectButtonAction(_ sender: Any) {
    //フィルター名を指定
    let filterName = filterArray[filterSelectNumber]
    
    //次の選択するエフェクト添字に更新
    filterSelectNumber += 1
    
    //添字が配列の数と同じかチェックする
    if filterSelectNumber == filterArray.count {
      //同じ場合は最後まで選択されたので先頭に戻す
      filterSelectNumber = 0
    }
    
    //元々の画像の回転角度を取得
    let rotate = originalImage!.imageOrientation
    
    //UIImage形式の画像をCIImageの画像に変換
    let inputImage = CIImage(image: originalImage!)
    
    //フィルターの種類を引数で指定された種類を指定してCIFilterのインスタンスを取得
    let effectFilter = CIFilter(name: filterName)!
    
    //エフェクトのパラメータを初期化
    effectFilter.setDefaults()
    
    //インスタンスにエフェクトする元画像を設定
    effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
    
    //エフェクト後のCIImag形式の画像を取り出す
    let outputImage = effectFilter.outputImage
    
    //CIContextのインスタンスを取得
    let ciContext = CIContext(options: nil)
    
    //エフェクト後の画像をCIContext上に描画し、結果をcgImageとしてCGImage形式の画像を取得
    let cgImage = ciContext.createCGImage(outputImage!, from: outputImage!.extent)
    
    //エフェクト後の画像をCGImage形式の画像からUIImage形式の画像に回転角度を指定して変換しImageViewに表示
    effectImage.image = UIImage(cgImage: cgImage!, scale: 1.0, orientation: rotate)
    
  }
  
  //画像を保存
  //  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
  //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
  //    self.effectImage.image = image
  //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
  //    self.dismiss(animated: true)
  //  }
  
  //保存した結果をアラートで表示
  //  func showResultOfSaveImage(_image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer){
  //    var title = "保存完了"
  //    var message = "カメラロールに保存しました"
  //    if error != nil{
  //      title = "エラー"
  //      message = "保存に失敗しました"
  //    }
  
  @IBAction func closeButtonAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

