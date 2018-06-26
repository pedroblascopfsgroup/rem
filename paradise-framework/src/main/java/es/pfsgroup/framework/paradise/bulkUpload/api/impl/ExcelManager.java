package es.pfsgroup.framework.paradise.bulkUpload.api.impl;

import java.io.FileNotFoundException;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVProcesoDao;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoAltaProceso;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.model.ExcelFileBean;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDEstadoProceso;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVPlantillaOperacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelValidator;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVExcelValidatorFactoryImpl;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;

/**
 * Clase manager encargada de la gesti�n de las plantillas excel de la pantalla
 * de alta masiva
 * 
 * @author manuel
 * 
 */
@Service
@Transactional(readOnly = false)
public class ExcelManager implements ExcelManagerApi {

	/** Logger available to subclasses */
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private MSVFicheroDao ficheroDao;

	@Autowired
	private MSVProcesoDao procesoDao;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private MSVDDOperacionMasivaDao operacionDao;
	
	@Autowired
	private MSVExcelValidatorFactoryImpl excelValidatorFactory;

	@Autowired
	private MSVExcelParser excelParser;
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi#generaExcelVacia
	 * (java.lang.String)
	 */
	@Override
	@BusinessOperation(MSV_BO_GENERA_EXCEL_VACIA)
	public ExcelFileBean generaExcelVacia(Long tipoPlantilla) throws FileNotFoundException {

		ExcelFileBean excelFileBean = new ExcelFileBean();
		FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcel(tipoPlantilla);
		excelFileBean.setFileItem(fileItem);

		return excelFileBean;

	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi#generaExcelVaciaPorTipoOperacion(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_BO_GENERA_EXCEL_VACIA_TIPO_OPERACION)
	public ExcelFileBean generaExcelVaciaPorTipoOperacion(Long idTipoOperacion) throws FileNotFoundException {
		
		MSVDDOperacionMasiva msvDDOperacionMasiva = operacionDao.get(idTipoOperacion);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tipoOperacion", msvDDOperacionMasiva);
		List<MSVPlantillaOperacion> lista = genericDao.getList(MSVPlantillaOperacion.class, filtro);
		if (lista.size() > 0)
			return this.generaExcelVacia(lista.get(0).getId());
		else
			throw new BusinessOperationException("No se encuentra la plantilla para lo operaci�n elegida.");
	}

	@Override
	@BusinessOperation(MSV_BO_UPLOAD_AND_VALDIATE)
	public Boolean uploadAndValidate(MSVExcelFileItemDto excelFileItemDto) throws Exception {

		MSVDocumentoMasivo document = null;
		MSVProcesoMasivo process = null;
		try {
			document = upload(excelFileItemDto);
			process = validateFormat(document);
			if (process.getEstadoProceso().equals(MSVDDEstadoProceso.CODIGO_ERROR)) return false;
			process = validateContent(document);
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	
	@SuppressWarnings("unused")
	@Override
	public Boolean uploadOnly(MSVExcelFileItemDto excelFileItemDto) throws Exception {
		Boolean resultado = false;
		MSVDocumentoMasivo document = null;
		MSVProcesoMasivo process = null;
		document = upload(excelFileItemDto);
		process = validateFormat(document);
		if(process.getEstadoProceso() != null && process.getEstadoProceso().getCodigo().equals(MSVDDEstadoProceso.CODIGO_ERROR)){
			resultado = false;
		}else{
			resultado = true;
		}
		return resultado;
	}
	
	@SuppressWarnings("unused")
	@Override
	public Boolean validateContentOnly(Long idProcess) throws Exception{
		
		MSVDocumentoMasivo document = ficheroDao.findByIdProceso(idProcess);
		MSVProcesoMasivo process = null;
		Boolean resultado = false;
		process = validateContent(document);
		if(process.getEstadoProceso() != null && process.getEstadoProceso().getCodigo().equals(MSVDDEstadoProceso.CODIGO_ERROR)){
			resultado = false;
		}else{
			resultado = true;
		}
		return resultado;
		
	}
		
	@Override
	public MSVDocumentoMasivo upload(MSVExcelFileItemDto excelFileItemDto) throws Exception {

		MSVDocumentoMasivo document = crearNuevoDocumentoMasivo(excelFileItemDto);
		ficheroDao.save(document);
		return document;
		
	}
	
	@Override
	public MSVProcesoMasivo validateFormat(MSVDocumentoMasivo document) throws Exception {

		MSVExcelValidator excelValidator = excelValidatorFactory.getForTipoValidador(document.getProcesoMasivo().getTipoOperacion().getCodigo());

		MSVDtoAltaProceso dtoModifProceso = new MSVDtoAltaProceso();
		dtoModifProceso.setIdProceso(document.getProcesoMasivo().getId());
	
		ExcelFileBean excelFile = new ExcelFileBean();
		excelFile.setFileItem(document.getContenidoFichero());
		
		MSVExcelFileItemDto excelFileDto = new MSVExcelFileItemDto();
		excelFileDto.setExcelFile(excelFile);
		excelFileDto.setIdTipoOperacion(document.getProcesoMasivo().getTipoOperacion().getId());
		excelFileDto.setProcessId(document.getProcesoMasivo().getId());

		MSVDtoValidacion dtoValidacionFormato = null;
		MSVProcesoMasivo resultado = null;
		try {
			String codigoOPM = document.getProcesoMasivo().getTipoOperacion().getCodigo();
			
			// Tratar la validación de los siguientes casos de manera personalizada (cuestión de cabeceras).
			if(!(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD01.equals(codigoOPM) ||
					MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_THIRD_PARTY.equals(codigoOPM) ||
					MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VENTA_DE_CARTERA.equals(codigoOPM)  ||
					MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD02.equals(codigoOPM) ||
					MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD03.equals(codigoOPM) ||
					MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_FINANCIEROS.equals(codigoOPM))){
				dtoValidacionFormato = excelValidator.validarFormatoFichero(excelFileDto);
				if (dtoValidacionFormato != null) {
					if (dtoValidacionFormato.getFicheroTieneErrores()) {
						dtoModifProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_ERROR);
						document.setErroresFichero(dtoValidacionFormato.getExcelErroresFormato());
					} else {
						dtoModifProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_PTE_VALIDAR);
						document.setErroresFichero(document.getContenidoFichero());
					}
				}
			}
			else {
				dtoModifProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_PTE_VALIDAR);
				document.setErroresFichero(document.getContenidoFichero());
			}
		} catch (Exception err) {
			logger.error("Ha fallado el validador de formato del fichero Excel", err);
			dtoModifProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_ERROR);
			//document.setErroresFichero(dtoValidacionFormato.getExcelErroresFormato());
			//throw err;
		}
		
