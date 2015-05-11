package es.pfsgroup.plugin.recovery.masivo.api.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.MSVExcelParser;
import es.pfsgroup.plugin.recovery.masivo.api.MSVCargaDocumentacionApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesosCargaDocsDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVAltaCargaDocDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVCargaDocumentacionInitDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesosCargaDocs;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVUtils;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVCargaDocumentacionColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.recovery.api.AsuntoApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@SuppressWarnings("deprecation")
@Service
@Transactional(readOnly = false)
public class MSVCargaDocumentacionManager implements MSVCargaDocumentacionApi {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	MSVProcesosCargaDocsDao procesosDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	
	private String strErrores;
	
	@Override
	@BusinessOperation(MSV_CARGADOC_FIND_AND_PROCESS)
	public void ejecuta(MSVCargaDocumentacionInitDto msvCargaDocumentacionDto) throws IllegalArgumentException, IOException, Exception {
		List<File> listaFicheros = getConfigFiles(msvCargaDocumentacionDto);
		List<File> listAllAdjuntos = new ArrayList<File>();
		for (File file : listaFicheros ) {
			listAllAdjuntos.addAll(procesarFichero(file, msvCargaDocumentacionDto));
		}
		
		if (msvCargaDocumentacionDto.getBorrarArchivos()) eliminarFicheros(listAllAdjuntos);
		
	}

	@Override
	@BusinessOperation(MSV_CARGADOC_GET_FILES)
	public List<File> getConfigFiles(MSVCargaDocumentacionInitDto msvCargaDocumentacionDto) throws Exception {
		List<File> listaFicheros = new ArrayList<File>();
		
		String rutaReal = msvCargaDocumentacionDto.getDirectorio();
		File file = new File(rutaReal);
		
		if (file.exists()) {
			if (file.isDirectory() ) {
				File[] ficheros = file.listFiles();
				for (int i=0;i<ficheros.length; i++) {
					if (Pattern.matches(dameRegex(msvCargaDocumentacionDto.getMascara()), ficheros[i].getName()))
						if ((!procesosDao.existeDocSinProcesar(ficheros[i].getName())) &&
								(!ficheros[i].getName().endsWith("Err.xls"))) { 
							listaFicheros.add(ficheros[i]);
							
						}
				}
			} else {
				throw new BusinessOperationException("La ruta \'"+rutaReal+"\' no es un directorio");
			}
		} else {
			throw new BusinessOperationException("No se encuentra la ruta: " + rutaReal);
		}
		logger.info("MSVCargaDocumentacion: Se han obtenido " + listaFicheros.size() + " ficheros de configuracion para procesar");
		return listaFicheros;
	}
	
//	@Override
//	public List<File> procesarFicheros(List<File> listaFiles, MSVCargaDocumentacionInitDto msvCargaDocumentacionDto) throws Exception {
//		MSVHojaExcel exc;
//		String strCelda = null;
//		List<File> listAllAdjuntos = new ArrayList<File>();
//		for (File file : listaFiles ) {
//			listAllAdjuntos = procesarFichero(file, msvCargaDocumentacionDto);
//		}
//		return listAllAdjuntos;
//	}
	
