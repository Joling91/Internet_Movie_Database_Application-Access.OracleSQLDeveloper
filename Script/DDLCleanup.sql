-- Cleanup for lab5
DROP TRIGGER group6User.TRIGGER1;
DROP VIEW group6User.PERSON_VIEW;
DROP VIEW group6User.ACTOR_VIEW;
DROP VIEW group6User.DIRECTOR_VIEW;
DROP USER group6User CASCADE;
DROP ROLE applicationAdmin;
DROP TABLESPACE Assignment2 INCLUDING CONTENTS AND DATAFILES;

-- End of File