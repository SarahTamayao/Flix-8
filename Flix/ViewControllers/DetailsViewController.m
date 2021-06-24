//
//  DetailsViewController.m
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/23/21.
//

#import "DetailsViewController.h"
#import <Cosmos-Swift.h>
#import "UIImageView+AFNetworking.h"
#import "PosterViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet CosmosView *cosmosView;
@property (weak, nonatomic) IBOutlet UIImageView *genresCardView;
@property (weak, nonatomic) IBOutlet UIButton *trailerButton;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardView.layer.cornerRadius = 5.0;
    self.genresCardView.layer.cornerRadius = 5.0;
    self.trailerButton.layer.cornerRadius = 0.5 * self.trailerButton.bounds.size.width;
    
    self.titleLabel.text = self.movie[@"title"];
    self.descriptionLabel.text = self.movie[@"overview"];
    self.genresLabel.text = self.genres;
    
    if (self.descriptionLabel.text.length > 307){
        self.descriptionLabel.text = [self.descriptionLabel.text substringToIndex:307];
        self.descriptionLabel.text = [self.descriptionLabel.text stringByAppendingString:@"..."];
        self.moreButton.hidden = false;
    }
    
    
    NSLog(@"%@", self.descriptionLabel.text);
    NSNumber *rating = self.movie[@"vote_average"];
    self.ratingLabel.text = [NSString stringWithFormat: @"%.1f",[rating doubleValue]];
    self.cosmosView.rating = [rating doubleValue]/2.0;
    
    NSString *baseURLSmallString = @"https://image.tmdb.org/t/p/w200";
    NSString *baseURLLargeString = @"https://image.tmdb.org/t/p/w500";
    
    NSURL *urlSmall = [NSURL URLWithString:[baseURLSmallString stringByAppendingString:self.movie[@"backdrop_path"]]];
    NSURL *urlLarge = [NSURL URLWithString:[baseURLLargeString stringByAppendingString:self.movie[@"backdrop_path"]]];

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];

    __weak DetailsViewController *weakSelf = self;

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


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     
     PosterViewController *posterViewController = [segue destinationViewController];
     posterViewController.movie = self.movie;
     
 }


@end
