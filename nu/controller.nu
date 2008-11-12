(class DGBController is NSObject
	(ivar 	(id) progressIndicator
			(id) urlField
			(id) numberField
			(id) printButton
			(id) book
			(int) pageCount)
	(ivar-accessors)
	
	(- (id) fetch:(id)sender is
		((self printButton) setEnabled:NO)
		(set url (NSURL URLWithString:((self urlField) stringValue)))
		(set count ((self numberField) intValue))
		(self setPageCount:count)
		(NSThread detachNewThreadSelector:"beginThreadedFetch:" toTarget:self withObject:url) )
		
	(- (id) beginThreadedFetch:(id)url is
		((self progressIndicator) setMaxValue:((self pageCount) doubleValue))
		((self progressIndicator) setHidden:NO)
		((self progressIndicator) setDoubleValue:0.0)
		(set downloader (GoogleBooksDownloader new))
		(downloader setDelegate:self)
		(set arr (downloader downloadBookAtURL:url pages:(self pageCount)))
		(self setBook:(downloader joinedImageFromPageArray:arr)) )
	
	(- (id) downloadedPage:(int) pageNumber of:(int) totalPages is
		(if (== pageNumber totalPages)
			((self progressIndicator) setHidden:YES)
			((self printButton) setEnabled:YES) )
		((self progressIndicator) setDoubleValue:(pageNumber doubleValue)) )
	
	(- (id) print:(id)sender is
		(set size ((self book) size))
		(set w (car size))
		(set h (car (cdr size)))
		(set view ((NSImageView alloc) initWithFrame:(list 0 0 w h)))
		(view setImageScaling:2)
		(view setImage:(self book))
		(set info (NSPrintInfo sharedPrintInfo))
		(info setJobDisposition:"NSPrintPreviewJob") ; "NSPrintSaveJob"
		(info setVerticalPagination:0)
		(info setPaperSize:(list w (/ h (self pageCount))))
		(info setBottomMargin:0)
		(info setTopMargin:0)
		(info setLeftMargin:0)
		(info setRightMargin:0)
		(set operation (NSPrintOperation printOperationWithView:view printInfo:info))
		(operation setShowsPrintPanel:NO)
		(operation runOperation) )
	)