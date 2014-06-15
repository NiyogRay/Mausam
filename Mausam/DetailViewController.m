//
//  DetailViewController.m
//  Mausam
//
//  Created by Niyog Ray on 12/06/14.
//  Copyright (c) 2014 Niyog Ray. All rights reserved.
//

#import "DetailViewController.h"
#import "ForecastTableViewCell.h"

#define COUNT_FORECAST_DAYS 14

#define TIME_TABLE_TOGGLE 0.3

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource, APIDelegate>
{
    NSMutableDictionary *location;
    
    __weak IBOutlet UILabel *locationNameLbl;
    __weak IBOutlet UILabel *locationWeatherLbl;
    __weak IBOutlet UIImageView *locationWeatherIconIV;
    __weak IBOutlet UILabel *locationTempLbl;
    __weak IBOutlet UILabel *locationWeatherDetailLbl;
    
    FBShimmeringView *shimmerView;
    __weak IBOutlet UILabel *forecastLbl;
    __weak IBOutlet UIView *forecastDividerV;
    
    __weak IBOutlet UITableView *forecastTblV;
    
    NSString *locationID, *locationName, *locationWeather, *locationWeatherIcon, *locationTemp, *locationWeatherDetail;
    NSString *timezone;
    
    NSMutableArray *forecasts;
    
    CFTimeInterval startTime, elapsedTime;
}

- (void)configureView;

- (IBAction)closeClicked:(id)sender;

@end

@implementation DetailViewController

- (void)setLocation:(NSMutableDictionary *)newLocation
{
    if (location != newLocation) {
        location = newLocation;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (location) {
        
        // extract
        locationID = [location objectForKey:@"id"];
        
        NSString *locationName2 = [location objectForKey:@"name"];
        NSString *locationCountryCode = [[location objectForKey:@"sys"] objectForKey:@"country"];
        locationName = [NSString stringWithFormat:@"%@, %@", locationName2, locationCountryCode];
        timezone = [location objectForKey:@"timezone"];
        
        // display
        locationNameLbl.text = locationName;
    }
    
    if (!forecasts)
    {
        [self hideTableViewAnimated:NO];
    }
}

- (IBAction)closeClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupShimmerView];
    [self configureView];
}

- (void)setupShimmerView
{
    shimmerView = [[FBShimmeringView alloc] initWithFrame:locationNameLbl.frame];
    [self.view addSubview:shimmerView];

    shimmerView.shimmeringSpeed = 200;
    shimmerView.shimmeringPauseDuration = 0.1;
    
    shimmerView.contentView = locationNameLbl;
    
    shimmerView.shimmering = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self callForecastAPI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callForecastAPI
{
    shimmerView.shimmering = YES;
    
    NSString *paramString = [NSString stringWithFormat:@"units=metric&cnt=%d&APPID=%s&id=%@", COUNT_FORECAST_DAYS, APP_ID, locationID];
    
    [[[APIHelper alloc] initWithDelegate:self] callAPI:@"Forecast Daily" Param:paramString Tag:0];
}

- (void)saveForecastData:(NSMutableDictionary *)response
{
    forecasts = [response objectForKey:@"list"];
    [forecastTblV reloadData];
    
    [self unhideTableViewAnimated:YES];
}

- (void)hideTableViewAnimated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:TIME_TABLE_TOGGLE animations:^(void)
         {
             forecastTblV.alpha = 0;
         }];
    }
    else
    {
        forecastTblV.alpha = 0;
    }
}

- (void)unhideTableViewAnimated:(BOOL)animated
{
    shimmerView.shimmering = NO;
    if (animated)
    {
        [UIView animateWithDuration:TIME_TABLE_TOGGLE delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^(void)
                    {
                        forecastTblV.alpha = 1;
                    }
                                     completion:^(BOOL finished)
                    {
                         
                    }];
    }
    else
    {
        forecastTblV.alpha = 1;
    }
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return forecasts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
    ForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForecastTableViewCell"];
    
    NSMutableDictionary *forecast = forecasts[row];
    
    // Temperature and rounding
    {
        NSMutableDictionary *temp = [forecast objectForKey:@"temp"];
        
        // minTemp
        NSNumber *minTempNum = [temp objectForKey:@"min"];
        float minTempFloat = [minTempNum floatValue];
        int minTempInt = roundf(minTempFloat);
        NSString *minTemp = [NSString stringWithFormat:@"%d°", minTempInt];
        
        cell.minTempLbl.text = minTemp;
        
        // maxTemp
        NSNumber *maxTempNum = [temp objectForKey:@"max"];
        float maxTempFloat = [maxTempNum floatValue];
        int maxTempInt = roundf(maxTempFloat);
        NSString *maxTemp = [NSString stringWithFormat:@"%d°", maxTempInt];
        
        cell.maxTempLbl.text = maxTemp;
    }
    
    // Weather
    {
        NSMutableArray *weathers = [forecast objectForKey:@"weather"];
        
        NSMutableDictionary *weather = weathers[0];
        NSString *weatherForecast = [weather objectForKey:@"description"];
        NSString *weatherIcon = [weather objectForKey:@"icon"];
        
        cell.forecastLbl.text = weatherForecast;
        cell.forecastIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", weatherIcon]];
    }
    
    // NSDate
    {
        NSNumber *unixTimeNum = [forecast objectForKey:@"dt"];
        CGFloat unixTimeInt = [unixTimeNum doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeInt];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setCalendar:calendar];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timezone]];
        
        // day
        [dateFormatter setDateFormat:@"d"];
        NSString *day = [dateFormatter stringFromDate:date];
        
        // weekday
        [dateFormatter setDateFormat:@"EEE"];
        NSString *weekday = [[dateFormatter stringFromDate:date] uppercaseString];
        
        // month
        [dateFormatter setDateFormat:@"MMM"];
        NSString *month = [[dateFormatter stringFromDate:date] uppercaseString];
        
        cell.dayLbl.text = day;
        cell.weekdayLbl.text = weekday;
        cell.monthLbl.text = month;
    }
    
    return cell;
}

#pragma mark - API

- (void)response:(NSMutableDictionary *)response forAPI:(NSString *)apiName withTag:(NSInteger)tag
{
    [self saveForecastData:response];
}

@end
