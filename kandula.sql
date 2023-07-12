----------------------------------------------------------
-- EMPTY THE DATABASE IN CASE IT CONTAINS CONTENT
----------------------------------------------------------
DROP TRIGGER IF EXISTS audit_trigger ON kandula.instances;
DROP FUNCTION IF EXISTS auditlogfunc();
DROP TABLE IF EXISTS kandula.instances_log;
DROP TABLE IF EXISTS kandula.instances;
DROP SCHEMA IF EXISTS kandula;

-----------------------------------
-- CREATE THE TABLE STRUCTURE
-----------------------------------

-- Create the database schemas
CREATE SCHEMA kandula;
SET SCHEMA 'kandula';
-- On psql:
-- SET search_path TO kandula;

-- Create a table for the Two Trees category data
CREATE TABLE kandula.instances (
    instance_id         VARCHAR(100) NOT NULL PRIMARY KEY,
    shutdown_time       TIME
);

CREATE TABLE kandula.instances_log(
    run_id              INT PRIMARY KEY,
    run_time            TIME,
    instance_id         VARCHAR(100),
    shutdown_time       TIME,
    CONSTRAINT FK_log_instances FOREIGN KEY(instance_id)
        REFERENCES instances(instance_id)
);
CREATE SEQUENCE run_id_seq OWNED BY kandula.instances_log.run_id;
ALTER TABLE kandula.instances_log ALTER COLUMN run_id SET DEFAULT nextval('run_id_seq');

CREATE OR REPLACE FUNCTION auditlogfunc() RETURNS TRIGGER AS $example_table$
   BEGIN
      INSERT INTO kandula.instances_log(run_time, instance_id, shutdown_time) VALUES (NOW(), new.instance_id, new.shutdown_time);
      RETURN NEW;
   END;
$example_table$ LANGUAGE plpgsql;

CREATE TRIGGER audit_trigger AFTER INSERT ON kandula.instances FOR EACH ROW EXECUTE PROCEDURE auditlogfunc();

-- INSERT INTO kandula.instances (instance_id, shutdown_time) VALUES ('test_id', NOW());
-- select * from kandula.instances_log;
-- select * from kandula.instances;
