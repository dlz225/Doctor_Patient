
#import "UIScrollView+AH3DPullRefresh.h"

#import <objc/runtime.h>
#pragma mark - Helpers

#define AHRelease(object) [object release]; object = nil

#pragma mark - [Interface] AHPullToRefreshView

typedef enum {
  AHPullViewStateHidden = 1,                // Not visible
	AHPullViewStateVisible,                   // Visible but won't trigger the loading if the user releases
  AHPullViewStateTriggered,                 // If the user releases the scrollview it will load
  AHPullViewStateTriggeredProgramatically,  // When triggering it programmatically
  AHPullViewStateLoading,                   // Loading
  AHPullViewStateLoadingProgramatically     // Loading when triggered programatically
} AHPullViewState;

static CGFloat const kAHPullView_ViewHeight = 60.0;

#define kAHPullView_ContentOffsetKey    @"contentOffset"
#define kAHPullView_FrameKey            @"frame"

@interface AHPullToRefreshView : UIView {
  
  AHPullViewState _state;                         // Current state
  
  UIScrollView * _scrollView;                     // The linked scrollview
  BOOL _isObservingScrollView;                    // If it's observing (KVO) the scrollview
  UIEdgeInsets _originalScrollViewContentInset;   // The original content inset of the scrollview
  
  UIColor * _backgroundColor;                     // The view's background color
  
  UIView * _backgroundView;                       // The background view
  UILabel * _label;                               // Where to display the texts depending on the state
  UIActivityIndicatorView * _activityIndicator;   // Shown while loading
  
  NSString * _pullingText;                        // Customization
  NSString * _releaseText;
  NSString * _loadingText;
  NSString * _loadedText;
}

@property (nonatomic, assign) BOOL isObservingScrollView;   // If it's observing (KVO) the scrollview

@property (nonatomic, retain) UILabel * label;

@property (nonatomic, retain) NSString * pullingText;       // Displayed in _label while pulling
@property (nonatomic, retain) NSString * releaseText;       // Displayed in _label before releasing
@property (nonatomic, retain) NSString * loadingText;       // Displayed in _label while loading
@property (nonatomic, retain) NSString * loadedText;        // Displayed in _label when loading did finish

@property (nonatomic, copy) void (^pullToRefreshHandler)(void);   // The block executed when triggering pull refresh
@property (nonatomic, copy) void (^pullToLoadMoreHandler)(void);  // The block executed when triggering pull load more

/**
 Initializes the view with the linked scrollview.
 @param scrollView The scrollview where to apply the pull refresh view.
 */
- (id)initWithScrollView:(UIScrollView *)scrollView;

/**
 Pulls the scrollview to refresh the contents, scrolling it up.
 The intented use of this method is to pull refresh programatically.
 */
- (void)pullToRefresh;

/**
 Hides the pull refresh view. Use it to notify the pull refresh view that the content have been refreshed.
 */
- (void)refreshFinished;

/**
 Sets the background color.
 @param backgroundColor the background color.
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor;

/**
 Sets the activity indicator style, displayed while loading.
 @param style the activity indicator style.
 */
- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

@end

#pragma mark - [Interface] AHPullToRefreshView (Private)

@interface AHPullToRefreshView (Private)

- (void)startObservingScrollView;
- (void)stopObservingScrollView;

- (void)scrollViewDidScroll:(CGPoint)contentOffset;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (UIEdgeInsets)scrollViewContentInset;
- (void)setState:(AHPullViewState)state;
- (void)layoutSubviews:(NSTimer *)timer;

- (void)pullAfterProgrammaticScroll;
- (void)layoutSubviewsToMaxFraction;

@end

#pragma mark - [Interface] AHTableView (Private)

@interface UIScrollView (AHTableViewPrivate)

@property (nonatomic, assign) BOOL isPullToRefreshEnabled;
@property (nonatomic, assign) BOOL isPullToLoadMoreEnabled;

@end

#pragma mark - AHPullToRefreshView

@implementation AHPullToRefreshView

@synthesize isObservingScrollView = _isObservingScrollView;

