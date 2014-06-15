//
//  AddLocationViewController.m
//  Mausam
//
//  Created by Niyog Ray on 13/06/14.
//  Copyright (c) 2014 Niyog Ray. All rights reserved.
//

#import "AddLocationViewController.h"

@interface AddLocationViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, APIDelegate>
{
    __weak IBOutlet UITextField *textF;
    __weak IBOutlet UITableView *searchResultsTblV;
    
    __weak IBOutlet UILabel *statusLbl;
    
    /// Keep the same handle for API calls
    APIHelper *apiHelper;
    /// To tag API calls
    NSInteger apiTag;
    
    NSMutableArray *searchResults;
    NSString *resultsTitle;
    
    FBShimmeringView *statusShimmerView, *cellShimmerView;
}

- (IBAction)closeClicked:(id)sender;

@end

@implementation AddLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [textF setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
    [textF setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    [self setupStatusShimmerView];
}

- (void)setupStatusShimmerView
{
    statusLbl.text = @"";
    
    statusShimmerView = [[FBShimmeringView alloc] initWithFrame:statusLbl.frame];
    [statusLbl.superview addSubview:statusShimmerView];
    
    statusShimmerView.shimmeringSpeed = 200;
    statusShimmerView.shimmeringPauseDuration = 0.1;
    
    statusShimmerView.contentView = statusLbl;
    
    statusShimmerView.shimmering = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [textF becomeFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
//    searchResultsTblV.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    [self searchLocationsWithSubstring:substring];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    return YES;
}

#pragma mark - API

- (void)searchLocationsWithSubstring:(NSString *)substring
{
    if (apiHelper == nil)
        apiHelper = [[APIHelper new] initWithDelegate:self];
    [apiHelper cancel];
    
    // Params
    NSString *params = [NSString stringWithFormat:@"q=%@&type=like&mode=json&units=metric", substring];
    
    // Tag and call
    apiTag++;
    [apiHelper callAPI:@"Location Find" Param:params Tag:apiTag];
    
    [self updateStatusToSearching];
}

- (void)response:(NSMutableDictionary *)response forAPI:(NSString *)apiName withTag:(NSInteger)tag
{
    if (tag == apiTag)
    {
        searchResults = [response objectForKey:@"list"];
        [searchResultsTblV reloadData];
        [self updateStatus];
    }
}

- (void)updateStatusToSearching
{
    statusShimmerView.shimmering = YES;
    statusLbl.text = @"Searching";
}

- (void)updateStatus
{
    if (searchResults)
    {
        NSInteger count = searchResults.count;
        if (count == 0)
            resultsTitle = @"No results found";
        else if (count == 1)
            resultsTitle = @"1 result found";
        else
            resultsTitle = [NSString stringWithFormat:@"%d results found", count];
    }
    else
        resultsTitle = @"";
    
    statusLbl.text = resultsTitle;
    statusShimmerView.shimmering = NO;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultsCell"];
    
    NSMutableDictionary *searchResult = searchResults[row];
    NSString *locationName = [searchResult objectForKey:@"name"];
    NSString *locationCountryCode = [[searchResult objectForKey:@"sys"] objectForKey:@"country"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", locationName, locationCountryCode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
    [self dismissKeyboard];
    
    // Save location
     NSMutableDictionary *searchResult = searchResults[row];
    [[LocationStore new] addNewLocationFromSearchResult:searchResult];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}

#pragma mark - Events

- (void)dismissKeyboard
{
    if ([UIResponder currentFirstResponder])
    {
        [[UIResponder currentFirstResponder] resignFirstResponder];
    }
}

- (IBAction)closeClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
