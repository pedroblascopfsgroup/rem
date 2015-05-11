--/*
--##########################################
--## AUTOR=OSCAR_DORADO
--## FECHA_CREACION=20150427
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.8
--## INCIDENCIA_LINK=FASE-1191
--## PRODUCTO=SI
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');


execute immediate 'INSERT INTO '||V_ESQUEMA||'.bie_adicional
   SELECT '||V_ESQUEMA||'.s_bie_adicional.NEXTVAL bie_adi_id, tmp.*
     FROM (SELECT bie_id, bie_adi_nom_empresa bie_adi_nom_empresa, bie_adi_cif_empresa bie_adi_cif_empresa, bie_adi_cod_iae bie_adi_cod_iae, bie_adi_des_iae bie_adi_des_iae, dd_tpb_id dd_tpb_id,
                  dd_tpn_id dd_tpn_id, bie_adi_valoracion bie_adi_valoracion, bie_adi_entidad bie_adi_entidad, bie_adi_num_cuenta bie_adi_num_cuenta, bie_adi_matricula bie_adi_matricula,
                  bie_adi_bastidor bie_adi_bastidor, bie_adi_modelo bie_adi_modelo, bie_adi_marca bie_adi_marca, bie_adi_fechamatricula bie_adi_fechamatricula, 0 VERSION, ''FASE-1195'' usuariocrear,
                  SYSDATE fechacrear, NULL usuariomodificar, NULL fechamodificar, NULL usuarioborrar, NULL fechaborrar, 0 borrado, bie_adi_ffin_rev_carga bie_adi_ffin_rev_carga,
                  bie_adi_sin_carga bie_adi_sin_carga, bie_adi_obs_carga bie_adi_obs_carga, bie_adi_deuda_segun_juz bie_adi_deuda_segun_juz, bie_adi_can_cargas_resumen bie_adi_car_cargas_resumen,
                  bie_adi_can_cargas_propuesta bie_adi_can_cargas_propuesta
             FROM (SELECT DISTINCT adi2.*
                              FROM (SELECT bie.bie_id, slb.deuda_segun_juz, adi.bie_adi_deuda_segun_juz, mig.cd_bien, sub.fecha_celebracion_subasta,
                                           RANK () OVER (PARTITION BY bie.bie_id ORDER BY sub.fecha_celebracion_subasta DESC, slb.deuda_segun_juz DESC) ranking
                                      FROM '||V_ESQUEMA||'.bie_bien bie JOIN '||V_ESQUEMA||'.bie_adicional adi ON bie.bie_id = adi.bie_id
                                           JOIN '||V_ESQUEMA||'.mig_procedimientos_bienes mig ON bie.bie_codigo_externo = mig.cd_bien
                                           JOIN '||V_ESQUEMA||'.mig_procedimientos_subastas sub ON mig.cd_procedimiento = sub.cd_procedimiento
                                           JOIN '||V_ESQUEMA||'.mig_procs_subasta_lotes_bienes slb ON mig.cd_bien = slb.cd_bien
                                           JOIN
                                           (SELECT   bie_id total
                                                FROM '||V_ESQUEMA||'.bie_adicional adi
                                            GROUP BY bie_id
                                              HAVING COUNT (*) > 1) adi ON bie.bie_id = adi.total
                                     WHERE slb.deuda_segun_juz = adi.bie_adi_deuda_segun_juz) total
                                   JOIN '||V_ESQUEMA||'.bie_adicional adi2 ON total.bie_id = adi2.bie_id AND total.deuda_segun_juz = adi2.bie_adi_deuda_segun_juz
                             WHERE 1 = 1
--and total.bie_id = 100000008
                                   AND ranking = 1)) tmp';



EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.bie_adicional
      WHERE bie_adi_id IN (SELECT bie_adi_id
                             FROM (SELECT bie_id, bie_adi_id, RANK () OVER (PARTITION BY bie_id ORDER BY bie_adi_id DESC) ranking
                                     FROM '||V_ESQUEMA||'.bie_adicional bie)
                            WHERE ranking > 1)';

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');

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
