--###########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5941
--## PRODUCTO=NO
--## 
--## Finalidad:
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_COUNT NUMBER(16) := 0; -- Vble. para contar updates
    V_USUARIO VARCHAR2(25 CHAR) := 'REMVIP-5941';
    
    OFR_NUM_OFERTA NUMBER(16);
    FECHA_INGRESO_CHEQUE VARCHAR2(100 CHAR);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
    V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
        T_JBV('90219820', NULL),
        T_JBV('90114494', '2018-10-30'),
        T_JBV('90194630', '2019-07-26'),
        T_JBV('90201865', '2019-08-06'),
        T_JBV('90201915', '2019-09-11'),
        T_JBV('90202574', '2019-07-16'),
        T_JBV('90204480', '2019-10-07'),
        T_JBV('90205003', '2019-09-11'),
        T_JBV('90206728', '2019-09-18'),
        T_JBV('90207381', '2019-07-31'),
        T_JBV('90208264', '2019-09-30'),
        T_JBV('90211152', '2019-10-16'),
        T_JBV('90212071', '2019-09-20'),
        T_JBV('90212887', '2019-10-21'),
        T_JBV('90213903', '2019-09-20'),
        T_JBV('90215100', '2019-09-26'),
        T_JBV('90215362', '2019-10-28'),
        T_JBV('90215371', '2019-11-25'),
        T_JBV('90215578', '2019-10-24'),
        T_JBV('90216152', '2019-10-18'),
        T_JBV('90216307', '2019-09-27'),
        T_JBV('90216892', '2019-10-31'),
        T_JBV('90217226', '2019-10-22'),
        T_JBV('90217607', '2019-09-30'),
        T_JBV('90217974', '2019-10-18'),
        T_JBV('90218336', '2019-09-30'),
        T_JBV('90218339', '2019-09-30'),
        T_JBV('90218341', '2019-09-30'),
        T_JBV('90218342', '2019-09-30'),
        T_JBV('90218355', '2019-09-30'),
        T_JBV('90218356', '2019-09-30'),
        T_JBV('90218449', '2019-09-30'),
        T_JBV('90218732', '2019-10-31'),
        T_JBV('90218742', '2019-10-31'),
        T_JBV('90218747', '2019-10-31'),
        T_JBV('90218754', '2019-10-31'),
        T_JBV('90218768', '2019-10-31'),
        T_JBV('90218780', '2019-10-31'),
        T_JBV('90218785', '2019-10-30'),
        T_JBV('90219179', '2019-10-31'),
        T_JBV('90222197', '2019-11-05'),
        T_JBV('90222234', '2019-11-12'),
        T_JBV('90222473', '2019-10-30'),
        T_JBV('90222485', '2019-11-27'),
        T_JBV('90222879', '2019-10-29'),
        T_JBV('90222930', '2019-11-20'),
        T_JBV('90223401', '2019-10-22'),
        T_JBV('90224213', '2019-11-28'),
        T_JBV('90224247', '2019-11-28'),
        T_JBV('90224729', NULL),
        T_JBV('90225365', '2019-11-29')
	); 
	V_TMP_JBV T_JBV;

BEGIN	

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
        V_COUNT := V_COUNT + 1;
        
        V_TMP_JBV := V_JBV(I);
        
        OFR_NUM_OFERTA := TRIM(V_TMP_JBV(1));
        FECHA_INGRESO_CHEQUE := TRIM(V_TMP_JBV(2));
        
        IF FECHA_INGRESO_CHEQUE IS NOT NULL THEN
        
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL 
                        SET ECO_FECHA_CONT_PROPIETARIO = TO_DATE('''||FECHA_INGRESO_CHEQUE||''', ''YYYY-MM-DD'')
                            ,DD_EEC_ID = (SELECT DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''08'')
                            ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                            ,FECHAMODIFICAR = SYSDATE
                        WHERE OFR_ID = (SELECT OFR_ID FROM OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||OFR_NUM_OFERTA||')';
            
            EXECUTE IMMEDIATE V_MSQL;
            
        ELSE 
        
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL 
                        SET ECO_FECHA_CONT_PROPIETARIO = TO_DATE('''||FECHA_INGRESO_CHEQUE||''', ''YYYY-MM-DD'')
                            ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                            ,FECHAMODIFICAR = SYSDATE
                        WHERE OFR_ID = (SELECT OFR_ID FROM OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||OFR_NUM_OFERTA||')';
            
            EXECUTE IMMEDIATE V_MSQL;
	
        END IF;
        
	END LOOP;
    
    DBMS_OUTPUT.put_line('[INFO] Se ha actualizado la fecha ingreso cheque de '||V_COUNT||' expedientes');
		
	COMMIT;
 
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
