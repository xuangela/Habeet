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
* user can use camera to set pfp
* user can view current match requests
* user can view their information
* user can view  match record

**Optional Nice-to-have Stories**

* user can set time and location for match requests
* calendar integration for match time suggestions
* user can edit and resend match requests from other players
* ratings system that adjusts player rating according to match history and initial experience level
* user can view their skill level
* opponent feedback for player's sportsmanship
* alerts for upcoming matches, received and confirmed requests
* record of missed matches, impacting future match ups
* user can update their court search, not have it be based on their current location
    * can search in the map for the location and tap a location to display the courts in that area

**Extra reach stories**
* coach status and dedicated coach searches, complete with ratings and reviews 
* doubles matches

### 2. Screen Archetypes

* Login/Register
   *  User can register a new account 
   *  User can login/logout 
   * user can use camera to set pfp
* Map View
    * User can view where local tennis courts are 
* Detail 
    * users can send or not send match request
* Stream 
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

### Models


**Match**


| Property | Type | Description |
| -------- | -------- | -------- |
| Sender     | pointer to PFUser     | unique id for player who sent the match request|
| Receiver     | pointer to PFUser     | unique id for player who sent the match request|
| Court     | pointer to Court     | court location, generated using foursquare api|
| time     | DateTime     | what time the match is scheduled at|
| confirmed     | Boolean   | is everything confirmed?|
| completed     | Boolean    | did the players play?|
| Score     | array of numbers      | set and match points|




**User**

| Property | Type | Description |
| -------- | -------- | -------- |
| years played     | Number | used in match suggestion|
| name     | String     | first or full depending on visibilty settings|
| age     | Number     | visibility dependent on settings|
| pfp     | File     | jpeg converted to binary|
| caption     | String   | description of experience|
| gender     | String    | visibility dependent on settings|
| settingsore     | array of boolean       | visibility, suggestion filtering, court options|
| confirmed requests     | array of pointers to Matches    | confirmed by both players|
|sent match requests     | array of pointers to Matches    | sent by this user|
| received match requests    | array of pointers to Matches    | received by this user|
| viable courts    | array of pointer to Court    | generated at registration (closest 10?)|


**Court** 

| Property | Type | Description |
| -------- | -------- | -------- |
| players     | array of pointers to Users | players who have this court in their viable courts list|
| name     | String     | name of the court|
| coordinates     | array of Number     | CLLocationCoordinate2D, lat and long using WGS 84 reference frame|


### Networking

* Login/Register
* Map View
* Detail 
* Stream 
* Profile 
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

https://hackmd.io/nlx2lZ54SheLKY6OgKzVzA?both
