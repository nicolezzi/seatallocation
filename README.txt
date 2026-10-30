================================================================================
               EXAM SEAT ALLOCATION SYSTEM — JAVA DESKTOP APPLICATION
================================================================================

1. PROJECT OVERVIEW
--------------------------------------------------------------------------------
The Exam Seat Allocation System is a native, professional Java desktop application 
designed for college academic administration. It provides automated, deterministic 
examination seating arrangement, student management, hall capacity planning, 
exam scheduling, live hall conflict detection, student seat lookup ("Find My Seat"), 
hall-wise attendance tracking, and printable seat allotment slips.

The system runs entirely locally on the computer without requiring any web server, 
internet connection, cloud service, or web browser.

The graphical interface was crafted to match the reference modern design 
system (1:1 visual fidelity) featuring navy-blue accents, soft slate backgrounds, 
clean typography, vector iconography, rounded card surfaces, and responsive 
card navigation.


2. KEY FEATURES
--------------------------------------------------------------------------------
1. Dashboard:
   - 4 Live Statistics Cards: Total Students, Total Exam Halls, Allocated Seats, 
     and Usable Remaining Seats.
   - Examination statistics selector for exam-specific analytics.
   - Quick Action buttons for instant access to key workflows.
   - Upcoming Examinations list with one-click allocation management.

2. Student Management:
   - Complete CRUD (Add, View, Edit, Search, Delete).
   - Search-as-you-type filtering by full name, register number, or department.
   - Input validation (non-empty fields, valid email format, unique register no).
   - Foreign-key protection: prevents deleting students with active seat assignments.

3. Exam Hall Management:
   - Add, edit, and delete examination halls.
   - Enforces positive seating capacities.
   - Capacity protection: blocks reducing capacity below the maximum allocated seats.
   - Prevents deletion of halls referenced by active examination seat assignments.

4. Exam and Subject Management:
   - Schedule examinations with Subject Name, Code, Date, Start Time, End Time, 
     Target Semester, and Status.
   - Hall Assignment Manager with real-time combined capacity computation.
   - Intelligent Schedule Conflict Prevention: detects and blocks hall double-booking 
     for overlapping exam times on the same date.
   - Validates that End Time is strictly later than Start Time.

5. Automatic Seat Allocation Algorithm:
   - Deterministic and fair allocation based on sorted student register numbers.
   - Automatically determines eligible candidates based on target semester.
   - Calculates available capacity and alerts with the exact shortfall if capacity 
     is insufficient (blocks partial/incomplete allocations).
   - Transactional safety: saves all allocations inside a single ACID database 
     transaction; commits only when every seat is assigned; rolls back on any error.
   - Protection against accidental overwriting of existing allocations.

6. Find My Seat (Student Self-Service):
   - Fast lookup by student register number.
   - Instant visual display of Student Name, Register Number, Course, Subject, 
     Exam Date & Time, Hall Name, and a prominent Seat Number badge.
   - Clear and informative empty states when a student is unregistered or unseated.
   - One-click "Print slip" button to print official allotment slips.

7. Hall-Wise Attendance Sheets:
   - Select exam and assigned hall to display allocated student roster.
   - In-place attendance status marking (Unmarked, Present, Absent).
   - Quick actions: "Mark All Present".
   - Live attendance counters (Total, Present, Absent, Unmarked).
   - Batch persistence into SQLite database with timestamps.
   - Printable formal attendance sheet formatted for invigilator signing.

8. Printable Documents (Java Printing API):
   - Seat Allotment Slip: Formatted card with institution headers, student details, 
     large seat badge, candidate instructions, and authorized signature lines.
   - Examination Attendance Sheet: Multi-column tabular roster with invigilator 
     and chief superintendent signature blocks.


3. TECHNOLOGIES USED
--------------------------------------------------------------------------------
- Language: Java (OpenJDK 17+ or OpenJDK 21/27)
- GUI Framework: Java Swing & AWT (Event Dispatch Thread, CardLayout, Java 2D Graphics)
- Database: SQLite 3
- Connectivity: JDBC (Java Database Connectivity) with sqlite-jdbc driver
- Driver Location: lib/sqlite-jdbc.jar
- Compiler & Runtime: javac and java


