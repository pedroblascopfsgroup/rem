--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211231
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11004
--## PRODUCTO=NO
--## 
--## Finalidad: CREAR PRESUPUESTOS 2022 EN ACT_PTO_PRESUPUESTO
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

  V_ESQUEMA VARCHAR2(30 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USER VARCHAR2(50 CHAR):= 'REMVIP-11004';

  V_ANYO VARCHAR2(50 CHAR):='2022';

BEGIN

	--Comprobamos SI ESTA EL EJERCICIO 2021

        	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||V_ANYO||''' ';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
	        --Si existe CONTINUAMOS
        	IF V_NUM_TABLAS > 0 THEN
      
		      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la insercion de presupuestos para los activos');

		      -------------------------------------------------
		      --INSERCION EN ACT_PTO_PRESUPUESTO--
		      -------------------------------------------------   
		      DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_PTO_PRESUPUESTO');

		      
		      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO T1
						USING (
							SELECT  ACT.ACT_ID, EJE.EJE_ID,  PTO.PTO_ID     
							FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                            				LEFT JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ANYO = '''||V_ANYO||'''
							LEFT JOIN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO PTO ON PTO.ACT_ID = ACT.ACT_ID AND PTO.EJE_ID = EJE.EJE_ID AND PTO.BORRADO = 0 
                            				WHERE ACT.BORRADO = 0 AND PTO.PTO_ID IS NULL
						) T2
						ON (T1.PTO_ID = T2.PTO_ID)
						WHEN NOT MATCHED THEN 
						INSERT (T1.PTO_ID,
							T1.ACT_ID,
							T1.EJE_ID,
							T1.PTO_IMPORTE_INICIAL,
							T1.PTO_FECHA_ASIGNACION,
							T1.VERSION,
							T1.USUARIOCREAR,
							T1.FECHACREAR,
							T1.BORRADO
						       )
					    	VALUES ('||V_ESQUEMA||'.S_ACT_PTO_PRESUPUESTO.NEXTVAL
							,T2.ACT_ID
							,(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||V_ANYO||''')
							,50000
							,to_date(''01/01/'||V_ANYO||''' ,''dd/mm/yyyy'')
							,0
							,'''||V_USER||'''
							,SYSDATE
							,0
						    	)
						    	';
				    
		      EXECUTE IMMEDIATE V_SQL;
		      
		      DBMS_OUTPUT.PUT_LINE('[INFO]  '||SQL%ROWCOUNT||' PRESUPUESTOS INSERTADOS');  

		ELSE
          		DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL EJERCICIO '''||V_ANYO||''' ');
				
        END IF;    

      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[FIN]');   
       
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;
/
EXIT;
