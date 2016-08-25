# RWorkshopCopenhagen
Files for the R Workshop with Tim 

## Workflow

1. Pull from github
2. Make your changes
3. Build website in RStudio
4. Commit your changes
5. Push

### Build website

This will only succedd if you have a `.httr-oauth` file in the same directory - this is not uploaded to github as it holds auth data.  You may one via `googleAnalyticsR::ga_auth()`

The demo uses Mark's blog GA account for some demos.  If your Google account that you authenticated with soesn't have access, it won't work.  Email Mark to get access with your Google email that you will authenticate with, and once added, Build Website should now succeed.

### If conflict

Potentially, if we make a change to the same bit of a file, it will say "conflict detected" in one of the files. 

Don't panic.

Open the file, and it will have ">>>>>>HEAD" and ">>>> MASTER" etc. inserted in the file.  delete out all the stuff you don't want (e.g. you choose which version wins the conflict), then recommit/push.
