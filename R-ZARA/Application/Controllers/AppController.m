//
//  AppController.m


#import "AppController.h"

static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Utility Data
        _appMainColor = RGBA(216, 152, 42, 1.0f);
        _appTextColor = RGBA(21, 33, 43, 1.0f);
        _appThirdColor = RGBA(16, 25, 32, 1.0f);
        
        _vAlert = [[DoAlertView alloc] init];
        _vAlert.nAnimationType = 2;  // there are 5 type of animation
        _vAlert.dRound = 7.0;
        _vAlert.bDestructive = NO;  // for destructive mode
        //        _vAlert.iImage = [UIImage imageNamed:@"logo_top"];
        //        _vAlert.nContentMode = DoContentImage;
        
        
        _introSliderImages = (NSMutableArray *) @[
                                                  @"bg_onboarding1",
                                                  @"bg_onboarding2",
                                                  @"bg_onboarding3"
                                                  ];
        
        _menuPages = [[NSMutableArray alloc] init];
        _menuPages = [@[
                        [@{@"tag" : @"1", @"title" : @"Home", @"icon" : @"home"} mutableCopy],
                        [@{@"tag" : @"2", @"title" : @"Profile", @"icon" : @"profile"} mutableCopy],
                        [@{@"tag" : @"3", @"title" : @"Friends", @"icon" : @"friends"} mutableCopy],
                        [@{@"tag" : @"4", @"title" : @"Statistics", @"icon" : @"statistics"} mutableCopy],
                        [@{@"tag" : @"5", @"title" : @"All Users", @"icon" : @"socialize"} mutableCopy],
                        [@{@"tag" : @"6", @"title" : @"My Rewards", @"icon" : @"myreward"} mutableCopy]
                        ] mutableCopy];
        
        _ownermenuPages = [[NSMutableArray alloc] init];
        _ownermenuPages = [@[
                        [@{@"tag" : @"1", @"title" : @"Home", @"icon" : @"home"} mutableCopy],
                        [@{@"tag" : @"2", @"title" : @"Profile", @"icon" : @"profile"} mutableCopy],
                        [@{@"tag" : @"3", @"title" : @"Friends", @"icon" : @"friends"} mutableCopy],
                        [@{@"tag" : @"4", @"title" : @"Statistics", @"icon" : @"statistics"} mutableCopy],
                        [@{@"tag" : @"5", @"title" : @"All Users", @"icon" : @"socialize"} mutableCopy],
                        [@{@"tag" : @"6", @"title" : @"My Rewards", @"icon" : @"myreward"} mutableCopy],
                        [@{@"tag" : @"7", @"title" : @"Posting Rewards", @"icon" : @"rewardpost"} mutableCopy]
                        ] mutableCopy];
        
        
               
        // Nav Temporary Data
        _editProfileImage = nil;
        _currentMenuTag = @"1";
        _isMyProfileChanged = NO;
        _isPushedFromForgotPasswordSet = NO;
        _isForgotPasswordSet = NO;
        _isPushedFromRegister = NO;
        _isPushedFromLogin = NO;
        _selectedUser = [[NSMutableDictionary alloc] init];
//        _userAvator = [[UIImage alloc] init];
        _datas = [[NSMutableArray alloc] init];
        _allRewardArray = [[NSMutableArray alloc] init];
        _entertainment = [[NSMutableArray alloc] init];
        _online = [[NSMutableArray alloc] init];
        _food = [[NSMutableArray alloc] init];
        _apparel = [[NSMutableArray alloc] init];
        
