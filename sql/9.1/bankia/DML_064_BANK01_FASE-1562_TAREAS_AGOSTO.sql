/* Formatted on 2015/08/05 13:36 (Formatter Plus v4.8.8) */
--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20150805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.14-bk
--## INCIDENCIA_LINK=FASE-1562
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
   v_esquema           VARCHAR2 (25 CHAR)     := '#ESQUEMA#';                                                                                                                  -- Configuracion Esquema
   v_esquema_m         VARCHAR2 (25 CHAR)     := '#ESQUEMA_MASTER#';                                                                                                    -- Configuracion Esquema Master
   err_num             NUMBER (25);                                                                                                              -- Vble. auxiliar para registrar errores en el script.
   err_msg             VARCHAR2 (1024 CHAR);                                                                                                     -- Vble. auxiliar para registrar errores en el script.
   par_esquema         VARCHAR2 (25 CHAR)     := '#ESQUEMA#';                                                                                                        -- [PARAMETRO] Configuracion Esquemas
   v_nueva_fecha       VARCHAR2 (25 CHAR);
   v_tar_id            NUMBER (16, 0);

   TYPE crs_actualizacion_type IS REF CURSOR;

   crs_actualizacion   crs_actualizacion_type;
BEGIN
   OPEN crs_actualizacion FOR    'SELECT TO_CHAR(nueva_fecha, ''dd/mm/yyyy HH24:MI:SS'') AS nueva_fecha,      
tar.tar_id    
FROM '
                              || par_esquema
                              || '.tar_tareas_notificaciones tar    
JOIN      
(SELECT tar.tar_id,        
SUBSTR(tar_fecha_venc,0,8) fecha_actual,        
CASE          
WHEN TO_CHAR (add_months (tar_fecha_venc, 1), ''D'') = 6          
THEN add_months (tar_fecha_venc, 1) + 2          
WHEN TO_CHAR (add_months (tar_fecha_venc, 1), ''D'') = 7          
THEN add_months (tar_fecha_venc, 1) + 1          
ELSE add_months (tar_fecha_venc, 1)        
END nueva_fecha      
FROM '
                              || par_esquema
                              || '.tar_tareas_notificaciones tar      
JOIN '
                              || par_esquema
                              || '.asu_asuntos asu      
ON tar.asu_id                             = asu.asu_id      
AND dd_tas_id                            IN (1,2)      
WHERE extract (MONTH FROM tar_fecha_venc) = 8      
AND tar_fecha_fin                        IS NULL      
AND TRUNC (tar_fecha_venc)                > TRUNC (sysdate)      
AND TRUNC(tar.tar_fecha_venc)             = TRUNC(tar.tar_fecha_venc_real)      
AND tar_tarea NOT                        IN ( ''Registrar comparecencia'', ''Registrar audiencia prévia'', ''Confirmar celebración juicio'', ''Registrar celebración vista'', ''Registrar Vista'', ''Lectura y aceptacion de instrucciones'', ''Celebración subasta y adjudicación'', ''Dictar Instrucciones'', ''Correo a gestión de activos'', ''Confirmar celebración del juicio verbal'',''Anotacion'')      
) fecha ON tar.tar_id                     = fecha.tar_id';

   LOOP
      FETCH crs_actualizacion
       INTO v_nueva_fecha, v_tar_id;

      EXIT WHEN crs_actualizacion%NOTFOUND;

      EXECUTE IMMEDIATE    'update '
                        || par_esquema
                        || '.tar_tareas_notificaciones set usuariomodificar = ''FASE-1562'', fechamodificar=sysdate, tar_fecha_venc = '''
                        || v_nueva_fecha
                        || ''' where tar_id = '
                        || v_tar_id;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      err_num := SQLCODE;
      err_msg := SQLERRM;
      DBMS_OUTPUT.put_line ('KO - error');
      DBMS_OUTPUT.put_line ('[ERROR] Se ha producido un error en la ejecución:' || TO_CHAR (err_num));
      DBMS_OUTPUT.put_line ('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line (err_msg);
      ROLLBACK;
      RAISE;
END;
/

EXIT