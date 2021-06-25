//
//  ReviewsViewController.m
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/24/21.
//

#import "ReviewsViewController.h"
#import "ReviewModalViewController.h"
#import "ReviewCell.h"

@interface ReviewsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSArray *reviews;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchReviews];
    // Do any additional setup after loading the view.
}

-(void)fetchReviews{
    [self.activityIndicator startAnimating];
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/reviews?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed", self.movie[@"id"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot get movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
               [alert addAction:okAction];
               [self presentViewController:alert animated:YES completion:^{}];
               
               
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               self.reviews = dataDictionary[@"results"];
               [self.tableView reloadData];
               [self.activityIndicator stopAnimating];
               
           }
        
       }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reviews.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    
    NSDictionary *review = self.reviews[indexPath.row];
    
    cell.authorLabel.text = review[@"author"];
    cell.reviewLabel.text = review[@"content"];
    
    
    return cell;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UITableViewCell *tappedCell = sender;
     NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
     NSDictionary *review = self.reviews[indexPath.row];
     
     ReviewModalViewController *modal = [segue destinationViewController];
     modal.review = review;
 }
 

@end


