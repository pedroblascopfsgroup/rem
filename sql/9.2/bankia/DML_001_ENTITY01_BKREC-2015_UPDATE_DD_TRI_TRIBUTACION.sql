--/*
--##########################################
--## AUTOR=RAFAEL ARACIL
--## FECHA_CREACION=20160314
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=BKREC-2015
--## PRODUCTO=NO
--## 
--## Finalidad: Poner a borrado lógico n uevos campos en el diccionario DD_TRI_TRIBUTACION
--## que tendrían que ser transparente en BANKIA
--## INSTRUCCIONES:  Ejecutar y listo
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_SENTENCIA VARCHAR2(1600 CHAR);
V_NUM NUMBER(2,0);

BEGIN
	--------------------------
	-- ## DD_TRI_TRIBUTACION ## --
	--------------------------

		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del script de borrado lógico en DD_TRI_TRIBUTACION');


		DBMS_OUTPUT.PUT_LINE('[INFO] Borrado lógico para los codigos');

V_SENTENCIA := 'update '||V_ESQUEMA||'.dd_tri_tributacion set borrado=1 where dd_tri_codigo in (
''TPO'',
''IGIC'',
''IGICREN'',
''IVA'',
''IVAREN''
)';
				
EXECUTE IMMEDIATE V_SENTENCIA;
    
COMMIT;

		DBMS_OUTPUT.PUT_LINE('[INFO] Borrado lógico realizado');
		

		DBMS_OUTPUT.PUT_LINE('[FIN] Script finalizado');
		
EXCEPTION
				WHEN OTHERS THEN

				  DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(SQLCODE));
				  DBMS_OUTPUT.put_line('-----------------------------------------------------------');
				  DBMS_OUTPUT.put_line(SQLERRM);

				  ROLLBACK;
				  RAISE;

END;
/
EXIT;
