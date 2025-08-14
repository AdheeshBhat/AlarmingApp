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
- Make repeatUntil "forever"/"date" text white instead of gray                                              - Done
    - also dividers
- Test the app in all screens using lots of mock data & document/fix bugs                                   - Done
    - Notification screen is still only hard coded (removed)
        - REMOVE NOTIFICATION CENTER
        - possible expansion: to have a way to contact caretaker here
    - Text on priority flow is cut off (fixed)
    - When calendar is being displayed after re-entering RepeatUntil flow, the selectedDate is not shown
        - REVISIT THIS LATER
    - repeatSetting is not saved from newly created reminders, when edited (fixed)
    - HomeScreen does not show current date (fixed)
    - CreateReminder does not save time/date properly
    
-   + "Low Priority & Fixes"                                                                                - Done

7. All Reminders view
    - Figma all reminders view takes user to month reminder screen for selected month                       - Done
    - test AllReminders use cases using mock data from databaseMock                                         - Done
    
    PROPOSE NEW ALL REMINDERS FUNCTIONALITY -- have a way to go back to current month date, see if this is native funcationality
        - selector at the top of the reminders month view (ex. where it says "July 2025") that allows user to scroll through months/years to filter
        - same thing as AllReminders screen, but as a filter that can change on the same screen, instead of on a new screen
        - issue with current AllReminders:
            - once a month is selected from AllReminders, there is no way to remove this "filter" unless you click the back button
            
        - Remove AllReminders                                                                                           - Done
        - Move "Reminders" text into HStack next to CreateReminderScreen button, and make month/year picker bigger      - Done




8 Settings Screen
 - Create a gear button in the top left for settings screen                                                             - Done
 - Notification sound picker                                                                                            -       Needs local variable to save

9 Notifications/Alerts                                                                                                  - Done


10. Calendar
    - Color code circles based on number of reminders (length of list of reminders on a given day)                      - Done
        - Change the background of the date VStack, not circle                                                          - Done
    - Functional Calendar view toggle                                                                                   - Done
    - Calendar Week view                                                                                                - Done
    - Grid lines between dates                                                                                          -
    - Hide week/month filters when currentCalendarPeriodText is pressed
    - Reminder/calendar filter: week filter display shouldn't be linked to month filter (when month changes, week is changing too)
    - Reminder View for week/month calendars
        - Reminder dimensions should be variables, not hard coded values
    

11. Find and migrate to a data store for our reminders dictionary                                                        -
    - firebase?
    - AWS?
    - want free storage
    
12. Styling changes to relfect Figma state for home screen and reminders screen, no hard coded values (should work for all screens)     -
    Change device from iPhone 16 Pro to iPad...


Low Priority Fixes
1. Add AM and PM to all displayed times instead of  24 hr clock (for home screen and reminders screen)      - Done
2. Remove blue highlight when moving away from page (home & reminders screens)                              - Done
3. Add swiping feature for RemindersScreen and CalendarView                                                 - 
4. Light mode/dark mode                                                                                     -
