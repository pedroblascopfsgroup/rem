--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20151110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.17-bk
--## INCIDENCIA_LINK=BKREC-1051
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
	

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'SELECT count(*) from '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''adjuntosDescargaZipExtensiones'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN

      DBMS_OUTPUT.PUT_LINE('[WARN] YA EXISTE: No se ha insertado el nuevo PARANETRO de PEN_PARAM_ENTIDAD adjuntosDescargaZipExtensiones');
  
  ELSE
	

    --/**
    -- * Se crean los nuevos parametros para configurar la descarga de archivos adjuntos
    -- * comprimidos en ZIP. Estos parametros permiten activar/desactivar la compresion 
    -- * permiten escoger las extensiones que deben encapsularse en ZIP y permiten elegir
    -- * el nivel de compresion.
    -- **/
    EXECUTE IMMEDIATE 
        'INSERT
          INTO '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
            (
              PEN_ID,
              PEN_PARAM,
              PEN_VALOR,
              PEN_DESCRIPCION,
              PEN_USOS,
              VERSION,
              USUARIOCREAR,
              FECHACREAR
            )
            VALUES
            (
              ' || V_ESQUEMA || '.S_PEN_PARAM_ENTIDAD.nextval,
              ''adjuntosDescargaZipExtensiones'',
              ''*.rtf *.docx'',
              ''Encapsula en ZIP las descargas de adjuntos, segun extension del adjunto.'',
              ''Syntaxis de la cadena PEN_VALOR:
                  "disable"                --> Deshabilita el encapsulado en ZIP
                  "*.*"                    --> Comprime en ZIP TODAS las descargas de adjuntos
                  "*.xxx"                  --> Comprime en ZIP solo los adjuntos que NO tienen ninguna extension
                  "*.ext1"                 --> Comprime en ZIP solo los adjuntos con extension "ext1". Metodo sencillo 
                  "*.ext1 *.ext2 *.ext3"   --> Comprime en ZIP solo los adjuntos con extensiones "ext1", "ext2" y "ext3". Metodo multiple.'',
              ''0'',
              ''BKREC-1051'',
              sysdate
            )';

    DBMS_OUTPUT.PUT_LINE('[INFO] Parametro adjuntosDescargaZipExtensiones, creado.');
  
  END IF;


  V_SQL := 'SELECT count(*) from '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD WHERE PEN_PARAM = ''adjuntosDescargaZipNivelCompresion'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN

      DBMS_OUTPUT.PUT_LINE('[WARN] YA EXISTE: No se ha insertado el nuevo PARANETRO de PEN_PARAM_ENTIDAD adjuntosDescargaZipNivelCompresion');
  
  ELSE

    EXECUTE IMMEDIATE 
        'INSERT
          INTO '||V_ESQUEMA||'.PEN_PARAM_ENTIDAD
            (
              PEN_ID,
              PEN_PARAM,
              PEN_VALOR,
              PEN_DESCRIPCION,
              PEN_USOS,
              VERSION,
              USUARIOCREAR,
              FECHACREAR
            )
            VALUES
            (
              ' || V_ESQUEMA || '.S_PEN_PARAM_ENTIDAD.nextval,
              ''adjuntosDescargaZipNivelCompresion'',
              ''0'',
              ''Nivel de compresion ZIP para las descargas encapsuladas. Valor [0-9]'',
              ''Syntaxis de la cadena PEN_VALOR:
                  [0-9]
                  0  --> Sin compresion, solo encapsula en ZIP
                  5  --> Compresion por defecto
                  9  --> Compresion maxima '',
              ''0'',
              ''BKREC-1051'',
              sysdate
            )';

    DBMS_OUTPUT.PUT_LINE('[INFO] Parametro adjuntosDescargaZipNivelCompresion, creado.');

  END IF;


    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT]');

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('[ROLLBACK]');
    RAISE;   
END;
/

EXIT;