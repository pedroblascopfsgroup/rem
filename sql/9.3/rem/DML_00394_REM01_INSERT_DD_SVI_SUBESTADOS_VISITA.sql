--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201223
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8466
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar subestado de visita
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
   V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
   V_MSQL VARCHAR(20000 CHAR);
   V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8466';
   V_TABLA VARCHAR2(50 CHAR) := 'DD_SVI_SUBESTADOS_VISITA';

 
BEGIN

   DBMS_OUTPUT.put_line('[INICIO]');

   DBMS_OUTPUT.put_line('[INFO] INSERTAR SUBESTADO DE VISITAS "Pdte Información"');

   V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'|| V_TABLA ||' (DD_SVI_ID, DD_EVI_ID, DD_SVI_CODIGO, DD_SVI_DESCRIPCION, DD_SVI_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
                     VALUES (
                     '|| V_ESQUEMA ||'.S_'|| V_TABLA ||'.NEXTVAL,
                     (SELECT DD_EVI_ID FROM '|| V_ESQUEMA ||'.DD_EVI_ESTADOS_VISITA WHERE DD_EVI_CODIGO = ''05''),
                     ''26'',
                     ''Pdte Información'',
                     ''Pdte Información'',
                     '''||V_USUARIO||''',
                     SYSDATE)';
         EXECUTE IMMEDIATE V_MSQL;

   DBMS_OUTPUT.PUT_LINE('[INFO] SUBESTADO INSERTADO CON ÉXITO');
               
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

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
