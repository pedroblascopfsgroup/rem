WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

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
		T_TABLAS('REM01','CLC_CLIENTE_COMERCIAL'),
		T_TABLAS('REM01','VIS_VISITAS'),
		T_TABLAS('REM01','OFR_OFERTAS'),
		T_TABLAS('REM01','ECO_EXPEDIENTE_COMERCIAL'),		
		T_TABLAS('REM01','ACT_OFR'),
		T_TABLAS('REM01','COE_CONDICIONANTES_EXPEDIENTE'),
		T_TABLAS('REM01','RES_RESERVAS'),
		T_TABLAS('REM01','OFR_TIA_TITULARES_ADICIONALES'),
		T_TABLAS('REM01','COM_COMPRADOR'),
		T_TABLAS('REM01','CEX_COMPRADOR_EXPEDIENTE'),
		T_TABLAS('REM01','GEX_GASTOS_EXPEDIENTE'),
		T_TABLAS('REM01','TXO_TEXTOS_OFERTA'),
		T_TABLAS('REM01','FOR_FORMALIZACION'),
		T_TABLAS('REM01','POS_POSICIONAMIENTO'),
		T_TABLAS('REM01','SUB_SUBSANACIONES'),
		T_TABLAS('REM01','ACT_HEP_HIST_EST_PUBLICACION'),
		T_TABLAS('REM01','ACT_COE_CONDICION_ESPECIFICA'),
		T_TABLAS('REM01','ACT_HVA_HIST_VALORACIONES'),
		T_TABLAS('REM01','PRP_PROPUESTAS_PRECIOS'),		
		T_TABLAS('REM01','ACT_PRP'),
		T_TABLAS('REM01','GPV_GASTOS_PROVEEDOR'),
		T_TABLAS('REM01','GPV_ACT'),
		T_TABLAS('REM01','GPV_TBJ'),
		T_TABLAS('REM01','GDE_GASTOS_DETALLE_ECONOMICO'),		
		T_TABLAS('REM01','GGE_GASTOS_GESTION'),
		T_TABLAS('REM01','GIM_GASTOS_IMPUGNACION'),		
		T_TABLAS('REM01','GIC_GASTOS_INFO_CONTABILIDAD'),
		T_TABLAS('REM01','PRG_PROVISION_GASTOS'),
		T_TABLAS('REM01','ACT_PAC_PERIMETRO_ACTIVO'),
		T_TABLAS('REM01','ACT_HAL_HIST_ALQUILERES'),
		T_TABLAS('REM01','ACT_ACTIVO'),		
		T_TABLAS('REM01','ACT_HAL_HIST_ALQUILERES'),
		T_TABLAS('REM01','ACT_AGR_AGRUPACION'),
		T_TABLAS('REM01','ACT_PAC_PROPIETARIO_ACTIVO'),		
		T_TABLAS('REM01','ACT_TBJ'),
		T_TABLAS('REM01','ACT_TBJ_TRABAJO'),
		T_TABLAS('REM01','ACT_TRA_TRAMITE'),
		T_TABLAS('REM01','TAR_TAREAS_NOTIFICACIONES'),
		T_TABLAS('REM01','ETN_EXTAREAS_NOTIFICACIONES'),
		T_TABLAS('REM01','TEX_TAREA_EXTERNA'),
		T_TABLAS('REM01','TAC_TAREAS_ACTIVOS')
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
    DELETE FROM REM01.ACT_ACTIVO ACT WHERE ACT.USUARIOCREAR = 'MIG2'; 
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
          	
    UPDATE REM01.ACT_AGR_AGRUPACION AGR
       SET
		   AGR.DD_TAG_ID = NULL
		  ,AGR.AGR_PUBLICADO = 0
		  ,AGR.USUARIOMODIFICAR = NULL
		  ,AGR.FECHAMODIFICAR = NULL
    WHERE AGR.USUARIOMODIFICAR = 'MIG2';	
	
	COMMIT;
	DELETE FROM ACT_PAC_PERIMETRO_ACTIVO WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM PRG_PROVISION_GASTOS WHERE USUARIOCREAR = 'MIG2';
	--DELETE FROM GIC_GASTOS_INFO_CONTABILIDAD WHERE USUARIOCREAR = 'MIG2';
	--DELETE FROM GIM_GASTOS_IMPUGNACION WHERE USUARIOCREAR = 'MIG2';
	OPERACION_DDL.DDL_TABLE('TRUNCATE', 'GIC_GASTOS_INFO_CONTABILIDAD');
	OPERACION_DDL.DDL_TABLE('TRUNCATE', 'GIM_GASTOS_IMPUGNACION');
	COMMIT;
	--DELETE FROM GGE_GASTOS_GESTION WHERE USUARIOCREAR = 'MIG2';
	--DELETE FROM GDE_GASTOS_DETALLE_ECONOMICO WHERE USUARIOCREAR = 'MIG2';
	--DELETE FROM GPV_TBJ GT WHERE EXISTS (SELECT 1 FROM GPV_GASTOS_PROVEEDOR GPV WHERE GPV.GPV_ID = GT.GPV_ID AND USUARIOCREAR = 'MIG2');
	--DELETE FROM GPV_ACT GA WHERE EXISTS (SELECT 1 FROM GPV_GASTOS_PROVEEDOR GPV WHERE GPV.GPV_ID = GA.GPV_ID AND USUARIOCREAR = 'MIG2');
	OPERACION_DDL.DDL_TABLE('TRUNCATE', 'GGE_GASTOS_GESTION');
	OPERACION_DDL.DDL_TABLE('TRUNCATE', 'GDE_GASTOS_DETALLE_ECONOMICO');
	OPERACION_DDL.DDL_TABLE('TRUNCATE', 'GPV_TBJ');
	OPERACION_DDL.DDL_TABLE('TRUNCATE', 'GPV_ACT');
	COMMIT;
	--DELETE FROM GPV_GASTOS_PROVEEDOR WHERE USUARIOCREAR = 'MIG2';
	OPERACION_DDL.DDL_TABLE('TRUNCATE', 'GPV_GASTOS_PROVEEDOR');
	COMMIT;
	DELETE FROM ACT_PRP AP WHERE EXISTS (SELECT 1 FROM PRP_PROPUESTAS_PRECIOS PRP WHERE PRP.PRP_ID = AP.PRP_ID AND USUARIOCREAR = 'MIG2');
	DELETE FROM PRP_PROPUESTAS_PRECIOS WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM ACT_HVA_HIST_VALORACIONES WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM ACT_COE_CONDICION_ESPECIFICA WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM ACT_HEP_HIST_EST_PUBLICACION WHERE USUARIOCREAR = 'MIG2';
	COMMIT;
	DELETE FROM SUB_SUBSANACIONES WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM POS_POSICIONAMIENTO WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM FOR_FORMALIZACION WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM TXO_TEXTOS_OFERTA WHERE USUARIOCREAR = 'MIG2'; 
	COMMIT;
	DELETE FROM GEX_GASTOS_EXPEDIENTE WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM CEX_COMPRADOR_EXPEDIENTE CEX WHERE EXISTS (SELECT 1 FROM COM_COMPRADOR COM WHERE COM.COM_ID = CEX.COM_ID AND USUARIOCREAR = 'MIG2');
	DELETE FROM COM_COMPRADOR WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM OFR_TIA_TITULARES_ADICIONALES WHERE USUARIOCREAR = 'MIG2';
	COMMIT;
	DELETE FROM ACT_HAL_HIST_ALQUILERES WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM RES_RESERVAS WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM COE_CONDICIONANTES_EXPEDIENTE WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM ACT_OFR AO WHERE EXISTS (SELECT 1 FROM OFR_OFERTAS OFR WHERE OFR.OFR_ID = AO.OFR_ID AND USUARIOCREAR = 'MIG2');
	COMMIT;
	DELETE FROM ECO_EXPEDIENTE_COMERCIAL WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM OFR_OFERTAS WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM VIS_VISITAS WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM CLC_CLIENTE_COMERCIAL WHERE USUARIOCREAR = 'MIG2';
	COMMIT;
	DELETE FROM ACT_TBJ ATBJ WHERE EXISTS (SELECT 1 FROM ACT_TBJ_TRABAJO TBJ WHERE TBJ.TBJ_ID = ATBJ.TBJ_ID AND USUARIOCREAR = 'MIG2');
	DELETE FROM ACT_TBJ_TRABAJO WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM ACT_TRA_TRAMITE WHERE USUARIOCREAR = 'MIG2';
	COMMIT;	
	DELETE FROM ETN_EXTAREAS_NOTIFICACIONES ETN WHERE EXISTS (SELECT 1 FROM TAR_TAREAS_NOTIFICACIONES TAR WHERE TAR.TAR_ID = ETN.TAR_ID AND USUARIOCREAR = 'MIG2');
	DELETE FROM TAR_TAREAS_NOTIFICACIONES WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM TEX_TAREA_EXTERNA WHERE USUARIOCREAR = 'MIG2';
	DELETE FROM TAC_TAREAS_ACTIVOS WHERE USUARIOCREAR = 'MIG2';
	
	/*QUERYS BORRADOS AUXILIARES*/
	
	DELETE FROM ADG_ADJUNTOS_GASTO ADJ
	WHERE ADJ.GPV_ID IN (
	select gpv_id from ADG_ADJUNTOS_GASTO adg
	where not exists (
	  select 1 from GPV_GASTOS_PROVEEDOR gpv where gpv.GPV_ID = adg.GPV_ID));

	DELETE FROM ADE_ADJUNTO_EXPEDIENTE ADJ
	WHERE ADJ.ECO_ID IN (
	select ADG.ECO_ID from ADE_ADJUNTO_EXPEDIENTE adg
	INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
	  ON adg.ECO_ID = ECO.ECO_ID
	where not exists (
	  select 1 from OFR_OFERTAS gpv where gpv.OFR_ID = ECO.OFR_ID));
	  
	DELETE FROM FOR_FORMALIZACION ADJ
	WHERE ADJ.ECO_ID IN (
	select ADG.ECO_ID from FOR_FORMALIZACION adg
	INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
	  ON adg.ECO_ID = ECO.ECO_ID
	where not exists (
	  select 1 from OFR_OFERTAS gpv where gpv.OFR_ID = ECO.OFR_ID));
	  
	DELETE FROM COE_CONDICIONANTES_EXPEDIENTE ADJ
	WHERE ADJ.ECO_ID IN (
	select ADG.ECO_ID from COE_CONDICIONANTES_EXPEDIENTE adg
	INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
	  ON adg.ECO_ID = ECO.ECO_ID
	where not exists (
	  select 1 from OFR_OFERTAS gpv where gpv.OFR_ID = ECO.OFR_ID));
	  
	DELETE FROM POS_POSICIONAMIENTO ADJ
	WHERE ADJ.ECO_ID IN (
	select ADG.ECO_ID from POS_POSICIONAMIENTO adg
	INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
	  ON adg.ECO_ID = ECO.ECO_ID
	where not exists (
	  select 1 from OFR_OFERTAS gpv where gpv.OFR_ID = ECO.OFR_ID));
	  
	DELETE FROM ACT_BEX_BLOQ_EXP_FORMALIZAR ADJ
	WHERE ADJ.ACT_BEX_ECO_ID IN (
	select ADG.ACT_BEX_ECO_ID from ACT_BEX_BLOQ_EXP_FORMALIZAR adg
	INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
	  ON adg.ACT_BEX_ECO_ID = ECO.ECO_ID
	where not exists (
	  select 1 from OFR_OFERTAS gpv where gpv.OFR_ID = ECO.OFR_ID));
	  
	DELETE FROM OEX_OBS_EXPEDIENTE ADJ
	WHERE ADJ.ECO_ID IN (
	select ADG.ECO_ID from OEX_OBS_EXPEDIENTE adg
	INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
	  ON adg.ECO_ID = ECO.ECO_ID
	where not exists (
	  select 1 from OFR_OFERTAS gpv where gpv.OFR_ID = ECO.OFR_ID));
	  
	DELETE FROM ERE_ENTREGAS_RESERVA ADJ
	WHERE ADJ.RES_ID IN (
	select ADG.RES_ID from ERE_ENTREGAS_RESERVA adg
	INNER JOIN RES_RESERVAS RES
	  ON RES.RES_ID = ADG.RES_ID
	INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
	  ON RES.ECO_ID = ECO.ECO_ID
	where not exists (
	  select 1 from OFR_OFERTAS gpv where gpv.OFR_ID = ECO.OFR_ID));
	 
	DELETE FROM RES_RESERVAS ADJ
	WHERE ADJ.ECO_ID IN (
	select ADG.ECO_ID from RES_RESERVAS adg
	INNER JOIN ECO_EXPEDIENTE_COMERCIAL ECO
	  ON adg.ECO_ID = ECO.ECO_ID
	where not exists (
	  select 1 from OFR_OFERTAS gpv where gpv.OFR_ID = ECO.OFR_ID));
	  
	DELETE FROM ECO_EXPEDIENTE_COMERCIAL ADJ
	WHERE ADJ.OFR_ID IN (
	select OFR_ID from ECO_EXPEDIENTE_COMERCIAL adg
	where not exists (
	  select 1 from OFR_OFERTAS gpv where gpv.OFR_ID = adg.OFR_ID));
	  
	DELETE FROM POS_POSICIONAMIENTO GEX2
	WHERE GEX2.ECO_ID IN (
	SELECT GEX.ECO_ID FROM POS_POSICIONAMIENTO GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ECO_EXPEDIENTE_COMERCIAL ECO WHERE GEX.ECO_ID = ECO.ECO_ID));
	  
	DELETE FROM GEX_GASTOS_EXPEDIENTE GEX2
	WHERE GEX2.ECO_ID IN (
	SELECT GEX.ECO_ID FROM GEX_GASTOS_EXPEDIENTE GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ECO_EXPEDIENTE_COMERCIAL ECO WHERE GEX.ECO_ID = ECO.ECO_ID));
	  
	DELETE FROM COM_COMPRADOR GEX2
	WHERE GEX2.CLC_ID IN (
	SELECT GEX.CLC_ID FROM COM_COMPRADOR GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM CLC_CLIENTE_COMERCIAL ECO WHERE GEX.CLC_ID = ECO.CLC_ID));
  
	DELETE FROM CEX_COMPRADOR_EXPEDIENTE GEX2
	WHERE GEX2.COM_ID IN (
	SELECT GEX.COM_ID FROM CEX_COMPRADOR_EXPEDIENTE CEX
	INNER JOIN COM_COMPRADOR GEX
	  ON GEX.COM_ID = CEX.COM_ID
	WHERE NOT EXISTS (
	  SELECT 1 FROM CLC_CLIENTE_COMERCIAL ECO WHERE GEX.CLC_ID = ECO.CLC_ID));
	  
	DELETE FROM RES_RESERVAS GEX2
	WHERE GEX2.ECO_ID IN (
	SELECT GEX.ECO_ID FROM RES_RESERVAS GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ECO_EXPEDIENTE_COMERCIAL ECO WHERE GEX.ECO_ID = ECO.ECO_ID));
	  
	DELETE FROM COE_CONDICIONANTES_EXPEDIENTE GEX2
	WHERE GEX2.ECO_ID IN (
	SELECT GEX.ECO_ID FROM COE_CONDICIONANTES_EXPEDIENTE GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM ECO_EXPEDIENTE_COMERCIAL ECO WHERE GEX.ECO_ID = ECO.ECO_ID));
	  
	DELETE FROM RCB_RESOL_COMITE_BANKIA GEX2
	WHERE GEX2.OFR_ID IN (
	SELECT GEX.OFR_ID FROM RCB_RESOL_COMITE_BANKIA GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM OFR_OFERTAS ECO WHERE GEX.OFR_ID = ECO.OFR_ID));
	  
	DELETE FROM DGG_DOC_GES_GASTOS GEX2
	WHERE GEX2.GPV_ID IN (
	SELECT GEX.GPV_ID FROM DGG_DOC_GES_GASTOS GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM GPV_GASTOS_PROVEEDOR ECO WHERE GEX.GPV_ID = ECO.GPV_ID));
	  
	DELETE FROM TEV_TAREA_EXTERNA_VALOR GEX2
	WHERE GEX2.TEX_ID IN (
	SELECT GEX.TEX_ID FROM TEV_TAREA_EXTERNA_VALOR GEX
	WHERE NOT EXISTS (
	  SELECT 1 FROM TEX_TAREA_EXTERNA ECO WHERE GEX.TEX_ID = ECO.TEX_ID));
	
	/*FIN BORRADO QUERYS AUXILIARES*/
	
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
