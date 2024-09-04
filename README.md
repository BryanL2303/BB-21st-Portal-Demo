# README

BB 21st Portal
This website helps to facilitate administrative tasks such as creating 32A results and conducting quizzes.

# This version of the website is meant as a demo for showcase.
Build Status: 
This demo website is running with the following link:
https://bb-21-demo-e026dc5f2bdb.herokuapp.com/

Usage:
The website is used by the Boys' Brigade 21st Singapore Company

Installation and Configuration:
Methods to configure this website will not be discussed as it was created for a specific user base

Author:
Bryan Lee bryanlee0033@gmail.com

Changelog:
Version: 1.0
25 July 2023
First commit, website uploaded with functions for creating quizzes and attempting quizzes, fixed dependencies and website is up

26 July 2023
Bug fix for Form submissions

27 - 29 July 2023
Updated CSS for visual bugs

6 August 2023
Results generation function added to view cumulative results from quiz attempts as well as grading quizzes

Version 1.1
11 August 2023
Awards system recreated and results generation functions added to the website, functional but not fully complete.
Requires more frontend work to edit backend for awards informations

19 August 2023
Bug fix - text wrap not working for pdf documents

22 August 2023
Uniform Inspection form added to the website
Seed added with Uniform Inspection Components
Bug fixs:
 - Officers cannot create new officer accounts
 - Officers/Primers will no longer see Quiz Page meant for Boys'

26 August 2023
Updated UI for Uniform Inspection form to easily switch between a group of Boys' when conducting uniform inspection

3 October 2023
Testing to remove unnecessary components from the folder

10 November 2023
Updating UI for mobile use, created CSS for mobile devices
Increased sizes for certain components for ease of users.
Changed website title from Quiz Website to BB 21st Portal

9 May 2024
1. Added files to the docs folder
    1. DeveloperGuide.md
    2. index.md
    3. UserGuide.md
    4. DevOps.md
2. DeveloperGuide.md has been updated
    1. Includes target users and user stories.
    2. Design considerations for quizzes and questions.
    3. PUML diagrams have not been added yet.
    4. Have not updated use cases.
3. The other files added to docs has not been updated.

7 August 2024
1. Updated from Ruby version 3.1.2 to 3.3.4
2. Updated Browserslist: caniuse-lite with npx update-browserslist-db@latest

13 August 2024
1. Updated seedRecords to change Total Defense mastery names from basic ... mastery to bronze ... gold
2. Fixed bug where the delete account button does nothing. But interaction after button press needs to be reconsidered
3. Fixed bug where the custom fields header will appear for awards that does not have any custom fields
4. Fixed bug where the results generation form will be stuck in an infinite loop for certain awards
5. Fixed bug where the user creation form will show a default selected value for rank and level but it does not register when form is submitted
6. Fixed bug where the uniform inspection form will not update itself when switching between boys
7. Fixed bug where the custom description and fields on the frontend remains when switching between awards
8. Updated known issues section to reflect fixed bugs

14 August 2024
1. Fixed issue with package.json script/build not pointing to the correct path
2. Resolved missing npm modules @hotwired/turbo-rails and @hotwired/stimulus
3. Missing npm module @hotwired/stimulus-loading which does not exist, commented out the line and the build is working
4. Fixed wrong path to controller files in application.js and controller/index.js
5. Update scripts in package.json
6. Removed package-lock.json file
7. Uodate dependencies using yarn

16 August 2024
1. Fixed bug where non-Administrators are unable to update the credentials of Officers/Primers
2. Updated known issues
3. Updated ResultsGenerationPage to partially work with no existing primers, bugs are not fully fixed and cannot be redeployed

21 August 2024
1. Fixed bug where ResultsGenerationPage does not account for case where there are no Primers and/or Officers
2. Added improvements for the UserManagementPage to reload the userlist whenever there are any writes to the database

28 August 2024
1. Added image files in docs/image folder for User Guide
2. Updated UserGuide.md to provide clear step by step guide for each existing feature
3. Removed template paragraph from DeveloperGuide.md
4. Removed the quiz and question tabs from the navigation bar
5. Updated libraries used in index.md

29 August 2024
1. Created help page with link to user guide and scss for help page in desktop view
2. Fixed incorrect comments in user guide
3. Added route to help page from main app
4. Resized images in user guide

3 September 2024
1. Create AdminPage to view all tables and data
2. Create css for desktop version of administrator page
3. Create controller for administrator page with CRUD functions
4. Add route to administrator controller api
5. Add link to administrator page from navigation menu
6. Create DatabaseTable to display in AdminPage with functions to CRUD database entries

4 September 2024
1. Converted the backend into a demo version
2. Split this version from the actual website to create a demo copy