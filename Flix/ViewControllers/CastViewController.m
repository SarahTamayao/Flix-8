//
//  CastViewController.m
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/25/21.
//

#import "CastViewController.h"
#import "CastCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface CastViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSArray *actors;


@end

@implementation CastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate =self;
    
    [self fetchActors];
    
    
    
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing)/2;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth * 1.5);
}

-(void)fetchActors{
    [self.activityIndicator startAnimating];
    
    NSString *urlString = [NSString stringWithFormat: @"https://api.themoviedb.org/3/movie/%@/credits?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed", self.movie[@"id"]];
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

               self.actors = dataDictionary[@"cast"];
               [self.collectionView reloadData];
               
           }
        [self.activityIndicator stopAnimating];
       }];
    [task resume];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.actors.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CastCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CastCollectionCell" forIndexPath:indexPath];
    NSDictionary *actor = self.actors[indexPath.item];
    
    cell.cardView.layer.cornerRadius = 10.0;
    
    cell.actorLabel.text = actor[@"name"];
    cell.characterLabel.text = actor[@"character"];
    
//    [cell.actorLabel sizeToFit];
//    [cell.characterLabel sizeToFit];
    

    if (actor[@"profile_path"] == (id)[NSNull null]){
        cell.photoView.image = [UIImage imageNamed:@"film"];;
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500/%@", actor[@"profile_path"]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        cell.photoView.layer.cornerRadius = 15.0;
        cell.photoView.image = [UIImage imageNamed:@"film"];;
        
        __weak CastCollectionCell *weakSelf = cell;
        [cell.photoView setImageWithURLRequest:request placeholderImage:nil
              success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
            // imageResponse will be nil if the image is cached
            if (imageResponse) {
                NSLog(@"Image was NOT cached, fade in image");
                weakSelf.photoView.alpha = 0.0;
                weakSelf.photoView.image = image;
                
                //Animate UIImageView back to alpha 1 over 0.3sec
                [UIView animateWithDuration:0.3 animations:^{
                    weakSelf.photoView.alpha = 1.0;
                }];
            }
            else {
                NSLog(@"Image was cached so just update the image");
                weakSelf.photoView.image = image;
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
            // do something for the failure condition
        }];
    }
    return cell;
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
