//
//  ViewController.swift
//  photomaster
//
//  Created by 内山香 on 2016/06/09.
//  Copyright © 2016年 内山香. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    //写真表示用ImgView
    @IBOutlet weak var photoImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //カメラ、ライブラリからの呼び出し
    func precentPickerController(sourceType: UIImagePickerControllerSourceType){
        
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
        //UIImagePickerControllerをインスタント化
        let picker = UIImagePickerController()
        
        //ソースタイプを設定
        picker.sourceType = sourceType
        
        //デリゲード設定
        picker.delegate = self
        
        self.presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    
    //写真が選択された時に呼び出される
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //画像出力
        photoImgView.image = image
        
    }
    
    //画像を取得ボタンが押された時
    @IBAction func selectButtonTapped(sender: UIButton){
        
        //選択肢の上に表示するタイトル、メッセージ、アラートタイプ設定
        let alertController = UIAlertController(title: "画像の取得先を選択", message: nil, preferredStyle: .ActionSheet)
        
        //選択肢の名前と処理を一つずつ設定
        let firstAction = UIAlertAction(title: "カメラ", style: .Default){
            
            action in
            self.precentPickerController(.Camera)
        }
        let secondAction = UIAlertAction(title: "アルバム", style: .Default){
            
            action in
            self.precentPickerController(.PhotoLibrary)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        
        //設定した選択肢をアラートに登録
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        
        //アラートを表示
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func drawText(image: UIImage) -> UIImage {
        
        //テキストの内容の設定
        let text = "LifeisTech!Learders8期"
        
        //グラフィックコンテキストの生成、編集を開始
        UIGraphicsBeginImageContext(image.size)
        
        //読み込んだ写真を書き出す
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        //書き出す位置と大きさの設定
        let textRect = CGRectMake(5, 5, image.size.width-5, image.size.height-5)
        
        //textFontAttributes:文字の特性(フォント、カラー、スタイル)の設定
        let textFontAttributes=[
            NSFontAttributeName: UIFont.boldSystemFontOfSize(120),
            NSForegroundColorAttributeName: UIColor.redColor(),
            NSParagraphStyleAttributeName: NSMutableParagraphStyle.defaultParagraphStyle()
        ]
        
        //textRectで指定した範囲にtextAttributesに従ってtextを書き出す
        text.drawInRect(textRect, withAttributes: textFontAttributes)
        
        //グラフィックスコンテキストの画像を取得
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        
        //グラフィックコンテクストの編集を終了
        UIGraphicsEndImageContext()
        
        return newImg
        
        
    }
    
    //元の画像にマスク画像を合成するメソッド
    func drawMaskImg(image: UIImage) -> UIImage {
        
        //グラフィックコンテクストの生成編集雨を開始
        UIGraphicsBeginImageContext(image.size)
        
        //読み込んだ写真を書き出す
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))

        //マスク画像
        let maskImg = UIImage(named: "monster002")
        
        //書き出す位置と大きさの設定
        let offset: CGFloat = 50.0
        let maskRect = CGRectMake(image.size.width - maskImg!.size.width - offset,
                                  image.size.height - maskImg!.size.height - offset,
                                  maskImg!.size.width,
                                  maskImg!.size.height)
        
        //maskRectで指定した範囲にmaskImgを書き出す
        maskImg!.drawInRect(maskRect)
        
        //グラフィックコンテクストの画像を取得
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        
        //グラフィックコンテクストの編集を終了
        UIGraphicsEndImageContext()
        
        return newImg
        
    }
    
    func simpleAlert(titleString: String) {
        let alertController = UIAlertController(title: titleString, message: nil, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //合成ボタンを押した時に呼ばれる
    @IBAction func precessButtonTapped(sender: UIButton){
        
        //photoImgView.imageがnilでなければselectPhotoに値が入る
        guard let selectedPhoto = photoImgView.image else{
            
            //nilならアラートを表示してメソッドを抜ける
            simpleAlert("画像がありません")
            return
        }
        
        let alertController = UIAlertController(title: "合成するパーツを選択", message: nil, preferredStyle: .ActionSheet)
        let firstAction = UIAlertAction(title: "テキスト", style: .Default ){
            action in
            
            //selectedPhotoに画像を合成して画面に書き出す
            self.photoImgView.image = self.drawText(selectedPhoto)
        }
        let secondAction = UIAlertAction(title: "monster", style: .Default ){
            action in
            
            //selectedPhotoに画像を合成して画面に書き出す
            self.photoImgView.image = self.drawMaskImg(selectedPhoto)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    //SNSに投稿するメソッド
    func posTotSNS(serviceType: String) {
        
        //SLComposeViewControllerのインスタント化し、SeviceTypeを指定
        let myComposeView = SLComposeViewController(forServiceType: serviceType)
        
        //投稿するテキストの指定
        myComposeView.setInitialText("test投稿")
        
        //投稿する画像を指定
        myComposeView.addImage(photoImgView.image)
        
        //myComposeViewの画面遷移
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }
    
    //アップロードを押した時に呼ばれる
    @IBAction func uploadButtonTapped(sender: UIButton){
        
        guard let selectedPhoto = photoImgView.image else{
            simpleAlert("画像がありません")
            return
        }
        
        let alertController = UIAlertController(title: "アップロード先を選択", message: nil, preferredStyle: .ActionSheet)
        let firstAction = UIAlertAction(title: "Facebookに投稿", style: .Default ){
            action in
            
            self.posTotSNS(SLServiceTypeFacebook)
        }
        let secondAction = UIAlertAction(title: "Twitterに投稿", style: .Default ){
            action in
            self.posTotSNS(SLServiceTypeTwitter)
            
        }
        let thirdAction = UIAlertAction(title: "カメラロールに保存", style: .Default ){
            action in
            UIImageWriteToSavedPhotosAlbum(selectedPhoto, self, nil, nil)
            self.simpleAlert("アルバムに保存されました")
            
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)

        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