@synthesize label = _label;

@synthesize pullingText = _pullingText;
@synthesize releaseText = _releaseText;
@synthesize loadingText = _loadingText;
@synthesize loadedText = _loadedText;

@synthesize pullToRefreshHandler;
@synthesize pullToLoadMoreHandler;

#pragma mark - View lifecycle

- (id)initWithScrollView:(UIScrollView *)scrollView {
  
  self = [super initWithFrame:CGRectMake(0, -kAHPullView_ViewHeight/2, _scrollView.bounds.size.width, kAHPullView_ViewHeight)];
  
  if (self) {
    
    // View setup
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    // Ivars init
    _scrollView = scrollView;
    _originalScrollViewContentInset = [_scrollView contentInset];
    [self setBackgroundColor:[UIColor clearColor]];
    
    _pullingText =  [NSLocalizedString(@"继续拉刷新",@"") retain];
    _releaseText = [NSLocalizedString(@"松开立即刷新",@"") retain];
    _loadingText = [NSLocalizedString(@"正在加载...",@"") retain];
    _loadedText = [NSLocalizedString(@"",@"") retain];
  }
  return self;
}

- (void)dealloc {
  
  [self stopObservingScrollView];
  
  AHRelease(_backgroundView);
  AHRelease(_activityIndicator);
  AHRelease(_backgroundColor);
  AHRelease(_label);
  
//  self. pullToRefreshHandler = nil;
  AHRelease(_pullingText);
  AHRelease(_releaseText);
  AHRelease(_loadedText);
  AHRelease(_loadingText);
  [super dealloc];
}

#pragma mark - Public methods

- (void)pullToRefresh {
  
  // If the it's actually loading or being pulled we avoid loading
  if (_state != AHPullViewStateHidden) {
    return;
  }
  
  // Stop observing scrollview
  [self stopObservingScrollView];
  
  // If pull to load more is not enabled then scroll to top
  BOOL isPullToLoadMoreEnabled = [_scrollView isPullToLoadMoreEnabled];
  if (!isPullToLoadMoreEnabled) {
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth([_scrollView frame]), CGRectGetHeight([_scrollView frame])) animated:YES];
  }
  
  // Set the state to triggered programmatically
  [self setState:AHPullViewStateTriggeredProgramatically];
  
  // If it's triggered programatically avoid the user interaction
  [_scrollView setScrollEnabled:NO];
  
  // The delay to prevent overlapping animations. It will be between 0.1 and 0.5 seconds
  CGFloat delay = MAX(MIN(_scrollView.contentOffset.y/CGRectGetHeight([_scrollView frame]),0.1),0.5);
  [self performSelector:@selector(pullAfterProgrammaticScroll) withObject:nil afterDelay:delay];
}

- (void)pullToLoadMore {
  
  // If the it's actually loading or being pulled we avoid loading
  if (_state != AHPullViewStateHidden) {
    return;
  }
  
  // Stop observing scrollview
  [self stopObservingScrollView];
  
  // If pull to refresh is not enabled then scroll to bottom
  BOOL isPullToRefreshEnabled = [_scrollView isPullToRefreshEnabled];
  if (!isPullToRefreshEnabled) {
    CGRect rect = CGRectMake(0, _scrollView.contentSize.height - CGRectGetHeight([_scrollView frame]), CGRectGetWidth([_scrollView frame]), CGRectGetHeight([_scrollView frame]));
    [_scrollView scrollRectToVisible:rect animated:YES];
  }
  
  // Set the state to triggered programmatically
  [self setState:AHPullViewStateTriggeredProgramatically];
  
  // If it's triggered programatically avoid the user interaction
  [_scrollView setScrollEnabled:NO];
  
  // The delay to prevent overlapping animations. It will be between 0.1 and 0.5 seconds
  CGFloat delay = MAX(MIN(_scrollView.contentOffset.y/_scrollView.contentSize.height,0.1),0.5);
  [self performSelector:@selector(pullAfterProgrammaticScroll) withObject:nil afterDelay:delay];
}

