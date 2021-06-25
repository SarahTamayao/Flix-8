//
//  PosterViewController.m
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/23/21.
//

#import "PosterViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PosterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;


@end

@implementation PosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.backdropView.
    
    static NSString *baseURLSmallString = @"https://image.tmdb.org/t/p/w200";
    static NSString *baseURLLargeString = @"https://image.tmdb.org/t/p/w500";
    
    NSURL *urlSmall = [NSURL URLWithString:[baseURLSmallString stringByAppendingString:self.movie[@"backdrop_path"]]];
    NSURL *urlLarge = [NSURL URLWithString:[baseURLLargeString stringByAppendingString:self.movie[@"backdrop_path"]]];

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];

    __weak PosterViewController *weakSelf = self;

    [self.backdropView setImageWithURLRequest:requestSmall placeholderImage:[UIImage imageNamed:@"film"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                       
       // smallImageResponse will be nil if the smallImage is already available
       // in cache (might want to do something smarter in that case).
       weakSelf.backdropView.alpha = 0.0;
       weakSelf.backdropView.image = smallImage;
                                       
       [UIView animateWithDuration:0.3 animations:^{
           weakSelf.backdropView.alpha = 1.0;
       } completion:^(BOOL finished) {
        // The AFNetworking ImageView Category only allows one request to be sent at a time
        // per ImageView. This code must be in the completion block.
            [weakSelf.backdropView setImageWithURLRequest:requestLarge placeholderImage:smallImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage){
                weakSelf.backdropView.image = largeImage;
            }
           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
               // do something for the failure condition of the large image request
               // possibly setting the ImageView's image to a default image
           }];
       }];
       }
       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
           // do something for the failure condition
           // possibly try to get the large image
       }];
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
