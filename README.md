# Ribbit Reference Implementation (iOS)
The reference implementation for designing the iOS user interface of a broker-dealer trading application with the Alpaca [Broker API](https://alpaca.markets/docs/broker/). The iOS user interface is implemented using Swift. 

To read more about what Ribbit is, its use cases, how it works, and more check out our [Ribbit documentation](https://alpaca.markets/docs/broker/ribbit/). 

You can also access the [Ribbit Reference Implementation (Backend)](https://github.com/alpacahq/ribbit-backend) and [Ribbit Reference Implementation (Android)](https://github.com/alpacahq/ribbit-android) for a reference implementation of Ribbit’s backend and Android user interface.

## Caveat
This code is provided as open source for the purpose of demonstration of the Broker API usage. It is not designed for the production use and Alpaca does not offer official support of the code available in this repository.

## Overview
This application uses KYC for user verification and grants users from anywhere access to the U.S. Stock Market. 
See below for examples of various flows included in the app.

![image](https://user-images.githubusercontent.com/24945583/139148957-d65f2b90-6a7e-44c0-8b1a-4432d70298ab.png)

![image](https://user-images.githubusercontent.com/24945583/139149090-9baa220f-759e-407d-a6bc-aac1e5426b68.png)

![image](https://user-images.githubusercontent.com/24945583/139149132-777d5102-6045-4227-bce1-27c92f516db3.png)

## Development Setup
### Requirements
To get started, you’ll need to install Xcode 13.1 or newer from the Mac App Store. You’ll also need to install Homebrew, from https://brew.sh.   
Before you’re able to compile the app, you’ll need to install its dependencies. To do this, install the Cocoapods package manager from Homebrew:

$ brew install cocoapods

Then, acquire the dependencies:

$ pod install

When the Cocoapods operation is complete, you’ll see a new Ribbit.xcworkspace file. Open this with Xcode to continue.

You can then select the Ribbit scheme, and build & run the project.

![image](https://user-images.githubusercontent.com/24945583/139124544-a59f0395-aa37-463e-9edb-90be56134962.png)

