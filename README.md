 # Hospital Management Database System

 A relational **Hospital Management Database System** built with MySQL to model and manage core hospital operations, including patient admissions, room assignments, physician and nurse management, medical orders, medication administration, health records, billing, invoices, and payments.

 The project focuses on designing a normalized relational database with strong entity relationships, foreign-key constraints, transactional workflows, automated billing logic, reusable database views, and analytical SQL queries. The database is designed around an EER model and translated into a complete relational schema containing entities such as `Patient`, `Room`, `Physician`, `Nurse`, `Order`, `MedicationType`, `HealthRecord`, `PatientRoomStay`, `PhysicianMonitors`, `OrderExecution`, and `MedicationAdministration`. 

 ## Key Features

 ### Patient & Hospital Operations

 * Patient registration and health-record management
 * Room assignments and patient admission/discharge tracking
 * Physician-to-patient monitoring relationships
 * Nurse assignment and medical order execution
 * Medication administration tracking
 * Room capacity and nightly-fee management

 The database uses primary keys, foreign keys, `ENUM` constraints, unique certification numbers, and cascading referential actions to maintain data integrity across the operational tables.  

 ### Billing & Financial Management

 The system includes a dedicated billing architecture for tracking patient charges and payments. Payables are categorized into **room, medication, and order charges**, with separate relationship tables connecting financial records to the underlying clinical activities. Invoices can aggregate multiple payable items for a patient. 

 Sample data covers patients, rooms, physicians, nurses, medical orders, medications, health conditions, room stays, order executions, medication administrations, invoices, payables, and payments.   

 ### Automated Billing with Triggers

 The project uses MySQL triggers to connect clinical operations with financial records automatically:

 * **Order execution trigger** — automatically creates a payable charge when a medical order is executed.
 * **Checkout trigger** — calculates room charges based on the patient's length of stay and room rate.
 * **Medication administration trigger** — calculates medication charges from unit cost and quantity administered.
 * **Discharge trigger** — updates applicable ongoing health records when a patient is discharged.
 * **Order validation trigger** — verifies that an order exists and that the patient is currently admitted before allowing execution.    

 This event-driven database logic reduces the need for application-level billing code and helps keep clinical and financial records synchronized.

 ### Transactional Workflows

 Stored procedures demonstrate how multi-step hospital operations can be handled atomically:

 **`usp_AdmitPatient`**

 * Registers a patient
 * Assigns the patient to a room
 * Creates an initial health record
 * Commits the complete admission only if all operations succeed
 * Rolls back the transaction when an SQL exception occurs

 **`usp_TransferPatient`**

 * Calculates the patient's current room usage
 * Checks the patient out of the existing room
 * Calculates the corresponding room charge
 * Creates a payable record
 * Assigns the patient to the new room
 * Uses a transaction and savepoint to protect the multi-step workflow.  

 ### Analytical SQL

 The repository contains **15 SQL queries** covering several levels of relational querying:

 * Multi-table joins
 * Aggregation and grouping
 * Nested and correlated subqueries
 * `HAVING` clauses with subqueries
 * `NOT EXISTS`
 * Conditional logic using `CASE`
 * Date calculations
 * Revenue and payment analysis
 * Healthcare workload analysis
 * Medication usage statistics
 * Room occupancy analysis
 * Patient balance analysis
 * Patient stay duration and room costs
 * Nurse workload and order execution statistics

 For example, the queries can retrieve currently admitted patients and their care teams, analyze monthly hospital revenue, identify patients with outstanding balances, calculate patient stay costs, and identify physicians with no current patients.    

 ### Database Views

 Reusable SQL views provide higher-level access to frequently needed operational and analytical information:

 * **`v_Patient_Balance`** — summarizes patient charges, payments, current balances, and balance status.
 * **`v_Staff_Directory`** — combines physician and nurse information into a unified staff directory.
 * **`v_Current_Admissions`** — provides information about currently admitted patients, rooms, admission dates, and length of stay.
 * **`v_Physician_Workload`** — summarizes active patient assignments, orders created, and average order values for physicians.
 * **`v_Medication_Summary`** — summarizes medication administration frequency, dosage, cost, and number of patients treated.    

 ## Repository Structure

 ```text
 Hospital_ManagementDatabase/
 ├── hospital-schema.sql
 ├── hospital-data.sql
 ├── hospital-query.sql
 ├── hospital-view.sql
 ├── hospital-trigger.sql
 ├── hospital-transaction.sql
 └── Project_Report.pdf
 ```

 **`hospital-schema.sql`** — Creates the database and relational schema, including tables, primary keys, foreign keys, constraints, and relationships.

 **`hospital-data.sql`** — Populates the database with sample hospital data covering patients, staff, rooms, orders, medications, admissions, medical activity, billing, invoices, and payments.

 **`hospital-query.sql`** — Contains the project's analytical and operational SQL queries.

 **`hospital-view.sql`** — Defines reusable database views for financial, operational, staffing, and medication analysis.

 **`hospital-trigger.sql`** — Implements automated billing, validation, and discharge-related database behavior.

 **`hospital-transaction.sql`** — Contains transactional stored procedures for patient admission and room transfer workflows.

 **`Project_Report.pdf`** — Documents the EER design, relational mapping, assumptions, SQL queries, views, triggers, and transaction logic. The EER design explicitly models strong entities, weak entities, relationship tables, and the invoice/payable subsystem.  

 ## Technologies

 * **MySQL**
 * SQL
 * Relational Database Design
 * EER Modeling
 * Primary & Foreign Keys
 * Constraints & Referential Integrity
 * Joins & Aggregations
 * Nested/Correlated Queries
 * Views
 * Stored Procedures
 * Transactions & Savepoints
 * Database Triggers

 ## Project Objective

 The goal of this project is to demonstrate how a real-world hospital's operational and financial processes can be represented using a relational database. Rather than functioning as a simple collection of tables, the system uses database-level logic to model relationships between clinical activity and billing, automate recurring financial operations, enforce business rules, and provide analytical queries for hospital administration.

 Overall, the project demonstrates practical database engineering concepts including **relational modeling, normalization, data integrity, complex SQL querying, transaction management, event-driven database logic, and analytical reporting**.
