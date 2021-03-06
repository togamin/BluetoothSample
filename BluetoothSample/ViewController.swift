//
//  ViewController.swift
//  BluetoothSample
//
//  Created by Togami Yuki on 2018/09/22.
//  Copyright © 2018 Togami Yuki. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController,MCSessionDelegate,MCBrowserViewControllerDelegate{
    

    //表示するテキストデータの配列
    var textLabelList = [UILabel]()
    
    //Bluetooth通信をするにあたって
    var session : MCSession!
    var peerID: MCPeerID!
    
    //相手のデバイスを探す際に必要
    let serviceType = "LCOC-Chat"//??
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //自分のデバイス情報の設定
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        //接続可能な端末を探すためのブラウザを作成
        self.browser = MCBrowserViewController(serviceType:serviceType,session:self.session)
        self.browser.delegate = self
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,discoveryInfo:nil, session:self.session)
        self.assistant.start()
    }
    
    
    //タッチした時の位置を取得し、その点にテキストを配置する。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけても可能。
        var location = touch.location(in: self.view) //in: には対象となるビューを入れる。
        print("x座標：",location.x,",y座標：",location.y)//タッチした点の座標を表示。
        
        //アラートの設定
        let alert = UIAlertController(title: "テキストを入力してください", message: nil, preferredStyle: .alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) -> Void in
            
            
            /*#######################################*/
            //テキストラベルにアラート内で書いたラベルを挿入する。
            /*#######################################*/
            let textLabel = UILabel()
            textLabel.text = alert.textFields![0].text!
            textLabel.frame = CGRect(x:location.x,y:location.y,width:100,height:20)
            
            //相手にデータを送る
            //送信したいデータをNSData型に変更
            let dataText = textLabel.text?.data(using: String.Encoding.utf8,allowLossyConversion:false)
            let dataX = NSData(bytes: &location.x, length: MemoryLayout<NSInteger>.size)
            let dataY = NSData(bytes: &location.y, length: MemoryLayout<NSInteger>.size)
            print("送信：",dataText!,dataX,dataY)
            
            
            do {
                try self.session.send(dataText as! Data ,toPeers:self.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            } catch {
                print(error)
            }
            
            
            self.textLabelList.append(textLabel)
            
            for text in self.textLabelList{
                self.view.addSubview(text)
            }
            
            
            
        }))
        //キャンセルボタン
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in print("キャンセル")}))
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(addTitleField: UITextField!) -> Void in
            addTitleField.placeholder = "タイトルを入力してください。"//プレースホルダー
        })
        //その他アラートオプション
        alert.view.layer.cornerRadius = 25 //角丸にする。
        present(alert,animated: true,completion: {()->Void in print("アラート表示")})//completionは動作完了時に発動。
        
        
    }
    /*#######################################*/
    //招待するためのブラウザを表示
    /*#######################################*/
    @IBAction func showBrowser(_ sender: UIButton) {
        self.present(self.browser, animated: true, completion: nil)
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*#######################################*/
    //セッションに関するコード
    /*#######################################*/
    //データを受け取った時
    func session(_ session: MCSession,didReceive data: Data,fromPeer peerID: MCPeerID){
        DispatchQueue.main.async() {
            
            var dataText = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            print("受け取ったデータ：",dataText)
            self.writeText(text:dataText! as String,x:200,y:200)
        }
    }
    func session(_ session: MCSession,didStartReceivingResourceWithName resourceName: String,fromPeer peerID: MCPeerID,with progress: Progress){
    }
    func session(_ session: MCSession,didFinishReceivingResourceWithName resourceName: String,fromPeer peerID: MCPeerID,at localURL: URL?,withError error: Error?){}
    func session(_ session: MCSession,didReceive stream: InputStream,withName streamName: String,fromPeer peerID: MCPeerID){}
    func session(_ session: MCSession,peer peerID: MCPeerID,didChange state: MCSessionState){}

    /*#######################################*/
    //テキストと位置情報からラベルを表示させる関数
    /*#######################################*/
    func writeText(text:String,x:Int,y:Int){
        var getLabel = UILabel()
        getLabel.text = text
        getLabel.frame = CGRect(x:x,y:y,width:100,height:20)
        textLabelList.append(getLabel)
        for text in self.textLabelList{
            self.view.addSubview(text)
        }
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

