package es.pfsgroup.plugin.recovery.iplus.driver;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.Normalizer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.cm.gw.API_Iplus.AccionDocumento;
import es.cm.gw.API_Iplus.AccionFicheroDocumento;
import es.cm.gw.API_Iplus.AccionSobreExpediente02;
import es.cm.gw.API_Iplus.ClaveExpediente;
import es.cm.gw.API_Iplus.ConsultaExpediente;
import es.cm.gw.API_Iplus.ExcepcionIplus;
import es.cm.gw.API_Iplus.InformacionDocumento;
import es.cm.gw.API_Iplus.InformacionFichero;
import es.cm.gw.API_Iplus.InformacionPagina;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.iplus.IplusDocDto;
import es.pfsgroup.plugin.recovery.iplus.manager.GestionIplusApi;

@Component
public class GestionIplusBankia implements GestionIplus {

	public static final String BBDD_IPLUS = "IPLGESTION";
	public static final String EXPEDIENTE_IPLUS = "ACTIVADJ01";

	public static final String IPLUS_DEBUG = "iplus.debug";
	public static final String IPLUS_RUTA_TMP = "iplus.rutatmp";
	public static final String IPLUS_USUARIO = "iplus.usuario";
	public static final String USUARIO_IPLUS = "A153744";
	// Pruebas: A153744 - Real: A153745

	private static final String DEVON_HOME_BANKIA = "datos/usuarios/recovecp";
	private static final String DEVON_HOME = "DEVON_HOME";
	private static final String DEVON_PROPERTIES = "devon.properties";

	private static final String SI = "SI";
	
	private SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	private static DecimalFormat df = new DecimalFormat("000");

	@Autowired
	private ApiProxyFactory proxyFactory;

	private Properties appProperties;

	private String iplusDebug = SI;
	private String iplusRutaTmp = null;
	private String iplusUsuario = null;
		
	public void almacenar(String idProcedi, int orden, String nombreFichero, File file) {
		
		//miDebug("[GestionIplusBankia.almacenar]: " + idProcedi + " - " + orden + " - " + nombreFichero + " - " + file.getName());
	
		int documentos = 1, numeroClaves = 1;

		ClaveExpediente[] misClaves = null;
		AccionSobreExpediente02 miAccionExp = null;
		try {
			comprobarPropiedades();

			misClaves = new ClaveExpediente[numeroClaves];
			miAccionExp = new AccionSobreExpediente02();
			miAccionExp.asignarDirectorioLocal(iplusRutaTmp);
			miAccionExp.asignarBaseDatos(BBDD_IPLUS);
			miAccionExp.asignarExpediente(EXPEDIENTE_IPLUS);

			// Si está informado en las propiedades ponemos ese (el genérico), si no recuperamos el conectado
			// Pero OJO, que debe tener las autorizaciones pertinentes
			miAccionExp.asignarUsuario(iplusUsuario); // Pruebas: A153744 - Real:
													// A153745.

			miAccionExp.asignarCodigoAccion(AccionSobreExpediente02.CREAR_O_TRABAJAR_CON_DOCUMENTOS);
		} catch (Throwable e) {
			miDebug("[GestionIplusBankia.almacenar]: " + e.getMessage());
			e.printStackTrace();
		}

		// indico a IPLUS la información del fichero que quiero subir
		InformacionFichero info[] = new InformacionFichero[1];
		info[0] = new InformacionFichero();
		int fin = nombreFichero.lastIndexOf(".");
		info[0].asignarDescripcion(nombreFichero.substring(0, fin));

		String extensionFichero = obtenerExtension(nombreFichero);
		info[0].asignarExtension(extensionFichero);
		info[0].asignarUbicacion(file.getAbsolutePath());

		AccionDocumento[] misAccionesDoc = new AccionDocumento[1];

		for (int i = 0; i < documentos; i++) {
			misAccionesDoc[i] = new es.cm.gw.API_Iplus.AccionDocumento();
		}

		// Crea el documento con el contenido del directorio, o fichero, especificado
		int numProcedi = Integer.parseInt(idProcedi);

		try {
			misAccionesDoc[0].asignarAccionDocumento(orden,
					AccionDocumento.CREAR_O_AÑADIR_PAGINAS, info);
			miAccionExp.asignarAccionesDocumentos(misAccionesDoc);
			for (int i = 0; i < numeroClaves; i++)
				misClaves[i] = new es.cm.gw.API_Iplus.ClaveExpediente();
			misClaves[0].asignarValorClave(1, numProcedi); // ID PROCEDIMIENTO
			miAccionExp.asignarClaves(misClaves);
			miAccionExp.realizarAccionExpediente();
		} catch (Throwable e) {
			miDebug("[GestionIplusBankia.almacenar]: " + e.getMessage());
			if (e instanceof ExcepcionIplus) {
				ExcepcionIplus ex = (ExcepcionIplus) e;
				miDebug(ex.obtenerCodigoRetorno());
				// Si la excepción se debe a un “Error de Documento”, se deben examinar los
				// resultados de las acciones realizadas sobre los Documentos, para determinar
				// en qué Documentos se ha producido el error
				if ((ex.obtenerCodigoRetorno()).equalsIgnoreCase("002"))
					for (int i = 0; i < misAccionesDoc.length; i++)
						miDebug("Documento " + misAccionesDoc[i].obtenerOrdenDocumento()
								+ ": " + misAccionesDoc[i].obtenerCodigoResultado()
								+ " " + misAccionesDoc[i].obtenerDescripcionResultado());
			}
			e.printStackTrace();
		}

		for (AccionDocumento accionDocumento : misAccionesDoc) {
			miDebug("[GestionIplusBankia.almacenar]: AccionDocumento: " + 
					accionDocumento.obtenerCodigoResultado() + "-" + accionDocumento.obtenerDescripcionResultado());
		}

	}

