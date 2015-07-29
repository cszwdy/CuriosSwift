//
//  LoginViewController.swift
//  Curios
//
//  Created by Emiaostein on 6/2/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, IRegisterDelegate{
  
  @IBOutlet weak var breathView: RippleView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    breathView.addBreathAnimation()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
  
  
  @IBAction func LoginAction(sender: UIButton) {
    
    let authOptions = ShareSDK.authOptionsWithAutoAuth(true, allowCallback: true, authViewStyle: SSAuthViewStyleFullScreenPopup, viewDelegate: nil, authManagerViewDelegate: nil);
    
    HUD.launch_Loading()
    ShareSDK.getUserInfoWithType(ShareTypeWeixiSession, authOptions: authOptions) { (result, userInfo, error) -> Void in
      //
      
      
      if result {
        let userId = userInfo.uid()
        let nickName = userInfo.nickname()
        let profileImage = userInfo.profileImage()
        
        
        var userModel = UserModel();
        userModel.nikename = nickName;
        userModel.iconURL = profileImage;
        userModel.weixin = userId;
        
        let userRequest = UserRequest();
        userRequest.setRegisterDelegate(self);
        userRequest.weixinRegister(userModel);
      }else{
        HUD.dismiss()
        let loginError = NSLocalizedString("CONNECT_IOERROR", comment: "")
        let alert = UIAlertView()
        alert.title = ""
        alert.message = loginError
        alert.addButtonWithTitle("Ok")
        alert.show()
      }
    }
  }
}

extension LoginViewController{
  func requestFailed(resultIndex:RegisterRequestEnum){
    var loginError = NSLocalizedString("LOGIN_ERROR", comment: "");
    switch(resultIndex){
    case .IOERROR:
      loginError = NSLocalizedString("CONNECT_IOERROR", comment: "");
    default:
      loginError = NSLocalizedString("LOGIN_ERROR", comment: "")
    }
    let alertTitle = ""
    let alert = UIAlertView()
    alert.title = alertTitle
    alert.message = loginError
    alert.addButtonWithTitle("Ok")
    alert.show()
  }
  
  func requestSuccess(userModel:UserModel, resultIndex:RegisterRequestEnum){
    saveUserInfo(userModel);
  }
  
  private func saveUserInfo(userInfo:UserModel){
    HUD.dismiss()
    LoginModel.shareInstance.login(userInfo)
  }
}
