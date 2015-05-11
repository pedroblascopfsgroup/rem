package es.pfsgroup.plugin.recovery.iplus.pruebasBankia;

import es.cm.gw.API_Iplus.*;

public class PruebaAcciones {

	public static void main(String[] args) {

		int documentos = 1;
		AccionDocumento[] misAccionesDoc;
		misAccionesDoc = new AccionDocumento[documentos];

		try {
			ClaveExpediente[] misClaves;
			AccionSobreExpediente02 miAccionExp;
			int numeroClaves = 3;

			miAccionExp = new AccionSobreExpediente02();
			miAccionExp.asignarDirectorioLocal("RUTA DEL DIRECTORIO LOCAL");
			miAccionExp.asignarUsuario("Annnnnn");
			miAccionExp.asignarBaseDatos("BDBDBDBDBD");
			miAccionExp.asignarExpediente("EXEXEXEXEX");
			miAccionExp
					.asignarCodigoAccion(AccionSobreExpediente.CREAR_O_TRABAJAR_CON_DOCUMENTOS);

			// Información de Ficheros del Documento 1
			int numFicheros = 2;
			InformacionFichero[] infoFicheros = new InformacionFichero[numFicheros];
			for (int k = 0; k < numFicheros; k++)
				infoFicheros[k] = new InformacionFichero();
			infoFicheros[0].asignarDescripcion("Descripción del fichero 1");
			//infoFicheros[0].asignarExtension("Extensión del fichero 1");
			infoFicheros[0].asignarUbicacion("Ruta del fichero 1");
			infoFicheros[1].asignarDescripcion("Descripción del fichero 2");
			//infoFicheros[1].asignarExtension("Extensión del fichero 2");
			infoFicheros[1].asignarUbicacion("Ruta del fichero 2");

			for (int i = 0; i < documentos; i++) {
				misAccionesDoc[i] = new AccionDocumento();
			}
			misAccionesDoc[0].asignarAccionDocumento(1,
					AccionDocumento.CREAR_O_AÑADIR_PAGINAS, infoFicheros); // Crea
																			// el
																			// documento
																			// con
																			// los
																			// ficheros
																			// especificados
																			// en
																			// infoFicheros
																			// o
																			// añade
																			// los
																			// ficheros
																			// al
																			// documento

			miAccionExp.asignarAccionesDocumentos(misAccionesDoc);

			misClaves = new ClaveExpediente[numeroClaves];
			for (int i = 0; i < numeroClaves; i++)
				misClaves[i] = new ClaveExpediente();
			misClaves[0].asignarValorClave(1, "AB2");
			misClaves[1].asignarValorClave(2, 778);
			misClaves[2].asignarValorClave(3, "50");
			miAccionExp.asignarClaves(misClaves);

			miAccionExp.realizarAccionExpediente();

			// El metodo "realizarAccionExpediente()" escribe los resultados de
			// las acciones
			// realizadas sobre los Documentos, en el array -ya definido- de
			// objetos del tipo
			// AccionDocumento
			for (int i = 0; i < misAccionesDoc.length; i++)
				System.out.println("Documento "
						+ misAccionesDoc[i].obtenerOrdenDocumento() + ": "
						+ misAccionesDoc[i].obtenerCodigoResultado() + " "
						+ misAccionesDoc[i].obtenerDescripcionResultado());
		} catch (Throwable th) {
			// TratamientoErrores.VentanaErrores v = new
			// TratamientoErrores.VentanaErrores();
			if (th instanceof ExcepcionIplus) {
				ExcepcionIplus ex;
				ex = (ExcepcionIplus) th;
				// v.setMensajeUsuario(ex.obtenerMensajeError());
				System.out.println(ex.obtenerCodigoRetorno());
				// Si la excepción se debe a un “Error de Documento”, se deben
				// examinar los
				// resultados de las acciones realizadas sobre los Documentos,
				// para determinar
				// en qué Documentos se ha producido el error
				if ((ex.obtenerCodigoRetorno()).equalsIgnoreCase("002"))
					for (int i = 0; i < misAccionesDoc.length; i++)
						System.out.println("Documento "
								+ misAccionesDoc[i].obtenerOrdenDocumento()
								+ ": "
								+ misAccionesDoc[i].obtenerCodigoResultado()
								+ " "
								+ misAccionesDoc[i]
										.obtenerDescripcionResultado());
			}
			// v.gestionError(th);
		}
	}
}
