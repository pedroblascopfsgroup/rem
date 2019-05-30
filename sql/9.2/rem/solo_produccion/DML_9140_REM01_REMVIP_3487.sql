--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190524
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3487
--## PRODUCTO=NO
--##
--## Finalidad: Script para crear las provisiones
--##			
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-3487';
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.PRG_PROVISION_GASTOS' );

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.PRG_PROVISION_GASTOS 
		    ( PRG_ID, 
		      PRG_NUM_PROVISION,
		      DD_EPR_ID,
		      PRG_FECHA_ALTA,
		      PVE_ID_GESTORIA,
		      PRG_FECHA_ENVIO,
		      PRG_FECHA_RESPUESTA,
		      BORRADO,
		      USUARIOCREAR,
		      FECHACREAR
		     )
		    SELECT 
		     '|| V_ESQUEMA ||'.S_PRG_PROVISION_GASTOS.NEXTVAL,
		     AUX.PRG_NUM_PROVISION,
		     ( SELECT DD_EPR_ID FROM '|| V_ESQUEMA ||'.DD_EPR_ESTADOS_PROVISION_GASTO WHERE DD_EPR_CODIGO = ''07'' ),
		     GPV_FECHA_EMISION,
		     GPV.PVE_ID_GESTORIA,
		     GPV_FECHA_EMISION,
		     GPV_FECHA_EMISION,			     
		     0,
		     ''' || V_USU || ''',
		     SYSDATE		
		     FROM '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV, '|| V_ESQUEMA ||'.AUX_REMVIP_3487 AUX
		     WHERE 1 = 1
		     AND GPV.GPV_NUM_GASTO_HAYA = AUX.GPV_NUM_GASTO_HAYA
		     AND NOT EXISTS ( SELECT 1
				      FROM '|| V_ESQUEMA ||'.PRG_PROVISION_GASTOS PRG
				      WHERE 1 = 1
				      AND PRG.PRG_NUM_PROVISION = AUX.PRG_NUM_PROVISION
				    )	  		
		';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS ' ||SQL%ROWCOUNT|| ' PROVISIONES ');


    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR' );

          V_MSQL := '
			UPDATE '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR
			SET PRG_ID = ( SELECT MAX( PRG_ID )
				       FROM PRG_PROVISION_GASTOS, AUX_REMVIP_3487 
				       WHERE PRG_PROVISION_GASTOS.PRG_NUM_PROVISION = AUX_REMVIP_3487.PRG_NUM_PROVISION 		 	
				       AND AUX_REMVIP_3487.GPV_NUM_GASTO_HAYA = GPV_GASTOS_PROVEEDOR.GPV_NUM_GASTO_HAYA ),
			    USUARIOMODIFICAR = ''REMVIP-3487'',
			    FECHAMODIFICAR   = SYSDATE
			WHERE EXISTS ( SELECT 1
				       FROM AUX_REMVIP_3487 AUX
				       WHERE AUX.GPV_NUM_GASTO_HAYA = GPV_GASTOS_PROVEEDOR.GPV_NUM_GASTO_HAYA )	
		
			';



          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS ' ||SQL%ROWCOUNT|| ' GASTOS ');
        
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: SCRIPT FINALIZADO CORRECTAMENTE ');


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
