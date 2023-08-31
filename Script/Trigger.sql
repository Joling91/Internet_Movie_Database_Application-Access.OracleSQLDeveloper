CREATE OR REPLACE TRIGGER PERSON_VIEW_trigger
INSTEAD OF INSERT OR UPDATE OR DELETE ON PERSON_VIEW
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        -- Insert a new record into the FNAME table using the fname_seq sequence
        INSERT INTO FNAME (FNAME_id, first_name) VALUES (fname_seq.NEXTVAL, :new.first_name);
        -- Insert a new record into the LNAME table using the lname_seq sequence
        INSERT INTO LNAME (LNAME_id, last_name) VALUES (lname_seq.NEXTVAL, :new.last_name);
        -- Insert a new record into the PERSON table using the person_seq sequence
        INSERT INTO PERSON (person_id, director_id, actor_id) VALUES (person_seq.NEXTVAL, :new.director_id, :new.actor_id);
        -- Insert a new record into the PERSON_FNAME table
        INSERT INTO PERSON_FNAME (PF_id, person_id, FNAME_id, STARTDATE, ENDDATE) VALUES (person_fname_seq.NEXTVAL, person_seq.currval, fname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
        -- Insert a new record into the PERSON_LNAME table
        INSERT INTO PERSON_LNAME (PL_id, person_id, LNAME_id, STARTDATE, ENDDATE) VALUES (person_lname_seq.NEXTVAL, person_seq.currval, lname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
    END IF;

    IF UPDATING THEN
        IF :new.first_name <> :old.first_name AND :new.last_name <> :old.last_name THEN
            -- Handle both first name and last name changes at the same time
            -- Update the existing PERSON_FNAME and PERSON_LNAME entries with the current SYSDATE as ENDDATE
            UPDATE PERSON_FNAME
            SET enddate = TO_DATE(SYSDATE, 'DD/MM/YY')
            WHERE person_id = :new.person_id AND enddate IS NULL;

            UPDATE PERSON_LNAME
            SET enddate =  TO_DATE(SYSDATE, 'DD/MM/YY')
            WHERE person_id = :new.person_id AND enddate IS NULL;

            -- Insert new records into the FNAME and LNAME tables using the fname_seq and lname_seq sequences
            INSERT INTO FNAME (FNAME_id, first_name) VALUES (fname_seq.NEXTVAL, :new.first_name);
            INSERT INTO LNAME (LNAME_id, last_name) VALUES (lname_seq.NEXTVAL, :new.last_name);

            -- Insert new records into the PERSON_FNAME and PERSON_LNAME tables
            INSERT INTO PERSON_FNAME (PF_id, person_id, FNAME_id, STARTDATE, ENDDATE) VALUES (person_fname_seq.NEXTVAL, :new.person_id, fname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
            INSERT INTO PERSON_LNAME (PL_id, person_id, LNAME_id, STARTDATE, ENDDATE) VALUES (person_lname_seq.NEXTVAL, :new.person_id, lname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);

        ELSIF :new.first_name <> :old.first_name THEN
            -- Handle only first name change
            UPDATE PERSON_FNAME
            SET enddate = TO_DATE(SYSDATE, 'DD/MM/YY')
            WHERE person_id = :new.person_id AND enddate IS NULL;

            INSERT INTO FNAME (FNAME_id, first_name) VALUES (fname_seq.NEXTVAL, :new.first_name);
            INSERT INTO PERSON_FNAME (PF_id, person_id, FNAME_id, STARTDATE, ENDDATE) VALUES (person_fname_seq.NEXTVAL, :new.person_id, fname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);

        ELSIF :new.last_name <> :old.last_name THEN
            -- Handle only last name change
            UPDATE PERSON_LNAME
            SET enddate =  TO_DATE(SYSDATE, 'DD/MM/YY')
            WHERE person_id = :new.person_id AND enddate IS NULL;

            INSERT INTO LNAME (LNAME_id, last_name) VALUES (lname_seq.NEXTVAL, :new.last_name);
            INSERT INTO PERSON_LNAME (PL_id, person_id, LNAME_id, STARTDATE, ENDDATE) VALUES (person_lname_seq.NEXTVAL, :new.person_id, lname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);

        END IF;
    END IF;
    IF DELETING THEN
        -- Handle the DELETE action
        -- Delete the related records from the dependent tables
        DELETE FROM PERSON_FNAME
        WHERE person_id = :old.person_id;

        DELETE FROM PERSON_LNAME
        WHERE person_id = :old.person_id;
        -- Delete the associated FNAME record
        DELETE FROM FNAME
        WHERE FNAME_id = (SELECT FNAME_id FROM PERSON_FNAME WHERE person_id = :old.person_id);

        -- Delete the associated LNAME record
        DELETE FROM LNAME
        WHERE LNAME_id = (SELECT LNAME_id FROM PERSON_LNAME WHERE person_id = :old.person_id);

        -- Delete the associated PERSON record
        DELETE FROM PERSON
        WHERE person_id = :old.person_id;


    END IF;
END;
/


CREATE OR REPLACE TRIGGER ACTOR_VIEW_trigger
INSTEAD OF INSERT OR UPDATE OR DELETE ON ACTOR_VIEW
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        -- Insert a new record into the FNAME table using the fname_seq sequence
        INSERT INTO FNAME (FNAME_id, first_name) VALUES (fname_seq.NEXTVAL, :new.first_name);
        -- Insert a new record into the LNAME table using the lname_seq sequence
        INSERT INTO LNAME (LNAME_id, last_name) VALUES (lname_seq.NEXTVAL, :new.last_name);
        -- Insert a new record into the ACTOR table using the actor_seq sequence
        INSERT INTO ACTOR (actor_id, birth_year) VALUES (actor_seq.NEXTVAL, :new.birth_year);
        INSERT INTO PERSON (person_id, director_id, actor_id) VALUES (person_seq.NEXTVAL, null, actor_seq.CURRVAL);
        -- Insert a new record into the ACTOR_FNAME table
     -- Insert a new record into the PERSON_FNAME table
        INSERT INTO PERSON_FNAME (PF_id, person_id, FNAME_id, STARTDATE, ENDDATE) VALUES (person_fname_seq.NEXTVAL, person_seq.currval, fname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
        -- Insert a new record into the PERSON_LNAME table
        INSERT INTO PERSON_LNAME (PL_id, person_id, LNAME_id, STARTDATE, ENDDATE) VALUES (person_lname_seq.NEXTVAL, person_seq.currval, lname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
   
   END IF;
    

    IF UPDATING THEN
        IF :new.first_name <> :old.first_name THEN
            -- Update the existing ACTOR_FNAME entry with the current SYSDATE as ENDDATE
            UPDATE Person_FNAME
            SET enddate =  TO_DATE(SYSDATE, 'DD/MM/YY')
            WHERE person_id = (SELECT person_id FROM PERSON WHERE PERSON.actor_id = :new.actor_id) AND enddate IS NULL;

            -- Insert a new record into the FNAME table using the fname_seq sequence
            INSERT INTO FNAME (FNAME_id, first_name) VALUES (fname_seq.NEXTVAL, :new.first_name);

            -- Insert a new record into the ACTOR_FNAME table
			INSERT INTO PERSON_FNAME (PF_id, person_id, FNAME_id, STARTDATE, ENDDATE) VALUES (person_fname_seq.NEXTVAL, (SELECT person_id FROM PERSON WHERE PERSON.actor_id = :new.actor_id), fname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
        END IF;

        IF :new.last_name <> :old.last_name THEN
            -- Update the existing ACTOR_LNAME entry with the current SYSDATE as ENDDATE
            UPDATE Person_LNAME
            SET enddate =  TO_DATE(SYSDATE, 'DD/MM/YY')
            WHERE person_id = (SELECT person_id FROM PERSON WHERE PERSON.actor_id = :new.actor_id) AND enddate IS NULL;

            -- Insert a new record into the LNAME table using the lname_seq sequence
            INSERT INTO LNAME (LNAME_id, last_name) VALUES (lname_seq.NEXTVAL, :new.last_name);

            -- Insert a new record into the ACTOR_LNAME table
            INSERT INTO PERSON_LNAME (PL_id, person_id, LNAME_id, STARTDATE, ENDDATE) VALUES (person_lname_seq.NEXTVAL, (SELECT person_id FROM PERSON WHERE PERSON.actor_id = :new.actor_id), lname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
        END IF;
    END IF;
	
	    IF DELETING THEN
        -- Handle the DELETE action
        -- Delete the related records from the dependent tables
		
        -- Delete the associated FNAME record
        DELETE FROM FNAME
        WHERE FNAME_id = (SELECT FNAME_id FROM person_FNAME WHERE person_id = (SELECT person_id FROM PERSON WHERE PERSON.actor_id = :old.actor_id));

        -- Delete the associated LNAME record
        DELETE FROM LNAME
         WHERE LNAME_id = (SELECT LNAME_id FROM person_LNAME WHERE person_id = (SELECT person_id FROM PERSON WHERE PERSON.actor_id = :old.actor_id));

        -- Delete the associated ACTOR record
        DELETE FROM ACTOR
        WHERE actor_id = :old.actor_id;



    END IF;
END;
/
CREATE OR REPLACE TRIGGER DIRECTOR_VIEW_trigger
INSTEAD OF INSERT OR UPDATE OR DELETE ON DIRECTOR_VIEW
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        -- Insert a new record into the FNAME table using the fname_seq sequence
        INSERT INTO FNAME (FNAME_id, first_name) VALUES (fname_seq.NEXTVAL, :new.first_name);
        -- Insert a new record into the LNAME table using the lname_seq sequence
        INSERT INTO LNAME (LNAME_id, last_name) VALUES (lname_seq.NEXTVAL, :new.last_name);
        -- Insert a new record into the DIRECTOR table using the director_seq sequence
        INSERT INTO DIRECTOR (director_id, birth_year) VALUES (director_seq.NEXTVAL, :new.birth_year);
        INSERT INTO PERSON (person_id, director_id, actor_id) VALUES (person_seq.NEXTVAL, director_seq.CURRVAL, null);
    -- Insert a new record into the PERSON_FNAME table
        INSERT INTO PERSON_FNAME (PF_id, person_id, FNAME_id, STARTDATE, ENDDATE) VALUES (person_fname_seq.NEXTVAL, person_seq.currval, fname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
        -- Insert a new record into the PERSON_LNAME table
        INSERT INTO PERSON_LNAME (PL_id, person_id, LNAME_id, STARTDATE, ENDDATE) VALUES (person_lname_seq.NEXTVAL, person_seq.currval, lname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
    
    END IF;

    IF UPDATING THEN
        IF :new.first_name <> :old.first_name THEN
            -- Update the existing DIRECTOR_FNAME entry with the current SYSDATE as ENDDATE
            UPDATE person_FNAME
            SET enddate =  TO_DATE(SYSDATE, 'DD/MM/YY')
            WHERE person_id = (SELECT person_id FROM PERSON WHERE PERSON.director_id = :new.director_id) AND enddate IS NULL;

            -- Insert a new record into the FNAME table using the fname_seq sequence
            INSERT INTO FNAME (FNAME_id, first_name) VALUES (fname_seq.NEXTVAL, :new.first_name);

            -- Insert a new record into the DIRECTOR_FNAME table
            INSERT INTO PERSON_FNAME (PF_id, person_id, FNAME_id, STARTDATE, ENDDATE) VALUES (person_fname_seq.NEXTVAL, (SELECT person_id FROM PERSON WHERE PERSON.director_id = :new.director_id), fname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
        END IF;

        IF :new.last_name <> :old.last_name THEN
            -- Update the existing DIRECTOR_LNAME entry with the current SYSDATE as ENDDATE
            UPDATE person_LNAME
            SET enddate = TO_DATE(SYSDATE, 'DD/MM/YY')
            WHERE person_id = (SELECT person_id FROM PERSON WHERE PERSON.director_id = :new.director_id) AND enddate IS NULL;

            -- Insert a new record into the LNAME table using the lname_seq sequence
            INSERT INTO LNAME (LNAME_id, last_name) VALUES (lname_seq.NEXTVAL, :new.last_name);

            -- Insert a new record into the DIRECTOR_LNAME table
            INSERT INTO PERSON_LNAME (PL_id, person_id, LNAME_id, STARTDATE, ENDDATE) VALUES (person_lname_seq.NEXTVAL, (SELECT person_id FROM PERSON WHERE PERSON.director_id = :new.director_id), lname_seq.CURRVAL,  TO_DATE(SYSDATE, 'DD/MM/YY'), NULL);
        END IF;
    END IF;
    IF DELETING THEN
        -- Handle the DELETE action
        -- Delete the related records from the dependent tables

        -- Delete the associated FNAME record
        DELETE FROM FNAME
        WHERE FNAME_id = (SELECT FNAME_id FROM person_FNAME WHERE person_id = (SELECT person_id FROM PERSON WHERE PERSON.director_id = :old.director_id));

        -- Delete the associated LNAME record
        DELETE FROM LNAME
        WHERE LNAME_id = (SELECT LNAME_id FROM person_LNAME WHERE person_id = (SELECT person_id FROM PERSON WHERE PERSON.director_id = :old.director_id));

        -- Delete the associated DIRECTOR record
        DELETE FROM DIRECTOR
        WHERE director_id = :old.director_id;



    END IF;
END;
/