	private void comprobarPropiedades() {
		
		if (appProperties == null || appProperties.isEmpty()) {
			miDebug("[GestionIplusBankia.comprobarPropiedades] appProperties es nulo.");
			appProperties = cargarProperties(DEVON_PROPERTIES);
		}

		if (appProperties == null || appProperties.isEmpty()) {
			System.out.println("[GestionIplusBankia.comprobarPropiedades] 3");
			miDebug("[GestionIplusBankia.comprobarPropiedades] appProperties no se ha podido cargar de: " + DEVON_PROPERTIES);
		} else {
			if (iplusDebug.equals(SI)) {
				iplusDebug = obtenerValorProps(appProperties, IPLUS_DEBUG, SI);
			}
			if (iplusRutaTmp == null) {
				iplusRutaTmp = obtenerValorProps(appProperties, IPLUS_RUTA_TMP, obtenerPathTemp());
				File fileDirTmp = new File(iplusRutaTmp);
				if (!fileDirTmp.exists()) {
					//miDebug("[GestionIplusBankia.comprobarPropiedades]: Creamos " + iplusRutaTmp + " porque no existe.");
					fileDirTmp.mkdir();
				} else {
					//miDebug("[GestionIplusBankia.comprobarPropiedades]: Borrado de documentos previos de " + iplusRutaTmp + ".");
					borrarDocumentosPrevios(iplusRutaTmp);
				}
				//miDebug("[GestionIplusBankia.comprobarPropiedades]: Directorio local=" + iplusRutaTmp);
			}
			if (iplusUsuario == null) {
				iplusUsuario = obtenerValorProps(appProperties, IPLUS_USUARIO, obtenerUsuario());
			}
		}
		
	}
	
	private String obtenerValorProps(Properties props, String clave, String defecto) {
		//System.out.println("[GestionIplusBankia.obtenerValorProps] " + clave + "\t" + defecto); // + "\n\n" + props);
		String resultado = defecto;
		if (props.containsKey(clave) && props.getProperty(clave) != null) {
			resultado = props.getProperty(clave);
		}
		return resultado;
	}

