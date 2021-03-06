//
//  CollectionsViewController.swift
//  ReciFoto
//
//  Created by Colin Taylor on 2/15/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import UIKit
class CollectionsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var feedList: [Recipe] = []
    fileprivate let kCellIdentifier = "CollectionCell"
    
    fileprivate var scrolling = false
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.title = "My Collection"
        let titleButton =  UIButton(type: .custom)
        titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleButton.backgroundColor = UIColor.clear
        titleButton.setTitle("My Collection", for: .normal)
        titleButton.addTarget(self, action: #selector(self.clickOnTitleButton), for: .touchUpInside)
        self.navigationItem.titleView = titleButton
        
        self.collectionView?.es_addPullToRefresh {
            self.refreshFeed()
        }
        self.collectionView?.es_startPullToRefresh()
        self.collectionView?.es_addInfiniteScrolling {
            self.loadMore()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func clickOnTitleButton(titleButton: UIButton) {
        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                          at: .top,
                                          animated: true)
    }
    private func refreshFeed() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.feedList.removeAll()
            self.currentIndex = 0
            self.collectionAPIByIndex(index: self.currentIndex, didFinishedWithResult: { count in
                if count > 0 {
                    self.collectionView?.reloadData()
                }else{
                    
                }
                self.collectionView?.es_stopPullToRefresh()
            })
        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.currentIndex < 100{
                self.currentIndex += 10
                self.collectionAPIByIndex(index: self.currentIndex, didFinishedWithResult: { count in
                    if count > 0 {
                        self.collectionView?.reloadData()
                    }else{
                        
                    }
                })
                self.collectionView?.es_stopLoadingMore()
            }else{
                self.collectionView?.es_noticeNoMoreData()
            }
        }
    }
    func collectionAPIByIndex(index: Int, didFinishedWithResult: @escaping(Int) -> Void) -> Void{
        let apiRequest = request(String(format:"%@%@",Constants.API_URL_DEVELOPMENT,Constants.getCollectionByIndex),
                                 method: .post, parameters: [Constants.USER_ID_KEY : Me.user.id,
                                                             Constants.USER_SESSION_KEY : Me.session_id,
                                                             Constants.INDEX_KEY : index])
        apiRequest.responseString(completionHandler: { response in
            do{
                print(response)
                let jsonResponse = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String : Any]
                let status = jsonResponse[Constants.STATUS_KEY] as! String
                print(jsonResponse)
                if status == "1"{
                    let result = jsonResponse[Constants.RESULT_KEY] as! [AnyObject]
                    if result.count > 0 {
                        for recipe in result {
                            self.feedList.append(Recipe(dict: recipe as! NSDictionary))
                        }
                        
                    }else{
                        //                        self.lblNoRecipePost.isHidden = false
                    }
                    didFinishedWithResult(result.count)
                }else {
                    didFinishedWithResult(0)
                    let alertController = UIAlertController(title: "ReciFoto", message: jsonResponse["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    appDelegate.setHasLoginInfo(status: false)
                    appDelegate.saveToUserDefaults()
                    
                    appDelegate.changeRootViewController(with: "loginNavigationVC")
                }
            }catch{
                didFinishedWithResult(0)
                print("Error Parsing JSON from get_collection_by_index")
            }
            
        })
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath)
        
        if let cell = cell as? CollectionCell {
        
            let item = self.feedList[indexPath.row]
            cell.imageView.af_setImage(withURL: URL(string: item.imageURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (self.collectionView?.frame.size.width)!, height: (self.collectionView?.frame.size.width)!)
        return size
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = self.feedList[indexPath.row] 
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recipeVC") as? RecipeViewController {
            if let navigator = navigationController {
                viewController.recipe = recipe
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrolling = true
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrolling = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            if !self.scrolling {
                
            }
        })
    }
}
