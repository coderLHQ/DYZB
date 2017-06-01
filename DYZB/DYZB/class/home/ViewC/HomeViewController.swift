//
//  HomeViewController.swift
//  DYZB
//
//  Created by lhq on 2017/5/17.
//  Copyright © 2017年 LhqHelianthus. All rights reserved.
//

import UIKit

private let KTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {
    //懒加载属性
    fileprivate lazy var pageTitleView: PageTitleView={[weak self] in
        let titleFrame = CGRect (x: 0, y: kStatuBarH+kNavigationBarH, width: kScreenW, height: KTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView (frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()

    fileprivate lazy var pageContentView : PageContentView = {[weak self] in
        
        //1.设置内容frame
        let contentH = kScreenH-kNavigationBarH-kStatuBarH-KTitleViewH
        let contentFrame = CGRect (x: 0, y: kNavigationBarH+kStatuBarH+KTitleViewH, width: kScreenW, height: contentH)
        
        //2.确定所有的子控制器
        var childVCs=[UIViewController]()
        
               for _ in 0..<4 {
            let vc = UIViewController()
                   vc.view.backgroundColor = UIColor (r: CGFloat(arc4random_uniform(100)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)), a: 1)
                   childVCs.append(vc)
                }
        
        
        let contentView = PageContentView (frame: contentFrame, childVcs: childVCs, parentViewController: self)
        
        contentView.delegate=self
        return contentView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
      //设置UI界面
        setupUI()
        // Do any additional setup after loading the view.
    }
}
    //设置UI界面
extension HomeViewController{
    
    fileprivate func setupUI(){
        
        //0.不需要调整scrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        //1.设置导航栏
        setupNavigationBar()
        //2.添加titleView
        view.addSubview(pageTitleView)
        //3.添加contentView
        pageContentView.backgroundColor=UIColor.orange
        view.addSubview(pageContentView)
        
    }
    
    fileprivate func setupNavigationBar(){
        //设置左侧item
        let btn = UIButton()
        btn.setImage(UIImage (named: "logo"), for: .normal)
        btn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem (customView: btn)
        //2.设置右侧的Items
        
        let histpryBtn = UIButton()
        histpryBtn.setImage(UIImage (named: "image_my_history"), for: UIControlState.normal)
        histpryBtn.setImage(UIImage (named: "image_my_history_click"), for: UIControlState.highlighted)
        histpryBtn.sizeToFit()
        let historyItem = UIBarButtonItem (customView: histpryBtn)
        let searchBtn = UIButton()
        searchBtn.setImage(UIImage (named: "btn_search"), for: UIControlState.normal)
        searchBtn.setImage(UIImage (named: "btn_search_clicked"), for: UIControlState.highlighted)
        searchBtn.sizeToFit()
        let searchItem  = UIBarButtonItem (customView: searchBtn)
        let qrcondeBtn = UIButton()
        qrcondeBtn.setImage(UIImage (named: "Image_scan"), for: UIControlState.normal)
        qrcondeBtn.setImage(UIImage (named: "Image_scan_click"), for: UIControlState.highlighted)
        qrcondeBtn.sizeToFit()
        let qrcondeImem = UIBarButtonItem (customView: qrcondeBtn)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcondeImem]

    }
        
    }

//
extension HomeViewController : PageTitleViewDelegate{
    
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

//遵守pagecontentViewdelegate
extension HomeViewController : PageContentViewDelegate{
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        pageTitleView.setPageTitleWithPrgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}








