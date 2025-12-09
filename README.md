# LeagueiOSChallenge

## Overview
The goal of this challenge is to create a basic social media app to showcase your engineering
skills.
- API documentation for this challenge can be found here
- A project is provided to assist in getting started

## Considerations
- You have creative control over the designs, but won’t be graded on it
- We use UIKit primarily; however, you’re welcome to create your own project or modify
any of the provided code
- Well-structured projects and self-documenting code are greatly appreciated

## Requirements

### General

- Do not use any third party libraries for this challenge.
- Do not use AI systems during the application process.
- Add in unit tests where appropriate.

# Developer Notes

## How to run
- Download the app.
- Open LeagueiOSChallenge.xcodeproj (Project was developed using XCode 16.4 with a minimum iOS version of 15.4).
- Build and Run.

## Assumptions
- Didn't added to much validation on the login but It was designed simpler
and easy to update.
- On PostListViewModel it was assumed that the userService.fetchUsers() will
retrieve all the users for every post retrieved.

## Code
- Used skeleton app provided as an starting point of the project.
- Used MVVM as pattern architechture.
- Used Swift concurrency for the services.
- Views were developed programmatically.
- Didn't want to add delegation methods or Task in the ViewControllers in order.
to not create biggers ViewControllers.

## Future Improvements
- Improve validations (username and password) and better focus strategy in  on login.
- Add theme of colors in order to have the tint and the main colors in one place. 
- Add more Unit Tests.
- Polish transitions.
- Add more information user info on the User Profile Screen.
- API should be aligned with screen UI (Actually we need to make more than one request to retrive the full information on the Post list).
- In case of no API modification find a better way to cache users on app side.

## Considerations
- The whole loading state was developed a long time ago by me. I wanted
to check if it still valid.
- The Responses were created using https://quicktype.io/ in order to agilize development.
- The Mocks on UITest were created using https://github.com/seanhenry/SwiftMockGeneratorForXcode in order to agilize development.