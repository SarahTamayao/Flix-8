//
//  TrailerViewController.m
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/24/21.
//

#import "TrailerViewController.h"
#import "YTPlayerView.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) NSString *videoKey;


@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchVideo];
    
}
//YdAIBlPVe9s
-(void)fetchVideo{
    [self.activityIndicator startAnimating];
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed", self.movie[@"id"]];
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
               NSLog(@"%@", dataDictionary[@"results"][0][@"key"]);
               self.videoKey = [NSString stringWithString:dataDictionary[@"results"][0][@"key"]];
               [self.playerView loadWithVideoId:self.videoKey];
           }
       }];
    
    [self.activityIndicator stopAnimating];
    [task resume];
}
- (IBAction)onTap:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
