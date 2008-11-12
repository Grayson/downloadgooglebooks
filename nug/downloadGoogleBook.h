@interface GoogleBooksDownloader : NSObject {}
+ (id) downloader;
- (id) downloadBookAtURL: (id) url pages: (int) numberOfPages;
- (id) _downloadCurrentPage;
- (id) joinedImageFromPageArray: (id) pageArray;
@end

