--##########################################
--## AUTOR=María Villanueva
--## FECHA_CREACION=20160415
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-3085
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla D_BIE_VIVIENDA_HABITUAL
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema ESQUEMA_DWH
TABLA VARCHAR(30) :='D_BIE_VIVIENDA_HABITUAL';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(4000 CHAR);


BEGIN 



 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	"VIVIENDA_HABITUAL_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"VIVIENDA_HABITUAL_DESC" VARCHAR2(50 CHAR)
	)' ;
     
	 EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE(''||TABLA||' CREADA');

EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;  
