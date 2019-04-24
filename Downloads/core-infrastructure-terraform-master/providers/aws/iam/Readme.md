# IAM Account
#
This account manages the following IAM Resources for River Island
  - Users
  - Groups

## Users
Users are created and managed in terraform, adding a user is detailed below.

Only the [code owners](https://github.com/River-Island/core-infrastructure-terraform/blob/master/.github/CODEOWNERS) of this folder can approve access requests.

## Groups

Each of the below groups can have their policies overriden with an argument into the module.

#### Operations

This is for support of the environment, by default its read only access across all environments.

#### Developers

Developers get read only access, unless overriden by a switch or a policy specified.
In general, Developers should get allow all access in development, and read only in staging and production.

#### Administrators

These users get read write to all environments. They should only be used in an emergency by anyone. This access should not be used to modify anything outside of resources managed by terraform!


## AWS account user account creation

The prerequisites for this process are that
 - You have a Github account with two factor authentication enabled
 - Your Github profile contains your first and last names
 - Your Github account has been added to the River-Island organisation using these instructions [here](http://documentation.ri-tech.io/github/)
 - You are running either Windows 10 or macOS 10+

The following section will guide you through securely requesting and provisioning an AWS account of your very own.

You will have one account and will be able to use it to access all environments that you are granted access to and can easily switch between them.

The process is a little labourious, however it has the following benefits:
 - We didn't have to buy any expensive system to manage this access more easily (although, we may in the future).
 - It is very secure.
   - Your identity will be validated.
   - Only you will ever have access to your credentials. Ever. Even your temporary password will be encrypted so only you can read it.
   - Every individual has their very own credentials. This means we can revoke them if you lose them or leave the company.
   - We enforce MFA for all new accounts for security reasons, which is an AWS Best Practice.
 - It is self-service.
 - Your request for access will be reviewed before it is granted.
 - All changes to who has access are audited.
 - You will have to demonstrate a basic understanding of the following:
   - GitHub workflow including creating a branch and raising a pull request.
   - Basic command execution.

If you get stuck, or encounter any issues, ask any existing users who have done this before for help, as seen in the list of users.

If you have to ask questions, the docs are broken! Therefore, update the docs to fix them in a way that makes it clear for the next user.

We are following [the boy scout rule](http://deviq.com/boy-scout-rule/) but for docs.

*Note: This process may require you to learn a little bit about PGP encryption and AWS IAM roles, and thus a little tedius and time consuming for some new users. However, the process follows AWS best practices to attain a high level of security and thus a slight tradeoff has been made over usability.*

To create a new user do the following:

  - Install [Keybase](https://keybase.io)
    - Create an account (via browser) - **Warning:** you might not receive the invite email if you try to do this from the desktop app (https://github.com/keybase/client/issues/6567)
    - Register your device (via browser - for the same reason)
  - we now need to generate a pgp key. There are a few options:
    - **Option 1:** The easy way - Using keybase:
	  - This is the easiest (& best) method as it gives you the option of automatically backing up an encrypted version of your secret key in keybase. It also works in the command prompt on Windows as well as the terminal on OSX.
      - generate pgp key pair: ```keybase pgp gen --multi```
	  - Enter your details and choose Y at all prompts.
    - **OR Option 2:** The hard way on OSX using the command line: (only for those who really know what they are doing)
      - install homebrew: https://brew.sh/
      - install gnupg: ```brew install gnupg```
      - generate pgp key pair: ```gpg --gen-key```  **Don't forget your password. You can't recover it!**
      - export and backup your public and private keys. More info [here](http://blog.ghostinthemachines.com/2015/03/01/how-to-use-gpg-command-line/)
        - ```cd ~/.gnupg/```
        - ```gpg --export-secret-keys your@email.com > mysecretkey.asc```
        - save **mysecretkey.asc** somewhere safe and don't lose it! This is your secret key.
        - ```gpg --export --armor your@email.com > mypubkey.asc```
        - save mypubkey.asc somewhere safe and don't lose it! This is your public key.
      - import your public key into keybase like so:
        ```keybase pgp import < mypubkey.asc```
        or if the above command doesn't work you can try:
        ```keybase pgp select```
  - Clone the [core-infrastructure-terraform](https://github.com/River-Island/core-infrastructure-terraform) repository and create a branch. Call the branch something sensible like 'add-{YOUR NAME}'.
  - In your local copy, add yourself to the list of users [here](https://github.com/River-Island/core-infrastructure-terraform/blob/master/providers/aws/iam/users.tf) and your user to the relevant accounts [here](https://github.com/River-Island/core-infrastructure-terraform/blob/master/providers/aws/iam/accounts.tf)
    - To understand which groups in which accounts you should add yourself to, read the groups section of this doc, or ask someone who is already a user.
    - If  you have terraform installed, then you can ensure that the files you've changed are formatted correctly by running `terraform fmt` in the iam folder. If they aren't, then the CI pipeline will fail.
  - Commit the changes and raise a pull request against master to be approved by administrators of the repo.
  - Once merged, go look at the [Concourse CI run](http://management-concourse.prod.transit.ri-tech.io/teams/aws-operations/pipelines/core-infrastructure-terraform/jobs/apply_non_product/builds/101) under the task ```apply_iam```, and go grab your encrypted password from the output of circle ci. There is one for each user. Grab the one below your username.
    - Currently there is a race condition that means that the build sometimes fails first time. Manually re-run the build from the Concourse UI to work around this issue.
	- Save the PGP message in a plain text file **pgp.txt**. The file should look something like this:
	  ```
      -----BEGIN PGP MESSAGE-----
      
      wcFMAzQbQicbQhy4ARAABjwFLTErlCIJHInupcrepgVS5X5Xt/sztLXCx5M2f6rHki+gp2tDQLLtrIf567qWunm1Uk3xMG/gvf7KUHu8Knm/U5P1i3SBNOV8Wv81N/oERdGV1mOzu7ipYsC80FK3b/v1fIk+uPrVVjbkkhpqPHrRQt9A1X9uMCCAOSP3/knbUsFphTYal+nSpjiwhwap/CqfQQtrXN/iOIyT0vz+EeH4o4V2lTT5MMfIZipQuBRtegTqf40s95FseC0WVzsI2Z2gTxwhft63oxkt8JlprE2rkxHRqaTzjJakq/tsM6rb3FHphk617eeexM7bICHZyUA9AYOxHEkd/fi7RqOn7Fa5lSDO3uF1jvMSG+aWj83Z30W97qhfEJe2tGjyum2BYGXIs43JOMyEm7HI3xXrUEcri47hTbnw2/IFYC15SMECNVdtPgBHARtwhXgDn5m2DTeARRjTKYbl07Ju7Tfvr9QCiJN/+7H7eUAXLRe7pP6yU2q/u+7GY0Hp04uuivBLu9FhCHd5ZGCx+rbieV5gloN+9qAok2e58uBeXvx8cOXtqAiunzZYOIkp0+NS9EVtACg6JoJkGekpw8RlT659sKTz0+xmC8SE5PZGnWYY5GcNs2W3AI+d0ZkytY7lTRP4bSsGqkjtWC8TqOZhZNzYR5HMcZGlmQ+A+WVnEUFbZTfS4AHkiww6KlyiBRY7S4hWNUpGBeGhruCQ4GXhPoLg6OJoxccA4JzkHxkKuxCQd9qH3XtEShdlsOCK4iwAIWng9uS3iZOIb4RrQVKkfnBUVodH4vlnqknhVN8A
      
      -----END PGP MESSAGE-----
      ```
    - Take care to respect the whitespace between the body and the header and footer.
    - Also make sure not to include the timestamps that will be copied when you copy from the concourse output.
  - Use keybase to decrypt your temporary password:
      - You can do this in the web browser, this is the easiest method:
	    - Open a browser at https://keybase.io/decrypt
		- Paste your encrypted password into the box. Remember when you copy it to include the header and footer.
		- Enter your Keybase passphrase and hit 'Decrypt'.
      - **OR** in the terminal on OSX:
        - `cat pgp.txt | keybase pgp decrypt; echo`
	  - **OR** in the command prompt on Windows:
	    - `type pgp.txt | keybase pgp decrypt`
      - **OR** if like willperkins you don't have the keybase application installed locally, you can use GPG directly to decrypt it without keybase:
	    - Open pgp.txt and remove the header and footer, so that it only contains the encrypted blob itself.
	    - `cat pgp.txt | base64 -D | gpg -d; echo`

  - Log in to the console of the IAM Account [https://riverisland.signin.aws.amazon.com/console](https://riverisland.signin.aws.amazon.com/console) using your new username and temporary password that you just decrypted.
  - You need to enable mfa through iam -> users -> your user -> Security Credentials (tab) -> Assigned MFA device (edit icon)
  - If you want to use an mfa app such as 'Authy' or 'Google Authenticator' select 'Virtual MFA Device' and then scan the QR code with your app of choice. 
  - **Log out and back in again so you have a valid mfa session. Otherwise you won't be able to do anything!**
  
Congratulations! You have now successfully and securely created your AWS account.

**Switch to Developer Account on AWS Console**
  - Go look at the [Concourse CI run](http://management-concourse.prod.transit.ri-tech.io/teams/aws-operations/pipelines/core-infrastructure-terraform/jobs/apply_non_product/builds/101) under the task ```apply_iam```, scroll all the way to the bottom of the page until you find '<your_aws_account>_switch_role_links' and copy the link to 'developers-dev'.
  - Open the link to 'developers-dev' in a browser. The link loads up a page with account name, role and display name prefilled. Hit Switch Role in order to be able to access AWS Services for any experiements/spikes.
  
## Creating AWS API keys

We will now go through the steps to create and securely manage your AWS API keys.
You only need to do this if you are planning on using the command line tools or terraform. It is not necessary for those just wanting access to the console.
  
  - Create AWS API keys (**If you can't create the keys, check if the above step is done.**)
  - Store these in your keychain or 1password. DO NOT STORE THESE UNENCRYPTED ON DISK!
  - When using your credentials you need to assume roles, you need to set up AWS profiles in ~/.aws/config
    *NOTE: The format ${placeholder} is used for variable substitution, replace these values where ever you see this*
    ```ini
    [default]
    region=eu-west-1

    [profile ${product_name}-${environment}]
    role_arn = arn:aws:iam::${product_environment_aws_account}:role/${group_name}
    mfa_serial=arn:aws:iam::667800118351:mfa/${aws_username}
    ```
  - Install [aws-vault](https://github.com/99designs/aws-vault/releases) this is going to manage switching roles for you.
  - set up your profiles in aws-vault
    - e.g `aws-vault add ${product_name}-${environment}` then enter your iam access keys.
  - you can now aws-vault exec ${product_name}-${environment} and supply your mfa token to create a secure AWS session that will expire.
  - If you want to use the console, and switch roles inside it, examine the output of a [CI run apply_non_product](http://management-concourse.prod.transit.ri-tech.io/teams/aws-operations/pipelines/core-infrastructure-terraform) to find the output switch_role_links in the terraform apply which is the `make apply` command. Each link lets you switch roles to the account, if you are a developer use the developer role links.