- (void)refreshFinished {
  
  // Set the state to hidden with a delay
  AHPullViewState state = AHPullViewStateHidden;
  SEL selector = @selector(setState:);
  NSMethodSignature *ms = [self methodSignatureForSelector:selector];
	NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:ms];
	[invocation setTarget:self];
	[invocation setSelector:selector];
	[invocation setArgument:&state atIndex:2];
  
  // Note: if called programatically quickly has a visual bug that the unfolding of the 3d view remains stuck. That's why there's a delay.
  if (_state == AHPullViewStateLoadingProgramatically) {
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:0.3];
  }
  else {
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:0.0];
  }
  
  // Apply an alpha anim to the view
  [UIView animateWithDuration:0.3
                   animations:^{[_scrollView pullToLoadMoreView].alpha = 0;}
                   completion:^(BOOL finished){ if (finished) { [_scrollView pullToLoadMoreView].alpha = 1;}}];
  
  // Show the user the scroll indicators
  [_scrollView performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:0.35];
}

- (void)setPullToRefreshHandler:(void (^)(void))handler {
  
  [pullToRefreshHandler release];
  pullToRefreshHandler = [handler copy];
  
  // UI setup
  [_scrollView addSubview:self];
  [_scrollView sendSubviewToBack:self];
  
  _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
  [_backgroundView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
  [self.layer addSublayer:_backgroundView.layer];
  
  _label = [[UILabel alloc] initWithFrame:[_backgroundView frame]];
  _label.text = _loadedText;
  _label.font = [UIFont boldSystemFontOfSize:14];
  [_label setTextAlignment:NSTextAlignmentCenter];
  _label.backgroundColor = [UIColor clearColor];
  _label.textColor = [UIColor darkGrayColor];
  [_label setCenter:_backgroundView.center];
  [self addSubview:_label];
  
  _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _activityIndicator.hidesWhenStopped = YES;
  [self addSubview:_activityIndicator];
  
  // Set the state to hidden
  [self setState:AHPullViewStateHidden];
}

- (void)removeRefreshHandler
{
  [_activityIndicator removeFromSuperview];
  [_label removeFromSuperview];
  [_backgroundView removeFromSuperview];
}



- (void)setPullToLoadMoreHandler:(void (^)(void))handler {
  
  [pullToLoadMoreHandler release];
  pullToLoadMoreHandler = [handler copy];
  
  // UI setup
  [_scrollView addSubview:self];
  
  _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
  [_backgroundView.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
  [self.layer addSublayer:_backgroundView.layer];
  
  _label = [[UILabel alloc] initWithFrame:[_backgroundView frame]];
  _label.text = _loadedText;
  _label.font = [UIFont boldSystemFontOfSize:14];
  [_label setTextAlignment:NSTextAlignmentCenter];
  _label.backgroundColor = [UIColor clearColor];
  _label.textColor = [UIColor darkGrayColor];
  [_label setCenter:_backgroundView.center];
  [self addSubview:_label];
  
  _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  _activityIndicator.hidesWhenStopped = YES;
  [self addSubview:_activityIndicator];
  
  // Set the state to hidden
  [self setState:AHPullViewStateHidden];
}

// This method is actually an UIView override
- (void)setBackgroundColor:(UIColor *)backgroundColor {
  
  // Set the color for the background view instead of the actual view
  [_backgroundColor release];
  _backgroundColor = [backgroundColor retain];
  [_backgroundView setBackgroundColor:_backgroundColor];
}

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
  
  [_activityIndicator setActivityIndicatorViewStyle:style];
}

#pragma mark - Private methods

/**
 Starts observing the scrollview if it wasn't already.
 */
- (void)startObservingScrollView {
  
  if (_isObservingScrollView) {
    return;
  }
  
  [_scrollView addObserver:self
                forKeyPath:kAHPullView_ContentOffsetKey
                   options:NSKeyValueObservingOptionNew
                   context:nil];
  
  [_scrollView addObserver:self
                forKeyPath:kAHPullView_FrameKey
                   options:NSKeyValueObservingOptionNew
                   context:nil];
  
  self.isObservingScrollView = YES;
}

/**
 Stops observing the scrollview if it was observing.
 */
- (void)stopObservingScrollView {
  
  if (!_isObservingScrollView) {
    return;
  }
  
  [_scrollView removeObserver:self forKeyPath:kAHPullView_ContentOffsetKey];
  [_scrollView removeObserver:self forKeyPath:kAHPullView_FrameKey];
  
  self.isObservingScrollView = NO;
}

/**
 Called when detected changes on scrollview offset. Deals with the states.
 */
- (void)scrollViewDidScroll:(CGPoint)contentOffset {
  
  if (pullToRefreshHandler) {
    
    // If it's loading do nothing
    if (_state == AHPullViewStateLoading) {
      
      // Do nothing
    }
    // If it was loaded programmatically force to layout to max fraction
    else if (_state == AHPullViewStateLoadingProgramatically) {
      
      [self layoutSubviewsToMaxFraction];
    }
    else {
      
      // Layout subviews when the view is becoming visible (to make the 3D transform happens)
      if (_state == AHPullViewStateVisible) {
        [self layoutSubviews];
      }
      
      // Set the state depending on the current state, if the user is dragging and the content y offset
      CGFloat scrollOffsetYThreshold = CGRectGetMinY(self.frame) * 2 - _originalScrollViewContentInset.top;
      CGFloat contentOffsetY = contentOffset.y;
      BOOL scrollViewIsDragging = [_scrollView isDragging];
      
      if (_state == AHPullViewStateTriggered &&
          !scrollViewIsDragging) {
        
        [self setState:AHPullViewStateLoading];
      }
      else if (_state == AHPullViewStateTriggeredProgramatically) {
        
        [self setState:AHPullViewStateLoadingProgramatically];
      }
      else if ((_state != AHPullViewStateLoading && _state != AHPullViewStateLoadingProgramatically) &&
               scrollViewIsDragging &&
               contentOffsetY > scrollOffsetYThreshold &&
               contentOffsetY < - _originalScrollViewContentInset.top) {
        
        [self setState:AHPullViewStateVisible];
      }
      else if (_state == AHPullViewStateVisible &&
               scrollViewIsDragging &&
               contentOffsetY < scrollOffsetYThreshold) {
        
        [self setState:AHPullViewStateTriggered];
      }
      else if (_state != AHPullViewStateHidden &&
               contentOffsetY >= - _originalScrollViewContentInset.top) {
        
        [self setState:AHPullViewStateHidden];
      }
    }
  }
  else if (pullToLoadMoreHandler) {
    
    // Adjust the frame when scrolling
    [self setFrame:CGRectMake(0, _scrollView.contentSize.height + CGRectGetHeight(self.frame),
                              CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
    
    // If it's loading do nothing
    if (_state == AHPullViewStateLoading) {
      
      // Do nothing
    }
    // If it was loaded programmatically force to layout to max fraction
    else if (_state == AHPullViewStateLoadingProgramatically) {
      
      [self layoutSubviewsToMaxFraction];
    }
    else {
      
      // Layout subviews when the view is becoming visible (to make the 3D transform happens)
      if (_state == AHPullViewStateVisible) {
        [self layoutSubviews];
      }
      
      // Set the state depending on the current state, if the user is dragging and the content y offset
      CGFloat scrollOffsetYThreshold = _scrollView.contentSize.height - _scrollView.frame.size.height;
      CGFloat contentOffsetY = contentOffset.y;
      BOOL scrollViewIsDragging = [_scrollView isDragging];
      
      if (_state == AHPullViewStateTriggered &&
          !scrollViewIsDragging) {
        
        [self setState:AHPullViewStateLoading];
      }
      else if (_state == AHPullViewStateTriggeredProgramatically) {
        
        [self setState:AHPullViewStateLoadingProgramatically];
      }
      else if ((_state != AHPullViewStateLoading && _state != AHPullViewStateLoadingProgramatically) &&
               scrollViewIsDragging &&
               contentOffsetY > scrollOffsetYThreshold &&
               contentOffsetY < scrollOffsetYThreshold + self.frame.size.height) {
        
        [self setState:AHPullViewStateVisible];
      }
      else if (_state == AHPullViewStateVisible &&
               scrollViewIsDragging &&
               contentOffsetY > scrollOffsetYThreshold) {
        
        [self setState:AHPullViewStateTriggered];
      }
      else if (_state != AHPullViewStateHidden &&
               contentOffsetY <= scrollOffsetYThreshold) {
        
        [self setState:AHPullViewStateHidden];
      }
    }
  }
}

/**
 Sets the scroll view content inset considering if pull refresh and/or load more is enabled.
 @param the scroll view content inset.
 */
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
  
  [UIView animateWithDuration:0.3
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     _scrollView.contentInset = contentInset;
                   }
                   completion:^(BOOL finished){}];
}

/**
 Calculates the scroll view's content offset depending on if the pull refresh and/or the pull to load more is enabled.
 @return the scroll view's content offset.
 */
- (UIEdgeInsets)scrollViewContentInset {
  
  BOOL isPullToRefreshEnabled = [_scrollView isPullToRefreshEnabled];
  BOOL isPullToLoadMoreEnabled = [_scrollView isPullToLoadMoreEnabled];
  
  UIEdgeInsets newInsets = _originalScrollViewContentInset;
  
  // If pull to refresh is enabled increase the top inset with the upper frame position
  if (isPullToRefreshEnabled) {
    
    CGFloat offset = _originalScrollViewContentInset.top + kAHPullView_ViewHeight;
    newInsets.top = newInsets.top + offset;
  }
  
  // The same applies for pull to load more, but with the bottom inset
  if (isPullToLoadMoreEnabled) {
    
    CGFloat offset = _originalScrollViewContentInset.bottom + kAHPullView_ViewHeight;
    newInsets.bottom = newInsets.bottom + offset;
  }
  
  return newInsets;
}

/**
 Sets the current state applying the corresponding UI updates.
 */
- (void)setState:(AHPullViewState)state {
  
  if (_state == state)
    return;
  
  _state = state;
  
  
  switch (_state) {
    case AHPullViewStateHidden:
      
      // Notify the scrollview
      if (pullToRefreshHandler) {
        
        [_scrollView setIsPullToRefreshEnabled:NO];
      }
      else if (pullToLoadMoreHandler) {
        
        [_scrollView setIsPullToLoadMoreEnabled:NO];
      }
      
      // Update the UI
      [_label setText:_loadedText];
      [_activityIndicator stopAnimating];
      
      // Adjust the content inset
      UIEdgeInsets contentInset = [self scrollViewContentInset];
      [self setScrollViewContentInset:contentInset];
      break;
      
    case AHPullViewStateVisible:
      
      // Update the UI
      [_label setText:_pullingText];
      break;
      
    case AHPullViewStateTriggered:
      
      // Update the UI
      [_label setText:_releaseText];
      break;
      
    case AHPullViewStateTriggeredProgramatically:
      
      // Do nothing
      break;
      
    case AHPullViewStateLoading:
    case AHPullViewStateLoadingProgramatically:
    {
      // Change the position of the activity indicator
      CGSize textSize = [_loadingText sizeWithFont:[_label font]];
      CGPoint activityIndicatorCenter = CGPointMake([_label center].x - textSize.width/2 - CGRectGetWidth([_activityIndicator frame]), [_label center].y);
      [_activityIndicator setCenter:activityIndicatorCenter];
      [_label setText:_loadingText];
      
      // Start animating the activity indicator
      [_activityIndicator startAnimating];
      
      if (pullToRefreshHandler) {
        
        // Notify the scrollview
        [_scrollView setIsPullToRefreshEnabled:YES];
        
        // Set the new scrollview insets
        UIEdgeInsets contentInset = [self scrollViewContentInset];
        [self setScrollViewContentInset:contentInset];
        
        // If pull to load more is not enabled, then set content offset to top
        BOOL isPullToLoadMoreEnabled = [_scrollView isPullToLoadMoreEnabled];
        if (!isPullToLoadMoreEnabled) {
          
          [_scrollView setContentOffset:CGPointMake(0, -self.frame.size.height) animated:YES];
        }
        
        // Execute the pull handler block
        pullToRefreshHandler();
      }
      else if (pullToLoadMoreHandler) {
        
        // Notify the scrollview
        [_scrollView setIsPullToLoadMoreEnabled:YES];
        
        // Set the new scrollview insets
        UIEdgeInsets contentInset = [self scrollViewContentInset];
        [self setScrollViewContentInset:contentInset];
        
        // If pull to refresh is not enabled, then set content offset to bottom
        BOOL isPullToRefreshEnabled = [_scrollView isPullToRefreshEnabled];
        if (!isPullToRefreshEnabled) {
          
          [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentSize.height - CGRectGetHeight([_scrollView frame])+ self.frame.size.height) animated:YES];
        }
        
        // Execute the pull handler block
        pullToLoadMoreHandler();
      }
      break;
    }
  }
}

