INSERT INTO BANK01.est_estados
            (est_id, 
            pef_id_gestor, 
            pef_id_supervisor, 
            iti_id, 
            dd_est_id,
             est_telecobro, 
             est_plazo, 
             est_automatico, 
             VERSION, 
             usuariocrear,
             fechacrear,
             borrado
            )
     VALUES (BANK01.s_est_estados.nextval, 
        (SELECT PEF_ID FROM BANK01.PEF_PERFILES WHERE PEF_CODIGO = 'GREC'), 
        (SELECT PEF_ID FROM BANK01.PEF_PERFILES WHERE PEF_CODIGO = 'SREC'), 
        (SELECT ITI_ID FROM BANK01.ITI_ITINERARIOS WHERE ITI_NOMBRE='Genérico recobro'), 
        (SELECT DD_EST_ID FROM BANKMASTER.DD_EST_ESTADOS_ITINERARIOS WHERE DD_EST_CODIGO = 'CMER'),
             0, 1, 0, 0, 'DD',
             SYSDATE,
             0
            );
            
COMMIT;            
