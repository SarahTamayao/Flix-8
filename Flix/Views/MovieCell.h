//
//  MovieCell.h
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/23/21.
//

#import <UIKit/UIKit.h>
#import <Cosmos-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet CosmosView *cosmosView;


@end

NS_ASSUME_NONNULL_END
