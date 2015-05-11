CREATE OR REPLACE FUNCTION rowconcat(q IN VARCHAR2) RETURN VARCHAR2 IS
  ret  VARCHAR2(4000);
  hold VARCHAR2(4000);
  cur  sys_refcursor;
BEGIN
  OPEN cur FOR q;
  LOOP
    FETCH cur INTO hold;
    EXIT WHEN cur%NOTFOUND;
    IF ret IS NULL THEN
      ret := hold;
    ELSE
      ret := ret || ', ' || hold;
    END IF;
  END LOOP;
  RETURN ret;
END;
/