		try{
			resultado = proxyFactory.proxy(MSVProcesoApi.class).modificarProcesoMasivo(dtoModifProceso);
		}catch(Exception e){
			logger.error("Ha fallado el guardado del proceso", e);
		}
		
		return resultado;
		
	}
	
	public MSVProcesoMasivo validateContent(MSVDocumentoMasivo document) throws Exception {
		
		MSVDtoAltaProceso dtoModifProceso = new MSVDtoAltaProceso();
		dtoModifProceso.setIdProceso(document.getProcesoMasivo().getId());
		try {
			if (isValidProcess(document.getProcesoMasivo().getId())) {
				dtoModifProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_VALIDADO);
			} else {
				dtoModifProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_ERROR);
			}

		} catch (Exception err) {
			logger.error("Ha fallado el validador de contenido del fichero Excel", err);
			dtoModifProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_ERROR);
			document.setErroresFichero(document.getContenidoFichero());
		//	throw err;
		}
		
		return proxyFactory.proxy(MSVProcesoApi.class).modificarProcesoMasivo(dtoModifProceso);
	}
	

	@Override
	@BusinessOperation(MSV_BO_DESCARGA_FICHERO)
	public ExcelFileBean descargarErrores(Long idProceso) throws Exception {
		ExcelFileBean excelFileBean = new ExcelFileBean();
		MSVDocumentoMasivo fichero = ficheroDao.findByIdProceso(idProceso);
		if (Checks.esNulo(fichero)) {
			throw new BusinessOperationException("No existe fichero para este proceso");
		} else {
			FileItem fileItem = fichero.getErroresFichero();
			fileItem.setFileName(fichero.getNombre());
			fileItem.setContentType(ExcelRepoApi.TIPO_EXCEL);
			excelFileBean.setFileItem(fileItem);
		}

		return excelFileBean;
	}

	@Override
	@BusinessOperation(MSV_BO_VALIDAR_ARCHIVO)
	public Boolean isValidProcess(Long idProceso) throws Exception {

		Boolean resultadoValidacion = true;

		MSVProcesoMasivo proceso = procesoDao.get(idProceso);
		MSVDocumentoMasivo archivo = ficheroDao.findByIdProceso(idProceso);

		MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
		dtoFile.setProcessId(proceso.getId());
		dtoFile.setIdTipoOperacion(proceso.getTipoOperacion().getId());

		if (!Checks.esNulo(archivo)) {
			ExcelFileBean excelFile = new ExcelFileBean();
			excelFile.setFileItem(archivo.getContenidoFichero());
			dtoFile.setExcelFile(excelFile);
			dtoFile.setRuta(archivo.getDirectorio() + "/" + archivo.getNombre());
		} else {
			resultadoValidacion = false;
		}

		MSVExcelValidator validador = excelValidatorFactory.getForTipoValidador(proceso.getTipoOperacion().getCodigo());
		MSVDtoValidacion dtoResultado = validador.validarContenidoFichero(dtoFile);

		if (!Checks.esNulo(dtoResultado)) {
			resultadoValidacion = !dtoResultado.getFicheroTieneErrores();
			if (dtoResultado.getFicheroTieneErrores()) {
				archivo.setErroresFichero(dtoResultado.getExcelErroresFormato());
			}
		} else {
			resultadoValidacion = false;
		}
		return resultadoValidacion;
	}

	private MSVDocumentoMasivo crearNuevoDocumentoMasivo(MSVExcelFileItemDto uploadForm) {
		MSVDocumentoMasivo document = ficheroDao.crearNuevoDocumentoMasivo();
		MSVProcesoMasivo proceso = findOne(uploadForm.getProcessId());

		if (Checks.esNulo(uploadForm)) {
			throw new BusinessOperationException("No tenemos fichero para subir");
		} else {
			if (Checks.esNulo(uploadForm.getExcelFile().getFileItem())) {
				throw new BusinessOperationException("No tenemos fichero para subir");
			}
		}
		if (Checks.esNulo(proceso)) {
			throw new BusinessOperationException("No hemos encontrado ning�n proceso que se corresponda con ese id");
		}

		document.setProcesoMasivo(proceso);
		
		document.setDirectorio("./");
		document.setNombre(uploadForm.getExcelFile().getFileItem().getFileName());
		document.setContenidoFichero(uploadForm.getExcelFile().getFileItem());
		//ErroresFichero inicialmente igual que el fichero base
		document.setErroresFichero(document.getContenidoFichero());
		document.setErroresFicheroProcesar(document.getContenidoFichero());
		document.setResultadoFich(document.getContenidoFichero());

		return document;
	}
	
	private MSVProcesoMasivo findOne(Long id) {
		if (Checks.esNulo(id)) {
			throw new BusinessOperationException("No se puede subir un fichero que no est� asociado a un proceso");
		}
		return procesoDao.get(id);
	}

	@Override
	@BusinessOperation(MSV_BO_UPDATE_FICHERO_ERRORES)
	public void updateErrores(Long idProceso, FileItem ficheroErrores)
			throws Exception {
		// Obtenemos el documentoMasivo
		MSVDocumentoMasivo docMasivo = ficheroDao.findByIdProceso(idProceso);
		docMasivo.setErroresFichero(ficheroErrores);
		// Updateamos el fichero
		ficheroDao.saveOrUpdate(docMasivo);
	}

	/**
	 * Crea una hoja excel de un fichero.
	 * @param fichero fichero excel.
	 * @return Hoja excel {@link MSVHojaExcel}
	 */
	@Override
	@BusinessOperation(MSV_BO_GET_HOJA_EXCEL)
	public MSVHojaExcel getHojaExcel(MSVDocumentoMasivo fichero) {
		MSVHojaExcel exc;
		checkFichero(fichero);
		if (fichero.getContenidoFichero().getFile() != null) {
			exc = excelParser.getExcel(fichero.getContenidoFichero().getFile() );
		} else {
			exc = excelParser.getExcel(fichero.getDirectorio());
		}
		return exc;
	}
	
	/**
	 * verifica que el fichero contiene todos los valores necesarios
	 * @param fichero
	 */
	private void checkFichero(MSVDocumentoMasivo fichero) {
		if (fichero == null) {
			throw new IllegalStateException("El objeto fichero es nulo");
		}
	}
}