4. PROJECT DIRECTORY STRUCTURE
--------------------------------------------------------------------------------
/workspace/
├── src/
│   ├── Main.java                   # Main desktop application entry point
│   ├── TestSuite.java              # 30-point automated functional test suite
│   ├── GenerateScreenshots.java    # Headless GUI renderer & screenshot generator
│   ├── model/
│   │   ├── Student.java            # Student entity
│   │   ├── ExamHall.java           # Exam Hall entity
│   │   ├── Exam.java               # Examination entity
│   │   ├── Allocation.java         # Seat Allocation entity
│   │   └── Attendance.java         # Attendance entity
│   ├── dao/
│   │   ├── StudentDAO.java         # Student SQL operations & validation
│   │   ├── ExamHallDAO.java        # Hall SQL operations & capacity rules
│   │   ├── ExamDAO.java            # Exam SQL operations & conflict checks
│   │   ├── AllocationDAO.java      # Allocation SQL operations & transactions
│   │   └── AttendanceDAO.java      # Attendance SQL operations & batching
│   ├── service/
│   │   ├── AllocationService.java  # Deterministic allocation algorithm
│   │   └── DashboardService.java   # Real-time statistics aggregation
│   ├── ui/
│   │   ├── ModernUI.java           # Theme colors, fonts, vector icons & components
│   │   ├── DashboardFrame.java     # Main window & layout coordinator
│   │   ├── SidebarPanel.java       # Collapsible modern navy sidebar
│   │   ├── TopHeaderPanel.java     # Top bar with hamburger & status pill
│   │   ├── DashboardPanel.java     # Dashboard analytics & quick actions
│   │   ├── StudentsPanel.java      # Student management CRUD table & dialogs
│   │   ├── ExamHallsPanel.java     # Hall management CRUD table & dialogs
│   │   ├── ExamsPanel.java         # Exam management, scheduling & hall assignment
│   │   ├── SeatAllocationPanel.java# Allocation controller & summary results
│   │   ├── FindMySeatPanel.java    # Student seat lookup & slip viewer
│   │   ├── AttendancePanel.java    # Hall attendance marking & printing
│   │   └── AllotmentSlipPanel.java # Multi-student allotment slip browser
│   └── util/
│       ├── Database.java           # SQLite connection & schema initialization
│       ├── ValidationUtil.java     # Data validation rules
│       └── PrintUtil.java          # Java Printable implementations
├── lib/
│   └── sqlite-jdbc.jar             # SQLite JDBC Driver JAR
├── data/
│   └── exam_seat_allocation.db     # Permanent local SQLite database
├── screenshots/                    # Generated high-resolution GUI snapshots
├── compile.sh                      # Compilation script for Linux / macOS
├── run.sh                          # Execution script for Linux / macOS
├── compile.bat                     # Compilation script for Windows
├── run.bat                         # Execution script for Windows
└── README.txt                      # Project documentation


5. DATABASE SCHEMA
--------------------------------------------------------------------------------
The application creates the database and initializes tables automatically:

1. students:
   - id INTEGER PRIMARY KEY AUTOINCREMENT
   - register_number TEXT NOT NULL UNIQUE
   - full_name TEXT NOT NULL
   - department TEXT NOT NULL
   - semester TEXT
   - email TEXT

2. exam_halls:
   - id INTEGER PRIMARY KEY AUTOINCREMENT
   - hall_name TEXT NOT NULL UNIQUE
   - building TEXT
   - capacity INTEGER NOT NULL CHECK (capacity > 0)
   - description TEXT

3. exams:
   - id INTEGER PRIMARY KEY AUTOINCREMENT
   - exam_name TEXT NOT NULL
   - subject_name TEXT NOT NULL
   - subject_code TEXT
   - exam_date TEXT NOT NULL
   - start_time TEXT NOT NULL
   - end_time TEXT NOT NULL
   - semester TEXT
   - status TEXT NOT NULL DEFAULT 'Scheduled'

4. exam_hall_assignments:
   - id INTEGER PRIMARY KEY AUTOINCREMENT
   - exam_id INTEGER NOT NULL REFERENCES exams(id) ON DELETE CASCADE
   - hall_id INTEGER NOT NULL REFERENCES exam_halls(id) ON DELETE RESTRICT
   - UNIQUE (exam_id, hall_id)

5. allocations:
   - id INTEGER PRIMARY KEY AUTOINCREMENT
   - exam_id INTEGER NOT NULL REFERENCES exams(id) ON DELETE RESTRICT
   - student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE RESTRICT
   - hall_id INTEGER NOT NULL REFERENCES exam_halls(id) ON DELETE RESTRICT
   - seat_number TEXT NOT NULL
   - UNIQUE (exam_id, student_id)
   - UNIQUE (exam_id, hall_id, seat_number)

6. attendance:
   - id INTEGER PRIMARY KEY AUTOINCREMENT
   - exam_id INTEGER NOT NULL REFERENCES exams(id) ON DELETE CASCADE
   - student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE RESTRICT
   - status TEXT NOT NULL DEFAULT 'Unmarked'
   - recorded_at TEXT
   - UNIQUE (exam_id, student_id)


