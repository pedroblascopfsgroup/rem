package es.pfsgroup.plugin.recovery.iplus.pruebasBankia;

import es.cm.gw.API_Iplus.*;

public class PruebaConsulta {

	public static void main(String[] args) {
		// ----------------- Consulta Expediente - Obtener Documentos e Información Documentos -------------------------
		try {
			ClaveExpediente[] misClaves;
			ConsultaExpediente miConsulta;
			int numeroClaves = 2;
			misClaves = new ClaveExpediente[numeroClaves];
			miConsulta = new ConsultaExpediente();
			miConsulta.asignarDirectorioLocal("C:/TEMP"); //Temporal
			miConsulta.asignarUsuario("A116621");  //Usuario de pruebas
			miConsulta.asignarBaseDatos("IPLPRUEBAS");
			miConsulta.asignarExpediente("PRUEBASFUN");

			miConsulta.asignarOrdenDocumento(0);

			for (int i=0; i<numeroClaves; i++) {
				misClaves[i] = new ClaveExpediente();
			}
			misClaves[0].asignarValorClave(1,"1");
			misClaves[1].asignarValorClave(2,"1");

			miConsulta.asignarClaves(misClaves);

			int numPags, ordenDoc;
			InformacionDocumento[] infoDoc;
			InformacionPagina[] infoPag;

			infoDoc = miConsulta.obtenerDocumento(true);

			System.out.println("Número de Documentos: "+infoDoc.length);
			for (int i=0; i<infoDoc.length; i++) {
				infoPag = infoDoc[i].obtenerInformacionPaginas();
				ordenDoc = infoDoc[i].obtenerOrden();
				numPags = infoDoc[i].obtenerNumeroPaginas();

				System.out.println("Datos del documento de orden "+ordenDoc+" con "+numPags+" ficheros/s");	
				System.out.println("\tCódigo: " + infoDoc[i].obtenerCodigo());
				System.out.println("\tDescripción: " + infoDoc[i].obtenerDescripcion());
				System.out.println("\tFormato: " + infoDoc[i].obtenerFormato());
				System.out.println("\tMultiples páginas: " + infoDoc[i].obtenerMultiplesPaginas());
				System.out.println("\tOrden presentación: " + infoDoc[i].obtenerOrdenPresentacion());
				System.out.println("\tTipo digitalización: " + infoDoc[i].obtenerTipoDigitalizacion());
				System.out.println("\tResolución digitalización: " + infoDoc[i].obtenerResolucionDigitalizacion());
				System.out.println("\tAncho ventana: " + infoDoc[i].obtenerAnchoVentana());
				System.out.println("\tCódigo icono: " + infoDoc[i].obtenerCodigoIcono());
				System.out.println("\tExistencia servidor: " + infoDoc[i].obtenerExistenciaServidor());
				System.out.println("\tNúmero ficheros: " + infoDoc[i].obtenerNumeroPaginas());
				System.out.println("\tNúmero servidor: " + infoDoc[i].obtenerNumeroServidor());
				System.out.println("\tEstado: " + infoDoc[i].obtenerEstado());
				System.out.println("\tDescripcion obligatoria: " + infoDoc[i].obtenerDescripcionObligatoria());
				System.out.println("\tFormato descripción: " + infoDoc[i].obtenerFormatoDescripcion());

				/* Información de ficheros */
				for (int j=0; j<numPags; j++) {		
					System.out.println("\tDatos del fichero " + infoPag[j].obtenerNumero());
					System.out.println("\t\tPertenece al documento: " + infoPag[j].obtenerOrdenDocumento());
					System.out.println("\t\tExtensión: " + infoPag[j].obtenerExtensionFichero());
					System.out.println("\t\tDescripción: " + infoPag[j].obtenerDescripcion());
					System.out.println("\t\tFecha alta: " + infoPag[j].obtenerFechaAlta());
					System.out.println("\t\tUsuario alta: " + infoPag[j].obtenerUsuarioAlta());
					System.out.println("\t\tUbicacion: " + infoPag[j].obtenerUbicacion());
					System.out.println("\t\tEstado: " + infoPag[j].obtenerEstado());
					//System.out.println("\t\tIdentificador: " + infoPag[j].obtenerIdentificador());
				}

			}
		

		} catch (Throwable th) {
			if (th instanceof ExcepcionIplus) { 
				ExcepcionIplus ex;
				ex = (ExcepcionIplus) th;
				System.out.println(ex.obtenerCodigoRetorno());
				System.out.println(ex.obtenerMensajeError());
			}
		}
	}
}