/**
 Called by a timer to layout the subviews periodically.
 @param timer The timer that fired this method.
 */
- (void)layoutSubviews:(NSTimer *)timer {
  
  [self layoutSubviews];
}

/**
 Called when pull refresh or pull load more is called programatically, after scrolling respectively the scrollview to top or to bottom.
 */
- (void)pullAfterProgrammaticScroll {
  
  // Start observing
  [self startObservingScrollView];
  
  // Enable the user interaction (only changes if it was triggered programmatically)
  [_scrollView setScrollEnabled:YES];
  
  // Set the state to loading
  [self setState:AHPullViewStateLoadingProgramatically];
  
  // Force layout subview while performing the 3d animation
  BOOL isTheOtherPullViewEnabled = NO;
  if (pullToRefreshHandler) {
    isTheOtherPullViewEnabled = [_scrollView isPullToLoadMoreEnabled];
  }
  else if (pullToLoadMoreHandler) {
    isTheOtherPullViewEnabled = [_scrollView isPullToRefreshEnabled];
  }
  
  // If the other pull view is not enabled then layout the subviews during 0.5s
  if (!isTheOtherPullViewEnabled) {
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(layoutSubviews:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer performSelector:@selector(invalidate) withObject:nil afterDelay:0.5];
  }
}