	public List<IplusDocDto> listaDocumentos(String idProcedi) {

		//miDebug("[GestionIplusBankia.listaDocumentos]: idProcedi=" + idProcedi);

		List<IplusDocDto> listaResultado = new ArrayList<IplusDocDto>();

		try {
			comprobarPropiedades();

			ClaveExpediente[] misClaves;
			ConsultaExpediente miConsulta;
			int numeroClaves = 1;
			misClaves = new ClaveExpediente[numeroClaves];
			miConsulta = new ConsultaExpediente();
			
			String dirTmp = iplusRutaTmp + idProcedi + File.separator;
			creacionDirectorioTemporal(dirTmp);
			
			miConsulta.asignarDirectorioLocal(dirTmp); // Temporal
			
			//miDebug("[GestionIplusBankia.listaDocumentos]: Directorio local=" + dirTmp);
			
			borrarDocumentosPrevios(dirTmp);

			// Si está informado en las propiedades ponemos ese (el genérico), si no recuperamos el conectado
			// Pero OJO, que debe tener las autorizaciones pertinentes
			miConsulta.asignarUsuario(iplusUsuario); // Pruebas: A153744 - Real:
													// A153745.

			miConsulta.asignarBaseDatos(BBDD_IPLUS);
			miConsulta.asignarExpediente(EXPEDIENTE_IPLUS);

			// Poner el orden 0 para todos los documentos
			miConsulta.asignarOrdenDocumento(0);
			
			//miDebug("[GestionIplusBankia.listaDocumentos]: : miConsulta="	+ iplusUsuario + "," + BBDD_IPLUS + "," + EXPEDIENTE_IPLUS);

			misClaves[0] = new ClaveExpediente();
			misClaves[0].asignarValorClave(1, idProcedi);
			miConsulta.asignarClaves(misClaves);
			//miDebug("[GestionIplusBankia.listaDocumentos]: misClaves:" + misClaves[0].obtenerOrdenClave() + "=" + misClaves[0].obtenerValorClave());
			
			InformacionDocumento[] infoDoc = miConsulta.obtenerDocumento(true);
			//listarDocumentos(infoDoc);			
			
			listaResultado = obtenerFicheros(idProcedi, dirTmp, miConsulta);

		} catch (Throwable th) {
			if (th instanceof ExcepcionIplus) {
				ExcepcionIplus ex = (ExcepcionIplus) th;
				miDebug("[GestionIplusBankia.listaDocumentos]: CodigoRetorno=" + ex.obtenerCodigoRetorno());
				miDebug("[GestionIplusBankia.listaDocumentos]: MensajeError=" + ex.obtenerMensajeError());
			}
			if (th.getMessage() != null) {
				miDebug("[GestionIplusBankia.listaDocumentos]: excepcion=" + th.getMessage());
			} else {
				th.printStackTrace();
			}
		}

		return listaResultado;
	}

	private void creacionDirectorioTemporal(String dirTmp) {
		
		File fileTmp = new File(dirTmp);
		if (!fileTmp.exists()) {
			String texto = "[GestionIplusBankia.creacionDirectorioTemporal] Creamos directorio " + dirTmp + " porque no existe previamente";
			//miDebug(texto);
			if (!fileTmp.mkdir()) {
				texto = "[GestionIplusBankia.creacionDirectorioTemporal] Error al intentar crear el directorio " + dirTmp + ".";
				//miDebug(texto);
			}
		}
		
	}

//	private void listarDocumentos(InformacionDocumento[] infoDoc) {
//
//		int numPags, ordenDoc;
//		InformacionPagina[] infoPag;
//
//		miDebug("[GestionIplusBankia.listaDocumentos]: Número de Documentos: " + infoDoc.length);
//		
//		for (int i = 0; i < infoDoc.length; i++) {
//			infoPag = infoDoc[i].obtenerInformacionPaginas();
//			ordenDoc = infoDoc[i].obtenerOrden();
//			numPags = infoDoc[i].obtenerNumeroPaginas();
//
//			StringBuffer msj = new StringBuffer("");
//			if (isIplusDebug()) {
//				if (numPags == 0) {
//					msj.append("Datos del documento de orden " + ordenDoc + " (" + 
//						infoDoc[i].obtenerCodigo() + "\tNo hay ficheros de este tipo.");
//				} else {
//					msj.append("Datos del documento de orden " + ordenDoc + " (" + infoDoc[i].obtenerCodigo()
//							+ ") con " + numPags + " ficheros/s");
//					msj.append("\tDescripción: " + infoDoc[i].obtenerDescripcion());
//					msj.append("\tFormato: " + infoDoc[i].obtenerFormato());
//					msj.append("\tMultiples páginas: " + infoDoc[i].obtenerMultiplesPaginas());
//					msj.append("\tOrden presentación: " + infoDoc[i].obtenerOrdenPresentacion());
//					msj.append("\tTipo digitalización: " + infoDoc[i].obtenerTipoDigitalizacion());
//					msj.append("\tResolución digitalización: " + infoDoc[i].obtenerResolucionDigitalizacion());
//					msj.append("\tAncho ventana: " + infoDoc[i].obtenerAnchoVentana());
//					msj.append("\tCódigo icono: " + infoDoc[i].obtenerCodigoIcono());
//					msj.append("\tExistencia servidor: " + infoDoc[i].obtenerExistenciaServidor());
//					msj.append("\tNúmero ficheros: " + infoDoc[i].obtenerNumeroPaginas());
//					msj.append("\tNúmero servidor: " + infoDoc[i].obtenerNumeroServidor());
//					msj.append("\tEstado: " + infoDoc[i].obtenerEstado());
//					msj.append("\tDescripcion obligatoria: " + infoDoc[i].obtenerDescripcionObligatoria());
//					msj.append("\tFormato descripción: " + infoDoc[i].obtenerFormatoDescripcion());
//
//					/* Información de ficheros */
//					for (int j = 0; j < numPags; j++) {
//						msj.append("\tDatos del fichero " + infoPag[j].obtenerNumero());
//						msj.append("\t\tPertenece al documento: " + infoPag[j].obtenerOrdenDocumento());
//						msj.append("\t\tExtensión: " + infoPag[j].obtenerExtensionFichero());
//						msj.append("\t\tDescripción: " + infoPag[j].obtenerDescripcion());
//						msj.append("\t\tFecha alta: " + infoPag[j].obtenerFechaAlta());
//						msj.append("\t\tUsuario alta: " + infoPag[j].obtenerUsuarioAlta());
//						msj.append("\t\tUbicacion: " + infoPag[j].obtenerUbicacion());
//						msj.append("\t\tEstado: " + infoPag[j].obtenerEstado());
//					}
//				}
//				miDebug(msj.toString());
//			}
//		}
//
//	}

//	private String obtenerTipoDoc(int ordenDoc) {
//		if (proxyFactory != null) {
//			return proxyFactory.proxy(GestionIplusApi.class)
//				.obtenerTipoDocDeNumOrden(ordenDoc);
//		} else {
//			return "DOC";
//		}
//	}

