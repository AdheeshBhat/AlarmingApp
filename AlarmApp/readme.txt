Actions Items

1. Filtering criteria for reminders                                          - Done
2. Fix reminders view (on Figma) to tell us what day/week/month we're on based on filter - Done
3. Revisit filtering function to add in logic to display day/week/month we're on in reminders screen - Done
4. Make a helper function called addToDatabase                               - Done


Add toggle to home screen on Figma                                           - Done
Add all of the commented out fields to the reminder (in RemindersController) - Done
    - edit Database to include those fields
showIncompleteReminders function                                             - Done
 - make new file called filteringReminders
Experiment with putting all reminders in a scroll view (home screen)         - Done

Get all Home Screen buttons to work                                          - Done
    Hide completed reminders functionality (toggle)                          - Done
    Done button                                                              - Done
    Un-complete reminders                                                    - Done
      - "Are you sure" prompt (pop-up in the middle)                         - Done
      
Add "No Pending Tasks" for the Home Screen                                   - Done
Revisit "Delete reminders" toggle on reminders screen on Figma               - Done
Revisit Calendar toggles on Figma                                            - Done

Next Steps on Reminders Screen (Xcode)
 - Edit/Delete functionality                                                 - Done
 - "Delete reminders" toggle                                                 - Done
 


Revisit showEditButton/showDeleteButton and passing them into formattedReminders

5. createReminderScreen
    - Code full priority flow                                                                                    - Done
    - Code all buttons except custom for RepeatSettings (including Repeat Until logic)                           - Done
    - Use date picker for calendar (make it look like Figma screen)                                              - Done
    - reminderNameSet variable needs to be checked before user can click repeat, priority, or save reminder      - Done
    - create local variables for (title, description,) repeatUntil, time, priority, unlockReminder so            - Done
    that when user clicks back button, stuff is not saved
    - clicking the save reminder button should bring user back to previous screen                                - Done
    - For specific date, display actual date that the user picked                                                - Done
        - repeatSettingsFlow:                                                                                    - Done
        - define a string variable to use to check if specific date is pressed (get the checkmarks working)
        - localRepeatUntil should be a date type, something else should be used to check options("Forever","Specific Date")


6. editReminderScreen
    - Populate existing info for reminder that was clicked                                                  - Done
    - Replace Priority and Repeat text fields with the actual screens                                       - Done
    - create local variables for (title, description,) repeatUntil, time, priority so that                  - Done
    when user clicks back button, stuff is not saved
        - ensure final values of variables are not changed until save is pressed                            - Done
        
        
        

Minor Stuff
- Run through all the files, and add comments to make code more clear                                       -
- Make repeatUntil "forever"/"date" text white instead of gray                                              -
    - also dividers
- Test the app in all screens using lots of mock data & document/fix bugs                                   -
-   + "Low Priority & Fixes"                                                                                -

7. All Reminders view
    - Figma all reminders view takes user to month reminder screen for selected month                       - Done
    - test AllReminders use cases using mock data from databaseMock                                         -
    - change period, not dismiss for all three AllReminders filter buttons                                  -


7.5 Notifications/Alerts?


8. Find and migrate to a data store for our reminders dictionary
    - firebase?
    - AWS?
    - want free storage

9. Calendar

10. Code filtering logic for pressing a month in AllReminders
    - put this in filteringReminders
11. Styling changes to relfect Figma state for home screen and reminders screen, no hard coded values (should work for all screens)
    Change device from iPhone 16 Pro to iPad...



Low Priority Fixes
1. Add AM and PM to all displayed times instead of  24 hr clock (for home screen and reminders screen)
2. Remove blue highlight when moving away from page (home & reminders screens)
