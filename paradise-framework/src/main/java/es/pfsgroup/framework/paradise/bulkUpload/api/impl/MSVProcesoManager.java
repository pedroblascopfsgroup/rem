package es.pfsgroup.framework.paradise.bulkUpload.api.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVProcesoDao;
import es.pfsgroup.framework.paradise.bulkUpload.dto.DtoMSVProcesoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoAltaProceso;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberatorsFactory;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDEstadoProceso;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;

@Component
@Transactional(readOnly = false)
public class MSVProcesoManager implements MSVProcesoApi {
	
	public final static String PEFIL_SUPERVISOR_BO = "SUPERVISOR BACK OFFICE";
	public final static String PEFIL_SUPERADMINISTRADOR = "SUPER ADMINISTRADOR";
	public final static String PEFIL_SUPERVISOR_OFICINA_PROCESAL = "SUPERVISOR OFI. PROCESAL";
	
	@Autowired
	private MSVProcesoDao procesoDao;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private MSVFicheroDao ficheroDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MSVLiberatorsFactory factoriaLiberators;
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Override
	@BusinessOperation(MSV_BO_ALTA_PROCESO_MASIVO)
	public Long iniciarProcesoMasivo(MSVDtoAltaProceso dto) throws Exception {
		MSVProcesoMasivo procesoMasivo = procesoDao.crearNuevoProceso();

		if (!Checks.esNulo(dto.getIdTipoOperacion())) {
			MSVDDOperacionMasiva tipoOperacion = genericDao.get(MSVDDOperacionMasiva.class,
					genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoOperacion()));
			if (!Checks.esNulo(tipoOperacion)) {
				procesoMasivo.setTipoOperacion(tipoOperacion);
			} else {
				throw new BusinessOperationException(
						"Necesitamos un tipo de operaci�n v�lido para dar de alta un proceso masivo");
			}
		} else {
			throw new BusinessOperationException(
					"Necesitamos un tipo de operaci�n v�lido para dar de alta un proceso masivo");
		}

		MSVDDEstadoProceso estadoProceso = genericDao.get(MSVDDEstadoProceso.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", MSVDDEstadoProceso.CODIGO_CARGANDO));

		procesoMasivo.setDescripcion(dto.getDescripcion());
		procesoMasivo.setEstadoProceso(estadoProceso);

		procesoMasivo.setToken(proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).getToken());

		procesoDao.save(procesoMasivo);