	@Override
	public FileItem abrirDocumento(String idProcedi, String nombre, String descripcion) {

		//miDebug("[GestionIplusBankia.abrirDocumento]: " + idProcedi + " - " + nombre + " - " + descripcion);

		String nombreDoc = normalizar(nombre);
		String descripcionDoc = normalizar(descripcion);

		//miDebug("[GestionIplusBankia.abrirDocumento] después de normalizar : " + idProcedi + " - " + nombreDoc + " - " + descripcionDoc);

		String dirTmp = iplusRutaTmp + idProcedi + File.separator;
		File dirTrabajo = new File(dirTmp);
		if (!dirTrabajo.exists()) {
			miDebug("Directorio " + dirTmp + " no existe");
		}
		File[] directorios = dirTrabajo.listFiles();

		for (File dir : directorios) {

			if (dir.isDirectory() && dir.listFiles() != null) {
				File[] subdirs = dir.listFiles();
				if (subdirs != null && subdirs.length > 0 ) {
					for (int i1 = 0; i1 < subdirs.length; i1++) {
						File[] archivos = subdirs[i1].listFiles();
						for (File archivo : archivos) {
							
							String nombreIplus = normalizar(archivo.getName());
							
							if (nombreDoc.equals(nombreIplus) || descripcionDoc.equals(nombreIplus)) {
								FileItem fi = new FileItem(archivo);								
								fi.setContentType("text/html");
								fi.setFileName(descripcionDoc);
								return fi;
							}
						}
					}
				} else {
					miDebug("[IPLUS.obtenerFicheros]: No tiene subdirectorios " + dir.getAbsolutePath());
				}
			}
		}

		return null;
	}

	@Override
	public void borrarDocumento(String idProcedi, String nombre, String descripcion) {

		//miDebug("[GestionIplusBankia.borrarDocumento]: " + idProcedi + " - " + nombre + " - " + descripcion);
		
		int[] datosFichero = obtenerDatosFichero(idProcedi, 0, descripcion);
		//miDebug("[GestionIplusBankia.borrarDocumento]: " + idProcedi + " - " + datosFichero[1] + " - " + datosFichero[0]);
		if (datosFichero[0] > 0) {
			borrarDocumentoIPlus(idProcedi, datosFichero[1], datosFichero[0]);
		} else {
			System.out.println("[GestionIplusBankia.borrarDocumento]: nombre=" + descripcion + " no encontrado.");
		}

	}

