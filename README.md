Original App Design Project 
===

# Tennis Connect

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
App that connects local tennis players for matches and practice. Accounts made based on phone number. Parse database to keep track of users. Google maps SDK to display courts and their availability. App keeps track of court availability. Users can indicate that they want to play on a date and app is able to suggest players that users can reach out to, connecting through the app, based on skill level, location, availability, court availability etc. 


### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Health and fitness, social
- **Mobile:** An app facilitates easy connection between players every step of the way, from finding opponents to the location and time. 
- **Story:** It's hard to find people to play with without joining a club. Aside from the cost of joining these clubs, in places without well-established ones, finding people to play with is near impossible. 
- **Market:** Tennis players
- **Habit:** Whenever someone wants to play tennis. 
- **Scope:** In its most boiled down form, this app is just a social app, which should be feasible to implement. There are also many additional features that can make the app much better including reminders for scheduled events, sharing progress, a friends feature etc. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can register a new account 
* User can login/logout 
* User can view where local tennis courts are 
* users can send or not send match request
* user can use camera to verify match progress/outcome
* user can view current match requests
* user can view their information
* user can view  match record

**Optional Nice-to-have Stories**

* calendar integration for match time suggestions
* when user match requests, they choose a court, which will indicate to other users that the court if not available
* coach status and dedicated coach searches, complete with ratings and reviews 
* user can make match requests to other players
* court availability schedule depending on matches that are scheduled and operating hours
* ratings system that adjusts player rating according to match history and initial experience level
* user can view match record
* user can view their skill level
* user can view skill view progress based on opponent feedback

### 2. Screen Archetypes

* Login/Register
   *  User can register a new account 
   *  User can login/logout 
* Map View
    * User can view where local tennis courts are 
* Detail 
    * users can send or not send match request
* Stream 
    * user can use camera to log match outcome
    * user can view current match requests
    * user can view  match record
* Profile 
    * user can view their information



### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Map View
* Detail
* Stream
* Profile

**Flow Navigation** (Screen to Screen)

* Login/Register
   *  Profile
* Map View
    * Detail 
    * Stream 
    * Profile
* Detail 
    * Map View 
    * Stream 
    * Profile
* Stream 
    * Map View 
    * Dertail 
    * Profile
* Profile 
    * Map View 
    * Detail Stream 
    * Stream 
    * Login/Register

## Wireframes
<img src="https://github.com/xuangela/Tennis-Connect/blob/master/wireframes.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

https://hackmd.io/nlx2lZ54SheLKY6OgKzVzA?both
