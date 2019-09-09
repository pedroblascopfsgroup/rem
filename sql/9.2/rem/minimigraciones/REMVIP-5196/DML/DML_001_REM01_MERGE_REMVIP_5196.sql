--/*
--###########################################
--## AUTOR=Oscar Diestre Perez
--## FECHA_CREACION=20190909
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5196
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR TAR_TAREAS_NOTIFICACIONES
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_ACT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-5196';
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR AUX_REMVIP_5196 ' );
           
                V_MSQL := ' 							
			MERGE INTO '||V_ESQUEMA||'.AUX_REMVIP_5196 T1
       			 USING (

				SELECT ACT.ACT_NUM_ACTIVO
				FROM '||V_ESQUEMA||'.AUX_REMVIP_5196 AUX,
				     '||V_ESQUEMA||'.ACT_ACTIVO ACT
				WHERE 1 = 1
				AND AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
				AND ACT.CPR_ID IS NULL

       				) T2 
		        ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
			WHEN MATCHED THEN UPDATE SET
		 	T1.CPR_ID = '||V_ESQUEMA||'.S_ACT_CPR_COM_PROPIETARIOS.NEXTVAL
		';

	EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS ' || SQL%ROWCOUNT || ' REGISTROS DE AUX_REMVIP_5196 ' );

--*******************************************************************************************************************************

    DBMS_OUTPUT.PUT_LINE('[INFO]: CREAR REGISTRO EM ACT_CPR_COM_PROPIETARIOS' );
            
                V_MSQL := ' 							
			MERGE INTO '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS T1
       			 USING (

				SELECT CPR_ID
				FROM '||V_ESQUEMA||'.AUX_REMVIP_5196 AUX
				WHERE 1 = 1
				AND CPR_ID IS NOT NULL

       			       ) T2 
		        ON ( T1.CPR_ID = T2.CPR_ID )
			WHEN NOT MATCHED THEN INSERT
			( CPR_ID, 
			  CPR_ESTATUTOS,
			  CPR_LIBRO_EDIFICIO,
			  CPR_CERTIFICADO_ITE,	
			  VERSION,
			  USUARIOCREAR,
			  FECHACREAR,
			  BORRADO
			)
			VALUES
			(
			 T2.CPR_ID,
			 0,
			 0,
			 0,
			 0,
			 '''||V_USUARIOMODIFICAR|| ''',
			 SYSDATE,
			 0 
			)
		';

	EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: CREADOS ' || SQL%ROWCOUNT || ' REGISTROS DE ACT_CPR_COM_PROPIETARIOS ' );

--*******************************************************************************************************************************

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACT_ACTIVO' );
            
                V_MSQL := ' 							
			MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
       			 USING (

				SELECT CPR_ID, ACT_NUM_ACTIVO
				FROM '||V_ESQUEMA||'.AUX_REMVIP_5196 AUX
				WHERE 1 = 1
				AND CPR_ID IS NOT NULL

       			       ) T2 
		        ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUM_ACTIVO)
			WHEN MATCHED THEN UPDATE SET
			 T1.CPR_ID = T2.CPR_ID,	
			 T1.USUARIOMODIFICAR =  '''||V_USUARIOMODIFICAR|| ''',
			 T1.FECHAMODIFICAR   = SYSDATE
		';

	EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS ' || SQL%ROWCOUNT || ' REGISTROS DE ACT_ACTIVO ' );

  	COMMIT;

    	DBMS_OUTPUT.PUT_LINE('[FIN] ');



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
EXIT;
