//
//  EditToolPannel.swift
//  
//
//  Created by Emiaostein on 7/16/15.
//
//

import UIKit
import SnapKit

class EditToolPannel: UIView, EditToolBarSettingDelegate {

  var settingPannel: EditToolSettingPannel!

}

//MARK: - EditToolBarSettingDelgate 
extension EditToolPannel {
  
  // container - LayerIndex / Animation
  func editToolBar(toolBar: EditToolBar, didSelectedLevel containerModel: ContainerModel) {
    updateSettingPannelByKey("Level", aContainerModel: containerModel)
  }
  
  func editToolBar(toolBar: EditToolBar, didSelectedAnimation containerModel: ContainerModel) {
    updateSettingPannelByKey("Animation", aContainerModel: containerModel)
  }
  
  // text - FontName / Color / Alignment
  func editToolBar(toolBar: EditToolBar, didSelectedTextFont containerModel: ContainerModel) {
    updateSettingPannelByKey("TextFont", aContainerModel: containerModel)
  }
  func editToolBar(toolBar: EditToolBar, didSelectedTextColor containerModel: ContainerModel) {
    updateSettingPannelByKey("TextColor", aContainerModel: containerModel)
    
  }
  func editToolBar(toolBar: EditToolBar, didSelectedTextAlignment containerModel: ContainerModel) {
    updateSettingPannelByKey("TextAlignment", aContainerModel: containerModel)
  }
  
  // image - none
}

//MARK: - settingPannel
extension EditToolPannel {
  
  private func updateSettingPannelByKey(key: String, aContainerModel: ContainerModel) {
    
    if let apannel = settingPannel {
      apannel.removeConstraints(apannel.constraints())
      apannel.removeFromSuperview()
    }
    
    settingPannel = EditToolSettingPannelFactory.createSettingPannelwithKey(key, containerModel: aContainerModel)
    settingPannel.bounds = bounds
    
    addSubview(settingPannel)
    
  }
  
}


//MARK: - Constraints
extension EditToolPannel {
  
  override func updateConstraints() {
    
    if let aPannel = settingPannel {
      aPannel.snp_makeConstraints({ (make) -> Void in
        make.edges.equalTo(self)
      })
    }
    super.updateConstraints()
  }
}
