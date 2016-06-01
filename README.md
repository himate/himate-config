## Settings for the HiMate Apps and Environments

The `settings.json` are being deployed by the dedicated jenkins jobs. 

The files are encrypted with `openssl`. 
Encryption can be managed through the `manage.sh` script. 
In order to use that script, please make sure that `openssl` is installed.

### Decrypt settings

Each staging environment (`live`, `beta`, `dev`) has its own dedicated password file:

```
live_pass_file
beta_pass_file
dev_pass_file
``` 

Make sure to place those files (with the password inside) at the root dir of this repository. 

**Decrypt all config files**
```
manage.sh -d
```

**Decrypt only live and dev config files**
```
manage.sh -d -s live,dev
```

The decrypted files will have the same name like the encrypted ones (without `.enc` at the ending).

### Encrypt settings

Once you made changes to one of the config files, make sure it gets encrypted.

**Encrypt all config files**
```
manage.sh -e
```

**Encrypt only live and dev config files**
```
manage.sh -e -s live,dev
```

#### Admin App
Meteor settings for admin app in LIVE environment: `live/admin/settings.json(.enc)`

Meteor settings for admin app in BETA environment: `beta/admin/settings.json(.enc)`

#### Customer App
Meteor settings for customer app in LIVE environment: `live/customer/settings.json(.enc)`

Meteor settings for customer app in BETA environment: `beta/customer/settings.json(.enc)`

#### Merchant App
Meteor settings for merchant app in LIVE environment: `live/merchant/settings.json(.enc)`

Meteor settings for merchant app in BETA environment: `beta/merchant/settings.json(.enc)`

#### Meteor settings for local development
For local development please use `dev/settings.json`