	@Override
	public void modificarDocumento(String idProcedi, int orden,
			String nombreFichero, IplusDocDto dto) {

		//miDebug("[GestionIplusBankia.modificarDocumento]: " + idProcedi + " - " + orden + " - " + nombreFichero);

	}

	private String obtenerPathTemp() {

		String dirTmp = "";
		try {
			File temp = File.createTempFile("temp-file-name", ".tmp");
			String tempFilePath = temp.getAbsolutePath().substring(0, temp.getAbsolutePath().lastIndexOf(File.separator));
			dirTmp = tempFilePath + "/iplus/" + obtenerUsuario();
		} catch (IOException e) {
			miDebug("[GestionIplusBankia.obtenerPathTemp]: " + e.getMessage());
			e.printStackTrace();
		}
		return dirTmp;

	}

	private String obtenerUsuario() {
		//Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		//return usuario.getUsername();
		//TODO: obtener usuario conectado (cuando los usuarios tengan permiso de acceso a IPLUS)
		return USUARIO_IPLUS;
	}

	private Boolean isIplusDebug() {
		return iplusDebug.equals(SI);
	}

	private void borrarDocumentosPrevios(String dirs) {
		
		File[] subdirs = (new File(dirs)).listFiles();
		if (subdirs != null && subdirs.length > 0) {
			try {
				for (File file : subdirs) {
					deleteDir(file);
				}
			} catch (IOException e) {
				miDebug("Error al borrar ficheros: " + e.getMessage());
			}
		}

	}
	
	private void deleteDir(File f) throws IOException {
		if (f.isDirectory()) {
			for (File c : f.listFiles())
				deleteDir(c);
		}
		if (!f.delete()) {
			throw new FileNotFoundException("No se ha podido borrar el fichero: " + f);
		}
	}

	private List<IplusDocDto>  obtenerFicheros(String idProcedi, String dirTmp, ConsultaExpediente miConsulta) throws Throwable {
		
		List<IplusDocDto> listaResultado = new ArrayList<IplusDocDto>();

		// Obtengo las rutas de aquellos subdirectorios que se hayan
		// generado tras bajar los ficheros de IPLUS
		// dentro del directorio de sesión del servidor
		File dirTrabajo = new File(dirTmp);
		File[] directorios = dirTrabajo.listFiles();

		// renombro los ficheros descargados desde IPLUS con sus nombres y extensiones originales
		InformacionDocumento[] infoDocumentos = miConsulta.obtenerInformacionDocumentos();
		
		for (File dir : directorios) {
			File[] subdirs = dir.listFiles();
			if (subdirs != null && subdirs.length > 0 ) {
				List<IplusDocDto> listaFicheros = obtenerInfoFicheros(idProcedi, subdirs, infoDocumentos);
				if (listaFicheros.size() > 0) {
					listaResultado.addAll(listaFicheros);
				}
			} else {
				miDebug("[IPLUS.obtenerFicheros]: No tiene subdirectorios " + dir.getAbsolutePath());
			}
		}
		return listaResultado;

	}
	
