CREATE OR REPLACE VIEW actor_view AS 
  SELECT
        a.actor_id,
        a.birth_year,
        f.first_name,
        l.last_name
    FROM
         actor a
        JOIN person p ON a.actor_id = p.actor_id
        JOIN person_fname pf ON p.person_id = pf.person_id
        JOIN person_lname pl ON p.person_id = pl.person_id
        JOIN fname        f ON pf.fname_id = f.fname_id
        JOIN lname        l ON pl.lname_id = l.lname_id
		    WHERE
        ( pf.enddate IS NULL )
        AND ( pl.enddate IS NULL );



CREATE OR REPLACE VIEW director_view AS
    SELECT
        d.director_id,
        d.birth_year,
        f.first_name,
        l.last_name
    FROM
             director d
        JOIN person p ON d.director_id = p.director_id
        JOIN person_fname pf ON p.person_id = pf.person_id
        JOIN person_lname pl ON p.person_id = pl.person_id
        JOIN fname        f ON pf.fname_id = f.fname_id
        JOIN lname        l ON pl.lname_id = l.lname_id
		    WHERE
        ( pf.enddate IS NULL )
        AND ( pl.enddate IS NULL );

-- view
CREATE OR REPLACE VIEW person_view AS
    SELECT
        person.person_id,
        person.director_id,
        person.actor_id,
        fname.first_name,
        lname.last_name 
    FROM
        person 
        LEFT JOIN person_fname ON person.person_id = person_fname.person_id
        LEFT JOIN fname ON person_fname.fname_id = fname.fname_id
        LEFT JOIN person_lname ON person.person_id = person_lname.person_id
        LEFT JOIN lname ON person_lname.lname_id = lname.lname_id
    WHERE
        ( person_fname.enddate IS NULL )
        AND ( person_lname.enddate IS NULL );