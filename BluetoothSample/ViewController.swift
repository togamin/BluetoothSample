//
//  ViewController.swift
//  BluetoothSample
//
//  Created by Togami Yuki on 2018/09/22.
//  Copyright © 2018 Togami Yuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    var textLabelList = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //タッチした時の位置を取得し、その点にテキストを配置する。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけても可能。
        let location = touch.location(in: self.view) //in: には対象となるビューを入れる。
        print("x座標：",location.x,",y座標：",location.y)//タッチした点の座標を表示。
        
        //アラートの設定
        let alert = UIAlertController(title: "テキストを入力してください", message: nil, preferredStyle: .alert)
        //OKボタン
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) -> Void in
            
            
            /*#######################################*/
            //テキストラベルにアラート内で書いたラベルを挿入する。
            /*#######################################*/
            var textLabel = UILabel()
            textLabel.text = alert.textFields![0].text!
            textLabel.frame = CGRect(x:location.x,y:location.y,width:100,height:20)
            
            self.textLabelList.append(textLabel)
            print("textLabelList:",self.textLabelList)
            print("textLabelListCount:",self.textLabelList.count)
            
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
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

