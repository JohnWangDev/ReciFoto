//
//  Constants.swift
//  ReciFoto
//
//  Created by Colin Taylor on 1/26/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//
import UIKit
struct Constants{
    static let colors = [
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 20       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 40       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 60       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 80       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 100       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 120       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 140       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 160       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 180       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 200       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 220       / 255.0,     alpha: 1.0),
        UIColor(red: 140     / 255.0,    green: 198      / 255.0,     blue: 240       / 255.0,     alpha: 1.0),
        ]
    //API Level
//    static let API_URL_DEVELOPMENT = "http://192.168.1.136/recifoto/index.php/api/"
    static let API_URL_DEVELOPMENT = "http://www.recifoto.com/api/"
    static let registerURL = "register_user"
    static let registerURLV2 = "register_user_v2"
    static let loginSocial = "login_user_social"
    static let loginURL = "login_user"
    static let loginURLV2 = "login_user_v2"
    static let getFeedByIndex = "get_feed_by_index"
    static let getUserRecipesV2 = "get_user_recipesV2"
    static let getProfileV2 = "get_profileV2"
    static let getTrendsV2 = "get_trendsV2"
    static let upload_recipeV2 = "upload_recipeV2"
    static let recipeSearchV2 = "recipe_searchV2"
    static let recipeLikeV2 = "recipe_likeV2"
    static let reportInappropriate = "report_inappropriate"
    static let deleteRecipe = "delete_recipeV2"
    static let saveCollection = "save_collection"
    static let getCommentsByIndexV2 = "getCommentsByIndexV2"
    static let addComment = "addComment"
    static let updateComment = "updateComment"
    static let getCollectionByIndex = "get_collection_by_index"
    static let updateProfileV2 = "update_profileV2"
    static let updateProfileWithPhotoV2 = "update_profileWithPhotoV2"
    static let followTo = "followTo"
    static let unfollowTo = "unfollowTo"
    static let getFollowings = "get_followings"
    static let getFollowers = "get_followers"
    
    //Static Keys
    static let USER_EMAIL_KEY = "user_email"
    static let PLATFORM_KEY = "platform"
    static let EMAIL_KEY = "email"
    static let USER_ID_KEY = "user_id"
    static let ID_KEY = "id"
    static let USER_PASSWORD_KEY = "user_password"
    static let USER_SESSION_KEY = "session_id"
    static let COMMENT_ID_KEY = "comment_id"
    static let USER_NAME_KEY = "username"
    static let SCREEN_NAME_KEY = "screen_name"
    static let USER_BIO_KEY = "user_bio"
    static let PROFILE_BIO_KEY = "profile_bio"
    static let BIO_KEY = "bio"
    static let USER_PICTURE_KEY = "user_picture"
    static let HAS_LOGIN_KEY = "has_login"
    static let LAUNCHED_BEFORE_KEY = "launched_before"
    static let RECIPE_ID_KEY = "recipe_id"
    static let CONTACT_PHONE_KEY = "contact_phone"
    static let PHONE_KEY = "phone"
    static let PHONE_NUM_KEY = "phone_num"
    static let HAVE_CONTACT_KEY = "have_contact"
    static let PROFILE_PICTURE_KEY = "profile_picture"
    static let PICTURE_KEY = "picture"
    static let RECIPE_IMAGE_KEY = "recipe_image"
    static let RECIPE_TITLE_KEY = "recipe_title"
    static let RECIPE_WEBSITE_KEY = "recipe_website"
    static let TIME_ELAPSED_KEY = "time_elapsed"
    static let COMMENT_COUNT_KEY = "comment_count"
    static let COMMENTS_KEY = "comments"
    static let IS_COMMENT_PRIVATE = "is_comment_private"
    static let LIKES_COUNT_KEY = "likes_count"
    static let RECIPE_KEY = "recipe"
    static let STATUS_KEY = "status"
    static let MESSAGE_KEY = "message"
    static let RESULT_KEY = "result"
    static let PROFILE_KEY = "profile"
    static let PROFILE_PIC_KEY = "profile_pic"
    static let FOLLOWER_KEY = "follower"
    static let RECIPE_COUNT_KEY = "recipe_count"
    static let FOLLOWING_KEY = "following"
    static let IS_FOLLOW_KEY = "is_follow"
    static let CONTACT_WEBSITE_KEY = "contact_website"
    static let INDEX_KEY = "index"
    static let SEARCH_KEY = "search_key"
    static let TOUSERID_KEY = "toUserId"
    static let USER_KEY = "user"
    static let USER_FULL_NAME_KEY = "full_name"
    static let USER_BIRTHDAY_KEY = "birthday"
// IAP Keys
    
    
// Notification Names
    static let NOTIFICATION_PURCHASE_PRODUCT = "purchase_product"

}
