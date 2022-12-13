//
// EndPoints.swift
// CINET//  Ribbit
//
// Created by Ahsan Ali on 31/03/2021.
//

import Foundation

struct EndPoint {
    static let kServerBase = "http://127.0.0.1:8080/"
    static let signup = "signup"
    static let login = "login"
    static let otp = "verification/"
    static let forgotPassword = "forgot-password"
    static let changePassword = "recover-password"
    static let updateProfile = "v1/profile"
    static let updateAvatar = "v1/profile/avatar"
    static let countries = "v1/countries"
    static let states = "v1/countries/country_code/states"
    static let cities = "v1/countries/country_code/states/state_code/cities"
    static let magic = "magic"
    static let createLinkToken = "v1/plaid/create_link_token"
    static let setAccessToken = "v1/plaid/set_access_token"
    static let recipientBanks = "v1/plaid/recipient_banks"
    static let detachBank = "v1/plaid/recipient_banks/bank_id"
    static let Sign = "v1/account/sign"
    static let transfer = "v1/transfer"
    static let deposit = "v1/transfer/bank/bank_id/deposit"
    static let stats = "v1/account/stats"
    static let shareableLink = "v1/profile/shareable-link"
    static let Assests = "v1/assets"
    static let watchList = "v1/watchlist"
    static let referel = "referral_code/verify/refCode"
    static let positions = "v1/positions"
    static let Order = "v1/orders"
    static let FavouriteAsset = "v1/watchlist"
    static let unFavoutite = "v1/watchlist/{symbol}"
    static let Bars = "v1/market/stocks/{symbol}/bars"
    static let TradingView = "v1/account/trading-profile"
    static let ordrHistory = "v1/account/portfolio/history"
    static let termsCondition = kServerBase + "template/terms_conditions.html"
    static let orgIcon = kServerBase + "file/"
    static let passwordPemKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhhTG+/piYXiz6yWYtFG9nJYymDbuMMu8UjiTT1dm4LzMa2B7K9SfnxGORqED3dl6o/EgVy1z0X2AgsbW/H7GqchP6hpMbG9rLUBgkhL/E+YJK40oLgmDRU52mDa0xnCuWGiBZC982F+z0KPomIxzQ/xb9hWAOlpRDETgv6mXL+kUo2HIDjZDYSGerGmlFJ85Ig46kTBIzMvWV41n7u4D3nWtpYR8TplpH6q5//LrOVyyFOffXUde4u/OsuHoqaxdcixGemLMMVkW9z/mPTWE5mhEqzZULagxVh9vas2YzRKleT+g7gZKUedxBATz8qLjDnnWIeud9WKLBA1Mmv7DVwIDAQAB"
}