/**
 Forces the layout subviews to the max fraction.
 */
- (void)layoutSubviewsToMaxFraction {
  
  [super layoutSubviews];
  
  if (self.pullToRefreshHandler) {
    
    // Subviews repositioning
    [_backgroundView setFrame:CGRectMake(0, -kAHPullView_ViewHeight/2, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
    [_label setFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
    CGSize textSize = [_loadingText sizeWithFont:[_label font]];
    CGPoint activityIndicatorCenter = CGPointMake([_label center].x - textSize.width/2 - CGRectGetWidth([_activityIndicator frame]), [_label center].y);
    [_activityIndicator setCenter:activityIndicatorCenter];
    
    // Set the backgroundView color
    [_backgroundView setBackgroundColor:_backgroundColor];
    
  }
  else if (self.pullToLoadMoreHandler) {
    
    // Subviews repositioning
    [_backgroundView setFrame:CGRectMake(0, -kAHPullView_ViewHeight, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
    [_label setFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
    CGSize textSize = [_loadingText sizeWithFont:[_label font]];
    CGPoint activityIndicatorCenter = CGPointMake([_label center].x - textSize.width/2 - CGRectGetWidth([_activityIndicator frame]), [_label center].y);
    [_activityIndicator setCenter:activityIndicatorCenter];
    
    // Set the backgroundView color
    [_backgroundView setBackgroundColor:_backgroundColor];
  }
}

#pragma mark - UIView overrides

- (void)addSubview:(UIView *)view {
  [_backgroundView addSubview:view];
  [self bringSubviewToFront:_activityIndicator];
  [self bringSubviewToFront:_label];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  
  if (newSuperview == _scrollView) {
    
    [self startObservingScrollView];
  }
  else if (newSuperview == nil) {
    
    [self stopObservingScrollView];
  }
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
  if (self.pullToRefreshHandler) {
    
    // Subviews repositioning
    [_backgroundView setFrame:CGRectMake(0, -kAHPullView_ViewHeight/2, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
    [_label setFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
    CGSize textSize = [_loadingText sizeWithFont:[_label font]];
    CGPoint activityIndicatorCenter = CGPointMake([_label center].x - textSize.width/2 - CGRectGetWidth([_activityIndicator frame]), [_label center].y);
    [_activityIndicator setCenter:activityIndicatorCenter];
    
    // Calculate the offset percentage (considering the height of this view * 2)
    CGFloat fraction = ((CGRectGetMinY(self.frame)*2 - _scrollView.contentOffset.y) / CGRectGetMinY(self.frame));
    fraction = MIN(MAX(fraction,0),1);
    
    // Set the backgroundView color
    [_backgroundView setBackgroundColor:_backgroundColor];
  }
  else if (self.pullToLoadMoreHandler) {
    
    // Subviews repositioning
    [_backgroundView setFrame:CGRectMake(0, -kAHPullView_ViewHeight, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
    [_label setFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(self.frame))];
    CGSize textSize = [_loadingText sizeWithFont:[_label font]];
    CGPoint activityIndicatorCenter = CGPointMake([_label center].x - textSize.width/2 - CGRectGetWidth([_activityIndicator frame]), [_label center].y);
    [_activityIndicator setCenter:activityIndicatorCenter];
    
    // Calculate the offset percentage (considering the height of this view * 2)
    CGFloat fraction = (CGRectGetMinY(self.frame) - CGRectGetHeight(_scrollView.frame) - _scrollView.contentOffset.y) / CGRectGetHeight(self.frame);
    fraction = MIN(MAX(1+fraction,0),1);
    
    // Set the backgroundView color
    [_backgroundView setBackgroundColor:_backgroundColor];
  }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:kAHPullView_ContentOffsetKey]) {
    
    [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
  }
  else if ([keyPath isEqualToString:kAHPullView_FrameKey]) {
    
    [self layoutSubviews];
  }
}

@end

// --------------------------------------------------------------------------------
#pragma mark - AHTableView

static char kAHTV_Key_PullToRefreshView;
static char kAHTV_Key_IsPullRefreshEnabled;
static char kAHTV_Key_PullToLoadMoreView;
static char kAHTV_Key_IsPullLoadMoreEnabled;

@implementation UIScrollView (AH3DPullRefresh)

@dynamic pullToRefreshView;
@dynamic pullToLoadMoreView;

#pragma mark - Public methods

#pragma mark > Init

- (void)setPullToRefreshHandler:(void (^)(void))handler {
  
  // If the view is nil, then it's created
  if (!self.pullToRefreshView) {
    
    self.pullToRefreshView = [[[AHPullToRefreshView alloc] initWithScrollView:self] autorelease];
  }
  
  [self.pullToRefreshView setPullToRefreshHandler:handler];
}

- (void)removeRefresh{

  [self.pullToRefreshView stopObservingScrollView];
  [self.pullToRefreshView removeRefreshHandler];
}

- (BOOL)isRefresh
{
  return self.pullToRefreshView.isObservingScrollView;
}

- (void)setPullToLoadMoreHandler:(void (^)(void))handler {
  
  // If the view is nil, then it's created
  if (!self.pullToLoadMoreView) {
    
    self.pullToLoadMoreView = [[[AHPullToRefreshView alloc] initWithScrollView:self] autorelease];
  }
  
  [self.pullToLoadMoreView setPullToLoadMoreHandler:handler];
}

- (void)removeLoadMore
{
  [self.pullToLoadMoreView stopObservingScrollView];
  [self.pullToLoadMoreView removeRefreshHandler];
}


- (BOOL)isLoadMore
{
  return self.pullToLoadMoreView.isObservingScrollView;
}

#pragma mark > Actions

- (void)pullToRefresh {
  
  [self.pullToRefreshView pullToRefresh];
}

- (void)pullToLoadMore {
  
  [self.pullToLoadMoreView pullToLoadMore];
}

- (void)refreshFinished {
  
  [self.pullToRefreshView refreshFinished];
}

- (void)loadMoreFinished {
  
  [self.pullToLoadMoreView refreshFinished];
}

#pragma mark > Customization

- (UILabel *)pullToRefreshLabel {
  
  return [self.pullToRefreshView label];
}

- (void)setPullToRefreshViewBackgroundColor:(UIColor *)backgroundColor {
  
  [self.pullToRefreshView setBackgroundColor:backgroundColor];
}

- (void)setPullToRefreshViewActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
  
  [self.pullToRefreshView setActivityIndicatorStyle:style];
}

- (void)setPullToRefreshViewPullingText:(NSString *)pullingText {
  
  [self.pullToRefreshView setPullingText:pullingText];
}

- (void)setPullToRefreshViewReleaseText:(NSString *)releaseText {
  
  [self.pullToRefreshView setReleaseText:releaseText];
}

- (void)setPullToRefreshViewLoadingText:(NSString *)loadingText {
  
  [self.pullToRefreshView setLoadingText:loadingText];
}

- (void)setPullToRefreshViewLoadedText:(NSString *)loadedText {
  
  [self.pullToRefreshView setLoadedText:loadedText];
}

- (UILabel *)pullToLoadMoreLabel {
  
  return [self.pullToLoadMoreView label];
}

- (void)setPullToLoadMoreViewBackgroundColor:(UIColor *)backgroundColor {
  
  [self.pullToLoadMoreView setBackgroundColor:backgroundColor];
}

- (void)setPullToLoadMoreViewActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
  
  [self.pullToLoadMoreView setActivityIndicatorStyle:style];
}

- (void)setPullToLoadMoreViewPullingText:(NSString *)pullingText {
  
  [self.pullToLoadMoreView setPullingText:pullingText];
}

- (void)setPullToLoadMoreViewReleaseText:(NSString *)releaseText {
  
  [self.pullToLoadMoreView setReleaseText:releaseText];
}

- (void)setPullToLoadMoreViewLoadingText:(NSString *)loadingText {
  
  [self.pullToLoadMoreView setLoadingText:loadingText];
}

- (void)setPullToLoadMoreViewLoadedText:(NSString *)loadedText {
  
  [self.pullToLoadMoreView setLoadedText:loadedText];
}

#pragma mark > Dynamic Ivars Getters/Setters

- (void)setPullToRefreshView:(AHPullToRefreshView *)aView {
  
  objc_setAssociatedObject(self, &kAHTV_Key_PullToRefreshView, aView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AHPullToRefreshView *)pullToRefreshView {
  
  return objc_getAssociatedObject(self, &kAHTV_Key_PullToRefreshView);
}

- (void)setPullToLoadMoreView:(AHPullToRefreshView *)aView {
  
  objc_setAssociatedObject(self, &kAHTV_Key_PullToLoadMoreView, aView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AHPullToRefreshView *)pullToLoadMoreView {
  
  return objc_getAssociatedObject(self, &kAHTV_Key_PullToLoadMoreView);
}

@end

#pragma mark - AHTableViewPrivate

@implementation UIScrollView (AHTableViewPrivate)

@dynamic isPullToRefreshEnabled;
@dynamic isPullToLoadMoreEnabled;

#pragma mark - Getters/Setters

- (void)setIsPullToRefreshEnabled:(BOOL)enabled {
  
  objc_setAssociatedObject(self, &kAHTV_Key_IsPullRefreshEnabled, [NSNumber numberWithBool:enabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isPullToRefreshEnabled {
  
  return [objc_getAssociatedObject(self, &kAHTV_Key_IsPullRefreshEnabled) boolValue];
}

- (void)setIsPullToLoadMoreEnabled:(BOOL)enabled {
  
  objc_setAssociatedObject(self, &kAHTV_Key_IsPullLoadMoreEnabled, [NSNumber numberWithBool:enabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isPullToLoadMoreEnabled {
  
  return [objc_getAssociatedObject(self, &kAHTV_Key_IsPullLoadMoreEnabled) boolValue];
}

@end