	@Override
	@BusinessOperation(MSV_CARGADOC_PRC_FILE)
	public List<File> procesarFichero(File file, MSVCargaDocumentacionInitDto msvCargaDocumentacionDto) throws Exception {
			String strCelda = null;
			
			logger.info("MSVCargaDocumentacion: Procesando el fichero " + file.getName());
			
			List<File> filesToZip = new ArrayList<File>();			
			MSVProcesosCargaDocs msvProcesos = saveProcesoMSV(file);
			
			// inicializamos la lista de errores para este fichero
			List<String> listaErrores = new ArrayList<String>();
			boolean hayErrores = false;

			// Abrimos el csv/xml y recorremos sus filas
			MSVHojaExcel exc = excelParser.getExcel(file);
			List<String> listaCabeceras=exc.getCabeceras();
			for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
				
				FileItem fiAdjunto = null;				
				strErrores = null;				
				Map<String, Object> mapFila = new HashMap<String, Object>();
				
				// Recorremos las columnas
				for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
					strCelda = exc.dameCelda(fila, columna);					
					if ((!"".equals(strCelda)) && (!Checks.esNulo(strCelda))) {
						// Obtenemos el fichero adjunto
						if (listaCabeceras.get(columna).equals(MSVCargaDocumentacionColumns.NOMBRE_ADJUNTO)) {
							File adjuntoFile;
							adjuntoFile = new File(msvCargaDocumentacionDto.getDirectorio() + strCelda);
							if (adjuntoFile.exists()) {
								if (adjuntoFile.length() > 0L) {
									fiAdjunto = new FileItem();
									fiAdjunto.setFile(adjuntoFile);
									fiAdjunto.setLength(adjuntoFile.length());
									fiAdjunto.setFileName(strCelda);
									fiAdjunto.setContentType(obtenerMimeTypeFichero(strCelda));								
									//Añado el adjunto al list de ficheros a comprimir
									filesToZip.add(adjuntoFile);
								} else {
									strErrores = "El fichero tiene tamaño 0Kb";
								}
							}
						}
					}
					mapFila.put(listaCabeceras.get(columna), strCelda);
				}

				// Comprobamos que se ha introducido el fichero adjunto
				if (Checks.esNulo(fiAdjunto)) {
					if (Checks.esNulo(strErrores)) {
						strErrores = "No se encuentra el fichero";
					}
				} else {
					EXTAsunto asunto = null;
					try {
						asunto = validarDatos(mapFila);
						String codigoTipoDocumento = mapFila.get(MSVCargaDocumentacionColumns.TIPO_DOCUMENTO).toString();
						String nombreTipoDocumento = mapFila.get(MSVCargaDocumentacionColumns.NOMBRE_ADJUNTO).toString();
						adjuntarDoc(asunto, nombreTipoDocumento, codigoTipoDocumento, fiAdjunto);
					} catch (Exception e) {
						strErrores = e.getMessage();
						logger.error("Error adjuntar fichero: " + strErrores);
					}
				}
				
