--/*
--##########################################
--## AUTOR= Sergio Salt
--## FECHA_CREACION=20191228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8881
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CNP_CONFIG_PORTAL los datos añadidos en T_ARRAY_DATA.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REGISTROS NUMBER(16); -- Vble. para validar la existencia de un registro.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TABLA_PRINCIPAL VARCHAR2(2400 CHAR) := 'ACT_CNP_CONFIG_PORTAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_JOIN_CARTERA VARCHAR2(2400 CHAR) := 'DD_CRA_CARTERA';
    V_TABLA_JOIN_SUBCARTERA VARCHAR2(2400 CHAR) := 'DD_SCR_SUBCARTERA';
    V_USUARIO_ACCION VARCHAR2(20 CHAR) := 'HREOS-8881'; -- Vble. auxiliar para almacenar el usuario que realiza la accion
    

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
--T_TIPO_DATA(  'CODIGO_CARTERA','CODIGO_SUBCARTERA','PENDIENTE_INSCRIPCION','CON_CARGAS,OCUPADO_SIN_TITULO,OCUPADO_CON_TITULO',USUARIO_ACCION)
        T_TIPO_DATA(    '08',             NULL,               1,              1,             0,            0,          V_USUARIO_ACCION),
        T_TIPO_DATA(    '02',             NULL,               1,              1,             1,            1,          V_USUARIO_ACCION),
        T_TIPO_DATA(    '07',             NULL,               1,              0,             0,            0,          V_USUARIO_ACCION)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    --Funciones para evitar exceso de comillas
    function toString  
      (input IN varchar2 ) return varchar2    IS
    null_input exception;
    output varchar2(5000);
    begin
      if input is not null then
            output := '''' || trim(input) || '''';
            return output;
      else 
        raise null_input;
      end if;
      exception 
        when null_input then
          return 'NULL';

    end;
    function toNumber
      (input IN varchar2 ) return varchar2    IS
    null_input exception;
    output varchar2(5000);
    flag number;
    begin
    
      if input is not null then
        flag := to_number(input);
        return input;
      else 
        raise null_input;
      end if;
      exception 
        when null_input then
          return 'NULL'; 
        when VALUE_ERROR then
         DBMS_OUTPUT.PUT_LINE(input);
         raise VALUE_ERROR;
    end;
    --Funcion para convertir códigos a sus IDs asociados
    function codigoToID  
      (codigo IN varchar2 , 
        entidad IN varchar2 ,  
        entidad_siglas IN varchar2) return varchar2 
     IS
      null_input exception;
      output varchar2(16);
    begin
        if codigo is not null 
              and entidad is not null 
                and entidad_siglas is not null then            
            EXECUTE IMMEDIATE ('SELECT DD_'|| entidad_siglas ||'_ID
              FROM ' || entidad || 
            ' WHERE DD_'||entidad_siglas||'_CODIGO = '||codigo) INTO output;
            DBMS_OUTPUT.PUT_LINE(output);
            return output;
        else 
          raise null_input;
        end if;
        exception 
          when null_input then
            return NULL;
    end;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_PRINCIPAL);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_SQL := 'SELECT count(1)
          FROM '||V_ESQUEMA||'.'||V_TABLA_PRINCIPAL||' config
          INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_JOIN_CARTERA||' 
            cartera ON config.DD_CRA_ID = cartera.DD_CRA_ID 
              AND cartera.DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''''
        ;
        IF TRIM(V_TMP_TIPO_DATA(2)) IS NOT NULL
        THEN V_SQL := V_SQL || ' INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_JOIN_SUBCARTERA||' 
            subcartera on config.DD_SCR_ID = subcartera.DD_SCR_ID 
              AND subcartera.DD_SCR_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''';
        END IF;


        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

        IF V_NUM_REGISTROS > 0 THEN		
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO CON EL CODIGO  '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TABLA_PRINCIPAL||
          ' SET 
            DD_CRA_ID = '||toNumber(codigoToID(TRIM(V_TMP_TIPO_DATA(1)),V_TABLA_JOIN_CARTERA,'CRA'))||',
            DD_SCR_ID = '||toNumber(codigoToID(TRIM(V_TMP_TIPO_DATA(2)),V_TABLA_JOIN_SUBCARTERA,'SCR'))||',
            CNP_PENDIENTE_INSCRIPCION = '||toNumber(TRIM(V_TMP_TIPO_DATA(3)))||',
            CNP_CON_CARGAS = '||toNumber(TRIM(V_TMP_TIPO_DATA(4)))||',
            CNP_OCUPADO_SIN_TITULO = '||toNumber(TRIM(V_TMP_TIPO_DATA(5)))||',
            CNP_OCUPADO_CON_TITULO = '||toNumber(TRIM(V_TMP_TIPO_DATA(6)))||',
            USUARIOMODIFICAR = '||toString(TRIM(V_TMP_TIPO_DATA(7)))||',
            FECHAMODIFICAR = SYSDATE
            WHERE DD_CRA_ID = '||toNumber(codigoToID(TRIM(V_TMP_TIPO_DATA(1)),V_TABLA_JOIN_CARTERA,'CRA'))||'';
            IF TRIM(V_TMP_TIPO_DATA(2)) IS NOT NULL
            THEN 
              V_MSQL := V_MSQL ||
                ' AND DD_SCR_ID =  '||toNumber(codigoToID(TRIM(V_TMP_TIPO_DATA(2)),V_TABLA_JOIN_SUBCARTERA,'SCR'))||'';
            ELSE 
              V_MSQL := V_MSQL ||
                ' AND DD_SCR_ID IS NULL ';
            END IF;
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

        ELSE		
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TABLA_PRINCIPAL||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          
          V_MSQL := ' INSERT INTO ' || V_ESQUEMA || '.' ||V_TABLA_PRINCIPAL ||
          '(CNP_ID,DD_CRA_ID, DD_SCR_ID, CNP_PENDIENTE_INSCRIPCION, CNP_CON_CARGAS,
            CNP_OCUPADO_SIN_TITULO, CNP_OCUPADO_CON_TITULO, USUARIOCREAR, FECHACREAR, BORRADO)
            VALUES
            ('
            ||toNumber(V_ID) ||', '
            ||toNumber(codigoToID(TRIM(V_TMP_TIPO_DATA(1)),V_TABLA_JOIN_CARTERA,'CRA'))||', '
            ||toNumber(codigoToID(TRIM(V_TMP_TIPO_DATA(2)),V_TABLA_JOIN_SUBCARTERA,'SCR'))||', '
            ||toNumber(TRIM(V_TMP_TIPO_DATA(3)))||', '
            ||toNumber(TRIM(V_TMP_TIPO_DATA(4)))||', '
            ||toNumber(TRIM(V_TMP_TIPO_DATA(5)))||', '
            ||toNumber(TRIM(V_TMP_TIPO_DATA(6)))||', '
            ||toString(TRIM(V_TMP_TIPO_DATA(7)))||', '
            ||toString(SYSDATE)||', '
            ||toNumber(0)||
            ')
          ';
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA_PRINCIPAL||' ACTUALIZADA CORRECTAMENTE ');


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