	private List<IplusDocDto> obtenerInfoFicheros(String idProcedi, File[] directorios, InformacionDocumento[] infoDocumentos) {
		
		List<IplusDocDto> listaFicheros = new ArrayList<IplusDocDto>();
		
		for (int i1 = 0; i1 < directorios.length; i1++) {
			String[] archivos = directorios[i1].list();
			// obtenemos la información de aquellos documentos que  tienen archivos asociados
			int principio = directorios[i1].getPath().lastIndexOf("/") + 1;
			int fin = directorios[i1].getPath().length();
			int indiceInfoDocumento = Integer.parseInt(directorios[i1].getPath().substring(principio, fin)) - 1;
			InformacionPagina[] infoPaginas = infoDocumentos[indiceInfoDocumento].obtenerInformacionPaginas() != null ? 
					infoDocumentos[indiceInfoDocumento].obtenerInformacionPaginas() : null;
			for (int j = 0; j < archivos.length; j++) {
				File archivoIPLUS = new File(directorios[i1].getPath()
						+ "/" + archivos[j]);
				//miDebug("[IPLUS.obtenerInfoFicheros] archivoIPLUS=" + directorios[i1].getPath() + "/" + archivos[j]);
				if (infoPaginas != null && infoPaginas.length > 0) { 
					File archivoSalida = null;
					String usuarioCrear = iplusUsuario;
					Date fechaCrear = new Date();
					for (int k = 0; k < infoPaginas.length; k++) {
						int numeroAlmacenado = infoPaginas[k].obtenerNumero();
						int numeroArchivo = Integer.parseInt(archivos[j].substring(0, archivos[j].lastIndexOf(".")));
						//miDebug("[IPLUS.obtenerInfoFicheros] numeroAlmacenado=" + numeroAlmacenado + ",numeroArchivo=" + numeroArchivo);
						if (numeroAlmacenado == numeroArchivo) {
							String nombreArchivoSalida = directorios[i1].getPath()+ "/" + 
									df.format(infoDocumentos[indiceInfoDocumento].obtenerOrden()) + "-" + 
									df.format(numeroAlmacenado) + "-" + infoPaginas[k].obtenerDescripcion()+ "."+ 
									infoPaginas[k].obtenerExtensionFichero();
							archivoSalida = new File(nombreArchivoSalida);
							//miDebug("[IPLUS.obtenerInfoFicheros] archivoSalida=" + nombreArchivoSalida);
							String fechaCrearStr = infoPaginas[k].obtenerFechaAlta();
							if (fechaCrearStr != null && !fechaCrearStr.equals("")) {
								try {
									fechaCrear = sdf.parse(fechaCrearStr);
								} catch (ParseException e) {
									miDebug("[IPLUS.obtenerInfoFicheros] Error al parsear fechaCrear=" + 
											fechaCrearStr + ": " + e.getMessage());
								}
							}
							if (infoPaginas[k].obtenerUsuarioAlta() != null && infoPaginas[k].obtenerUsuarioAlta().equals("")) {
								usuarioCrear = infoPaginas[k].obtenerUsuarioAlta();
							}
							break;
						}
					}
					if (archivoSalida != null) {
						archivoIPLUS.renameTo(archivoSalida);
						//miDebug("[IPLUS.renombrarFicheros] archivo archivoIPLUS " + archivoIPLUS.getAbsolutePath() + " renombrado a " + archivoSalida.getAbsolutePath());

						IplusDocDto dto = new IplusDocDto();
						int numOrden = infoDocumentos[indiceInfoDocumento].obtenerOrden();
						dto.setCodigoTipoDoc(Integer.toString(numOrden));
						dto.setIdProcedi(idProcedi);
						dto.setNombreFichero(normalizar(infoDocumentos[indiceInfoDocumento].obtenerDescripcion()));
						dto.setFile(archivoSalida);
						dto.setNumOrden(numOrden);
						dto.setFechaCrear(fechaCrear);
						dto.setUsuarioCrear(usuarioCrear);
						listaFicheros.add(dto);
					}
				}
			}
		}
		return listaFicheros;

	}

	private void miDebug(String texto) {
		if (isIplusDebug()) {
			System.out.println(texto);
		}
	}

	private Properties cargarProperties(String nombreProps) {

		InputStream input = null;
		Properties prop = new Properties();
		
		try {
			String devonHome = DEVON_HOME_BANKIA;
			System.out.println("[GestionIplusBankia.cargarProperties]: /" + devonHome + "/" + nombreProps);
			if (System.getenv(DEVON_HOME) != null) {
				devonHome = System.getenv(DEVON_HOME);
			}
			System.out.println("[GestionIplusBankia.cargarProperties]: /" + devonHome + "/" + nombreProps);
			
			try {
				input = new FileInputStream("/" + devonHome + "/" + nombreProps);
				System.out.println("[GestionIplusBankia.cargarProperties]: input:" + input);
				prop.load(input);
				System.out.println("[GestionIplusBankia.cargarProperties]: input:" + prop);
			} catch (IOException ex) {
				System.out.println("[GestionIplusBankia.cargarProperties]: /" + devonHome + "/" + nombreProps + ":" + ex.getMessage());
			} finally {
				if (input != null) {
					try {
						input.close();
					} catch (IOException e) {
						System.out.println("[GestionIplusBankia.cargarProperties]: /" + devonHome + "/" + nombreProps + ":" + e.getMessage());
					}
				}
			}
		} catch (Exception e) {
			System.out.println("[GestionIplusBankia.cargarProperties]: " + nombreProps + ":" + e.getMessage());
			e.printStackTrace();
		}
		return prop;
	}

