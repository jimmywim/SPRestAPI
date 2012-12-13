SPRestAPI
=========

A Simple REST API Wrapper for SharePoint 2013
=======
### README - SPRestAPI

James Love (jimmywim)
December 13th 2012

This is a simple API for helping with authentication and calling the SharePoint REST APIs.

Detailed information about this API can be found on my blog here:
http://e-junkie-chronicles.blogspot.com/2012/12/sharepoint-2013-rest-api-in-ios.html

Note that this release doesn't have much in the way of error checking - it should bail nicely if you type a wrong username or password, but might work unexpected otherwise. I'll add more error checking in later.

If you screw up an API query, hopefully the response will be helpfully bundled into the response XML.

For brevity, here's a quick usage guide (i.e.: sample code):

### Log in:

    NSString *site = siteUrlField.text;
    NSString *username = usernameField.text;
    NSString *password = passwordField.text;
    
    SPClaimsHelper *spClaims = [[SPClaimsHelper alloc] initWithUsernamePasswordSite:username password:password site:site];
    [spClaims setDelegate:(id)self];
    [spClaims GetTokens];

### Handle response:

    - (void)tokenDelegate: (SPClaimsToken *)tokenClass didReceiveToken: (int)count
    {
        NSLog(@"Tokens received");
        MasterViewController *masterVC = [[MasterViewController alloc] init];
        [self presentViewController:masterVC animated:TRUE completion:nil];
    }



### Issue query (with queryId):

    SPRESTQuery *titleQuery = [[SPRESTQuery alloc] initWithUrlRequestId:@"http://mycompany.sharepoint.com/_api/web/Title" id:@"SiteTitle"];
    [titleQuery setDelegate:(id)self];
    [titleQuery executeQuery];



### Handle response:

    -(void)SPREST:(id)SPREST didCompleteQueryWithRequestId:(SMXMLDocument *)result requestId:(NSString *)requestId{
        
        if (requestId == @"SiteTitle")
        {
            SMXMLElement *bodyElement = result.root;
            NSString *titleText = [bodyElement value];
            self.navigationItem.title = titleText;
            webtitle = titleText;
        }
        [self.tableView reloadData];
    }


Cheerio!!