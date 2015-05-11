update UNMASTER.DD_STA_SUBTIPO_TAREA_BASE sub set sub.DD_STA_GESTOR = null where sub.DD_STA_ID = 27;
update UNMASTER.DD_STA_SUBTIPO_TAREA_BASE sub set sub.dd_tge_id = 3 where sub.DD_STA_ID = 27;

commit;