				// Emula el onError del CallBack
				listaErrores.add(strErrores);
				if (!Checks.esNulo(strErrores)) hayErrores=true;
			}
			
			// Emula el onEndProcess del CallBack
			String nomFileErrores = onEndProcess(msvProcesos.getId(), listaErrores, file, hayErrores);
			File fileErrores = null;
			if (!Checks.esNulo(nomFileErrores)) {
				//Añado el fichero de error al list de ficheros a comprimir
				fileErrores = new File(nomFileErrores);				
			}
						
			zipAndMove(filesToZip, file, fileErrores, msvCargaDocumentacionDto);			
			return filesToZip;
	}

	private MSVProcesosCargaDocs saveProcesoMSV(File file) {
		// Creamos el registro en la tabla
		MSVProcesosCargaDocs msvProcesos = procesosDao.crearNuevoProceso();			
		msvProcesos.setDescripcion(file.getName());
		MSVDDEstadoProceso estadoProceso=genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_EN_PROCESO));			
		msvProcesos.setEstadoProceso(estadoProceso);
		procesosDao.save(msvProcesos);
		return msvProcesos;
	}
	
	/**
	 * Elimina todos los adjuntos que se han comprimido
	 * @param listAllAdjuntos
	 */
	@Override
	@BusinessOperation(MSV_CARGADOC_DEL_FILES)
	public void eliminarFicheros(List<File> listAllAdjuntos) {
		// Eliminamos todos los archivos comprimidos al final por si existe algún adjunto en dos ficheros de configuración
		logger.info("MSVCargaDocumentacion: Eliminado " + listAllAdjuntos.size() + " ficheros");
		for (File filetoDelete : listAllAdjuntos) {
			if (filetoDelete.exists())
				filetoDelete.delete();
		}
		
	}


	
	
	private EXTAsunto validarDatos(Map<String, Object> map) throws Exception {
		// Comprobar que exista el asunto
				Long idAsunto  = ("".equals(map.get(MSVCargaDocumentacionColumns.ASU_ID)) ? null :  Long.valueOf(map.get(MSVCargaDocumentacionColumns.ASU_ID).toString()));		
				EXTAsunto asu = null;
				
				if (!Checks.esNulo(idAsunto)) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id",
							idAsunto);
					asu = genericDao.get(EXTAsunto.class, filtro);
					if (Checks.esNulo(asu)) {
						throw new BusinessOperationException("No existe el asunto");
					}
				}
				// Comprobar el contrato corresponde con el caso nova
				Long codContrato =  ("".equals(map.get(MSVCargaDocumentacionColumns.N_CASO_NOVA)) ? null : Long.valueOf(map.get(MSVCargaDocumentacionColumns.N_CASO_NOVA).toString()));
				EXTContrato cnt = null;
				if (!Checks.esNulo(codContrato)) {
					cnt = getContratoPorCasoNova(codContrato);
					if (Checks.esNulo(cnt)) {
						throw new BusinessOperationException("No existe el contrato con este caso nova");				
					}
				}
				
				// Comprobar que el asunto corresponde con el contrato
				if((!Checks.esNulo(asu)) && (!Checks.esNulo(cnt))) {
					boolean asuInCnt = false;
					Set<Contrato> cnts = asu.getContratos();
					for (Contrato contrato : cnts) {
						if (contrato.getId().equals(cnt.getId())) {
							asuInCnt = true;
							break;
						}
					}
					if (!asuInCnt) {
						throw new BusinessOperationException("No se corresponden el asunto y el caso nova");
					}
				}
				
				
				// Añadir el adjunto al asunto incorporando tamaño, tipo fichero...
				//Si el asunto no se ha pasado en el csv se obtiene del contrato
				if (Checks.esNulo(asu)) {
					// Obtenemos el primer asunto encontrado
					List <Asunto> listaAsuntos = cnt.getAsuntosActivos(); 
					if (Checks.estaVacio(listaAsuntos)) {
						throw new BusinessOperationException("No se encuentra ningún asunto para este código nova");
					}
					// Obtenemos el primer asunto encontrado
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id",
							((Asunto) listaAsuntos.get(0)).getId());
					asu = genericDao.get(EXTAsunto.class, filtro);
				}
				
				// Comprobamos que tenga algún procedimiento activo
				boolean existeProcedimiento = false;
				List<Procedimiento> procedimientos = asu.getProcedimientos();
				for (Procedimiento procedimiento : procedimientos) {
					if (procedimiento.getEstaAceptado()) {
						existeProcedimiento = true;
						break;
					}
				}		
				if (!existeProcedimiento) {
					throw new BusinessOperationException("No existe ningún procedimiento activo");
				}
				//Comprobamos que se pasa un tipo de documento válido
				String codigoTipoDocumento = map.get(MSVCargaDocumentacionColumns.TIPO_DOCUMENTO).toString();
				if (!"".equals(codigoTipoDocumento) && genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoDocumento)) == null) {
					throw new BusinessOperationException("Tipo de documento no existente.");
				}
				return asu;
	}
	
	/**
	 * Valida que el asunto o contrato pasados en el map sean correctos y le adjunta al asunto el fileItem 
	 * @param codigoTipoDocumento 
	 * @param map
	 * @param adjunto
	 * @return
	 */
	private void adjuntarDoc(EXTAsunto asu, String nombreTipoDocumento, String codigoTipoDocumento, FileItem adjunto) {
		logger.info("---------------------------");
		logger.info("Asunto: "+asu.getId()+" - Nombre documento: "+nombreTipoDocumento);
		EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(adjunto);
		adjuntoAsunto.setAsunto(asu);
		adjuntoAsunto.setDescripcion(nombreTipoDocumento);
		
		DDTipoFicheroAdjunto tipoFicheroAdjunto = null;
		if (codigoTipoDocumento != null) {
			tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoDocumento));
		}
		if (tipoFicheroAdjunto == null) {
			tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "OT"));
		}
		
		adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
		Auditoria.save(adjuntoAsunto);
		asu.getAdjuntos().add(adjuntoAsunto);
		AsuntoApi asuntoApi = proxyFactory.proxy(AsuntoApi.class);
		asuntoApi.saveOrUpdateAsunto(asu);
		logger.info("Asunto ("+asu.getId()+") Guardado");
		
	}	

	private String obtenerMimeTypeFichero(String nombreFichero) {
		Map<String, String> mapaExtensiones = new HashMap<String, String>();
		mapaExtensiones.put(".pdf", "application/pdf");
		mapaExtensiones.put(".txt", "text/plain");
		mapaExtensiones.put(".doc", "application/msword");
		mapaExtensiones.put(".docx", "application/msword");
		mapaExtensiones.put(".xls", "application/excel");
		mapaExtensiones.put(".xlsx", "application/excel");
		mapaExtensiones.put(".xml", "application/xml");
		mapaExtensiones.put(".html", "text/html");
		mapaExtensiones.put(".jpg", "image/jpeg");
		mapaExtensiones.put(".gif", "image/gif");
		mapaExtensiones.put(".png", "image/png");
		
		String defaultExtension = "application/octet-stream";
		
		for (String clave : mapaExtensiones.keySet()) {
			if (nombreFichero.endsWith(clave)) {
				return mapaExtensiones.get(clave); 
			}
		}
		
		return defaultExtension;
	}

	/**
	 * Crea el fichero de errores al finalizar el proceso y devuelve el nombre. Si no ha habido errores devuelve null.
	 * @param idProceso
	 * @param listaErrores
	 * @param file
	 * @param hayErrores
	 * @return String con el nombre del fichero de errores o null en caso de no haber errores.
	 */
	private String onEndProcess(Long idProceso, List<String> listaErrores, File file, boolean hayErrores) {
		MSVAltaCargaDocDto dtoUpdateEstado = new MSVAltaCargaDocDto();
		dtoUpdateEstado.setIdProceso(idProceso);
		String nomFileErrores = null;		
		if (hayErrores) {
			try {
				// Insertamos los errores en el fichero de errores
				MSVHojaExcel hojaExcel = new MSVHojaExcel();
				hojaExcel.setFile(file);
				nomFileErrores = hojaExcel.crearExcelErrores(listaErrores);				
			} catch (RowsExceededException e) {
				throw new BusinessOperationException(e.getCause() + " " + e.getMessage());
			} catch (IllegalArgumentException e) {
				throw new BusinessOperationException(e.getCause() + " " + e.getMessage());
			} catch (WriteException e) {
				throw new BusinessOperationException(e.getCause() + " " + e.getMessage());
			} catch (IOException e) {
				throw new BusinessOperationException(e.getCause() + " " + e.getMessage());
			}

			// Cambiamos el estado del proceso "Procesado con errores"
			dtoUpdateEstado.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_PROCESADO_CON_ERRORES);			
		} else {
			// Cambiamos el estado del proceso "Procesado"
			dtoUpdateEstado.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_PROCESADO);			
		}
		// Updateamos el estado
		this.modificaProcesoCargaDoc(dtoUpdateEstado);
		
		return nomFileErrores;
	}
	
	
	
	
	/**
	 * Devuelve el primer contrato encontrado por el número caso nova
	 * @param casoNova
	 * @return
	 */
	private EXTContrato getContratoPorCasoNova(Long casoNova) {

		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "nroContrato",
				casoNova);
		EXTContrato cnt = genericDao.get(EXTContrato.class, filtro);
		return cnt;

	}

	@Override
	@BusinessOperation(MSV_CARGADOC_MODIFICACION)
	public MSVProcesosCargaDocs modificaProcesoCargaDoc(MSVAltaCargaDocDto dto) {
		
		MSVProcesosCargaDocs procesoMasivo;
		if (Checks.esNulo(dto.getIdProceso())){
			throw new BusinessOperationException("Necesitamos un id de proceso a modificar");
		} else {			
			procesoMasivo=procesosDao.mergeAndGet(dto.getIdProceso());
		}
		
		if (!Checks.esNulo(procesoMasivo)){
			if (!Checks.esNulo(dto.getIdEstadoProceso())){
				MSVDDEstadoProceso estadoProceso=genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdEstadoProceso()));
				if(!Checks.esNulo(estadoProceso)){
					procesoMasivo.setEstadoProceso(estadoProceso);
				}	
			}else
			if (!Checks.esNulo(dto.getCodigoEstadoProceso())){
				MSVDDEstadoProceso estadoProceso=genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoEstadoProceso()));
				if(!Checks.esNulo(estadoProceso)){
					procesoMasivo.setEstadoProceso(estadoProceso);
				}
			}
		}
		procesosDao.mergeAndUpdate(procesoMasivo);
		return procesoMasivo;
		
	}


	/**
     * Se le pasa una máscara de fichero típica de ficheros con * e ? y
     * devuelve la cadena regex que entiende la clase Pattern.
     * @param mascara Un String que no sea null.
     * @return Una máscara regex válida para Pattern.
     */
    private static String dameRegex(String mascara)
    {
        mascara = mascara.replace(".", "\\.");
        mascara = mascara.replace("*", ".*");
        mascara = mascara.replace("?",".");
        return mascara;
    }
    
    private String makeDir(String rutaFicheros) throws InterruptedException {
    	boolean existe = false;
    	File fileDir = null;
    	String rutaCopia = null;
    	do {
	    	String nombre = MSVUtils.getNow("yyyyMMdd_HHmmss","_CargaDoc");
	    	rutaCopia = rutaFicheros+nombre+"/";
	    	// Creamos el directorio de copia
			fileDir = new File(rutaCopia);
			if (fileDir.exists()) {
				// Si existe esperamos un segundo para cambiar el nombre de la carpeta
				Thread.sleep(1000);
				existe = true;
			} else {
				existe = false;
			}
    	} while(existe);
    	
		fileDir.mkdir();
		return rutaCopia;
    }

		
	private void zipAndMove(List<File> filesToZip, File fileConfig, File fileErrores, MSVCargaDocumentacionInitDto msvCargaDocumentacionDto) throws Exception {
		
		String rutaFicheros = msvCargaDocumentacionDto.getRutaBackup();
		String rutaCopia = makeDir(rutaFicheros);
		
		if ((filesToZip.size()>0) && (msvCargaDocumentacionDto.getHacerBackup())) { 
			logger.info("MSVCargaDocumentacion: Realizando el backup de " + fileConfig.getName() + " - " + filesToZip.size());
			final int BUFFER_SIZE = 1024;
			
			FileInputStream fis = null;
			FileOutputStream fos = null;
			ZipOutputStream zipos = null;
			
			byte[] buffer = new byte[BUFFER_SIZE];
			
			try {
				fos = new FileOutputStream(rutaCopia+"adjuntos.zip");		
				zipos = new ZipOutputStream(fos);
			} catch (FileNotFoundException e1) {
				throw e1;
			}
			
			for (File filetoZip : filesToZip) {
				try {
					fis = new FileInputStream(filetoZip);				
					ZipEntry zipEntry = new ZipEntry(filetoZip.getName());
					zipos.putNextEntry(zipEntry);
				
					int len = 0;
					
					while ((len = fis.read(buffer, 0, BUFFER_SIZE)) != -1)
						zipos.write(buffer, 0, len);
					
					// volcar la memoria al disco
					zipos.flush();
					fis.close();
				} catch (Exception e) {
					//No hacemos nada - duplicacion de fichero
					logger.info("Error ZIP: " + e.getMessage());
				}
			}
			// cerramos los files
			zipos.close();			
			fos.close();
		}
		
		// Movemos el fichero de configuración y errores a la carpeta backup
		if (!fileConfig.renameTo(new File(rutaCopia+fileConfig.getName()))) {
			logger.error("MSVCargaDocumentacion: No se ha podido mover el archivo " + fileConfig.getName() + " a " + rutaCopia);
		}
		if (!Checks.esNulo(fileErrores)) {
			if(!fileErrores.renameTo(new File(rutaCopia+fileErrores.getName()))) {
				logger.error("MSVCargaDocumentacion: No se ha podido mover el archivo de error " + fileErrores.getName() + " a " + rutaCopia);
			}
		}
		
			
	}
		
	
}
