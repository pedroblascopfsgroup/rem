package es.pfsgroup.plugin.recovery.masivo.api.impl;

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
import es.pfsgroup.plugin.recovery.masivo.MSVExcelParser;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelRepoApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesoDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoValidacion;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVExcelFileItemDto;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVPlantillaOperacion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVExcelValidator;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVExcelValidatorFactoryImpl;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;

/**
 * Clase manager encargada de la gesti�n de las plantillas excel de la pantalla
 * de alta masiva
 * 
 * @author manuel
 * 
 */
@SuppressWarnings("deprecation")
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
	public
	ExcelFileBean generaExcelVaciaPorTipoOperacion(Long idTipoOperacion) throws FileNotFoundException {
		
		MSVDDOperacionMasiva msvDDOperacionMasiva = operacionDao.get(idTipoOperacion);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tipoOperacion", msvDDOperacionMasiva);
		List<MSVPlantillaOperacion> lista = genericDao.getList(MSVPlantillaOperacion.class, filtro);
		if (lista.size() > 0)
			return this.generaExcelVacia(lista.get(0).getId());
		else
			throw new BusinessOperationException("No se encuentra la plantilla para lo operaci�n elegida.");
	}

	@Override
	@BusinessOperation(MSV_BO_UPLOAD_FICHERO)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)
	public MSVDtoResultadoSubidaFicheroMasivo uploadFile(ExcelFileBean uploadForm, MSVDtoFileItem dto) throws Exception {
		MSVDtoResultadoSubidaFicheroMasivo dtoResultado = new MSVDtoResultadoSubidaFicheroMasivo();

		dtoResultado.setIdProceso(dto.getIdProceso());
		MSVExcelFileItemDto excelFileDto = new MSVExcelFileItemDto();
		excelFileDto.setExcelFile(uploadForm);
		excelFileDto.setIdTipoOperacion(dto.getIdTipoOperacion());
		excelFileDto.setIdProceso(dto.getIdProceso());

		// Bruno 21/2/2013: Seteamos la ruta y el nombre del archivo en el dto
		// si no nos
		// viene
		if (Checks.esNulo(dto.getRuta())) {
			String ruta = uploadForm.getFileItem().getFile().getParent();
			dto.setRuta(ruta != null ? ruta : "./");
		}

		if (Checks.esNulo(dto.getNombre())) {
			dto.setNombre(uploadForm.getFileItem().getFileName());
		}

		MSVDocumentoMasivo documento = crearNuevoDocumentoMasivo(uploadForm, dto);

		MSVExcelValidator excelValidator = excelValidatorFactory.getForTipoValidador(documento.getProcesoMasivo().getTipoOperacion().getId());

		MSVDtoAltaProceso dtoAltaProceso = new MSVDtoAltaProceso();
		dtoAltaProceso.setIdProceso(dto.getIdProceso());
		RuntimeException excepcionValidador = null;

		try {
			MSVDtoValidacion dtoValidacionFormato = excelValidator.validarFormatoFichero(excelFileDto);
			// Bruno 20/02/2013: Si el resultado de la validaci�n no devuelve
			// nada
			// no se guardan errores
			if (dtoValidacionFormato != null) {
				if (dtoValidacionFormato.getFicheroTieneErrores()) {
					documento.setErroresFichero(dtoValidacionFormato.getExcelErroresFormato());
				} else {
					// Bruno 21/2/2013 Si no hubiera errores de validaci�n
					// copiamos
					// la misma excel, ya que peta si dejamos este campo a NULL
					documento.setErroresFichero(uploadForm.getFileItem());
				}
			}
			// Bruno 20/02/2013: Cabe la posibildiad que el
			// dtoValidacionesFormato
			// sea null ??
			if ((dtoValidacionFormato != null) && (dtoValidacionFormato.getFicheroTieneErrores())) {
				dtoAltaProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_ERROR);
			} else {
				dtoAltaProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_PTE_VALIDAR);
			}
		} catch (RuntimeException err) {
			excepcionValidador = err;
			logger.error("Ha fallado el validador del fichero Excel", err);
			dtoAltaProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_ERROR);
			documento.setErroresFichero(uploadForm.getFileItem());
		}

		ficheroDao.save(documento);

		proxyFactory.proxy(MSVProcesoApi.class).modificarProcesoMasivo(dtoAltaProceso);

		if (excepcionValidador == null) {
			return dtoResultado;
		} else {
			throw excepcionValidador;
		}
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
	public Boolean validarArchivo(Long idProceso) {

		Boolean resultadoValidacion = true;

		MSVProcesoMasivo proceso = procesoDao.get(idProceso);
		MSVDocumentoMasivo archivo = ficheroDao.findByIdProceso(idProceso);

		MSVExcelFileItemDto dtoFile = new MSVExcelFileItemDto();
		dtoFile.setIdProceso(proceso.getId());
		dtoFile.setIdTipoOperacion(proceso.getTipoOperacion().getId());

		if (!Checks.esNulo(archivo)) {
			ExcelFileBean excelFile = new ExcelFileBean();
			excelFile.setFileItem(archivo.getContenidoFichero());
			dtoFile.setExcelFile(excelFile);
			dtoFile.setRuta(archivo.getDirectorio() + "/" + archivo.getNombre());
		} else {
			resultadoValidacion = false;
		}

		MSVExcelValidator validador = excelValidatorFactory.getForTipoValidador(proceso.getTipoOperacion().getId());
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

	//No se utliza
//	private void cambiaEstadoProceso(MSVDtoValidacion dtoValidacionFormato, MSVDtoFileItem dto) throws Exception {
//		MSVProcesoMasivo proceso = dameProcesoMasivo(dto);
//		if (Checks.esNulo(proceso)) {
//			throw new BusinessOperationException("No hemos encontrado ning�n proceso que se corresponda con ese id");
//		}
//		MSVDtoAltaProceso dtoAltaProceso = new MSVDtoAltaProceso();
//		if (dtoValidacionFormato.getFicheroTieneErrores()) {
//			dtoAltaProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_ERROR);
//		} else {
//			dtoAltaProceso.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_PTE_VALIDAR);
//		}
//		proxyFactory.proxy(MSVProcesoApi.class).modificarProcesoMasivo(dtoAltaProceso);
//	}

	private MSVDocumentoMasivo crearNuevoDocumentoMasivo(ExcelFileBean uploadForm, MSVDtoFileItem dto) {
		MSVDocumentoMasivo documento = ficheroDao.crearNuevoDocumentoMasivo();
		MSVProcesoMasivo proceso = dameProcesoMasivo(dto);

		if (Checks.esNulo(uploadForm)) {
			throw new BusinessOperationException("No tenemos fichero para subir");
		} else {
			if (Checks.esNulo(uploadForm.getFileItem())) {
				throw new BusinessOperationException("No tenemos fichero para subir");
			}
		}
		if (Checks.esNulo(proceso)) {
			throw new BusinessOperationException("No hemos encontrado ning�n proceso que se corresponda con ese id");
		}

		documento.setProcesoMasivo(proceso);
		documento.setDirectorio(dto.getRuta());
		documento.setNombre(uploadForm.getFileItem().getFileName());
		documento.setContenidoFichero(uploadForm.getFileItem());

		return documento;
	}

	private MSVProcesoMasivo dameProcesoMasivo(MSVDtoFileItem dto) {
		if (Checks.esNulo(dto.getIdProceso())) {
			throw new BusinessOperationException("No se puede subir un fichero que no est� asociado a un proceso");
		}
		return procesoDao.get(dto.getIdProceso());
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