6. COMPILATION AND EXECUTION INSTRUCTIONS
--------------------------------------------------------------------------------
Prerequisites:
- Installed Java Development Kit (JDK 17 or later).
- 'lib/sqlite-jdbc.jar' placed inside the project lib/ directory.

Linux / macOS:
-------------
1. Compile:
   chmod +x compile.sh
   ./compile.sh
   (Or manually: javac -cp "lib/sqlite-jdbc.jar" -d out src/*.java src/model/*.java src/dao/*.java src/service/*.java src/ui/*.java src/util/*.java)

2. Run Application:
   chmod +x run.sh
   ./run.sh
   (Or manually: java -cp "out:lib/sqlite-jdbc.jar" Main)

3. Run Automated Test Suite:
   java -cp "out:lib/sqlite-jdbc.jar" TestSuite

4. Generate GUI Snapshots:
   java -Djava.awt.headless=true -cp "out:lib/sqlite-jdbc.jar" GenerateScreenshots

Windows:
--------
1. Compile:
   compile.bat
   (Or manually: javac -cp "lib\sqlite-jdbc.jar" -d out src\*.java src\model\*.java src\dao\*.java src\service\*.java src\ui\*.java src\util\*.java)

2. Run Application:
   run.bat
   (Or manually: java -cp "out;lib\sqlite-jdbc.jar" Main)

3. Run Automated Test Suite:
   java -cp "out;lib\sqlite-jdbc.jar" TestSuite


7. HOW SEAT ALLOCATION WORKS
--------------------------------------------------------------------------------
1. Candidate Selection:
   Students matching the exam's semester criteria are retrieved and sorted 
   alphabetically by Register Number (case-insensitive).

2. Usable Capacity Check:
   Assigned examination halls are retrieved and sorted consistently. The total 
   available capacity is computed by summing the individual capacities.
   If Eligible Students > Total Available Capacity, the allocation is safely 
   HALTED with an informative shortfall notification. No student is left partially seated.

3. Deterministic Sequential Allocation:
   Halls are filled sequentially. Seats are numbered 1, 2, 3... up to that hall's 
   capacity. Each eligible student receives exactly one seat.

4. Transactional Persistence:
   All seat allocations are written in a single SQLite database transaction. 
   If any insertion fails, the complete operation rolls back, preserving database integrity.


8. TEST RESULTS SUMMARY (ALL 30 TESTS PASSED)
--------------------------------------------------------------------------------
A comprehensive automated test suite (src/TestSuite.java) was executed against a 
temporary isolated database (data/test_seat_allocation.db):

 1. [PASS] Application starts successfully
 2. [PASS] SQLite database created automatically
 3. [PASS] Student records can be added
 4. [PASS] Student records can be edited
 5. [PASS] Students can be searched
 6. [PASS] Students can be deleted when safe
 7. [PASS] Duplicate register numbers rejected by SQLite UNIQUE constraint
 8. [PASS] Exam halls can be created
 9. [PASS] Hall capacity can be edited
10. [PASS] Capacity restrictions prevent reduction below occupied seat count
11. [PASS] Exams can be created and edited
12. [PASS] Invalid exam times rejected (End Time <= Start Time blocked)
13. [PASS] Overlapping hall assignments prevented (double-booking alert)
14. [PASS] Student eligibility calculated correctly by semester
15. [PASS] Seat allocation works when sufficient capacity exists
16. [PASS] Allocation rejected when capacity is insufficient (shortfall alert)
17. [PASS] Existing allocations protected from accidental overwrite
18. [PASS] Duplicate seat assignments prevented by database constraints
19. [PASS] Duplicate student allocations prevented by database constraints
20. [PASS] Allocation transactions roll back cleanly on foreign key errors
21. [PASS] Dashboard statistics accurate and reactive
22. [PASS] Find My Seat returns correct allocation
23. [PASS] Unallocated students receive clear guidance
24. [PASS] Attendance sheets show only students assigned to the selected hall
25. [PASS] Attendance records save and reload correctly with timestamps
26. [PASS] Allotment slips contain complete student, exam, and seat details
27. [PASS] Attendance sheet printing implementation verified
28. [PASS] Data remains available after closing and reopening application
29. [PASS] SQLite foreign keys enforced on every database connection
30. [PASS] GUI operations and services execute without errors

Total: 30 Passed, 0 Failed (100% Pass Rate).


9. BACKUP AND DATA SAFETY
--------------------------------------------------------------------------------
- Database file is located at: data/exam_seat_allocation.db
- Backup: To make a backup, simply copy `data/exam_seat_allocation.db` to a secure location.
- Restore: To restore, replace `data/exam_seat_allocation.db` with your backup copy 
  while the application is closed.
- Reset: To reset the database to sample demo data, delete `data/exam_seat_allocation.db`. 
  The application will automatically recreate the database and reload demo records on launch.
================================================================================
