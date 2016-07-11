--/*
--#########################################
--## AUTOR=Pablo Meseguer 
--## FECHA_CREACION=20160516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-408
--## PRODUCTO=NO
--## 
--## Finalidad: Volcar el contenido de la tabla ACT_AGA_AGRUPACION_ACTIVO en la tabla ACT_AAH_AGRUP_ACTIVO_HIST.
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_COL_EXISTS NUMBER(16); -- Vble. para almacenar la existencia de una columna.
  V_NUM_INSERTS NUMBER(16); -- Vble. para almacenar los inserts realizados.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE VOLCADO DE ACT_AGA_AGRUPACION_ACTIVO');
          
   -- COMPROBAMOS SI LA COLUMNA AAH_PRINCIPAL EXISTE EN LA TABLA ACT_AAH_AGRUP_ACTIVO_HIST       
   V_SQL := '
		 SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME=''AAH_PRINCIPAL'' AND TABLE_NAME = ''ACT_AAH_AGRUP_ACTIVO_HIST'' AND OWNER = '''||V_ESQUEMA||'''
		 '
         ;
                            
    EXECUTE IMMEDIATE V_SQL INTO V_COL_EXISTS;      
    
    -- SI EXISTE LA ELIMINAMOS
    
	IF V_COL_EXISTS > 0 THEN	
    
		V_SQL := '
			ALTER TABLE ACT_AAH_AGRUP_ACTIVO_HIST DROP COLUMN AAH_PRINCIPAL
			'
			;
    
		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA AAH_PRINCIPAL SE HA ELIMINADO DE LA TABLA ACT_AAH_AGRUP_ACTIVO_HIST');    

    END IF;
    
    -- INSERTAMOS EN ACT_AAH_AGRUP_ACTIVO_HIST LOS REGISTROS DE ACT_AGA_AGRUPACION_ACTIVO
    
    V_SQL := '
		 INSERT INTO '||V_ESQUEMA||'.ACT_AAH_AGRUP_ACTIVO_HIST (
		 AAH_ID,
		 AGR_ID,
	     ACT_ID,
	     AAH_FECHA_DESDE,
	     AAH_FECHA_HASTA,
		 VERSION,
		 USUARIOCREAR,
		 FECHACREAR,
		 USUARIOMODIFICAR,
		 FECHAMODIFICAR,
		 USUARIOBORRAR,
		 FECHABORRAR,
		 BORRADO
		 )
		 WITH FILTRO AS (
			SELECT AGA.AGR_ID, AGA.ACT_ID, AGA.AGA_FECHA_INCLUSION FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
			WHERE AGA.AGR_ID || AGA.ACT_ID || AGA.AGA_FECHA_INCLUSION NOT IN (SELECT AAH.AGR_ID ||	AAH.ACT_ID || AAH.AAH_FECHA_DESDE  
			FROM '||V_ESQUEMA||'.ACT_AAH_AGRUP_ACTIVO_HIST AAH)
			)
		 SELECT 
	     '||V_ESQUEMA||'.S_ACT_AAH_AGRUP_ACTIVO_HIST.NEXTVAL,
		 FIL.AGR_ID,
		 FIL.ACT_ID,
	     FIL.AGA_FECHA_INCLUSION,
	     NULL,
		 ''0'',
		 ''HREOS-408'',
		 SYSDATE,
		 NULL,
		 NULL,
		 NULL,
		 NULL,
		 0
		 FROM FILTRO FIL
		 '
         ;
         
    EXECUTE IMMEDIATE V_SQL;
    
    V_NUM_INSERTS := sql%rowcount;
    
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_AAH_AGRUP_ACTIVO_HIST COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_AAH_AGRUP_ACTIVO_HIST ANALIZADA.');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INSERTADO '||V_NUM_INSERTS||' REGISTROS EN ACT_AAH_AGRUP_ACTIVO_HIST.');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA ACT_AAH_AGRUP_ACTIVO_HIST SE HA ACTUALIZADO CORRECTAMENTE');
 
 
EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT
