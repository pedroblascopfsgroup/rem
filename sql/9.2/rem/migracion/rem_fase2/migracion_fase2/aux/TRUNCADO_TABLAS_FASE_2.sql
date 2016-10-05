DECLARE
        TABLE_COUNT NUMBER(3);
        EXISTE    NUMBER;
        V_SQL VARCHAR2(4000 CHAR);
        V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';

        ERR_NUM NUMBER(25);  
        ERR_MSG VARCHAR2(1024 CHAR);     
        TYPE T_TABLAS IS TABLE OF VARCHAR2(150);      
        TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;          
        V_TEMP_TABLAS  T_TABLAS;
        V_NUMBER    NUMBER;    
        
   V_TABLA T_ARRAY_TABLAS := T_ARRAY_TABLAS(
                                                            T_TABLAS('REM01','ACT_PAC_PERIMETRO_ACTIVO'),
                                                            T_TABLAS('REM01','ACT_ACTIVO'),
                                                            T_TABLAS('REM01','GIC_GASTOS_INFO_CONTABILIDAD'),
                                                            T_TABLAS('REM01','GIM_GASTOS_IMPUGNACION'),
                                                            T_TABLAS('REM01','GGE_GASTOS_GESTION'),
                                                            T_TABLAS('REM01','GDE_GASTOS_DETALLE_ECONOMICO'),
                                                            T_TABLAS('REM01','GPV_TBJ'),
                                                            T_TABLAS('REM01','GPV_ACT'),
                                                            T_TABLAS('REM01','GPV_GASTOS_PROVEEDOR'),
                                                            T_TABLAS('REM01','ACT_PVC_PROVEEDOR_CONTACTO'),
                                                            T_TABLAS('REM01','ACT_PRD_PROVEEDOR_DIRECCION'),
                                                            T_TABLAS('REM01','ACT_PVE_PROVEEDOR'),
                                                            T_TABLAS('REM01','ACT_PRP'),
                                                            T_TABLAS('REM01','PRP_PROPUESTAS_PRECIOS'),
                                                            T_TABLAS('REM01','ACT_HVA_HIST_VALORACIONES'),
                                                            T_TABLAS('REM01','ACT_COE_CONDICION_ESPECIFICA'),
                                                            T_TABLAS('REM01','ACT_HEP_HIST_EST_PUBLICACION'),
                                                            T_TABLAS('REM01','SUB_SUBSANACIONES'),
                                                            T_TABLAS('REM01','POS_POSICIONAMIENTO'),
                                                            T_TABLAS('REM01','FOR_FORMALIZACION'),
                                                            T_TABLAS('REM01','OEX_OBS_EXPEDIENTE'),
                                                            T_TABLAS('REM01','GEX_GASTOS_EXPEDIENTE'),
                                                            T_TABLAS('REM01','CEX_COMPRADOR_EXPEDIENTE'),
                                                            T_TABLAS('REM01','COM_COMPRADOR'),
                                                            T_TABLAS('REM01','OFR_TIA_TITULARES_ADICIONALES'),
                                                            T_TABLAS('REM01','RES_RESERVAS'),
                                                            T_TABLAS('REM01','COE_CONDICIONANTES_EXPEDIENTE'),
                                                            T_TABLAS('REM01','ACT_OFR'),
                                                            T_TABLAS('REM01','OFR_OFERTAS'),
                                                            T_TABLAS('REM01','VIS_VISITAS'),
                                                            T_TABLAS('REM01','CLC_CLIENTE_COMERCIAL')
                        );
       
BEGIN
 
  DBMS_OUTPUT.PUT_LINE('********************' );
  DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
  DBMS_OUTPUT.PUT_LINE('********************' );
  
  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP
     BEGIN
       V_TEMP_TABLAS := V_TABLA(I);
       
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
       LOOP
           BEGIN
               
                  DBMS_OUTPUT.PUT_LINE('Desactivando : '|| J.table_name ||'.'|| J.constraint_name );    
                  EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME;        
           END;    
       END LOOP;    
       
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERROR al desactivar la constraint ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    END;
  END LOOP;
  COMMIT;   
 
  DBMS_OUTPUT.PUT_LINE('********************' );
  DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
  DBMS_OUTPUT.PUT_LINE('********************' );
  
  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP
     BEGIN
       V_TEMP_TABLAS := V_TABLA(I);
       
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
       LOOP
           BEGIN
               
                  DBMS_OUTPUT.PUT_LINE('Desactivando : '|| J.table_name ||'.'|| J.constraint_name );    
                  EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME || ' CASCADE ';        
           END;    
       END LOOP;    
       
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERROR al desactivar la constraint ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    END;
  END LOOP;
  COMMIT;   
 
  /*BORRADO*/
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.ACT_PAC_PERIMETRO_ACTIVO';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.GIC_GASTOS_INFO_CONTABILIDAD';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.GIM_GASTOS_IMPUGNACION';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.GGE_GASTOS_GESTION';
	COMMIT;
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.GDE_GASTOS_DETALLE_ECONOMICO';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.GPV_TBJ';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.GPV_ACT';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.GPV_GASTOS_PROVEEDOR';
	COMMIT;
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.ACT_PRD_PROVEEDOR_DIRECCION';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.ACT_PRP';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.PRP_PROPUESTAS_PRECIOS';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.ACT_HVA_HIST_VALORACIONES';
	COMMIT;
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.ACT_COE_CONDICION_ESPECIFICA';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.ACT_HEP_HIST_EST_PUBLICACION';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.SUB_SUBSANACIONES';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.POS_POSICIONAMIENTO';
	COMMIT;
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.FOR_FORMALIZACION';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.OEX_OBS_EXPEDIENTE';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.GEX_GASTOS_EXPEDIENTE';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.CEX_COMPRADOR_EXPEDIENTE';
	COMMIT;
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.COM_COMPRADOR';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.OFR_TIA_TITULARES_ADICIONALES';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.RES_RESERVAS';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.COE_CONDICIONANTES_EXPEDIENTE';
	COMMIT;
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.ACT_OFR';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.OFR_OFERTAS';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.VIS_VISITAS';
	EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.CLC_CLIENTE_COMERCIAL';
	UPDATE REM01.ACT_ACTIVO ACT SET
		ACT.ACT_BLOQUEO_PRECIO_FECHA_INI = NULL
		,ACT.ACT_BLOQUEO_PRECIO_USU_ID = NULL
		,ACT.DD_TPU_ID = NULL
		,ACT.DD_EPU_ID = NULL
		,ACT.DD_TCO_ID = NULL
		,ACT.ACT_FECHA_IND_PRECIAR = NULL
		,ACT.ACT_FECHA_IND_REPRECIAR = NULL
		,ACT.ACT_FECHA_IND_DESCUENTO = NULL
		,ACT.USUARIOMODIFICAR = NULL
		,ACT.FECHAMODIFICAR = NULL
	WHERE ACT.USUARIOMODIFICAR = 'MIG2';
	COMMIT;
	DELETE FROM REM01.ACT_PVC_PROVEEDOR_CONTACTO WHERE USUARIOCREAR = 'MIG2'; 
	DELETE FROM REM01.ACT_PVE_PROVEEDOR WHERE USUARIOCREAR = 'MIG2';

  /*FIN BORRADO*/
  
  DBMS_OUTPUT.PUT_LINE('********************' );
  DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
  DBMS_OUTPUT.PUT_LINE('********************' );
  
  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP
       V_TEMP_TABLAS := V_TABLA(I);
       
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P'
                 AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2) AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
       LOOP
           BEGIN              
                      DBMS_OUTPUT.PUT_LINE('Activando : '|| J.table_name ||'.'|| J.constraint_name );    
                      EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;        
 
 
                      FOR H IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE R_CONSTRAINT_NAME=J.CONSTRAINT_NAME )
                       LOOP
                           BEGIN              
                               DBMS_OUTPUT.PUT_LINE('Activando : '|| H.table_name ||'.'|| H.constraint_name );    
                               EXECUTE IMMEDIATE 'ALTER TABLE ' || H.TABLE_NAME || ' ENABLE CONSTRAINT ' || H.CONSTRAINT_NAME;
                             
                           EXCEPTION WHEN OTHERS THEN
                               DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
                           END;
                       END LOOP H;            
                     
        EXCEPTION WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
        END;
       END LOOP;            
  END LOOP;
  COMMIT;   

 
  DBMS_OUTPUT.PUT_LINE('********************' );
  DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
  DBMS_OUTPUT.PUT_LINE('********************' );
  
  FOR I IN V_TABLA.FIRST .. V_TABLA.LAST
  LOOP
       V_TEMP_TABLAS := V_TABLA(I);
       
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R'
                 AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2) AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
       LOOP
           BEGIN              
                      DBMS_OUTPUT.PUT_LINE('Activando : '|| J.table_name ||'.'|| J.constraint_name );    
                      EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
                      
        EXCEPTION WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
        END;
       END LOOP;            
  END LOOP;
  COMMIT;   
 
  DBMS_OUTPUT.PUT_LINE('*******************************' );
  DBMS_OUTPUT.PUT_LINE('**FALTA ACTIVAR RESTRICCIONES**' );
  DBMS_OUTPUT.PUT_LINE('*******************************' );
 
       FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE  STATUS='DISABLED'
               AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
       LOOP
           BEGIN              
               DBMS_OUTPUT.PUT_LINE('Activación extra : '|| J.table_name ||'.'|| J.constraint_name );    
                EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
                      
        EXCEPTION WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
        END;
       END LOOP;       

DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO' );

  EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;   

END;