//        _datas = [@[
//                    [@{
//                       @"malum_name" : @"Class",
//                       @"user_full_name" : @"John Smith",
//                       @"user_photo_url" : @"u01",
//                       @"user_occupation" : @"Student",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.674437",
//                       @"user_location_longitude" : @"-73.932155",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Party",
//                       @"user_full_name" : @"Victoria Blomvik",
//                       @"user_photo_url" : @"u02",
//                       @"user_occupation" : @"Doctor",
//                       @"user_phone_number" : @"+1 392 316 5013",
//                       @"user_rating_avg" : @"4.8",
//                       @"user_age" : @"20",
//                       @"user_is_fav" : @"1",
//                       
//                       @"user_location_latitude" : @"40.690031",
//                       @"user_location_longitude" : @"-73.949127",
//                       @"user_location_address" : @"340 Malcolm X Blvd, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"340 Malcolm X Blvd",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       } mutableCopy],
//                    [@{
//                       @"malum_name" : @"Class",
//                       @"user_full_name" : @"Bianca Fklkand",
//                       @"user_photo_url" : @"u03",
//                       @"user_occupation" : @"Dancer",
//                       @"user_phone_number" : @"+1 392 316 5013",
//                       @"user_rating_avg" : @"4.8",
//                       @"user_age" : @"20",
//                       @"user_is_fav" : @"1",
//                       
//                       @"user_location_latitude" : @"40.653268",
//                       @"user_location_longitude" : @"-73.9425687",
//                       @"user_location_address" : @"340 Malcolm X Blvd, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"340 Malcolm X Blvd",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       
//                       
//                       } mutableCopy],
//                    
//                    
//                    [@{
//                       @"malum_name" : @"Party",
//                       @"user_full_name" : @"Siguard Larson",
//                       @"user_photo_url" : @"u04",
//                       @"user_occupation" : @"Teacher",
//                       @"user_phone_number" : @"+1 506 316 2298",
//                       @"user_rating_avg" : @"3.2",
//                       @"user_age" : @"18",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.688337",
//                       @"user_location_longitude" : @"-73.922117",
//                       @"user_location_address" : @"849 Madison St, Brooklyn, NY 11221",
//                       
//                       @"malum_location_street" : @"849 Madison St",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11221"
//                       } mutableCopy],
//                    [@{
//                       @"malum_name" : @"Conference",
//                       @"user_full_name" : @"Mina Johannessen",
//                       @"user_photo_url" : @"u05",
//                       @"user_occupation" : @"Vender",
//                       @"user_phone_number" : @"+1 392 316 5013",
//                       @"user_rating_avg" : @"4.8",
//                       @"user_age" : @"20",
//                       @"user_is_fav" : @"1",
//                       
//                       @"user_location_latitude" : @"40.6725631",
//                       @"user_location_longitude" : @"-73.9875621",
//                       @"user_location_address" : @"340 Malcolm X Blvd, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"340 Malcolm X Blvd",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Meeting",
//                       @"user_full_name" : @"Sofie Henriksen",
//                       @"user_photo_url" : @"u06",
//                       @"user_occupation" : @"Police",
//                       @"user_phone_number" : @"+1 392 316 5013",
//                       @"user_rating_avg" : @"4.8",
//                       @"user_age" : @"20",
//                       @"user_is_fav" : @"1",
//                       @"user_location_latitude" : @"40.6569851",
//                       @"user_location_longitude" : @"-73.9632587",
//                       @"user_location_address" : @"340 Malcolm X Blvd, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"340 Malcolm X Blvd",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Class",
//                       @"user_full_name" : @"Lilana Podraza",
//                       @"user_photo_url" : @"u07",
//                       @"user_occupation" : @"Professor",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.663537",
//                       @"user_location_longitude" : @"-73.912155",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Party",
//                       @"user_full_name" : @"Emma Kristiansen",
//                       @"user_photo_url" : @"u08",
//                       @"user_occupation" : @"Worker",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.672537",
//                       @"user_location_longitude" : @"-73.933555",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    
//                    
//                    [@{
//                       @"malum_name" : @"Dinner",
//                       @"user_full_name" : @"Christine Eriksen",
//                       @"user_photo_url" : @"u09",
//                       @"user_occupation" : @"Driver",
//                       @"user_phone_number" : @"+1 506 316 2298",
//                       @"user_rating_avg" : @"4.5",
//                       @"user_age" : @"22",
//                       @"user_is_fav" : @"1",
//                       @"user_location_latitude" : @"40.682218",
//                       @"user_location_longitude" : @"-73.910789",
//                       @"user_location_address" : @"522 Chauncey St, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"522 Chauncey St",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       } mutableCopy]
//                    ] mutableCopy];
        _allUsers = [[NSMutableArray alloc] init];
        _userFriends = [[NSMutableArray alloc] init];
