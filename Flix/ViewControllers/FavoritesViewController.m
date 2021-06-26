//
//  FavoritesViewController.m
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/25/21.
//

#import "FavoritesViewController.h"
#import "DetailsViewController.h"
#import "FavoriteCell.h"
#import "UIImageView+AFNetworking.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSMutableDictionary *genres;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    
    [self fetchGenres];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.movies = [standardUserDefaults objectForKey:@"favorites"];
    
    NSLog(@"%@",self.movies);
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    self.movies = [standardUserDefaults objectForKey:@"favorites"];
    [self.tableView reloadData];
    
}

-(void)fetchGenres{
    [self.activityIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/genre/movie/list?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
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
            
               NSArray *genresArray = dataDictionary[@"genres"];
               self.genres = [NSMutableDictionary dictionary];
               for (int i = 0; i < genresArray.count; i++){
                   [self.genres setObject:genresArray[i][@"name"]  forKey:genresArray[i][@"id"]];
               }
               [self.tableView reloadData];
               
           }
        [self.activityIndicator stopAnimating];
       }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
    
    cell.cardView.layer.cornerRadius = 10;
    cell.posterView.layer.cornerRadius = 15;
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    
    NSNumber *rating = movie[@"vote_average"];
    cell.ratingLabel.text = [NSString stringWithFormat: @"%.1f",[rating doubleValue]];
    cell.cosmosView.rating = [rating doubleValue]/2.0;
    
    NSString *genresString = @"";
    for (id genreId in movie[@"genre_ids"]){
        genresString = [genresString stringByAppendingString:[NSString stringWithFormat: @"%@, ",self.genres[genreId]]];
    }
    cell.genresLabel.text =  [genresString substringToIndex:genresString.length-2];;
    
    NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@", movie[@"poster_path"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    cell.posterView.image = [UIImage imageNamed:@"film"];
    __weak FavoriteCell *weakSelf = cell;
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil
          success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            NSLog(@"Image was NOT cached, fade in image");
            weakSelf.posterView.alpha = 0.0;
            weakSelf.posterView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.posterView.alpha = 1.0;
            }];
        }
        else {
            NSLog(@"Image was cached so just update the image");
            weakSelf.posterView.image = image;
        }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        // do something for the failure condition
    }];
    
    return cell;
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     
     UITableViewCell *tappedCell = sender;
     NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
     NSDictionary *movie = self.movies[indexPath.row];
     
     //if ([segue destinationViewController] )
     DetailsViewController *detailsViewController = [segue destinationViewController];
     detailsViewController.movie = movie;
     
     NSString *genresString = @"";
     for (id genreId in movie[@"genre_ids"]){
         genresString = [genresString stringByAppendingString:[NSString stringWithFormat: @"%@, ",self.genres[genreId]]];
     }
     detailsViewController.genres =  [genresString substringToIndex:genresString.length-2];;
 }

@end
