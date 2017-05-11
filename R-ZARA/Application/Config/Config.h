//
//  Config.m
//  Silver


#define SERVER_URL @"http://malumapp.com/malum"

#define API_KEY @"123456789"

#define API_URL (SERVER_URL @"/api")
#define API_URL_USER_SIGNUP (SERVER_URL @"/api/user_signup")
#define API_URL_USER_LOGIN (SERVER_URL @"/api/user_login")
#define API_URL_USER_RETRIEVE_PASSWORD (SERVER_URL @"/api/user_retrieve_password")
#define API_URL_USER_LOGOUT (SERVER_URL @"/api/user_logout")
#define API_URL_PROFILE_UPDATE (SERVER_URL @"/api/profile_update")
#define API_URL_ALL_USERS (SERVER_URL @"/api/all_users")
#define API_URL_LIKE_USER (SERVER_URL @"/api/like_user")
#define API_URL_USER_FRIENDS (SERVER_URL @"/api/user_friends")
#define API_URL_POST_REWARD (SERVER_URL @"/api/post_reward")
#define API_URL_ALL_REWARDS (SERVER_URL @"/api/all_rewards")
#define API_URL_USER_REWARDS (SERVER_URL @"/api/user_rewards")
#define API_URL_USER_REWARD_REMOVE (SERVER_URL @"/api/user_reward_remove")
#define API_URL_USER_ADD_REWARDS (SERVER_URL @"/api/user_add_rewards")
#define API_URL_UPLOAD_RANK (SERVER_URL @"/api/upload_rank")
#define API_URL_MATCH_USERS (SERVER_URL @"/api/match_users")


#define API_URL_FAVORITE_BARKS (SERVER_URL @"/api/favorites")

#define API_URL_DISCOVERY_SETTINGS (SERVER_URL @"/api/discovery_settings")
#define API_URL_LOCATION_SETTINGS (SERVER_URL @"/api/location_settings")
#define API_URL_USER_SETTINGS_LOCATION_ID (SERVER_URL @"/api/user_settings_location_id")

// MEDIA CONFIG
#define MEDIA_USER_SELF_DOMAIN_PREFIX @"tt_media_user_"

#define MEDIA_URL (SERVER_URL @"/assets/media/")
#define MEDIA_URL_USERS (SERVER_URL @"/assets/media/users/")
#define MEDIA_URL_REWARDS (SERVER_URL @"/assets/media/reward/")

// Settings Config
#define USER_AGE_MIN 18
#define USER_AGE_MAX 80

// Explore Barks Default Config
#define EXPLORE_USERS_COUNT_DEFAULT @"100"

// Map View Default Config
#define MINIMUM_ZOOM_ARC 0.034 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.25
#define MAX_DEGREES_ARC 360


// Utility Values
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]
#define M_PI        3.14159265358979323846264338327950288
#define BUTTON_COMMON_RADIUS 4.0f
#define MSG_FILL_FORM_CORRECTLY @"Fill the form correctly"
#define EMAIL_VERIFY_CODE_MAX_LENGTH 4

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_MAX_LENGTH >= 667.0)
