//
//  PageTitleView.swift
//  DYZB
//
//  Created by lhq on 2017/5/18.
//  Copyright © 2017年 LhqHelianthus. All rights reserved.
//

import UIKit

//定一个协议
protocol PageTitleViewDelegate : class {
    
    func pageTitleView(titleView : PageTitleView,selectedIndex index: Int)
}
//定义常亮

private let KscrollLineH : CGFloat = 2
private let KNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let KSlectColor  : (CGFloat,CGFloat,CGFloat) = (255,128,0)

class PageTitleView: UIView {

    //定义属性
    fileprivate var titles : [String]
    fileprivate var currentIndex : Int = 0
    
    weak var delegate : PageTitleViewDelegate?
    //懒加载哦
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        
        return scrollView
    }()
    fileprivate lazy var scrollLine : UIView = {
       
        let scrollLine = UIView()
        scrollLine.backgroundColor=UIColor (r: KSlectColor.0, g: KSlectColor.1, b: KSlectColor.2, a: 1)
        return scrollLine
    }()
  //自定义构造函数
    init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        
        //设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//设置-UI界面
extension PageTitleView {
    fileprivate func setupUI(){
        //1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        //2.添加对应的Label
        setupTitleLabels()
        //3.底线和滚动滑块
        setupBottomMenuAndScrollLine()
    }
    
    private func setupTitleLabels() {
        
        //0.确定一些fame的值

        let labelW: CGFloat = frame.width/CGFloat(titles.count)
        let labelH: CGFloat = frame.height-KscrollLineH
        let labelY: CGFloat = 0
        for (index, title) in titles.enumerated(){
        //1.创建UIlabel
        let label = UILabel()
        //2.设置label属性
            label.text = title
            label.tag  = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor (r: KNormalColor.0, g: KNormalColor.1, b: KNormalColor.2, a: 1)
            label.textAlignment = .center
         //3.设置label的frame
         
            let labelX: CGFloat = labelW*CGFloat(index)
         
            label.frame = CGRect (x: labelX, y: labelY, width: labelW, height: labelH)
         //4.讲label添加到scrollView
            scrollView.addSubview(label)
         //5.讲label添加到数组
            titleLabels.append(label)
        //给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer (target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
            
    }
        
    }
    
    private func setupBottomMenuAndScrollLine(){
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.frame = CGRect (x: 0, y: frame.height-KscrollLineH, width: frame.width, height: KscrollLineH)
        addSubview(bottomLine)
        //2.添加滚动的线
        //获取第一个label
        guard  let fristLabel = titleLabels.first else {return }
        fristLabel.textColor = UIColor(r: KSlectColor.0, g: KSlectColor.1, b: KSlectColor.2, a: 1)
        scrollLine.frame=CGRect (x: fristLabel.frame.origin.x, y: fristLabel.frame.height-KscrollLineH, width: fristLabel.frame.width, height: KscrollLineH)
        
        scrollView.addSubview(scrollLine)
    }
    
}
//label手势方法
extension PageTitleView{
    
    @objc fileprivate func titleLabelClick(tapGes:UITapGestureRecognizer){
        //1.获取label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        //2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        //3.切换文字颜色
        currentLabel.textColor = UIColor(r: KSlectColor.0, g: KSlectColor.1, b: KSlectColor.2, a: 1)
        oldLabel.textColor = UIColor (r: KNormalColor.0, g: KNormalColor.1, b: KNormalColor.2, a: 1)
        //保存下标
        currentIndex=currentLabel.tag
        //5.滚动条位置发生改变
        let scrollineIndex=CGFloat(currentLabel.tag)*scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            
            self.scrollLine.frame.origin.x=scrollineIndex
        }
        
        //6.通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//对外暴露的方法
extension PageTitleView{
    
    func setPageTitleWithPrgress(progress : CGFloat,sourceIndex :Int,targetIndex : Int) {
        //1.取出sourceIndexLabel和targetlabel
        let soucrceLabel = titleLabels[sourceIndex]
        let targetLabel =  titleLabels[targetIndex]
        //2.处理滑块逻辑
        let moveToX = targetLabel.frame.origin.x - soucrceLabel.frame.origin.x
        let moveX = moveToX*progress
        
        scrollLine.frame.origin.x=soucrceLabel.frame.origin.x+moveX
        //3.颜色的渐变
        //3.1取出变化范围
        let colorDelta = (KSlectColor.0-KNormalColor.0,KSlectColor.1-KNormalColor.1,KSlectColor.2-KNormalColor.2)
        //3.2变化sourceIndexLabel
        soucrceLabel.textColor=UIColor (r: KSlectColor.0-colorDelta.0*progress, g: KSlectColor.1-colorDelta.1*progress, b: KSlectColor.1-colorDelta.1*progress, a: 1)
        //3.3变化targetLabel
        targetLabel.textColor=UIColor (r: KNormalColor.0+colorDelta.0*progress, g:  KNormalColor.1+colorDelta.1*progress, b:  KNormalColor.1+colorDelta.1*progress, a: 1)
        // 4.记录最新的index
        currentIndex = targetIndex
    }
}




