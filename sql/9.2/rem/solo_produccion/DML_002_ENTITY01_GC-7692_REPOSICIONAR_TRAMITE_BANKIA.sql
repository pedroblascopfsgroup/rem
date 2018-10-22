--/*
--##########################################
--## AUTOR=Jorge Mollá
--## FECHA_CREACION=20181001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMNIVUNO-1513
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   USUARIO VARCHAR2(50 CHAR):= 'REMNIVUNO-1513'; -- Usuario con el que se registraran las modificaciones. Campo obligatorio
   LIST_EXP_REP VARCHAR2(1024 CHAR):= '86504'; -- Ej. 'XXX,XXX,XXX'-- Lista de números de expedientes comerciales, separados por comas, que queramos reposicionar. Es obligatorio.
   TRAM_DESTINO VARCHAR2(1024 CHAR):= 'T013_ResolucionExpediente' ; -- Trámite al que se quiere avanzar cada expediente comercial. Es obligatorio.
   LIST_EXP_EEC VARCHAR2(1024 CHAR):= ''; -- Ej. 'XXX,XXX,XXX' -- Lista de números de expediente comerciales, separados por comas, que queramos cambiar su estado. No es obligatorio, si se deja vacío no hará ese paso.
   EEC_DESTINO VARCHAR2(1024 CHAR):= ''; --  Estado en el que se quiere poner el expediente o expedientes comerciales que se pasen en la lista anterior. No es obligatorio, si se deja vacío no hará ese paso.
   PL_OUTPUT VARCHAR2(20000 CHAR);
   
/*  
   TAREAS DEL TRÁMITE -- TRAM_DESTINO
   Código tarea trámite					Descripción
   T014_DefinicionOferta				Definición Oferta -- Alquiler
   T013_DefinicionOferta				Definición Oferta -- Venta
   T013_CierreEconomico					Cierre Económico
   T013_ResolucionComite				Resolución Comité
   T013_RespuestaOfertante				Respuesta Ofertante
   T013_InstruccionesReserva			Instrucciones Reserva
   T013_ResultadoPBC					Resultado PBC
   T013_PosicionamientoYFirma			Posicionamiento y Firma
   T013_ResolucionExpediente			Resolución Expediente
                      
                      
	ESTADO EXPEDIENTE COMERCIAL -- EEC_DESTINO
	Código Descripción
		01	En tramitación
		02	Anulado
		03	Firmado
		04	Contraofertado
		05	Bloqueo Adm.
		06	Reservado
		07	Posicionado
		08	Vendido
		09	Resuelto
		15	Alquilado
		10	Pte. Sanción
		11	Aprobado
		12	Denegado
		13	Pte. doble firma
		14	Rpta. ofertante
		16	En devolución
*/


BEGIN

	#ESQUEMA#.REPOSICIONAMIENTO_TRAMITE(USUARIO,LIST_EXP_REP,TRAM_DESTINO,LIST_EXP_EEC,EEC_DESTINO,PL_OUTPUT);
       

COMMIT;

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
