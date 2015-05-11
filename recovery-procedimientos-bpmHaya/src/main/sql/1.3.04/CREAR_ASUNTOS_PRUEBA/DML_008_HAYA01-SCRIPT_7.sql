DECLARE

FLAG NUMBER;

BEGIN

        UPDATE PRC_PROCEDIMIENTOS SET VERSION = ROWNUM;

/*SELECT VERSION, ROW_NUMBER()
   OVER (PARTITION BY DD_TPO_ID ORDER BY PRC_ID) AS PROC_ID
   FROM PRC_PROCEDIMIENTOS;
*/
   
    FOR CONT IN 1 .. 13
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2386,TIPO_PROC_ORIGINAL=2386
            WHERE version = CONT;
               
    
        
    END LOOP;
    
        FOR CONT IN 14 .. 26
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2385,TIPO_PROC_ORIGINAL=2385
            WHERE version = CONT;
               
    
        
    END LOOP;
    
        FOR CONT IN 27 .. 29
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2354,TIPO_PROC_ORIGINAL=2354
            WHERE version = CONT;
               
    
        
    END LOOP;
    
        FOR CONT IN 30 .. 32
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2358,TIPO_PROC_ORIGINAL=2358
            WHERE version = CONT;
               
    
        
    END LOOP;
    
            FOR CONT IN 33 .. 35
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2351,TIPO_PROC_ORIGINAL=2351
            WHERE version = CONT;
                   END LOOP;

            FOR CONT IN 36 .. 36
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2360,TIPO_PROC_ORIGINAL=2360
            WHERE version = CONT;
                END LOOP;

            
          FOR CONT IN 37 .. 39
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2359,TIPO_PROC_ORIGINAL=2359
            WHERE version = CONT;
                END LOOP;

          FOR CONT IN 40 .. 44
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2142,TIPO_PROC_ORIGINAL=2142
            WHERE version = CONT;         
    
        
    END LOOP;
               
           FOR CONT IN 45 .. 47
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2376,TIPO_PROC_ORIGINAL=2376
            WHERE version = CONT;         
    
        
    END LOOP;
                   
           FOR CONT IN 48 .. 51
    LOOP       
        
        UPDATE PRC_PROCEDIMIENTOS SET DD_TPO_ID = 2371,TIPO_PROC_ORIGINAL=2371
            WHERE version = CONT;         
    
        
    END LOOP;
    
            UPDATE PRC_PROCEDIMIENTOS SET VERSION = 0;

END;