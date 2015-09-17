package es.pfsgroup.plugin.recovery.masivo.api.impl;

import java.io.File;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.FileSystemResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.MSVFileManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVResolucionDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;
import es.pfsgroup.plugin.recovery.masivo.model.MSVCampoDinamico;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoJuicio;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVFileItem;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.MSVResolucionInputApi;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolucionesProc;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.api.TareaExternaApi;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.tareas.RecoveryBPMfwkInputsTareasApi;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;



@Service
@Transactional(readOnly = false)
public class MSVResolucionManager implements MSVResolucionApi {

	private static final String FICHERO_VACIO = "/reports/plugin/masivo/vacio.file";
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private MSVResolucionDao msvResolucionDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
    @Autowired(required=false)
    ServletContext servletContext;
    
    @Autowired
    private transient RecoveryBPMfwkDatosProcedimientoApi datosProcedimientoManager;
    
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi#mostrarResoluciones()
	 */
	@Override
	@BusinessOperation(MSV_BO_MOSTRAR_RESOLUCIONES)
	public	List<MSVResolucion> mostrarResoluciones() {
		
		return msvResolucionDao.dameListaProcesos(this.getUsername());
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi#mostrarResoluciones(es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos)
	 */
	@Override
	@BusinessOperation(MSV_BO_MOSTRAR_RESOLUCIONES_PAGINATED)
	public Page mostrarResoluciones(MSVDtoFiltroProcesos dto) {
		
		dto.setUsername(this.getUsername());
		
		this.parseaColumnasOrder(dto);

		return msvResolucionDao.dameListaProcesos(dto);

	}

	private void parseaColumnasOrder(MSVDtoFiltroProcesos dto) {

		String sort = dto.getSort();
		if (sort == null || sort.trim().length() == 0) {
			
			dto.setSort(" res.auditoria.fechaCrear ");
			dto.setDir("DESC");
		}else{

			sort = sort.trim();
	
			// Parseamos todas las posibles columnas que pueden llegar del Dto
			if ("id".equals(sort)) {
				dto.setSort(" res.id ");
			}
			else if("id".equals(sort)){
				dto.setSort(" res.auditoria.fechaCrear ");
			}
			else if("idTipoResolucion".equals(sort)){
				dto.setSort(" res.tipoResolucion.id ");
			}
			else if("tipoResolucion".equals(sort)){
				dto.setSort(" res.tipoResolucion.descripcion ");
			}
			else if("asunto".equals(sort)){
				dto.setSort(" res.asunto.nombre ");
			}
			else if("fechaEjecucion".equals(sort)){
				dto.setSort(" res.auditoria.fechaCrear ");
			}
			else if("estado".equals(sort)){
				dto.setSort(" res.estadoResolucion.descripcion ");
			}
			else if("usuario".equals(sort)){
				dto.setSort(" res.auditoria.usuarioCrear ");
			}
			else if("auto".equals(sort)){
				dto.setSort(" res.autos ");
			}
		}
		
	}

	private String getUsername() {
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		String username = usu.getUsername();
		return username;
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi#uploadFile(es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean, es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFileItem)
	 */
	
	/**
	 * uploadFile: guarda un fichero en la tabla de RESOLUCIONES MASIVAS
	 * si el Dto que llega como argument contiene un Id de Proceso (de Resolución) se realiza un alta
	 * si no, se realiza una modificacion
	 * @author pedro
	 * 
	 * @return Dto que contiene el ID de resolucion
	 */
	@Override
	@BusinessOperation(MSV_BO_UPLOAD_FICHERO_RESOLUCION)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)
	public MSVDtoResultadoSubidaFicheroMasivo uploadFile(ExcelFileBean uploadForm, MSVDtoFileItem dto) throws BusinessOperationException {

		MSVDtoResultadoSubidaFicheroMasivo resultado = new MSVDtoResultadoSubidaFicheroMasivo();
		
		//Si el idProceso(idResolucion) es nulo creamos una nueva resoluci�n.
		MSVResolucion msvResolucion; 
		if (Checks.esNulo(dto.getIdResolucion())){
			msvResolucion = new MSVResolucion();
		}else{
			msvResolucion = msvResolucionDao.get(dto.getIdResolucion());
		}
		msvResolucion.setNombreFichero(uploadForm.getFileItem().getFile().getAbsolutePath());
		
		//Comprobamos que el fichero se puede abrir (es v�lido), en caso contrario devolvemos una excepción
		// Si no, devolvemos una excepci�n
		File file = uploadForm.getFileItem().getFile();
		if (!file.exists()) {
			throw new BusinessOperationException("Fichero inexistente");
		} else {
			msvResolucion.setContenidoFichero(uploadForm.getFileItem());
		}
		
		//Estado inicial de la resoluci�n: CODIGO_EN_PROCESO 
		MSVDDEstadoProceso estadoProceso=genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_EN_PROCESO));
		msvResolucion.setEstadoResolucion(estadoProceso);

