tell application "Reminders"
    set now to (current date)
    set oneMonthAgo to (now - (30 * days))

    repeat with eachList in lists
        if name of eachList is "2025" then
            log "Skipping list: " & name of eachList
        else
            set remindersToDelete to {} -- Create an empty list to batch delete later

            repeat with eachReminder in (reminders of eachList)
                set isCompleted to completed of eachReminder
                set dueDate to due date of eachReminder
                
                if (not isCompleted) and (dueDate is missing value) then
                    set creationDate to creation date of eachReminder
                    set modificationDate to modification date of eachReminder

                    if (creationDate < oneMonthAgo) and (modificationDate < oneMonthAgo) then
                        set end of remindersToDelete to eachReminder -- Collect reminders for batch deletion
                    end if
                end if
            end repeat

            repeat with r in remindersToDelete
                log "Deleting: " & name of r & " (Created: " & creation date of r & ", Modified: " & modification date of r & ")"
                delete r
            end repeat
        end if
    end repeat
end tell
