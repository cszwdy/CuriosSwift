//
//  IPage.swift
//  CuriosSwift
//
//  Created by Emiaostein on 5/15/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import Foundation

protocol IPageProtocol: NSObjectProtocol {
  
  
  func pageDidSelected(page: PageModel, selectedContainer container: ContainerModel, onView: UIView ,onViewCenter: CGPoint, size: CGSize, angle: CGFloat)
  func pageDidDeSelected(page: PageModel, deselectedContainer container: ContainerModel)
  func pageDidDoubleSelected(page: PageModel, doubleSelectedContainer container: ContainerModel)
  func pageDidEndEdit(page: PageModel)
  
  
    
    func pageDidSelected(page: IPage, selectedContainer: IContainer, position: CGPoint, size: CGSize, rotation: CGFloat, ratio: CGFloat, inTargetView: UIView)
    func pageDidDeSelected(page: IPage, deSelectedContainers: [IContainer])
    func shouldMultiSelection() -> Bool
    func didEndEdit(page: IPage)
}

protocol IPage: NSObjectProtocol {
  
  func begainResponseToTap(onScreenPoint: CGPoint, tapCount: Int)
    
    func setDelegate(aDelegate: IPageProtocol)
    func cancelDelegate()
    
    func setNeedUpload(needUpload: Bool)
    func saveInfo()
    func uploadInfo(userID: String, publishID: String)
    func exchangeContainerFromIndex(fromIndex: Int, toIndex: Int)
}
