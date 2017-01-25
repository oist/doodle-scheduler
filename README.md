# doodle-scheduler
Scheduler for a Photoshoot using a Doodle Poll

Procedure to generate the schedule

1. Export data from Doodle as an Excel file. 

2. Export the data to a CSV file keeping only the rows starting with a name

3. Update the name of the CSV in photoshoot.hs

4. Run main in photoshoot.hs, the output will be output.csv and printed in the terminal too

Remarks:

- You have to manually list the time slots that you want to populate in main
- If some timeslots were forgotten in the Doodle, plug them in in the Excel file and consider the new timeslot as available only if the previous and next timeslots were available.
- Switching the rows in the CSV will produce different outputs, as the algorithms places the first people to appear first
