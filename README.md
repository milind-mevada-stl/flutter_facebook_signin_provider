# Facebook Sign-in Provider

An Implementation of Facebook sign-in based on dart Auth provider.

## Introduction
This packages is intended to easily integrate Facebook sign-in in Flutter based Application.

The package is responsible for the Facebook-Sign in and caching the session data. We can also provide a custom implementation of caching session data.


## Installation
**Step 1:** Add this package as a dependency in `pubspec.yaml` file.

```
flutter_facebook_signin:
    git:
      url: git@github.com:solutelabs/flutter_facebook_signin_provider.git
``` 

**Step 2:** Integrate Facebook-Sign in for Android and iOS. [Reference](https://pub.dev/packages/flutter_facebook_login)

## Usage
```
import 'package:flutter_facebook_signin/flutter_facebook_signin.dart';

...

await facebookSignInProvider(scopes: ['email']).signIn();
```
