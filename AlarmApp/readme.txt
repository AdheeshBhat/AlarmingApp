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
    - Code full priority flow
    - Code all buttons except custom for RepeatSettings (including Repeat Until logic)
    - Use date picker for calendar (make it look like Figma screen)

6. editReminderScreen
    - Populate existing info for reminder that was clicked
    - Reuse functionality from createReminderScreen

7. Find and migrate to a data store for our reminders dictionary
    - firebase?
    - AWS?
    - want free storage

8. Calendar

9. Finalize allReminders view in Figma
10. Code filtering logic for pressing a month in AllReminders
    - put this in filteringReminders
11. Styling changes to relfect Figma state for home screen and reminders screen, no hard coded values (should work for all screens)
    Change device from iPhone 16 Pro to iPad...



Low Priority Fixes
1. Remove blue highlight when moving away from page (home & reminders screens)
2. All Reminders view
