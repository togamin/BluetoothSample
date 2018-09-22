//
//  ViewController.swift
//  BluetoothSample
//
//  Created by Togami Yuki on 2018/09/22.
//  Copyright © 2018 Togami Yuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //タッチした時の位置を取得する。
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //このタッチイベントの場合確実に1つ以上タッチ点があるので`!`つけても可能。
        let location = touch.location(in: self.view) //in: には対象となるビューを入れる。
        print("x座標：",location.x,",y座標：",location.y)//タッチした点の座標を表示。
        
        
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

