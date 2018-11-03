//
//  RequestPath.swift
//  CarForIos
//
//  Created by chilunyc on 2018/7/11.
//  Copyright © 2018 chilunyc. All rights reserved.
//

import Foundation

// API 地址 http://carcms.pages.git.chilunyc.com/CarForBack/user/unbind.html

// 模式每页请求数量
let DefaultPageSize = 10

let BaseURLStr     = "https://www.huifenghuawen.com/gateway.do"


// MARK: - HOME -
let URL_Slideshow = "notice.slideshow"

let URL_ArticleList = "article.list"

let URL_ArticleDetail = "article.detail"

let URL_ArticleFav = "article.fav"

///我的收藏
let URL_MyFav = "my.fav"

/**
 * 点赞
 *
 * article_id    文章ID
 * comment_id    要对评论进行评论的标识ID
 * op            进行的操作：0 - 撤消点赞；1 - 点赞
 */
let URL_ArticleLike = "article.like"


/**
 * 评论
 *
 * article_id    文章ID
 * comment_id    要对评论进行评论的标识ID
 * content       评论内容
 */
let URL_ArticleComment = "article.comment"


/**
 * 评论列表
 *
 * article_id    文章ID
 * page_index    页数，从1开始
 * page_size     每页记录数
 */
let URL_ArticleCommentList = "article.comment_list"


/**
 * 我的通知
 *
 * page_index    页数，从1开始
 * page_size     每页记录数
 */
let URL_MyNotify = "my.notify"


/**
 * 福袋收取积分
 *
 * type          积分来源
 */
let URL_PointsTake = "points.take"


/**
 * 解绑第三方账号
 *
 * type          第三方类型
 */
let URL_Unbind = "user.unbind"


/**
 * 绑定第三方账号
 *
 * client_type    String    是    设备类型
 * type    String    是    第三方账号类型
 * code    String    否    第三方系统授权通过以后返回的 code
 * access_token    String    否    第三方系统授权通过以后，根据 code 换取的 access_token，和 code 二选一
 * uid    String    否    第三方系统授权用户id（微信传 openid/微博传 uid）
 */
let URL_UserBind = "user.bind"

/**
 * 上传文件地址
 * 该 URL 为绝对路径
 *
 * type    String    是    第三方登录
 * {filename}    {String}    是     文件名称
 */
let URL_FileUpload = "https://www.huifenghuawen.com/c/file_upload"


/**
 * 验证短信验证码
 *
 * type    String    是    验证码类型
 * mobile    String    是    手机号码
 * sms_code    String    是    短信验证码
 */
let URL_MsgVerify = "sms.verify"





//MARK: - Mine -
let URL_Login = "user.login"

/// 用户信息 登录后也获取到
let URL_UserInfo = "user.info"

let URL_Logout = "user.logout"

let URL_SmsCode = "sms.code"

let URL_AboutUs = "my.about_us"

let URL_AppInfo = "app.info"

/// 修改用户名字\ 修改用户头像
let URL_Update = "user.update"
/// 改绑mobile
let URL_ChangeMobile = "user.change_mobile"



