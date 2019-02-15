//
//  RequestType.swift
//  eLit
//
//  Created by Gianpaolo Di Pietro on 15/01/2019.
//  Copyright © 2019 Alberto Mario Bellini. All rights reserved.
//

import UIKit

enum RequestType: String {
    case FETCH_ALL = "fetch_all"
    case UPDATE_DB = "update_db"
    case USER_SIGN_IN = "user_sign_in"
    case FETCH_REVIEWS = "fetch_reviews"
    case FETCH_CATEGORIES = "fetch_categories"
    case RATING = "rating"
    case ADD_REVIEW = "add_review"
}
