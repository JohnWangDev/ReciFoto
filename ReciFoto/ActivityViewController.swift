//
//  ActivityViewController.swift
//  ReciFoto
//
//  Created by Colin Taylor on 1/20/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import UIKit

class ActivityViewController: UITableViewController {
    var feedList: [Recipe] = []
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationItem.title = "My Recipes"
        let titleButton =  UIButton(type: .custom)
        titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleButton.backgroundColor = UIColor.clear
        titleButton.setTitle("My Recipes", for: .normal)
        titleButton.addTarget(self, action: #selector(self.clickOnTitleButton), for: .touchUpInside)
        self.navigationItem.titleView = titleButton
        
        let settingButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(ActivityViewController.collectionAction))
        self.navigationItem.rightBarButtonItem = settingButton
        
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        self.tableView.es_addPullToRefresh(animator: header) { [weak self] in
            self?.refreshActivity()
        }
        self.tableView.es_addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.tableView.estimatedRowHeight = 500.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.refreshIdentifier = String.init(describing: "default")
        self.tableView.expriedTimeInterval = 20.0
        
        self.tableView.es_startPullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func clickOnTitleButton(titleButton: UIButton) {
        self.tableView.es_startPullToRefresh()
    }
    func collectionAction(){
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myCollectionVC") as? CollectionsViewController {
            if let navigator = navigationController {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    private func refreshActivity() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.feedList.removeAll()
            self.currentIndex = 0
            self.feedAPIByIndex(index: self.currentIndex, didFinishedWithResult: { count in
                if count > 0 {
                    self.tableView.reloadData()
                }else{
                    
                }
                self.tableView.es_stopPullToRefresh()
            })
        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.currentIndex < 100{
                self.currentIndex += 10
                self.feedAPIByIndex(index: self.currentIndex, didFinishedWithResult: { count in
                    if count > 0 {
                        self.tableView.reloadData()
                    }else{
                        
                    }
                })
                self.tableView.es_stopLoadingMore()
            }else{
                self.tableView.es_noticeNoMoreData()
            }
        }
    }
    func feedAPIByIndex(index: Int, didFinishedWithResult: @escaping(Int) -> Void) -> Void{
        let apiRequest = request(String(format:"%@%@",Constants.API_URL_DEVELOPMENT,Constants.getUserRecipesV2),
                                 method: .post, parameters: [Constants.USER_ID_KEY : Me.user.id,
                                                             Constants.USER_SESSION_KEY : Me.session_id,
                                                             Constants.TOUSERID_KEY: Me.user.id,
                                                             Constants.INDEX_KEY : index])
        
        apiRequest.responseString(completionHandler: { response in
            do{
                print(response)
                let jsonResponse = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String : Any]
                let status = jsonResponse[Constants.STATUS_KEY] as! String
                
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
                }
            }catch{
                 didFinishedWithResult(0)
                print("Error Parsing JSON from get_feed_by_index")
            }
            
        })
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.feedList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DGFeedCell = tableView.dequeueReusableCell(withIdentifier: "DGFeedCell", for: indexPath) as! DGFeedCell
        cell.delegate = self
        cell.loadData(self.feedList[indexPath.row])
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
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
extension ActivityViewController : DGFeedCellDelegate{

    func didLikeWithItem(item: Recipe) {
        NetworkManger.sharedInstance.likeAPI(parameters: [Constants.USER_ID_KEY : Me.user.id,
                                                          Constants.USER_SESSION_KEY : Me.session_id,
                                                          Constants.RECIPE_ID_KEY : item.identifier]) { (jsonResponse, status) in
            
        }
    }
    func saveCollection(item: Recipe){
        NetworkManger.sharedInstance.saveCollectionAPI(parameters: [Constants.USER_ID_KEY : Me.user.id,
                                                                    Constants.USER_SESSION_KEY : Me.session_id,
                                                                    Constants.RECIPE_ID_KEY : item.identifier]) { (jsonResponse, status) in
                                                                        
        }
    }

    func didMoreWithItem(item: Recipe, sender : UIButton) {
        let actionSheetController = UIAlertController(title: "ReciFoto", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Save to Collection", style: .default) { action -> Void in
            print("Save")
            self.saveCollection(item: item)
//            let product = RecifotoProducts.products[0]
//            
//            if RecifotoProducts.store.isProductPurchased(product.productIdentifier){
//                self.saveCollection(item: item)
//            }else{
//                RecifotoProducts.boughtRecipe = item
//                RecifotoProducts.store.buyProduct(product)
//            }
        }
        actionSheetController.addAction(saveActionButton)
        
        let reportActionButton = UIAlertAction(title: "Flag as Inappropriate", style: .default) { action -> Void in
            print("Flag as Inappropriate")
            NetworkManger.sharedInstance.reportRecipeAPI(parameters: [Constants.USER_ID_KEY : Me.user.id,
                                                                      Constants.USER_SESSION_KEY : Me.session_id,
                                                                      Constants.RECIPE_ID_KEY : item.identifier], completionHandler: { (jsonResponse, status) in
                                                                        
            })
        }

        actionSheetController.addAction(reportActionButton)
        let deleteActionButton = UIAlertAction(title: "Delete Recipe", style: .default) { action -> Void in
            print("Delete Recipe")
            NetworkManger.sharedInstance.deleteRecipeAPI(parameters: [Constants.USER_ID_KEY : Me.user.id,
                                                                      Constants.USER_SESSION_KEY : Me.session_id,
                                                                      Constants.RECIPE_ID_KEY : item.identifier], completionHandler: { (jsonResponse, status) in
                if status == "1"{
                    let index = self.getIndexFromItem(item: item)
                    if index != -1{
                        self.feedList.remove(at: index)
                        self.tableView.reloadData()
                    }
                }
            })
        }
        
        actionSheetController.addAction(deleteActionButton)
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(actionSheetController, animated: true, completion: nil)
        }else{
            actionSheetController.modalPresentationStyle = .popover
            let popOver: UIPopoverPresentationController = actionSheetController.popoverPresentationController!
            popOver.sourceView = sender
            popOver.sourceRect = sender.bounds
            popOver.permittedArrowDirections = .down
            self.present(actionSheetController, animated: true, completion: {
                
            })
        }
        
    }
    func getIndexFromItem(item: Recipe)->Int{
        for (index, name) in self.feedList.enumerated() {
            if name.identifier == item.identifier{
                return index
            }
        }
        return -1
    }
    func didCommentWithItem(item: Recipe) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "commentsVC") as? CommentsViewController {
            if let navigator = navigationController {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    func didProfileWithItem(item: Recipe) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileVC") as? ProfileViewController {
            if let navigator = navigationController {
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    func didDetailWithItem(item: Recipe) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recipeVC") as? RecipeViewController {
            if let navigator = navigationController {
                viewController.recipe = item
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    func didLinkClickedWithItem(item: Recipe, url: URL, sender : UIView) {
        let actionSheetController = UIAlertController(title: "ReciFoto", message: "Choose your action", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let openActionButton = UIAlertAction(title: "Open Website", style: .default) { action -> Void in
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                
            })
        }
        actionSheetController.addAction(openActionButton)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(actionSheetController, animated: true, completion: nil)
        }else{
            actionSheetController.modalPresentationStyle = .popover
            let popOver: UIPopoverPresentationController = actionSheetController.popoverPresentationController!
            popOver.sourceView = sender
            popOver.sourceRect = sender.bounds
            popOver.permittedArrowDirections = .up
            self.present(actionSheetController, animated: true, completion: {
                
            })
        }
    }
}
