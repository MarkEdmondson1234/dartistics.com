# RWorkshopCopenhagen
Files for the R Workshop with Tim 

## Workflow

1. Pull from github
2. Make your changes
3. Build website in RStudio
4. Commit your changes
5. Push

### Build website

This will only succeed if you have a `.httr-oauth` file in the same directory - this is not uploaded to github as it holds auth data for all the websites you have access to (e.g. the `.httr-oauth` file is specified in the `.gitignore` file and ignored by Git)

You may make a local `.httr-oauth` file via `googleAnalyticsR::ga_auth()`.  This will sit in your local folder and take care of auth for your local version.  I also have my own auth file sitting in my local folder.  If you don't do this before building the website the error `interactive environment needed` will show as its trying to get you to login to Google in the script without you there to say its ok.

A demo in the website uses Mark's blog GA account, which is rebuilt everytime the website is built (e.g. it downloads data etc.)  

If the Google account that you authenticated with doesn't have access, it won't work with a `you don’t have sufficient permissions` error. 

E-mail Mark to get access with your Google email that you will authenticate with, and once added, `Build Website` should now succeed.

### If conflict

Potentially, if we make a change to the same bit of a file, git will say "conflict detected" in one of the files. 

Don't panic.

Open the file, and it will have ">>>>>>HEAD" and ">>>> MASTER" etc. inserted in the file.  Delete out all the stuff you don't want (e.g. you choose which version wins the conflict), then recommit/push.