		if (dto.getIdTipoJuicio() != null){
			msvResolucion.setTipoJuicio(genericDao.get(MSVDDTipoJuicio.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoJuicio())));
		}
		if (dto.getIdTipoResolucion() != null){
			msvResolucion.setTipoResolucion(genericDao.get(MSVDDTipoResolucion.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoResolucion())));
		}
		if (dto.getIdAsunto() != null){
			Filter filtroExiste = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdAsunto());
			EXTAsunto asunto = (EXTAsunto) genericDao.get(EXTAsunto.class, filtroExiste);
			msvResolucion.setAsunto(asunto);
		}
		msvResolucion.setAutos(dto.getAuto());
		msvResolucion.setJuzgado(dto.getJuzgado());
		msvResolucion.setPlaza(dto.getPlaza());		
		msvResolucion.setPrincipal(dto.getPrincipal());
		if (!Checks.esNulo(dto.getIdTarea())) {
			EXTTareaExterna tarea=(EXTTareaExterna) proxyFactory.proxy(TareaExternaApi.class).get(dto.getIdTarea());
			msvResolucion.setTarea(tarea);
		}
		
		//Guardamos los datos en BD
		msvResolucionDao.saveOrUpdate(msvResolucion);
		
		
		resultado.setIdProceso(msvResolucion.getId());
		resultado.setNombreFichero(msvResolucion.getNombreFichero());
		
		return resultado;
	
	}

	@Override
	@BusinessOperation(MSV_BO_GUARDAR_DATOS_RESOLUCION)
	public MSVResolucion guardarDatos(MSVResolucionesDto dto){
		
		MSVResolucion msvResolucion = this.guardarResolucion(dto);
		
		//Adjuntamos el fichero al asunto.
		if (msvResolucion.getAdjunto() != null){
			//this.adjuntarFichero(msvResolucion.getAdjunto(), msvResolucion);
			msvResolucion.setAdjuntoFinal(adjuntarFicheroFinal(msvResolucion.getAdjunto(), msvResolucion));
		}
		//this.adjuntarFicheroResolucion(msvResolucion);

		return msvResolucion;
	}

	@Override
	@BusinessOperation(MSV_BO_GUARDAR_RESOLUCION)
	public MSVResolucion guardarResolucion(MSVResolucionesDto dto) {
		MSVResolucion msvResolucion;
		if (dto.getIdResolucion() == null)
			msvResolucion = new MSVResolucion();
		else
			msvResolucion = msvResolucionDao.get(dto.getIdResolucion());
		
		this.populateResolucion(msvResolucion, dto);
		
		msvResolucionDao.saveOrUpdate(msvResolucion);
		
		if (dto.getIdFichero() != null){
			MSVFileItem msvFileItem = this.getFile(dto);
			msvResolucion.setNombreFichero(msvFileItem.getNombre());
			msvResolucion.setContenidoFichero(msvFileItem.getFileItem());
			msvResolucion.setAdjunto(msvFileItem);
			msvResolucionDao.saveOrUpdate(msvResolucion);
		}
		return msvResolucion;
	}
	
	/**
	 * Adjunta un fichero al asunto relacionado con una resoluci�n y lo devuelve.
	 * @param msvFileItem Objeto que contiene la informaci�n del fichero.
	 * @param msvResolucion Datos de la resoluci�n.
	 */
	private EXTAdjuntoAsunto adjuntarFicheroFinal(MSVFileItem msvFileItem, MSVResolucion msvResolucion) {
		
		Asunto asunto = msvResolucion.getAsunto();
		Procedimiento prc = msvResolucion.getProcedimiento();
		
		FileItem fileItem = msvFileItem.getFileItem();
		EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(fileItem);
		
		adjuntoAsunto.setAsunto(asunto);
		adjuntoAsunto.setContentType(msvFileItem.getContentType());
		adjuntoAsunto.setNombre(msvFileItem.getNombre());
		adjuntoAsunto.setDescripcion(msvFileItem.getNombre());
		if (prc != null){
			adjuntoAsunto.setProcedimiento(prc);
		}
		if (!Checks.esNulo(msvFileItem.getTipoFichero())){
			adjuntoAsunto.setTipoFichero(msvFileItem.getTipoFichero());
		} else {
			DDTipoFicheroAdjunto tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "OT"));
			adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
		}
		adjuntoAsunto.setLength(fileItem.getFile().length());
		Auditoria.save(adjuntoAsunto);
		asunto.getAdjuntos().add(adjuntoAsunto);
		AsuntoApi asuntoApi = proxyFactory.proxy(AsuntoApi.class);
		asuntoApi.saveOrUpdateAsunto(asunto);
		
		return adjuntoAsunto;
	}
	
	/**
	 * Adjunta un fichero al asunto relacionado con una resoluci�n.
	 * @param msvFileItem Objeto que contiene la informaci�n del fichero.
	 * @param msvResolucion Datos de la resoluci�n.
	 */
	private void adjuntarFichero(MSVFileItem msvFileItem, MSVResolucion msvResolucion) {
		
		Asunto asunto = msvResolucion.getAsunto();
		Procedimiento prc = msvResolucion.getProcedimiento();
		
		FileItem fileItem = msvFileItem.getFileItem();
		EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(fileItem);
		
		adjuntoAsunto.setAsunto(asunto);
		adjuntoAsunto.setContentType(msvFileItem.getContentType());
		adjuntoAsunto.setNombre(msvFileItem.getNombre());
		adjuntoAsunto.setDescripcion(msvFileItem.getNombre());
		if (prc != null){
			adjuntoAsunto.setProcedimiento(prc);
		}
		if (!Checks.esNulo(msvFileItem.getTipoFichero())){
			adjuntoAsunto.setTipoFichero(msvFileItem.getTipoFichero());
		} else {
			DDTipoFicheroAdjunto tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "OT"));
			adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
		}
		adjuntoAsunto.setLength(fileItem.getFile().length());
		Auditoria.save(adjuntoAsunto);
		asunto.getAdjuntos().add(adjuntoAsunto);
		AsuntoApi asuntoApi = proxyFactory.proxy(AsuntoApi.class);
		asuntoApi.saveOrUpdateAsunto(asunto);
	}

	private void populateResolucion(MSVResolucion msvResolucion, MSVResolucionesDto dto) {

		if(!Checks.esNulo(dto.getAuto())){
			msvResolucion.setAutos(dto.getAuto());
		}
		if(!Checks.esNulo(dto.getJuzgado())){
			msvResolucion.setJuzgado(dto.getJuzgado());
		}
		if(!Checks.esNulo(dto.getPlaza())){
			msvResolucion.setPlaza(dto.getPlaza());
		}
		if(!Checks.esNulo(dto.getPrincipal())){
			msvResolucion.setPrincipal(dto.getPrincipal());
		}
		
		if (!Checks.esNulo(dto.getIdTarea())) {
			EXTTareaExterna tarea=(EXTTareaExterna) proxyFactory.proxy(TareaExternaApi.class).get(dto.getIdTarea());
			msvResolucion.setTarea(tarea);
		}
		if (dto.getComboTipoJuicioNew() != null){
			msvResolucion.setTipoJuicio(genericDao.get(MSVDDTipoJuicio.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getComboTipoJuicioNew())));
		}
		if (dto.getComboTipoResolucionNew() != null){
			msvResolucion.setTipoResolucion(genericDao.get(MSVDDTipoResolucion.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getComboTipoResolucionNew())));
		}		
		
		if (dto.getEstadoResolucion() != null){
			msvResolucion.setEstadoResolucion(genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoResolucion())));
		}else{
			msvResolucion.setEstadoResolucion(genericDao.get(MSVDDEstadoProceso.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_EN_PROCESO)));
		}
		
		if (msvResolucion.getContenidoFichero() == null){
			FileItem contenidoFichero = new FileItem();
			String path = servletContext.getRealPath(FICHERO_VACIO);
			FileSystemResource resource = new FileSystemResource(path);
			contenidoFichero.setFile(resource.getFile());
			msvResolucion.setContenidoFichero(contenidoFichero);
		}
		if (dto.getIdAsunto() != null){
			Filter filtroExiste = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdAsunto());
			EXTAsunto asunto = (EXTAsunto) genericDao.get(EXTAsunto.class, filtroExiste);
			msvResolucion.setAsunto(asunto);
		}
		if (dto.getIdProcedimiento() != null) {
			Filter filtroExiste = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdProcedimiento());
			MEJProcedimiento procedimiento = genericDao.get(MEJProcedimiento.class, filtroExiste);
			msvResolucion.setProcedimiento(procedimiento);
		}
		if(dto.getCamposDinamicos() != null && dto.getCamposDinamicos().size() > 0){
			Set<MSVCampoDinamico> camposResolucion = msvResolucion.getCamposDinamicos();
			Map<String,String> camposDinamicos = dto.getCamposDinamicos();

			for (Map.Entry<String, String> entry : camposDinamicos.entrySet()) {
				MSVCampoDinamico msvCampoDinamico = this.dameCampo(entry.getKey(), camposResolucion);
				msvCampoDinamico.setNombreCampo(entry.getKey());
			    msvCampoDinamico.setValorCampo(this.formateaValor(entry.getValue()));
			    msvCampoDinamico.setResolucion(msvResolucion);
			    genericDao.save(MSVCampoDinamico.class, msvCampoDinamico);
			    camposResolucion.add(msvCampoDinamico);
			}
			
			msvResolucion.setCamposDinamicos(camposResolucion);
			
		}
		

		
	}
	
	/**
	 * Recupera un fichero de la base de datos.
	 * @param dto dto con el dato idFichero.
	 * @return objeto con el fichero.
	 */
	private MSVFileItem getFile(MSVResolucionesDto dto) {
 
		return proxyFactory.proxy(MSVFileManagerApi.class).getFile(dto.getIdFichero());
	}

	private String formateaValor(String value) {
		if (value != null && value.matches("\\d{4}-\\d{2}-\\d{2}T00:00:00")) {
		    return value.substring(8, 10) + "/" + value.substring(5, 7) + "/" + value.substring(0, 4);
		}
		return value;
	}

	private MSVCampoDinamico dameCampo(String key, Set<MSVCampoDinamico> camposResolucion) {
		for(MSVCampoDinamico msvCampoDinamico : camposResolucion){
			if (msvCampoDinamico.getNombreCampo().equals(key))
				return msvCampoDinamico;
		}
		return new MSVCampoDinamico();
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi#getResolucion(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_BO_GET_DATOS_RESOLUCION)
	public	MSVResolucion getResolucion(Long idResolucion)  throws BusinessOperationException {
		
		if (idResolucion == null)
			throw new BusinessOperationException("El id de la resoluci�n (idResolucion) no puede ser nulo.");
		MSVResolucion resolucion = msvResolucionDao.mergeAndGet(idResolucion);
		return resolucion;
	}

	@Override
	@BusinessOperation(MSV_BO_DAME_AYUDA_RESOLUCION)
	public String dameAyuda(Long idTipoResolucion) {
		MSVDDTipoResolucion msvDDTipoResolucion = genericDao.get(MSVDDTipoResolucion.class, genericDao.createFilter(FilterType.EQUALS, "id", idTipoResolucion));
		if (msvDDTipoResolucion != null)
			return msvDDTipoResolucion.getAyuda();
		return null;
	}

	@Override
	@BusinessOperation(MSV_BO_PROCESA_RESOLUCION)
	@Transactional(readOnly = false, noRollbackFor=RuntimeException.class)	
	public MSVResolucion procesaResolucion(Long idResolucion) {
		if (idResolucion == null)
			throw new BusinessOperationException("El id de la resoluci�n (idResolucion) no puede ser nulo.");
		MSVResolucion msvResolucion = msvResolucionDao.mergeAndGet(idResolucion);
		
		String resultadoProceso = MSVDDEstadoProceso.CODIGO_PROCESADO;
		try{
			
			MSVDDTipoResolucion tipoResolucion = proxyFactory.proxy(MSVResolucionApi.class).getTipoResolucion(msvResolucion.getTipoResolucion().getId());
			RecoveryBPMfwkDDTipoInput tipoInput = this.getTipoInput(tipoResolucion, msvResolucion);
			RecoveryBPMfwkInputDto inputDto = this.populateDto(tipoInput, msvResolucion);
			
			
			// Si no tiene tarea no procesamos el input, tan solo lo informamos
			Long idInput = null;			
			if (Checks.esNulo(msvResolucion.getTarea())) { 
				RecoveryBPMfwkInput myInput = proxyFactory.proxy(RecoveryBPMfwkInputApi.class).saveInput(inputDto);
				if (!Checks.esNulo(myInput)) {
					idInput = myInput.getId();
					//FIXME C�digo repetido en RecoveryBPMfwkInputInformarDatosExecutor.execute (Evaluar si se a�ade este caso al framework)
					RecoveryBPMfwkCfgInputDto config = proxyFactory.proxy(RecoveryBPMfwkConfigApi.class).getInputConfigNodo(myInput.getTipo().getCodigo(), msvResolucion.getProcedimiento().getTipoProcedimiento().getCodigo(), MSVResolucionInputApi.MSV_NODO_SIN_TAREAS);
			        if(config != null){
				        try {
				            datosProcedimientoManager.guardaDatos(myInput.getIdProcedimiento(), myInput.getDatos(), config);
				        } catch (RecoveryBPMfwkError e) {
				            throw e;
				        } 
				        catch (Exception e) {
				            throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION ,"Error al intentar guardar los datos." ,e);
				        }
			        }
				}
			} else {
				idInput = proxyFactory.proxy(RecoveryBPMfwkRunApi.class).procesaInput(inputDto);
			}
			
			
			//TODO - Guarda una relaci�n entre el input y la tarea. Desacoplar de tareas
			if ((!Checks.esNulo(idInput)) && (!Checks.esNulo(msvResolucion.getTarea()))) {
				proxyFactory.proxy(RecoveryBPMfwkInputsTareasApi.class).save(idInput, msvResolucion.getTarea().getId());
			}
		}
		catch(RecoveryBPMfwkError ex){
			ex.printStackTrace();
			resultadoProceso = MSVDDEstadoProceso.CODIGO_ERROR;
		}
		catch(Exception ex){
			ex.printStackTrace();
			resultadoProceso = MSVDDEstadoProceso.CODIGO_ERROR;
		}
		finally{
			//Actualizamos el estado de la resoluci�n.
			msvResolucion.setEstadoResolucion(genericDao.get(MSVDDEstadoProceso.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", resultadoProceso)));
			msvResolucionDao.saveOrUpdate(msvResolucion);
		}
		
		return msvResolucion;
		
	}

	
	
	
	//FIXME: ����TODO ESTE C�DIGO EST� DUPLICADO Y TIENE QUE IR A LINDORFF!!!!
	


	private RecoveryBPMfwkInputDto populateDto(	RecoveryBPMfwkDDTipoInput tipoInput, MSVResolucion msvResolucion) {

		RecoveryBPMfwkInputDto inputDto = new RecoveryBPMfwkInputDto();
		
		Procedimiento prc = this.getProcedimiento(msvResolucion);
		Long idAsunto = null;
		Long idProcedimiento = null;
		if(prc != null){
			idAsunto = prc.getAsunto().getId();
			idProcedimiento = prc.getId();
		}
		Map<String, Object> mapa = this.getMapaObject(msvResolucion);
		mapa.put("idAsunto", idAsunto);
		
		inputDto.setCodigoTipoInput(tipoInput.getCodigo());
		inputDto.setIdProcedimiento(idProcedimiento);
		inputDto.setDatos(mapa);
		return inputDto;
	}

	private RecoveryBPMfwkDDTipoInput getTipoInput(	MSVDDTipoResolucion tipoResolucion, MSVResolucion msvResolucion) {
		
		String codigoTipoInput = this.getCodigoTipoInput(tipoResolucion.getCodigo(), msvResolucion);
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoInput);
		RecoveryBPMfwkDDTipoInput tipoInput = genericDao.get(RecoveryBPMfwkDDTipoInput.class, f1);
		return tipoInput;
	}

	/**
	 * Relaci�n tipos de resoluci�n vs tipo de input.
	 * @param codigoTipoResolucion
	 * @param dtoTarea 
	 * @return
	 */
	private String getCodigoTipoInput(String codigoTipoResolucion, MSVResolucion msvResolucion) {
		
		Long idProcedimiento = null;
		String codigoTipoProcedimiento = null;
		Map<String, String> campos = this.getMapa(msvResolucion);
		
		Procedimiento prc = this.getProcedimiento(msvResolucion);
		if (prc != null){
			idProcedimiento = prc.getId();
			if (prc.getTipoProcedimiento() != null){
				codigoTipoProcedimiento = prc.getTipoProcedimiento().getCodigo();
			}
		}
		//A�adimos que el campo que indica si tiene el procurador
		String tieneProc = "NO";
		if (prc != null && prc.getAsunto() != null && prc.getAsunto().getProcurador() != null) {
			tieneProc = "SI";
		}
		campos.put("tieneProc", tieneProc);
		//A�adimos comprobacion de si el importe del procedimiento es mayor o menor de 6000
		String importeMayor="MENOR";
		if (prc != null && prc.getSaldoDeudorTotal()!=null ){
			BigDecimal valor=new BigDecimal(6000);
			if (prc.getSaldoRecuperacion() != null && prc.getSaldoRecuperacion().compareTo(valor)==1 ){
				importeMayor="MAYOR";
			}
		}
		campos.put("importeMayor", importeMayor);
		// Comprobamos si la notificaci�n positiva ha sido total o parcial, de momento parcial si hay m�s de un demandado y total si solo hay un demandado
				// TODO
		String notificacion="TOTAL";
		if (prc != null && prc.getPersonasAfectadas()!=null){
			if (prc.getPersonasAfectadas().size()>1){
				notificacion="PARCIAL";
			}
		}
		campos.put("notificacion", notificacion);
		
		// Comprobaci�n para derivar en tr�mite de embargo dependiendo que lo que venga en el formulario
		String tramiteEmbargo="NINGUNO";
		if (campos.containsKey("d_embargoBienes") && campos.containsKey("d_embargoSalario")){
					tramiteEmbargo="BIENES_SALARIO";
		} 
		if (campos.containsKey("d_embargoBienes") && !campos.containsKey("d_embargoSalario")){
					tramiteEmbargo="BIENES";
		} 
		if (!campos.containsKey("d_embargoBienes") && campos.containsKey("d_embargoSalario")){
					tramiteEmbargo="SALARIO";
		} 
		campos.put("tramiteEmbargo", tramiteEmbargo);
	
		
		return proxyFactory.proxy(MSVResolucionInputApi.class).obtenerTipoInputParaResolucion(idProcedimiento, codigoTipoProcedimiento, codigoTipoResolucion, campos);
	}
	
	/**
	 * Obtiene un mapa de tipo Map<String,String> a partir de los datos de la tarea.
	 * @param dtoTarea el dto de la tarea
	 * @return el mapa de datos.
	 */
	private Map<String, String> getMapa(MSVResolucion msvResolucion) {
		
		Map<String,String> campos = new HashMap<String,String>();
		for(MSVCampoDinamico campo: msvResolucion.getCamposDinamicos()){
			campos.put(campo.getNombreCampo(), campo.getValorCampo());
		}
		return campos;
	}
	
	/**
	 * Obtiene un mapa de tipo Map<String,String> a partir de los datos de la tarea.
	 * @param dtoTarea el dto de la tarea
	 * @return el mapa de datos.
	 */
	private Map<String, Object> getMapaObject(MSVResolucion msvResolucion) {
		
		Map<String,Object> campos = new HashMap<String,Object>();
		for(MSVCampoDinamico campo: msvResolucion.getCamposDinamicos()){
			campos.put(campo.getNombreCampo(), campo.getValorCampo());
		}
		return campos;
	}
	
	private Procedimiento getProcedimiento(MSVResolucion msvResolucion) {
		
		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(msvResolucion.getProcedimiento().getId());
		return prc;
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi#getTiposDeResolucion(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_BO_GET_TIPOS_RESOLUCION)
	public List<MSVDDTipoResolucion> getTiposDeResolucion(Long idProcedimiento) {

		if (idProcedimiento == null)
			throw new BusinessOperationException("El id del procedimiento (idProcedimiento) no puede ser nulo.");
		
		Procedimiento proc = this.getProcedimiento(idProcedimiento);
		
		if (proc == null)
			throw new BusinessOperationException("No existe el procedimiento.");
		
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "tipoJuicio.tipoProcedimiento", proc.getTipoProcedimiento());
		return genericDao.getList(MSVDDTipoResolucion.class, f1);
	}
	
	@Override
	@BusinessOperation(MSV_BO_GET_TIPO_RESOLUCION)
	public	MSVDDTipoResolucion getTipoResolucion(Long idTipoResolucion) {
		
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idTipoResolucion);
		return genericDao.get(MSVDDTipoResolucion.class, f1);
	}
	
	/**
	 * Recupera un procedimiento a partir del idProcedimiento
	 * @param idProcedimiento
	 * @return
	 */
	private Procedimiento getProcedimiento(Long idProcedimiento) {
		return proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
	}


	@Override
	@BusinessOperation(MSV_BO_GET_TIPO_RESOLUCION_POR_CODIGO)
	public	MSVDDTipoResolucion getTipoResolucionPorCodigo(String codigoTipoResolucion) {
		
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoResolucion);
		return genericDao.get(MSVDDTipoResolucion.class, f1);
	}
	
	@Override
	@BusinessOperation(MSV_BO_GET_TIPO_RESOLUCION_POR_TAREA_RESOLUCION)
	public MSVResolucion getResolucionByTareaNotificacion(Long idTareaNotificacion) {

		return msvResolucionDao.getResolucionByTareaNotificacion(idTareaNotificacion);

	}

	@Override
	@BusinessOperation(MSV_BO_GUARDAR_ARCHIVO_ADJUNTO_RESOLUCION)
	public MSVResolucion guardarAdjuntoResolucion(MSVResolucionesDto dtoResolucion) {
		
		MSVResolucion msvResolucion = getResolucion(dtoResolucion.getIdResolucion());
		
		if (dtoResolucion.getIdFichero() != null){
			//MSVFileItem msvFileItem = proxyFactory.proxy(MSVFileManagerApi.class).getFile(dtoResolucion.getIdFichero());
			MSVFileItem msvFileItem = this.getFile(dtoResolucion);
			msvResolucion.setNombreFichero(msvFileItem.getNombre());
			msvResolucion.setContenidoFichero(msvFileItem.getFileItem());
			msvResolucion.setAdjunto(msvFileItem);
			msvResolucion.setAdjuntoFinal(adjuntarFicheroFinal(msvResolucion.getAdjunto(), msvResolucion));
			msvResolucionDao.saveOrUpdate(msvResolucion);
		}
		
		//msvResolucionDao.saveOrUpdate(msvResolucion);

		return msvResolucion;
	}

}
