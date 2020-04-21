--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200409
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10020
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica gastos de Apple
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-10020';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    
    --Comprobamos el dato a insertar
    V_SQL := '
        SELECT
        COUNT(GPV.GPV_ID)
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
        LEFT JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID AND GIC.BORRADO = 0
        WHERE
          GPV.BORRADO = 0
          AND (GPV.USUARIOCREAR = ''MIG_DIVARIAN'' OR GPV.USUARIOMODIFICAR = ''MIG_DIVARIAN'')
          AND GIC.GIC_ID IS NULL
    ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    --1 existe lo modificamos
    IF V_NUM_TABLAS = 0 THEN	

      DBMS_OUTPUT.PUT_LINE('[INFO]: YA SE HAN ACTUALIZA LOS REGISTROS EN GIC');  

    ELSE
    
      DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS');

      V_MSQL := '
                INSERT INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                (
                  GIC.GIC_ID
                  , GIC.GPV_ID
                  , GIC.EJE_ID
                  , GIC.USUARIOCREAR
                  , GIC.FECHACREAR
                ) 
                  SELECT
                    '||V_ESQUEMA||'.S_GIC_GASTOS_INFO_CONTABILIDAD.NEXTVAL GIC_ID
                    , GPV.GPV_ID
                    , (SELECT EJE.EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = EXTRACT(YEAR FROM GPV.GPV_FECHA_EMISION)) EJE_ID
                    , ''MIG_DIVARIAN'' USUARIOCREAR
                    , SYSDATE FECHACREAR
                  FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                  LEFT JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID AND GIC.BORRADO = 0
                  WHERE
                    GPV.BORRADO = 0
                    AND (GPV.USUARIOCREAR = ''MIG_DIVARIAN'' OR GPV.USUARIOMODIFICAR = ''MIG_DIVARIAN'')
                    AND GIC.GIC_ID IS NULL
      ';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE EN GIC PARA ACTIVOS DIVARIAN: ' ||sql%rowcount);
    
    END IF;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]:  MODIFICADO CORRECTAMENTE ');
   

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
