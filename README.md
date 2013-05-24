SPRestAPI
=========

PLEASE NOTE THIS REPO IS NO LONGER MAINTAINED. THIS HAS BEEN MIGRATED TO:
https://github.com/jimmywim/SPMobile


A Simple REST API Wrapper for SharePoint 2013 for iOS Developers
=======
### README - SPRestAPI

James Love (jimmywim)

UPDATE - May 14th 2013
I have added a class that handles FormsAuthentication (called SPFormsAuth.m). This works in SharePoint 2010, which makes for an interesting point.
I have also added a couple of properties which can enhance the outgoing request, including setting a SOAPMethod, and adding a SOAP Payload. This actually allows you to call the bog standard ASMX web services in SharePoint, which means this can become a generic iOS SharePoint Library. 
This then means I might have to rename this project, and refactor hell of a lot of code to take away the 'REST' side of things. Anyway, if you want to use it with SharePoint 2010, you'll need to set the SOAPAction (using the setSoapAction message), set the method to POST, and finally set the payload. This needs to be the full SOAP envelope for your request. If I decide to rename and refactor this to a generic SharePoint library, then I'll probably simplify this such that you simply pass in a method name and the code will store the SOAP envelope for you, but I'll see how it goes.

If I do decide to rename the project, I'll keep this one alive but freeze it, and create a new project site with the new code in there. Watch this space!



December 13th 2012

This is a simple API for helping with authentication and calling the SharePoint REST APIs from iOS devices.

Full usage guide: https://github.com/jimmywim/SPRestAPI/wiki/Usage

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
