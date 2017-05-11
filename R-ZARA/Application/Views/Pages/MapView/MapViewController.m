//
//  MapViewController.m
//  Malum
//
//  Created by Mars on 6/17/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Place.h"
#import "PlaceMark.h"
#import "DXAnnotationView.h"
#import "DXAnnotationSettings.h"

#define MAP_CALLOUT_WIDTH 118
#define MAP_CALLOUT_HEIGHT 40
#define LIST_CONTAINER_CELL_COUNT_PER_PAGE (IS_IPHONE_6_OR_ABOVE ? 2.5f : 2.0f)

@interface MapViewController ()<MKMapViewDelegate>{
    BOOL isCurrentMapView, isDataChanged;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)initView {
    _mapView.layer.borderWidth = 2.0f;
    _mapView.layer.borderColor = [UIColor grayColor].CGColor;
    [commonUtils setRoundedRectBorderView:_startBtn withBorderWidth:0.0f withBorderColor:[UIColor clearColor] withBorderRadius:10.0f];
    [self updateMapView];
}
#pragma mark - Map View
- (void)updateMapView {
    
    [commonUtils removeAnnotationsFromMapView:self.mapView];
    
    Place *home = [[Place alloc] init];
//    home.name = [@"You are here\n" stringByAppendingString:[appController.currentUser objectForKey:@"user_location_street"]];
    home.name = [appController.currentUser objectForKey:@"user_place"];
    home.latitude = [[appController.currentUser objectForKey:@"user_location_latitude"] floatValue];
    home.longitude = [[appController.currentUser objectForKey:@"user_location_longitude"] floatValue];
    PlaceMark *placeMark = [[PlaceMark alloc] initWithPlace:home];
    placeMark.isMain = YES;
    placeMark.nameText = @"You are here";
    placeMark.addressText = [appController.currentUser objectForKey:@"user_place"];

    [self.mapView addAnnotation:placeMark];
    
//    [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
    [self initMyLocationCallOutShow];
    
    [self centerMap];
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)initMyLocationCallOutShow {
    id annotation;
    for(annotation in self.mapView.annotations) {
        PlaceMark *placeMark = (PlaceMark *)annotation;
        if(placeMark.isMain) {
            [self.mapView selectAnnotation:annotation animated:TRUE];
            break;
        }
    }
    
}

// size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated {
    NSArray *annotations = mapView.annotations;
    int count = (int)[self.mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}


- (void) centerMap {
    MKCoordinateRegion region;
    //    CLLocationDegrees maxLat = -90;
    //    CLLocationDegrees maxLon = -180;
    //    CLLocationDegrees minLat = 120;
    //    CLLocationDegrees minLon = 150;
    CLLocationDegrees maxLat = -180;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 180;
    CLLocationDegrees minLon = 180;
    
//    NSMutableArray *temp = [[NSMutableArray alloc] init];
//    [temp addObject:[appController.currentUser mutableCopy]];
   
        Place* home = [[Place alloc] init];
        home.latitude = [[appController.currentUser objectForKey:@"user_location_latitude"] floatValue];
        home.longitude =[[appController.currentUser objectForKey:@"user_location_longitude"] floatValue];
        PlaceMark* from = [[PlaceMark alloc] initWithPlace:home];
        CLLocation* currentLocation = (CLLocation*)from ;
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        region.span.latitudeDelta  =  maxLat - minLat;
        region.span.longitudeDelta = maxLon - minLon;
   
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    
    UIImageView *pinView = nil;
    UIView *calloutView = nil;
    
    DXAnnotationView *annotationView = (DXAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([DXAnnotationView class])];
    if (!annotationView) {
        
        PlaceMark *placeMark = (PlaceMark *)annotation;
        if(placeMark.isMain) {
            pinView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            [pinView setImage:[UIImage imageNamed:@"point_mine"]];
            //            pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_map_my_location"]];
            [pinView setContentMode:UIViewContentModeScaleAspectFill];
        } else {
            pinView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
            [pinView setImage:[UIImage imageNamed:placeMark.imageUrl]];
            [pinView setContentMode:UIViewContentModeScaleAspectFill];
            //            [commonUtils setRoundedRectBorderImage:pinView withBorderWidth:2.0f withBorderColor:appController.appMainColor withBorderRadius:pinView.frame.size.width / 2.0f];
        }
        
        calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAP_CALLOUT_WIDTH, MAP_CALLOUT_HEIGHT)];
        [calloutView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:calloutView.frame];
        [bgImageView setImage:[UIImage imageNamed:@"bg_map_callout"]];
        [bgImageView setContentMode:UIViewContentModeScaleAspectFit];
        [calloutView addSubview:bgImageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3.0f, MAP_CALLOUT_WIDTH, MAP_CALLOUT_HEIGHT / 3.0f - 3.0f)];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:9.0f]];
        [nameLabel setShadowOffset:CGSizeZero];
        [nameLabel setShadowColor:[UIColor clearColor]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setText:placeMark.nameText];
        [nameLabel setAdjustsFontSizeToFitWidth:YES];
        [nameLabel setMinimumScaleFactor:0.5f];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MAP_CALLOUT_HEIGHT / 3.0f, MAP_CALLOUT_WIDTH, MAP_CALLOUT_HEIGHT / 3.0f)];
        [addressLabel setTextAlignment:NSTextAlignmentCenter];
        [addressLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:10.0f]];
        [addressLabel setShadowOffset:CGSizeZero];
        [addressLabel setShadowColor:[UIColor clearColor]];
        [addressLabel setTextColor:[UIColor whiteColor]];
        [addressLabel setText:placeMark.addressText];
        [addressLabel setAdjustsFontSizeToFitWidth:YES];
        [addressLabel setMinimumScaleFactor:0.5f];
        
        [calloutView addSubview:nameLabel];
        [calloutView addSubview:addressLabel];
        
        DXAnnotationSettings *newSettings = [DXAnnotationSettings defaultSettings];
        
        newSettings.calloutOffset = 5.0f;
        newSettings.shouldAddCalloutBorder = NO;
        newSettings.animationType = DXCalloutAnimationFadeIn;
        
        annotationView = [[DXAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:NSStringFromClass([DXAnnotationView class])
                                                              pinView:pinView
                                                          calloutView:calloutView
                                                             settings:newSettings];
        
        annotationView.userInteractionEnabled = NO;
        [annotationView setEnabled:YES];
        [annotationView setCanShowCallout:NO];
        
    }
    
    return annotationView;
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:[DXAnnotationView class]]) {
        [((DXAnnotationView *)view)hideCalloutView];
        view.layer.zPosition = -1;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:[DXAnnotationView class]]) {
        [((DXAnnotationView *)view)showCalloutView];
        view.layer.zPosition = 0;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
