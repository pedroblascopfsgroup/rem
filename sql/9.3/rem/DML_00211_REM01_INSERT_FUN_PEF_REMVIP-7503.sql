--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7503
--## PRODUCTO=NO
--##
--## Finalidad: Habilitar al perfil “Superusuario Gestión Activos” la edición del apartado Suplidos de los trabajos
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
	V_USR VARCHAR2(50 CHAR) := 'REMVIP-7503';
	V_FUNCION VARCHAR2(50 CHAR) := 'EDITAR_LIST_PROVSUPLI_TRABAJO';
	V_PERFIL VARCHAR2(50 CHAR) := 'SUPERGESTACT';
	
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EN FUN_PEF');
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF(
				FUN_ID
				,PEF_ID
				,FP_ID
				,USUARIOCREAR
				,FECHACREAR
				) VALUES(
				(SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_FUNCION||''')
				,(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||V_PERFIL||''')
				,'||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL 
				,'''||V_USR||'''
				,SYSDATE
				)';
	EXECUTE IMMEDIATE V_MSQL;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA FUN_PEF ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
