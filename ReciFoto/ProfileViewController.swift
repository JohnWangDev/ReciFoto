//
//  ProfileViewController.swift
//  ReciFoto
//
//  Created by Colin Taylor on 1/20/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var feedList: [Recipe] = []
    var currentIndex = 0
    var settingButton : UIBarButtonItem?//()
    var followButton : UIBarButtonItem?
    var user = Me.user
    
    fileprivate let kCellIdentifier = "pCollectionCell"
    fileprivate var scrolling = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblRecipes: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "My Profile"
        if user.id == Me.user.id {
            var settingImage = UIImage(named: "gear")
            settingImage = settingImage?.withRenderingMode(.alwaysOriginal)
            settingButton = UIBarButtonItem(image: settingImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileViewController.settingAction))
            self.navigationItem.rightBarButtonItem = settingButton
        }else{
            followButton = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(ProfileViewController.followAction))
            self.navigationItem.rightBarButtonItem = followButton
        }
        loadFromServer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.reloadData()
    }
    func settingAction(){
        self.performSegue(withIdentifier: "showSettings", sender: self)
    }
    func followAction(){
        
    }
    @IBAction func editAction(_ sender: Any) {
        if user.id == Me.user.id {
            if let navigator = navigationController {
                
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigator.pushViewController(EditProfileViewController(), animated: true)
            }
        }
    }
    func loadFromServer(){
        if profileAPIByIndex(index: currentIndex) == 1{
            
        }else{
            
        }
    }
    func profileAPIByIndex(index: Int) -> Int{
        let apiRequest = request(String(format:"%@%@",Constants.API_URL_DEVELOPMENT,Constants.getProfileV2),
                                 method: .post, parameters: [Constants.USER_ID_KEY : Me.user.id,
                                                             Constants.USER_SESSION_KEY : Me.session_id,
                                                             Constants.TOUSERID_KEY : user.id,
                                                             Constants.INDEX_KEY : index])
        
        apiRequest.responseString(completionHandler: { response in
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String : Any]

                let status = jsonResponse[Constants.STATUS_KEY] as! String
                
                if status == "1"{
                    let result = jsonResponse[Constants.RECIPE_KEY] as! [AnyObject]
                    let profile = jsonResponse[Constants.PROFILE_KEY] as! [String : AnyObject]
                    if let profile_picture = profile[Constants.PICTURE_KEY] as? String {
                        if profile_picture.characters.count > 0 {
                            self.btnAvatar.af_setBackgroundImage(for: UIControlState.normal, url: URL(string: profile_picture)!)
                            self.btnAvatar.layer.cornerRadius = 40
                            self.btnAvatar.clipsToBounds = true
                        }
                    }
                    self.lblUsername.text = self.user.userName
                    let follower = jsonResponse[Constants.FOLLOWER_KEY] as! String
                    let following = jsonResponse[Constants.FOLLOWING_KEY] as! String
                    let recipe_count = jsonResponse[Constants.RECIPE_COUNT_KEY] as! String
                    
                    self.lblRecipes.text = recipe_count
                    self.lblFollowers.text = follower
                    self.lblFollowing.text = following
                    
                    if result.count > 0 {
                        for recipe in result {
                            self.feedList.append(Recipe(dict: recipe as! NSDictionary))
                        }
                        self.collectionView.reloadData()
                    }else{
                        //                        self.lblNoRecipePost.isHidden = false
                    }
                }else {
                    let alertController = UIAlertController(title: "ReciFoto", message: jsonResponse["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }catch{
                print("Error Parsing JSON from get_profile")
            }
            
        })
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath)
        
        if let cell = cell as? CollectionCell {
            
            let item = self.feedList[indexPath.row]
            cell.imageView.af_setImage(withURL: URL(string: item.imageURL)!)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = self.feedList[indexPath.row]
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recipeVC") as? RecipeViewController {
            if let navigator = navigationController {
                viewController.recipe = recipe
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrolling = true
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrolling = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            if !self.scrolling {
                
            }
        })
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