	public void setAppProperties(Properties appProperties) {
		this.appProperties = appProperties;
	}

//	private String obtenerNuevoNombreFicheroTemporal(String nombreFicheroTemporal, String nombreFichero) {
//		
//		//Quitar la extensión tmp y sustituirla por la original
//		int posExtensionTmp = nombreFicheroTemporal.lastIndexOf(".") + 1;
//		int posExtensionOri = nombreFichero.lastIndexOf(".") + 1;
//		String extensionTmp = nombreFicheroTemporal.substring(posExtensionTmp);
//		String extensionOriginal = nombreFichero.substring(posExtensionOri);
//		String nuevoNombreFicheroTemporal = nombreFicheroTemporal;
//		if ("TMP".equalsIgnoreCase(extensionTmp)) {
//			nuevoNombreFicheroTemporal = nombreFicheroTemporal.substring(0,posExtensionTmp-1) + "." + extensionOriginal;
//		}
//		return nuevoNombreFicheroTemporal;
//
//	}

	private String obtenerExtension(String nombreFichero) {
		
		int posExtensionOri = nombreFichero.lastIndexOf(".") + 1;
		String extensionOriginal = nombreFichero.substring(posExtensionOri);
		return extensionOriginal;

	}

	private int[] obtenerDatosFichero(String idProcedi, int orden,
			String nombreFichero) {
		
		//miDebug("[GestionIplusBankia.obtenerDatosFichero]: " + idProcedi + " - " + orden + " - " + nombreFichero);

		int[] datosFichero = {0, 0};
		
		int numFichero = 0;
		int ordenFichero = 0;
		
		try {
			ClaveExpediente[] misClaves;
			ConsultaExpediente miConsulta;
			int numeroClaves = 1;
			misClaves = new ClaveExpediente[numeroClaves];
			miConsulta = new ConsultaExpediente();

			String dirTmp = iplusRutaTmp + idProcedi + File.separator;
			creacionDirectorioTemporal(dirTmp);
			
			miConsulta.asignarDirectorioLocal(dirTmp); // Temporal
			
			//miDebug("[GestionIplusBankia.obtenerDatosFichero]: Directorio local=" + dirTmp);

			miConsulta.asignarUsuario(iplusUsuario); 
			miConsulta.asignarBaseDatos(BBDD_IPLUS);
			miConsulta.asignarExpediente(EXPEDIENTE_IPLUS);

			miConsulta.asignarOrdenDocumento(orden);

			misClaves[0] = new ClaveExpediente();
			misClaves[0].asignarValorClave(1, idProcedi);
			miConsulta.asignarClaves(misClaves);

			InformacionDocumento[] infoDoc = miConsulta.obtenerInformacionDocumentos();
			
			int numPags, ordenDoc;
			InformacionPagina[] infoPag;
			for (int i = 0; i < infoDoc.length; i++) {
				infoPag = infoDoc[i].obtenerInformacionPaginas();
				ordenDoc = infoDoc[i].obtenerOrden();
				numPags = infoDoc[i].obtenerNumeroPaginas();
				if (orden == 0 || ordenDoc == orden) {
					if (numPags > 0) {
						for (int j = 0; j < infoPag.length; j++) {
							String descripcionDocIPLUS = infoPag[j].obtenerDescripcion() + "." + 
									infoPag[j].obtenerExtensionFichero().toUpperCase();
							//miDebug("[GestionIplusBankia.obtenerDatosFichero]: " + nombreFichero + " - " + descripcionDocIPLUS);
							if (nombreFichero.endsWith(descripcionDocIPLUS)) {
								numFichero = infoPag[j].obtenerNumero();
								ordenFichero = infoPag[j].obtenerOrdenDocumento();
								//miDebug("[GestionIplusBankia.obtenerDatosFichero] resultado: " + numFichero + " - " + ordenFichero);
								break;
							}
						}
					}
				}
				if (numFichero != 0) {
					break;
				}
			}
		} catch (Throwable th) {
			if (th instanceof ExcepcionIplus) {
				ExcepcionIplus ex;
				ex = (ExcepcionIplus) th;
				System.out.println("[GestionIplusBankia.obtenerDatosFichero]: CodigoRetorno=" + ex.obtenerCodigoRetorno());
				System.out.println("[GestionIplusBankia.obtenerDatosFichero]: MensajeError=" + ex.obtenerMensajeError());
			}
			if (th.getMessage() != null) {
				System.out.println("[GestionIplusBankia.obtenerDatosFichero]: excepcion=" + th.getMessage());
			} else {
				th.printStackTrace();
			}
		}
		
		datosFichero[0] = numFichero;
		datosFichero[1] = ordenFichero;
		return datosFichero;
	}