//        _allUsers = [@[
//                    [@{
//                       @"malum_name" : @"Class",
//                       @"user_full_name" : @"John Smith",
//                       @"user_photo_url" : @"u01",
//                       @"user_occupation" : @"Student",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.674437",
//                       @"user_location_longitude" : @"-73.932155",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Party",
//                       @"user_full_name" : @"Julie Halvorsen",
//                       @"user_photo_url" : @"u02",
//                       @"user_occupation" : @"Doctor",
//                       @"user_phone_number" : @"+1 392 316 5013",
//                       @"user_rating_avg" : @"4.8",
//                       @"user_age" : @"20",
//                       @"user_is_fav" : @"1",
//                       
//                       @"user_location_latitude" : @"40.690031",
//                       @"user_location_longitude" : @"-73.949127",
//                       @"user_location_address" : @"340 Malcolm X Blvd, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"340 Malcolm X Blvd",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       } mutableCopy],
//                    [@{
//                       @"malum_name" : @"Class",
//                       @"user_full_name" : @"Henrik Kapstad",
//                       @"user_photo_url" : @"u03",
//                       @"user_occupation" : @"Dancer",
//                       @"user_phone_number" : @"+1 392 316 5013",
//                       @"user_rating_avg" : @"4.8",
//                       @"user_age" : @"20",
//                       @"user_is_fav" : @"1",
//                       
//                       @"user_location_latitude" : @"40.653268",
//                       @"user_location_longitude" : @"-73.9425687",
//                       @"user_location_address" : @"340 Malcolm X Blvd, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"340 Malcolm X Blvd",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       
//                       
//                       } mutableCopy],
//                    
//                    
//                    [@{
//                       @"malum_name" : @"Party",
//                       @"user_full_name" : @"Siguard Larson",
//                       @"user_photo_url" : @"u04",
//                       @"user_occupation" : @"Teacher",
//                       @"user_phone_number" : @"+1 506 316 2298",
//                       @"user_rating_avg" : @"3.2",
//                       @"user_age" : @"18",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.688337",
//                       @"user_location_longitude" : @"-73.922117",
//                       @"user_location_address" : @"849 Madison St, Brooklyn, NY 11221",
//                       
//                       @"malum_location_street" : @"849 Madison St",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11221"
//                       } mutableCopy],
//                    [@{
//                       @"malum_name" : @"Conference",
//                       @"user_full_name" : @"Oliver Peramin",
//                       @"user_photo_url" : @"u05",
//                       @"user_occupation" : @"Vender",
//                       @"user_phone_number" : @"+1 392 316 5013",
//                       @"user_rating_avg" : @"4.8",
//                       @"user_age" : @"20",
//                       @"user_is_fav" : @"1",
//                       
//                       @"user_location_latitude" : @"40.6725631",
//                       @"user_location_longitude" : @"-73.9875621",
//                       @"user_location_address" : @"340 Malcolm X Blvd, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"340 Malcolm X Blvd",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Meeting",
//                       @"user_full_name" : @"Cody Zany",
//                       @"user_photo_url" : @"u06",
//                       @"user_occupation" : @"Police",
//                       @"user_phone_number" : @"+1 392 316 5013",
//                       @"user_rating_avg" : @"4.8",
//                       @"user_age" : @"20",
//                       @"user_is_fav" : @"1",
//                       @"user_location_latitude" : @"40.6569851",
//                       @"user_location_longitude" : @"-73.9632587",
//                       @"user_location_address" : @"340 Malcolm X Blvd, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"340 Malcolm X Blvd",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Class",
//                       @"user_full_name" : @"Lilana Podraza",
//                       @"user_photo_url" : @"u07",
//                       @"user_occupation" : @"Professor",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.663537",
//                       @"user_location_longitude" : @"-73.912155",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Party",
//                       @"user_full_name" : @"Erik Rustad",
//                       @"user_photo_url" : @"u08",
//                       @"user_occupation" : @"Worker",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.672537",
//                       @"user_location_longitude" : @"-73.933555",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    [@{
//                       @"malum_name" : @"Party",
//                       @"user_full_name" : @"Jesse Ferguson",
//                       @"user_photo_url" : @"u10",
//                       @"user_occupation" : @"Justice",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.672537",
//                       @"user_location_longitude" : @"-73.933555",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    [@{
//                       @"malum_name" : @"Dinner",
//                       @"user_full_name" : @"Daniel James",
//                       @"user_photo_url" : @"u11",
//                       @"user_occupation" : @"Worker",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.672537",
//                       @"user_location_longitude" : @"-73.933555",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Party",
//                       @"user_full_name" : @"Kasper Fdegard",
//                       @"user_photo_url" : @"u12",
//                       @"user_occupation" : @"Designer",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.672537",
//                       @"user_location_longitude" : @"-73.933555",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    
//                    [@{
//                       @"malum_name" : @"Class",
//                       @"user_full_name" : @"Eero Kemi",
//                       @"user_photo_url" : @"u13",
//                       @"user_occupation" : @"Dancer",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.672537",
//                       @"user_location_longitude" : @"-73.933555",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//                    
//                    
//                    [@{
//                       @"malum_name" : @"Work",
//                       @"user_full_name" : @"Harald Wilson",
//                       @"user_photo_url" : @"u08",
//                       @"user_occupation" : @"Painter",
//                       @"user_phone_number" : @"+1 359 4927 0912",
//                       @"user_age" : @"21",
//                       @"user_rating_avg" : @"4.2",
//                       @"user_is_fav" : @"0",
//                       
//                       @"user_location_latitude" : @"40.672537",
//                       @"user_location_longitude" : @"-73.933555",
//                       @"user_location_address" : @"1133 St Marks Ave, Brooklyn, NY 11213",
//                       
//                       @"malum_location_street" : @"1133 St Marks Ave",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11213"
//                       } mutableCopy],
//
//
//                   
//                    
//                    [@{
//                       @"malum_name" : @"Dinner",
//                       @"user_full_name" : @"Albert Nilsson",
//                       @"user_photo_url" : @"u09",
//                       @"user_occupation" : @"Driver",
//                       @"user_phone_number" : @"+1 506 316 2298",
//                       @"user_rating_avg" : @"4.5",
//                       @"user_age" : @"22",
//                       @"user_is_fav" : @"1",
//                       @"user_location_latitude" : @"40.682218",
//                       @"user_location_longitude" : @"-73.910789",
//                       @"user_location_address" : @"522 Chauncey St, Brooklyn, NY 11233",
//                       
//                       @"malum_location_street" : @"522 Chauncey St",
//                       @"user_location_city" : @"Brooklyn",
//                       @"user_location_state" : @"NY",
//                       @"user_location_zip" : @"11233"
//                       } mutableCopy]
//                    ] mutableCopy];


        
        // Data
        _currentUser = [[NSMutableDictionary alloc] init];
//        _currentUser = [@{
//                          @"user_id" : @"1",
//                          @"user_full_name" : @"Kevin Brown",
//                          @"user_place" : @"522 Chauncey St",
//                          @"user_malum_name" : @"The Art institute of Houston",
//                          @"user_malum_latitude" : @"40.752218",
//                          @"user_malum_longitude" : @"-73.905789",
//                          @"user_email" : @"user123@gmail.com",
//                          @"user_photo_url" : @"",
//                          @"user_phone_number" : @"+358 923 165013",
//                          @"user_location_latitude" : @"40.679094",
//                          @"user_location_longitude" : @"-73.928190",
//                          @"user_location_address" : @"1784 Fulton St, Brooklyn, NY 11233",
//                          
//                          @"user_location_street" : @"1784 Fulton St",
//                          @"user_location_city" : @"Brooklyn",
//                          @"user_location_state" : @"NY",
//                          @"user_location_zip" : @"11233",
//                          
//                          } mutableCopy];
//
        
    }
    return self;
}

@end
