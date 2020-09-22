//
//  EventMapper.swift
//  TealiumFirebaseExample
//
//  Created by Christina S on 8/30/20.
//  Copyright © 2020 Christina. All rights reserved.
//

import Foundation

enum EventNames {
    
    static var lookup = [
        "user_login": "event_login",
        "user_register": "event_signup",
        "share": "event_share",
        "show_offers": "event_present_offer",
        "join_group": "event_join_group",
        "travel_order": "event_ecommerce_purchase",
        "earn_currency": "event_earn_virtual_currency",
        "spend_currency": "event_spend_virtual_currency",
        "unlock_achievement": "event_unlock_achievement",
        "level_up": "event_level_up",
        "start_tutorial": "event_tutorial_begin",
        "stop_tutorial": "event_tutorial_complete",
        "record_score": "event_post_score",
        "category": "event_view_item_list",
        "product": "event_view_item",
        "cart_add": "event_add_to_cart",
        "wishlist_add": "event_add_to_wishlist",
        "checkout": "event_begin_checkout",
        "checkout_progress": "event_checkout_progress",
        "email_signup": "event_generate_lead",
        "order": "event_ecommerce_purchase",
    ]
}
