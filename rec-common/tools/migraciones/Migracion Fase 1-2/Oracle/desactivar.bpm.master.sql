/* Formatted on 2009/02/06 09:58 (Formatter Plus v4.8.8) */
UPDATE jbpm_job jb
   SET jb.issuspended_ = 1
 WHERE jb.id_ IN (
          SELECT jb.id_
            FROM jbpm_variableinstance vi, jbpm_job jb
           WHERE vi.name_ = 'DB_ID'
             AND jb.processinstance_ = vi.processinstance_
             AND vi.longvalue_ IN (1, 2, 3));