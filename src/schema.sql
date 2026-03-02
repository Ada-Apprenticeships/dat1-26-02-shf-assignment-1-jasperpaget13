.open fittrackpro.db
.mode column

DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;

PRAGMA foreign_keys = ON;

CREATE TABLE locations (
    location_id CHECK (
        location_id GLOB '[0-9]') PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL
    CHECK (length(address) >=5),
    phone_number TEXT NOT NULL 
    CHECK ( 
        length(phone_number) BETWEEN 10 AND 15 
        AND phone_number GLOB '[0-9]*'
    ),
    email TEXT NOT NULL
    CHECK (
        length(email) BETWEEN 6 AND 254
        AND email LIKE '%_@_%._%'
    ),
    opening_hours TEXT NOT NULL 
    CHECK (
        opening_hours GLOB '[0-2][0-9]:[0-5][0-9]-[0-2][0-9]:[0-5][0-9]'
    )
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY
    CHECK (member_id BETWEEN 1 AND 11),
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL
    CHECK (
        length(email) BETWEEN 6 AND 254
        AND email LIKE '%_@_%._%'
    ),
    phone_number TEXT NOT NULL 
    CHECK ( 
        length(phone_number) BETWEEN 10 AND 15 
        AND phone_number GLOB '[0-9]*'
    ),
    date_of_birth CHECK ( date_of_birth GLOB '[0-9][0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9]'),
    join_date TEXT
    CHECK (
        join_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(join_date) IS NOT NULL),
    emergency_contact_name TEXT NOT NULL,
    emergency_contact_phone TEXT NOT NULL 
    CHECK ( 
        length(emergency_contact_phone) BETWEEN 10 AND 15 
        AND emergency_contact_phone GLOB '[0-9]*'
    )
);   

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL
    CHECK (
        length(email) BETWEEN 6 AND 254
        AND email LIKE '%_@_%._%'
    ),
    phone_number TEXT NOT NULL 
    CHECK ( 
        length(phone_number) BETWEEN 10 AND 15 
        AND phone_number GLOB '[0-9]*'
    ),
    position TEXT
    CHECK (position IN ('Manager','Trainer','Receptionist','Maintenance')),
    hire_date TEXT
    CHECK (
        hire_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(hire_date) IS NOT NULL),
    location_id INTEGER
    CHECK ( location_id IN (1,2)),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id CHECK 
    (equipment_id GLOB '[0-9]') PRIMARY KEY, 
    name TEXT NOT NULL
    CHECK ( name IN ('Treadmill 2000','Elliptical Trainer','Smith Machine','Dumbbell Set')),
    type TEXT NOT NULL 
    CHECK ( type IN ('cardio','trainer','strength')),
    purchase_date TEXT
    CHECK (
        purchase_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(purchase_date) IS NOT NULL),
    last_maintenance_date TEXT
    CHECK (
        last_maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(last_maintenance_date) IS NOT NULL),
    next_maintenance_date TEXT
    CHECK (
        next_maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(next_maintenance_date) IS NOT NULL),
    location_id INTEGER
    CHECK ( location_id IN (1,2)),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE classes ( 
    class_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL 
    CHECK ( name IN ('Spin Class', 'Yoga Basics','HIIT')),
    description TEXT NOT NULL
    CHECK ( length(description) BETWEEN 10 AND 255),
    capacity INTEGER NOT NULL
    CHECK (capacity BETWEEN 1 AND 30),
    duration INTEGER NOT NULL,
    location_id INTEGER NOT NULL
    CHECK (location_id IN (1,2)),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    start_time TEXT NOT NULL
    CHECK (start_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]'
    AND DATETIME(start_time) IS NOT NULL),
    end_time TEXT NOT NULL 
    CHECK ( end_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]'
    AND DATETIME(end_time) IS NOT NULL),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE memberships (
    membership_id INTEGER NOT NULL PRIMARY KEY,
    member_id INTEGER NOT NULL,
    type TEXT NOT NULL
    CHECK ( type IN ('Standard','Premium')),
    start_date TEXT
    CHECK (
        start_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(start_date) IS NOT NULL),
    end_date TEXT
    CHECK (
        end_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(end_date) NOT NULL),
    status TEXT
    CHECK (status IN ('Inactive','Active')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL
    CHECK (location_id = 1),
    check_in_time TEXT NOT NULL
    CHECK (
        check_in_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]'
        AND datetime(check_in_time) IS NOT NULL),
    check_out_time TEXT NOT NULL
    CHECK (
        check_out_time GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]'
        AND datetime(check_out_time) IS NOT NULL),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    attendance_status TEXT NOT NULL
        CHECK (attendance_status IN ('Registered','Attended','Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL
    CHECK (member_id BETWEEN 1 AND 11),
    amount TEXT NOT NULL
    CHECK (amount GLOB '[0-9][0-9]*.[0-9][0-9]'),
    payment_date TEXT NOT NULL
    CHECK (
        payment_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]'
        AND datetime(payment_date) IS NOT NULL),
    payment_method TEXT NOT NULL
    CHECK (
        payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type TEXT NOT NULL
    CHECK ( 
        payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    session_date TEXT
    CHECK (
        session_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(session_date) IS NOT NULL), 
    start_time TEXT NOT NULL
        CHECK (
            start_time GLOB '[0-2][0-9]:[0-5][0-9]:[0-5][0-9]'),
    end_time TEXT NOT NULL
        CHECK (
            end_time GLOB '[0-2][0-9]:[0-5][0-9]:[0-5][0-9]'),
    notes TEXT
    CHECK (
        notes IN ('Cardio focus','Strength training','Form check')),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    measurement_date TEXT NOT NULL
    CHECK (
        measurement_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(measurement_date) IS NOT NULL),
    weight TEXT NOT NULL
    CHECK  (weight GLOB '[0-9][0-9]*.[0-9]'),
    body_fat_percentage TEXT NOT NULL
    CHECK (body_fat_percentage GLOB '[0-9][0-9]*.[0-9]'),
    muscle_mass TEXT NOT NULL
    CHECK (muscle_mass GLOB '[0-9][0-9]*.[0-9]'),
    bmi TEXT NOT NULL
    CHECK (bmi GLOB '[0-9][0-9]*.[0-9]'),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER NOT NULL,
    maintenance_date TEXT
    CHECK (
        maintenance_date GLOB '[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]'
        AND DATE(maintenance_date) IS NOT NULL),
    description TEXT NOT NULL
    CHECK (
        description IN ('Belt replacement','Oiling and sensor check','Safety bar adjustment')
    ),
    staff_id INTEGER NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
);