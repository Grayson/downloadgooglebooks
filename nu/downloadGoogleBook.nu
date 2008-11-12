(class GoogleBooksDownloader is NSObject
     (ivar 	(id) pageHTML
           (id) delegate)
     
     (ivar-accessors)
     
     (+ (id) downloader is
        (((self class) new) autorelease))
     
     (- (id) downloadBookAtURL:(id) url pages:(int) numberOfPages is
		(unless (/&output=html/ findInString:(url description))
			(set url (+ (url description) "&output=html")))
        (set pages (NSMutableArray array))
        (if (!= (NSURL class) (url class))
            (set url (NSURL URLWithString:url)))
        (self setPageHTML:(NSString stringWithContentsOfURL:url))
        (numberOfPages times:(do (pageNumber)
                                 (pages addObject:(self _downloadCurrentPage))
                                 (if ((self delegate) respondsToSelector:"downloadedPage:of:")
                                     ((self delegate) downloadedPage:(+ 1 pageNumber) of:numberOfPages))
                                 (set m (/.*<a href="(.*?)"  accesskey="n"/ findInString:(self pageHTML)))
                                 (set x (NSURL URLWithString:(m groupAtIndex:1)))
                                 (self setPageHTML:(NSString stringWithContentsOfURL:x)) ))
        (pages) )
     
     (- (id) _downloadCurrentPage is
        (set m (/\.html_page_image { background-image: url\("(.*?)\"\)/ findInString:(self pageHTML)))
        (set pageURL (NSURL URLWithString:(m groupAtIndex:1)))
        (set page ((NSImage alloc) initWithContentsOfURL:pageURL))
        (page))
     
     (- (id) joinedImageFromPageArray:(id) pageArray is
        (set maxWidth 0)
        (set maxHeight 0)
        (pageArray each:(do (page)
                            (set size (page size))
                            (set w (head size))
                            (set h (head (tail size)))
                            (if (> w maxWidth) (set maxWidth w))
                            (if (> h maxHeight) (set maxHeight h)) ))
        (set img ((NSImage alloc) initWithSize:(list maxWidth (* maxHeight (pageArray count)) )) )
        (img lockFocus)
        (set yPos (* maxHeight (pageArray count)))
        (pageArray each:(do (page)
                            (page dissolveToPoint:(list 0 (- yPos maxHeight)) fraction:1.0)
                            (set yPos (- yPos maxHeight)) ))
        (img unlockFocus)
        (img) )
     )