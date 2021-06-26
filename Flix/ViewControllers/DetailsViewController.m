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
@property (weak, nonatomic) IBOutlet UIButton *trailerButton;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *reviewsButton;
@property (weak, nonatomic) IBOutlet UIButton *castButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@property (nonatomic) bool isFavorite;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardView.layer.cornerRadius = 15.0;
    self.trailerButton.layer.cornerRadius = 0.5 * self.trailerButton.bounds.size.width;
    self.reviewsButton.layer.cornerRadius = 10;
    self.castButton.layer.cornerRadius = 10;
    
    self.titleLabel.text = self.movie[@"title"];
    self.descriptionLabel.text = self.movie[@"overview"];
    self.genresLabel.text = self.genres;
    
    if (self.descriptionLabel.text.length > 350){
        self.moreButton.hidden = false;
    }
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableSet *set = [standardUserDefaults objectForKey:@"favorites"];
    self.isFavorite = [set containsObject:self.movie];
    
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

- (void)viewWillAppear:(BOOL)animated{
    if (self.isFavorite){
        [self.favoritesButton setImage:[UIImage imageNamed:@"filledheart"] forState: UIControlStateNormal] ;
    }
    else{
        [self.favoritesButton setImage:[UIImage imageNamed:@"emptyheart"] forState: UIControlStateNormal] ;
    }
}

- (IBAction)favoritesButtonPress:(id)sender {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[standardUserDefaults objectForKey:@"favorites"] mutableCopy];
    //NSData *movieEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.movie requiringSecureCoding:true error:nil];
    self.isFavorite = !self.isFavorite;
    if (self.isFavorite){
        [self.favoritesButton setImage:[UIImage imageNamed:@"filledheart"] forState: UIControlStateNormal] ;
        [array addObject:self.movie];
    }
    else{
        [self.favoritesButton setImage:[UIImage imageNamed:@"emptyheart"] forState: UIControlStateNormal] ;
        [array removeObject:self.movie];
    }
    [standardUserDefaults setObject:array forKey:@"favorites"];
    [standardUserDefaults synchronize];
    
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     
     PosterViewController *posterViewController = [segue destinationViewController];
     posterViewController.movie = self.movie;
     
 }


@end
