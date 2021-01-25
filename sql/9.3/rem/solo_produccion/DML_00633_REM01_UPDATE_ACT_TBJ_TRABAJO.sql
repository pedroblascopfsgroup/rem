--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210125
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8776
--## PRODUCTO=NO
--##
--## Finalidad: 
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
  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';  -- Tabla a modificar
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8776'; -- USUARIOCREAR/USUARIOMODIFICAR

    
BEGIN	

		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion en '||V_TABLA||'');


            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (
                        SELECT TBJ_ID,TBJ.TBJ_FECHA_TOPE,CAST(TBJ.TBJ_FECHA_HORA_CONCRETA AS DATE) AS FECHACONCRETA FROM '||V_ESQUEMA||'.'||V_TABLA||' TBJ
                        WHERE TBJ.BORRADO=0 AND TBJ.TBJ_FECHA_TOPE IS NULL AND TBJ.TBJ_FECHA_HORA_CONCRETA IS NOT NULL                       
                        
                        ) T2
                    ON (T1.TBJ_ID = T2.TBJ_ID)
                    WHEN MATCHED THEN UPDATE SET
                    T1.TBJ_FECHA_TOPE=T2.FECHACONCRETA,
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJOS SIN FECHA TOPE PERO CON FECHA CONCRETA MODIFICADOS: '||sql%rowcount ||'');

        DBMS_OUTPUT.PUT_LINE('[FIN] FECHA TOPE DE LOS TRABAJOS MODIFICADA CORRECTAMENTE');
        
        COMMIT;
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT