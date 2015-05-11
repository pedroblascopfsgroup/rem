--/*
--##########################################
--## Author: Bruno Anglés robles
--## Finalidad: DML para añadir una nueva función
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
v_fun_count number(3);
V_ESQUEMA varchar(30) := 'BANKMASTER';


TYPE T_TIPO_FUN IS TABLE OF VARCHAR2(150);
TYPE T_ARRAY_FUN IS TABLE OF T_TIPO_FUN;

V_MSQL VARCHAR2(5000);


V_TIPO_FUN T_ARRAY_FUN := T_ARRAY_FUN(
		T_TIPO_FUN('EXPORTAR_PDF_EXPEDIENTE','Habilitar la exportación a PDF del Expediente.')
); 

V_TMP_TIPO_FUN T_TIPO_FUN;

BEGIN

	
	
   DBMS_OUTPUT.PUT_LINE('Cargando Funciones......');
   
   FOR I IN V_TIPO_FUN.FIRST .. V_TIPO_FUN.LAST
   LOOP
      V_TMP_TIPO_FUN := V_TIPO_FUN(I);
      v_fun_count := 0;
 
      V_MSQL := 'SELECT count(1) FROM '|| V_ESQUEMA ||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION ='''||V_TMP_TIPO_FUN(1)||'''';
      
      EXECUTE IMMEDIATE V_MSQL INTO v_fun_count;
      
      IF v_fun_count = 0 THEN
      
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION, FUN_DESCRIPCION_LARGA,' ||
                                                                               'VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                ' VALUES( '|| V_ESQUEMA ||'.S_FUN_FUNCIONES.NEXTVAL,'''|| V_TMP_TIPO_FUN(1) || ''',''' || V_TMP_TIPO_FUN(2) || ''',0,''DD'',SYSDATE,0)';
     
        DBMS_OUTPUT.PUT_LINE('INSERTANDO: '||V_TMP_TIPO_FUN(1)||''','''||TRIM(V_TMP_TIPO_FUN(2))||'''');
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
      END IF;
   END LOOP; --LOOP 
   
   COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
       rollback;
	RAISE;
END;
/
