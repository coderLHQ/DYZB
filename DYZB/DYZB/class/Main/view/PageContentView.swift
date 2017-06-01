//
//  PageContentView.swift
//  DYZB
//
//  Created by lhq on 2017/5/18.
//  Copyright © 2017年 LhqHelianthus. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: class {
    
    func pageContentView(contentView : PageContentView,progress : CGFloat,sourceIndex : Int,targetIndex : Int)
}
private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    //自定义属性
    fileprivate var childVcs : [UIViewController]
    fileprivate weak var parentViewController:UIViewController?
    fileprivate var startConteOffectX:CGFloat = 0
    fileprivate var isForbidScrollDelegate : Bool = false
    weak var delegate:PageContentViewDelegate?
    //懒加载
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //创建UIcollectionView
        let collectionView = UICollectionView (frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate=self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:ContentCellID )
        
        return collectionView
        
    }()
    //自定义构造函数
    init(frame: CGRect,childVcs : [UIViewController],parentViewController:UIViewController?) {
        
        self.childVcs=childVcs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        //设置UI
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//设置UI界面
extension PageContentView{
    
    fileprivate func setupUI(){
        //1.将自控制器添加到父控制器
        for childVC in childVcs{
            
            parentViewController?.addChildViewController(childVC)
        }
         //2.添加UicollectionView。用于存放控制器中的view
        addSubview(collectionView)
        collectionView.frame=bounds
    }
   
    
}
//UIcollectionViewDataSource  代理方法
extension PageContentView:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        //2.设置cell的内容
        // 防止循环利用
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVC = childVcs[indexPath.item]
        childVC.view.frame=cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        return cell
    }
    
}
//UIcollectionDelegate 代理方法
extension PageContentView:UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate=false
         startConteOffectX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0.判断是否点击事件
        if isForbidScrollDelegate{return}
      //1.定义重要数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
      //2.判断是左滑动还是右边滑动
        let currentOffectX = scrollView.contentOffset.x
        
      let scrollViewW = scrollView.bounds.width
        if currentOffectX>startConteOffectX {//左划
           //1.计算progress
             progress = currentOffectX/scrollViewW - floor(currentOffectX/scrollViewW)
            //2.计算sourceIndex
            sourceIndex = Int(currentOffectX/scrollViewW)
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVcs.count {
                
                targetIndex = childVcs.count - 1
            }
            //4.如果完全划过去了
            if currentOffectX - startConteOffectX == scrollViewW{
           
                progress = 1
                targetIndex = sourceIndex
            }
        } else {//右滑动
            //1.计算progress
             progress = 1-(currentOffectX/scrollViewW - floor(currentOffectX/scrollViewW ))
            //2.计算targetIndex
           targetIndex = Int(currentOffectX/scrollViewW)
            //3.计算sourceIndex
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childVcs.count {
                
                sourceIndex=childVcs.count-1
            }
        }
        
        //3.将数据传递给titleView
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
//对外暴露的方法

extension PageContentView {
    
    func setCurrentIndex( currentIndex : Int) {
        
        //
        isForbidScrollDelegate=true
       
        let offsetX = CGFloat(currentIndex)*collectionView.frame.width
        collectionView.setContentOffset(CGPoint (x: offsetX, y: 0), animated: false)
    }
}