	private void borrarDocumentoIPlus(String idProcedi, int ordenDoc, int numFichero) {
		
		//miDebug("[GestionIplusBankia.borrarDocumentoIPlus]: " + idProcedi + " - " + ordenDoc + " - " + numFichero);
	
		int numeroClaves = 1;

		ClaveExpediente[] misClaves = null;
		AccionSobreExpediente02 miAccionExp = null;
		AccionDocumento[] accionesDoc = new AccionDocumento[1];
		accionesDoc[0] = new AccionDocumento();
		
		try {
			comprobarPropiedades();

			misClaves = new ClaveExpediente[numeroClaves];
			miAccionExp = new AccionSobreExpediente02();
			miAccionExp.asignarDirectorioLocal(iplusRutaTmp);
			miAccionExp.asignarBaseDatos(BBDD_IPLUS);
			miAccionExp.asignarExpediente(EXPEDIENTE_IPLUS);

			// Si está informado en las propiedades ponemos ese (el genérico), si no recuperamos el conectado
			// Pero OJO, que debe tener las autorizaciones pertinentes
			miAccionExp.asignarUsuario(iplusUsuario); // Pruebas: A153744 - Real:
													// A153745.
			miAccionExp.asignarCodigoAccion(AccionSobreExpediente02.TRABAJAR_CON_DOCUMENTOS);
		} catch (Throwable e) {
			miDebug("[GestionIplusBankia.borrarDocumentoIPlus]: " + e.getMessage());
			e.printStackTrace();
		}

		// Crea el documento con el contenido del directorio, o fichero, especificado
		int numProcedi = Integer.parseInt(idProcedi);

		try {

			// indico a IPLUS la información del fichero que quiero borrar
			AccionFicheroDocumento[] misAccionesFicheroDoc = new AccionFicheroDocumento[1];
			misAccionesFicheroDoc[0] = new AccionFicheroDocumento();
			misAccionesFicheroDoc[0].borrar(numFichero);
			//misAccionesDoc[0].asignarAccionDocumento(ordenDoc, AccionDocumento.BORRAR, nombreFichero);
			for (int i = 0; i < numeroClaves; i++)
				misClaves[i] = new ClaveExpediente();
			misClaves[0].asignarValorClave(1, numProcedi); // ID PROCEDIMIENTO
			miAccionExp.asignarClaves(misClaves);
			
			accionesDoc[0].asignarAccionDocumento(ordenDoc, AccionDocumento.TRABAJAR_CON_FICHEROS, misAccionesFicheroDoc);
			miAccionExp.asignarAccionesDocumentos(accionesDoc);
			
			miAccionExp.realizarAccionExpediente();

		} catch (Throwable e) {
			miDebug("[GestionIplusBankia.borrarDocumentoIPlus]: " + e.getMessage());
			if (e instanceof ExcepcionIplus) {
				ExcepcionIplus ex = (ExcepcionIplus) e;
				miDebug(ex.obtenerCodigoRetorno());
			}
			e.printStackTrace();
		}

		for (AccionDocumento accionDocumento : accionesDoc) {
			miDebug("[GestionIplusBankia.borrarDocumentoIPlus]: AccionDocumento: " + 
					accionDocumento.obtenerCodigoResultado() + "-" + accionDocumento.obtenerDescripcionResultado());
		}

	}

	/**
	 * Función que elimina acentos y caracteres especiales de
	 * una cadena de texto.
	 * @param input
	 * @return cadena de texto limpia de acentos y caracteres especiales.
	 */
	public static String normalizar(String input) {

		String aux = Normalizer.normalize(input, Normalizer.Form.NFD);
		String resultado = aux.replaceAll("[^\\x00-\\x7F]", "");
		return resultado;
		
	}
	
}