		return procesoMasivo.getId();
	}

	@Override
	@BusinessOperation(MSV_BO_MODIFICACION_PROCESO_MASIVO)
	@Transactional(readOnly = false)
	public MSVProcesoMasivo modificarProcesoMasivo(MSVDtoAltaProceso dto) throws Exception {
		MSVProcesoMasivo procesoMasivo;
		if (Checks.esNulo(dto.getIdProceso())) {
			throw new BusinessOperationException("Necesitamos un id de proceso a modificar");
		} else {
			procesoMasivo = procesoDao.mergeAndGet(dto.getIdProceso());
		}
		if (!Checks.esNulo(procesoMasivo)) {
			if (!Checks.esNulo(dto.getIdEstadoProceso())) {
				MSVDDEstadoProceso estadoProceso = genericDao.get(MSVDDEstadoProceso.class,
						genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdEstadoProceso()));
				if (!Checks.esNulo(estadoProceso)) {
					procesoMasivo.setEstadoProceso(estadoProceso);
				}
			} else if (!Checks.esNulo(dto.getCodigoEstadoProceso())) {
				MSVDDEstadoProceso estadoProceso = genericDao.get(MSVDDEstadoProceso.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigoEstadoProceso()));
				if (!Checks.esNulo(estadoProceso)) {
					procesoMasivo.setEstadoProceso(estadoProceso);
				}
			}
		}
		procesoDao.mergeAndUpdate(procesoMasivo);
		return procesoMasivo;
	}

	@Override
	@BusinessOperation(MSV_BO_ELIMINAR_PROCESO)
	public String eliminarProceso(long idProceso) {
		String resultado = "ok";
		if (Checks.esNulo(idProceso)) {
			resultado = "ko";
		} else {
			MSVDocumentoMasivo fichero = ficheroDao.findByIdProceso(idProceso);
			if (fichero != null)
				ficheroDao.delete(fichero);
			procesoDao.deleteById(idProceso);
		}
		return resultado;
	}
	
	@Override
	public String getUsername() {
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		String username = usu.getUsername();
		return username;
	}

	@Override
	@BusinessOperation(MSV_BO_MOSTRAR_PROCESOS)
	public List<DtoMSVProcesoMasivo> mostrarProcesos() {
		List<MSVProcesoMasivo> listaProcesos = procesoDao.dameListaProcesos(this.getUsername());
		List<DtoMSVProcesoMasivo> procesosDto = new ArrayList<DtoMSVProcesoMasivo>();

		for (MSVProcesoMasivo proceso : listaProcesos) {
			DtoMSVProcesoMasivo nuevoDto = new DtoMSVProcesoMasivo();
			boolean sePuedeProcesar = false;
			boolean conErrores = false;
			boolean validable = false;
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "id", proceso.getId());
				if(!Checks.esNulo(proceso.getTipoOperacion())) {
					beanUtilNotNull.copyProperty(nuevoDto, "tipoOperacion", proceso.getTipoOperacion().getDescripcion());
					beanUtilNotNull.copyProperty(nuevoDto, "tipoOperacionId", proceso.getTipoOperacion().getId());
				}
				if(!Checks.esNulo(proceso.getEstadoProceso())){
					beanUtilNotNull.copyProperty(nuevoDto, "estadoProceso",	proceso.getEstadoProceso().getDescripcion());					
					if(MSVDDEstadoProceso.CODIGO_VALIDADO.equals(proceso.getEstadoProceso().getCodigo())) {
						sePuedeProcesar = true;
					} else if (MSVDDEstadoProceso.CODIGO_ERROR.equals(proceso.getEstadoProceso().getCodigo()) ||
							MSVDDEstadoProceso.CODIGO_PROCESADO_CON_ERRORES.equals(proceso.getEstadoProceso().getCodigo())){
						conErrores = true;
					} else if (MSVDDEstadoProceso.CODIGO_PTE_VALIDAR.equals(proceso.getEstadoProceso().getCodigo())){
						validable = true;
					}
					beanUtilNotNull.copyProperty(nuevoDto, "sePuedeProcesar", sePuedeProcesar);
					beanUtilNotNull.copyProperty(nuevoDto, "conErrores", conErrores);
					beanUtilNotNull.copyProperty(nuevoDto, "validable", validable);
				}
				beanUtilNotNull.copyProperty(nuevoDto, "nombre", proceso.getDescripcion());
				if (!Checks.esNulo(proceso.getAuditoria())) {
					beanUtilNotNull.copyProperty(nuevoDto, "usuario", proceso.getAuditoria().getUsuarioCrear());
					beanUtilNotNull.copyProperty(nuevoDto, "fechaCrear", proceso.getAuditoria().getFechaCrear());
				}

				procesosDto.add(nuevoDto);
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
		}

		return procesosDto;
	}

	@Override
	@BusinessOperation(MSV_BO_MOSTRAR_PROCESOS_PAGINATED)
	public Page mostrarProcesosPaginated(MSVDtoFiltroProcesos dto) {
		
		dto.setUsername(this.getUsername());
		if(this.esUsuarioSuperAdministrador()){
			dto.setEsSupervisor(true);
		}else{
			dto.setEsSupervisor(this.esUsuarioSupervisor());
		}
		
		this.parseaColumnasOrder(dto);

		return procesoDao.dameListaProcesos(dto);

	}

	/**
	 * Cambia el nombre de las columnas de ordenaci�n para que coincidan con las del objeto de Hibernate.
	 * @param dto
	 */
	private void parseaColumnasOrder(PaginationParams dto) {
		
		String sort = dto.getSort();
		if (sort == null || sort.trim().length() == 0) {
			
			dto.setSort(" proc.auditoria.fechaCrear ");
			dto.setDir("DESC");
		}else{

			sort = sort.trim();
	
			// Parseamos todas las posibles columnas que pueden llegar del Dto
			if ("id".equals(sort)) {
				dto.setSort(" proc.id ");
			}
			else if("id".equals(sort)){
				dto.setSort(" proc.auditoria.fechaCrear ");
			}
			else if("nombre".equals(sort)){
				dto.setSort(" proc.descripcion ");
			}
			else if("idTipoOperacion".equals(sort)){
				dto.setSort(" proc.tipoOperacion.id ");
			}
			else if("tipoOperacion".equals(sort)){
				dto.setSort(" proc.tipoOperacion.descripcion ");
			}
			else if("idEstado".equals(sort)){
				dto.setSort(" proc.estadoProceso.id ");
			}
			else if("estado".equals(sort)){
				dto.setSort(" proc.estadoProceso.descripcion ");
			}
			else if("fecha".equals(sort)){
				dto.setSort(" proc.auditoria.fechaCrear ");
			}
			else if("usuario".equals(sort)){
				dto.setSort(" proc.auditoria.usuarioCrear ");
			}
		}
	}	
	
	/**
	 * Comprueba si el usuario logado tiene perfil super administrador.
	 * @return
	 */
	private Boolean esUsuarioSuperAdministrador() {
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		return this.tienePerfil(MSVProcesoManager.PEFIL_SUPERADMINISTRADOR,usu);
	}	
	
	/**
	 * Comprueba si el usuario logado tiene perfil super administrador.
	 * @return
	 */
	private Boolean esUsuarioSupervisor() {
		Boolean result = false;
		String perfiles[] = {MSVProcesoManager.PEFIL_SUPERVISOR_BO, MSVProcesoManager.PEFIL_SUPERVISOR_OFICINA_PROCESAL};
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		for (int i = 0; i < perfiles.length; i++) {
			result = this.tienePerfil(perfiles[i],usu);
			if(result) return true;			
		}
		return result;
	}
	
	/**
	 * Comprueba si un usuario tiene un perfil determinado.
	 * @param descripcionPerfil descripci�n del perfil.
	 * @param u usuario
	 * @return
	 */
	private Boolean tienePerfil(String descripcionPerfil, Usuario u) {
	
		if (u == null || descripcionPerfil == null) {
	        return false;
	    }
	
	    for (Perfil p : u.getPerfiles()) {
	    	if(descripcionPerfil.equals(p.getDescripcion()))
	    		return true;
	    }
	
	    return false;
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi#liberarFichero(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_BO_LIBERAR_FICHERO )
	public	MSVProcesoMasivo liberarFichero(Long idProceso) throws Exception {

		MSVDocumentoMasivo fichero= ficheroDao.findByIdProceso(idProceso);
		MSVDDOperacionMasiva tipoOperacion = null;
		if(!Checks.esNulo(fichero)){
			tipoOperacion = fichero.getProcesoMasivo().getTipoOperacion();
			MSVLiberator lib = factoriaLiberators.dameLiberator(tipoOperacion);
			if (!Checks.esNulo(lib)) lib.liberaFichero(fichero);
		}
		
		MSVDtoAltaProceso dto = new MSVDtoAltaProceso();
		dto.setIdProceso(idProceso);

		dto.setCodigoEstadoProceso(comprobarPendienteProcesar(tipoOperacion));
		MSVProcesoMasivo proceso=this.modificarProcesoMasivo(dto);
		return proceso;
		
	}	
	
	/**
	 * Devuelve el estado del proceso si ya ha realizado todas las funciones la operaci�n o queda alguna pendiente de ejecutar por batch
	 * @param tipoOperacion
	 * @return
	 */
	private String comprobarPendienteProcesar(MSVDDOperacionMasiva tipoOperacion) {
		if (tipoOperacion == null)
			return MSVDDEstadoProceso.CODIGO_PTE_PROCESAR;
		return MSVDDEstadoProceso.CODIGO_PTE_PROCESAR;
	}	
	
	@BusinessOperation(MSV_BO_GETBYTOKEN)
	public MSVProcesoMasivo getByToken(Long tokenProceso) {
		return procesoDao.getByToken(tokenProceso);		
	}
		
	/**
	* Devuelve el Documento Masivo a partir de un id de proceso
	* @param idProcess
	* @return MSVDocumentoMasivo
	*/
	public MSVDocumentoMasivo getMSVDocumento(Long idProcess){
		return ficheroDao.findByIdProceso(idProcess);
	}
	
	
	public MSVProcesoMasivo get(Long idProcess){
		return procesoDao.get(idProcess);
	}	
	
	public MSVDDOperacionMasiva getOperacionMasiva(Long idTipoOperacion){
		return genericDao.get(MSVDDOperacionMasiva.class, genericDao.createFilter(FilterType.EQUALS, "id", idTipoOperacion));
	}
	
	/**
	 * Comprueba si un usuario tiene un perfil determinado por código de perfil.
	 * @param código de perfil.
	 * @param u usuario
	 * @return
	 */
	@Override
	public Boolean tienePerfilPorCodigo(String pefCodigo, Usuario usuario) {
	
		if (usuario == null || pefCodigo == null) {
	        return false;
	    }
	
	    for (Perfil p : usuario.getPerfiles()) {
	    	if(pefCodigo.equals(p.getCodigo()))
	    		return true;
	    }
	
	    return false;
	}
	
}	