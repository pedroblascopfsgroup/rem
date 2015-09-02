--Script encargado de cancelar los timers JBP asociados a la nueva instancia en caso de que esta
--pudiera haber existido anteriormente

--UPDATE pfsmaster.jbpm_job jb
--   SET jb.issuspended_ = 1
--WHERE jb.id_ IN (
--          SELECT jb.id_
--            FROM pfsmaster.jbpm_variableinstance vi, pfsmaster.jbpm_job jb
--           WHERE vi.name_ = 'DB_ID'
--             AND jb.processinstance_ = vi.processinstance_
--             AND vi.longvalue_ = :entidadId
--             );

delete ${master.schema}.jbpm_job jb
		WHERE jb.id_ IN (
          SELECT jb.id_
            FROM ${master.schema}.jbpm_variableinstance vi, ${master.schema}.jbpm_job jb
           WHERE vi.name_ = 'DB_ID'
             AND jb.processinstance_ = vi.processinstance_
             AND vi.longvalue_ = :entidadId
        );



