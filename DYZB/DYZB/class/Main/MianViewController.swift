//
//  MianViewController.swift
//  DYZB
//
//  Created by lhq on 2017/5/17.
//  Copyright © 2017年 LhqHelianthus. All rights reserved.
//

import UIKit

class MianViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVc(storeName: "Home")
        addChildVc(storeName: "Live")
        addChildVc(storeName: "Floow")
        addChildVc(storeName: "Me")
        // Do any additional setup after loading the view.
    }
    private func addChildVc(storeName:String){
        //1.通过storeboard获取控制器
        let childVc = UIStoryboard(name: storeName, bundle: nil).instantiateInitialViewController()!
        //2.讲childVc作为子控制器
        addChildViewController(childVc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
