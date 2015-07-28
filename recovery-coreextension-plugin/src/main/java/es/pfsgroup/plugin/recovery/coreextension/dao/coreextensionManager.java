package es.pfsgroup.plugin.recovery.coreextension.dao;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.despachoExterno.DespachoExternoManager;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.EXTDDTipoGestorManager;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoDao;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoHistoricoDao;
import es.capgemini.pfs.multigestor.dao.EXTTipoGestorPropiedadDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;
import es.capgemini.pfs.multigestor.model.EXTGestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto;
import es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.DDPropiedadAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.despachoExterno.EXTDespachoExternoComparator;
import es.pfsgroup.recovery.ext.impl.multigestor.comparator.EXTUsuarioComparatorByApellidosNombre;

//FIXME Hay que eliminar esta clase o renombrarla
//No a�adir nueva funcionalidad
@Component
public class coreextensionManager implements coreextensionApi {
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	

	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	private EXTTipoGestorPropiedadDao tipoGestorPropiedadDao;

	@Autowired
	private EXTGestoresDao gestoresDao;

	@Autowired
	private EXTTipoProcedimientoDao tipoProcedimientoDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private EXTGestorAdicionalAsuntoDao gestorAdicionalAsuntoDao;
	
	@Autowired
	EXTGestorAdicionalAsuntoHistoricoDao gestorAdicionalAsuntoHistoricoDao;
	
	@Autowired
	DespachoExternoManager despachoExternoManager;
	
	@Autowired
	EXTDDTipoGestorManager tipoGestorManager;
	
	@Override
	@BusinessOperation(GET_LIST_TIPO_GESTOR)
	public List<EXTDDTipoGestor> getList(String ugCodigo) {		
		return getListDespachoByClaveValor(EXTTipoGestorPropiedad.TGP_CLAVE_UNIDAD_GESTION_VALIDAS, ugCodigo);
	}
	
	@Override
	@BusinessOperation(GET_LIST_TIPO_GESTOR_DESPACHO)
	public List<EXTDDTipoGestor> getListDespacho(String codTipoDespacho) {
		return getListDespachoByClaveValor(EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS, codTipoDespacho);
	}
	
	
	private List<EXTDDTipoGestor> getListDespachoByClaveValor(String clave, String codTipoDespacho) {
		List<EXTDDTipoGestor> listado = new ArrayList<EXTDDTipoGestor>();
		List<EXTTipoGestorPropiedad> listaTGP = tipoGestorPropiedadDao.getByClaveValor(clave, codTipoDespacho);
		for(EXTTipoGestorPropiedad tgp:listaTGP){
			listado.add(tgp.getTipoGestor());
		}
		return listado;
	}
	
	
	@Override
	@BusinessOperation(GET_STRING_TIPOS_GESTOR_DESPACHO)
	public String getTiposGestorDespacho(Long idTipoDespacho) {
		DDTipoDespachoExterno ddTipoDespacho = genericDao.get(DDTipoDespachoExterno.class, 
				genericDao.createFilter(FilterType.EQUALS, "id", idTipoDespacho),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		
		return this.getTiposGestorDespacho(ddTipoDespacho);
	}
	
	private String getTiposGestorDespacho(DDTipoDespachoExterno ddTipoDespacho) {
		String sRet = null;
		if (!Checks.esNulo(ddTipoDespacho)) {
			List<EXTTipoGestorPropiedad> listaTGP = tipoGestorPropiedadDao.getByClaveValor(EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS, ddTipoDespacho.getCodigo());
			for(EXTTipoGestorPropiedad tgp:listaTGP){			
				sRet += ","+tgp.getTipoGestor().getCodigo();
			}
		}
		return sRet;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi#getListTipoGestorAdicional()
	 */
	@BusinessOperation(GET_LIST_TIPO_GESTOR_ADICIONAL)
	public List<EXTDDTipoGestor> getListTipoGestorAdicional() {
		
		Order order = new Order(OrderType.ASC, "descripcion");
		List<EXTDDTipoGestor> listado = genericDao.getListOrdered(EXTDDTipoGestor.class, order, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
		return listado;
	}


	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi#getListDespachos(java.lang.Long)
	 */
	@Override
	@BusinessOperation(GET_LIST_TIPO_DESPACHO)
	public List<DespachoExterno> getListDespachos(Long idTipoGestor) {
		
		return getListAllDespachos(idTipoGestor, false);
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi#getListDespachos(java.lang.Long)
	 */
	@Override
	@BusinessOperation(GET_LIST_ALL_TIPO_DESPACHO)
	public List<DespachoExterno> getListAllDespachos(Long idTipoGestor, Boolean incluirBorrados) {

		List<DespachoExterno> listadoTotal = new ArrayList<DespachoExterno>();
		List<EXTTipoGestorPropiedad> listaTGP = tipoGestorPropiedadDao.getByClave(EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS);
		
		for(EXTTipoGestorPropiedad tgp:listaTGP){
			if(tgp.getTipoGestor().getId().equals(idTipoGestor)){
				
				if(tgp.getValor()!=null){
					String[] listaTiposDespachos = tgp.getValor().split(",");
					for(String tipoDespacho:listaTiposDespachos){
						DDTipoDespachoExterno ddTiposDespacho = genericDao.get(DDTipoDespachoExterno.class, 
								genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDespacho),
								genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
						
						if(ddTiposDespacho != null){
							
							List<DespachoExterno> listaDespachos;
							
							if(incluirBorrados) {
								listaDespachos = genericDao.getList(DespachoExterno.class, 
										genericDao.createFilter(FilterType.EQUALS, "tipoDespacho.codigo", tipoDespacho));
								
							} else {
								listaDespachos = genericDao.getList(DespachoExterno.class, 
										genericDao.createFilter(FilterType.EQUALS, "tipoDespacho.codigo", tipoDespacho),
										genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
								
							}							
							
							if(listaDespachos != null)
								listadoTotal.addAll(listaDespachos);
						}
							
					}
				}
			}
			//listadoTotal.add(tgp.getTipoGestor());
		}
		
		Collections.sort(listadoTotal, new EXTDespachoExternoComparator());
		return listadoTotal;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi#getListUsuariosData(long)
	 */
	@Override
	@BusinessOperation(GET_LIST_USUARIOS)
	public List<Usuario> getListUsuariosData(long idTipoDespacho) {
		return getListAllUsuariosData(idTipoDespacho, false);
	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi#getListUsuariosPaginatedData(es.pfsgroup.plugin.recovery.coreextension.api.UsuarioDto)
	 */
	@Override
	@BusinessOperation(GET_LIST_USUARIOS_PAGINATED)
	public Page getListUsuariosPaginatedData(UsuarioDto usuarioDto) {
		return gestoresDao.getGestoresByDespacho(usuarioDto);
	}	

	@Override
	@BusinessOperation(SAVE_GESTOR)
	@Transactional(readOnly = false)
	public void insertarGestor(Long idTipoGestor, Long idAsunto, Long idUsuario) {

		EXTGestorEntidad ge = new EXTGestorEntidad();

		ge.setGestor(genericDao.get(Usuario.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idUsuario)));
		ge.setTipoGestor(genericDao.get(EXTDDTipoGestor.class,
				genericDao.createFilter(FilterType.EQUALS, "id", idTipoGestor)));
		ge.setTipoEntidad(genericDao.get(DDTipoEntidad.class,
				genericDao.createFilter(FilterType.EQUALS, "id", 3L)));
		ge.setUnidadGestionId(idAsunto);

		genericDao.save(EXTGestorEntidad.class, ge);
	}
	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi#insertarGestorAdicionalAsunto(java.lang.Long, java.lang.Long, java.lang.Long, java.lang.Long)
	 */
	@BusinessOperation(SAVE_GESTOR_ADICIONAL_ASUNTO)
	@Transactional(readOnly = false)
	public void insertarGestorAdicionalAsunto(Long idTipoGestor, Long idAsunto, Long idUsuario, Long idTipoDespacho) throws Exception {
		
		try {
		
			Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
			if (asu instanceof EXTAsunto) {
				if (!Checks.esNulo(idAsunto) && !Checks.esNulo(idUsuario) && !Checks.esNulo(idTipoDespacho)) {
					GestorDespacho gestor = genericDao.get(GestorDespacho.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", idUsuario),
							genericDao.createFilter(FilterType.EQUALS, "despachoExterno.id", idTipoDespacho),
							genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
					EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "id", idTipoGestor));
					Filter filtroAsunto = genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto);
					Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", idTipoGestor);
					EXTGestorAdicionalAsunto gaa = genericDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto, filtroTipoGestor);
					if (Checks.esNulo(gaa)) {
						gaa = new EXTGestorAdicionalAsunto();
						gaa.setAsunto(asu);
						gaa.setTipoGestor(tipoGestor);
						gaa.setGestor(gestor);
						gestorAdicionalAsuntoDao.save(gaa);
						this.guardarHistoricoGestorAdicional(gaa);					
					}else{
						gaa.setGestor(gestor);
						if(idUsuario != gaa.getGestor().getUsuario().getId()){
							this.actualizaFechaHastaHistoricoGestorAdicional(idAsunto , idTipoGestor);
							this.guardarHistoricoGestorAdicional(gaa);
						}
						gestorAdicionalAsuntoDao.saveOrUpdate(gaa);
					}
				}
			}
		}
		catch(Exception e) {
			logger.error("insertarGestorAdicionalAsunto: " + e.getMessage());
			throw e;
		}
		
	}
	
	//Actualizamos las filas antiguas del hist�rico para un asunto y un tipo de gestor dado
	private void actualizaFechaHastaHistoricoGestorAdicional(Long idAsunto, Long idTipoGestor) {
		gestorAdicionalAsuntoHistoricoDao.actualizaFechaHasta(idAsunto, idTipoGestor);
		
	}

	//Guardamos el hist�rico de cambios de los gestores.
	private void guardarHistoricoGestorAdicional(EXTGestorAdicionalAsunto gaa) {
		EXTGestorAdicionalAsuntoHistorico gaah = new EXTGestorAdicionalAsuntoHistorico();
		gaah.setGestor(gaa.getGestor());
		gaah.setAuditoria(Auditoria.getNewInstance());
		gaah.setAsunto(gaa.getAsunto());
		gaah.setTipoGestor(gaa.getTipoGestor());
		gaah.setFechaDesde(new Date());
		gestorAdicionalAsuntoHistoricoDao.save(gaah);
	}

	public void setTipoGestorPropiedadDao(EXTTipoGestorPropiedadDao tipoGestorPropiedadDao) {
		this.tipoGestorPropiedadDao = tipoGestorPropiedadDao;
	}

	public EXTTipoGestorPropiedadDao getTipoGestorPropiedadDao() {
		return tipoGestorPropiedadDao;
	}

	@Override
	@BusinessOperation(REMOVE_GESTOR)
	@Transactional
	public void removeGestor(Long idAsunto, Long idUsuario, String codTipoGestor) {
		
		Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		//COMPROBAMOS QUE ESTE EN LA TABLA GESTORENDIDAD
		
		EXTGestorEntidad gestorEntidad = genericDao.get(EXTGestorEntidad.class, 
				genericDao.createFilter(FilterType.EQUALS, "tipoEntidad.codigo", DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO),
				genericDao.createFilter(FilterType.EQUALS, "unidadGestionId", idAsunto),
				genericDao.createFilter(FilterType.EQUALS, "gestor.id", idUsuario),
				genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", codTipoGestor),filtroAuditoria);
		
		if(gestorEntidad != null){
			genericDao.deleteById(EXTGestorEntidad.class,gestorEntidad.getId());
		}else{ //BUSCAMOS EN EL GAA
			
			EXTGestorAdicionalAsunto gestorAsunto = genericDao.get(EXTGestorAdicionalAsunto.class, 
					genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto),
					genericDao.createFilter(FilterType.EQUALS, "gestor.usuario.id", idUsuario),
					genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo", codTipoGestor),filtroAuditoria);
			
			if(gestorAsunto != null){
				genericDao.deleteById(EXTGestorAdicionalAsunto.class, gestorAsunto.getId());
			}else{//BUSCAMOS EN EL ASUNTO
				
				EXTDDTipoGestor tipo = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "codigo",codTipoGestor));
				
				//COMPROBAMOS QUE EL GESTOR A BORRAR SEA DE ESTOS TRES TIPOS, PORQUE SINO NO ESTARAN EN EL ASUNTO
				if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO.equals(tipo.getCodigo()) || EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR.equals(tipo.getCodigo()) || EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR.equals(tipo.getCodigo())){
					Asunto asu = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAsunto),filtroAuditoria);
					
					if(asu != null){
						if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO.equals(tipo.getCodigo())){
							GestorDespacho gestorDespacho = asu.getGestor();
							if(idUsuario.equals(gestorDespacho.getUsuario().getId())){
									asu.setGestor(null);
									genericDao.save(Asunto.class, asu);
							}
						}
						if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR.equals(tipo.getCodigo())){
							GestorDespacho gestorDespacho = asu.getSupervisor();
							if(idUsuario.equals(gestorDespacho.getUsuario().getId())){
								asu.setSupervisor(null);
								genericDao.save(Asunto.class, asu);
							}
						}
						if(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR.equals(tipo.getCodigo())){
							GestorDespacho gestorDespacho = asu.getProcurador();
							if(idUsuario.equals(gestorDespacho.getUsuario().getId())){
								asu.setProcurador(null);
								genericDao.save(Asunto.class, asu);
							}
						}
					}
				}
			}
		}		
	}

	@Override
	@BusinessOperation(GET_LIST_TIPO_PROCEDIMIENTO_POR_TIPO_ACTUACION)
	public List<TipoProcedimiento> getListTipoProcedimientosPorTipoActuacion(String codigoActuacion) {
		
		List<TipoProcedimiento> listado = tipoProcedimientoDao.getListTipoProcedimientosPorTipoActuacion(codigoActuacion);
		listado = eliminarOpcionTramiteSubastaByPropiedadAsunto(listado);
		
		return listado;		
	}
	
	private List<TipoProcedimiento> eliminarOpcionTramiteSubastaByPropiedadAsunto(List<TipoProcedimiento> listado) {
		
		
		return null;
	}

	@Override
	@BusinessOperation(GET_LIST_TIPO_PROCEDIMIENTO_MENOS_TIPO_ACTUACION)
	public List<TipoProcedimiento> getListTipoProcedimientosMenosTipoActuacion(String codigoActuacion) {
		return tipoProcedimientoDao.getListTipoProcedimientosMenosTipoActuacion(codigoActuacion);		
	}


	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.coreextension.api.coreextensionApi#getListGestorAdicionalAsuntoHistoricosData(java.lang.Long)
	 */
	@Override
	@BusinessOperation(GET_LIST_HISTORICO_GESTORES_ADICIONALES)
	public List<EXTGestorAdicionalAsuntoHistorico> getListGestorAdicionalAsuntoHistoricosData(Long idAsunto) {
		return gestorAdicionalAsuntoHistoricoDao.getListOrderedByAsunto(idAsunto);
	}

	
	/**
	 * Funci�n de negocio que devuelve el listado de despachos para un tipo de gestor dado.
	 * Ordenado por el campo despacho.
	 *
	 * @return Lista de despachos. {@link DespachoExterno}
	 */
	@BusinessOperation(GET_LIST_TIPO_DESPACHO_DE_USUARIO)
	public List<DespachoExterno> getListDespachosDeUsuario(Long idTipoGestor, Long idUsuario, boolean adicional, boolean procuradorAdicional) {
		
		// Todos los despachos
		List<DespachoExterno> listaDespachos = getListDespachos(idTipoGestor);

		// TODO: Esto hay que mejorarlo porque está hardcodeado GEST
		if (adicional) {
			EXTDDTipoGestor tipoGestoria = tipoGestorManager.getByCod("GEST");
			if (idTipoGestor.equals(tipoGestoria.getId())) 
				return listaDespachos;
		}
		
		if (procuradorAdicional) {
			EXTDDTipoGestor tipoGestoria = tipoGestorManager.getByCod("PROC");
			if (idTipoGestor.equals(tipoGestoria.getId())) 
				return listaDespachos;
		}
		
		// quitamos los que no puede ver.
		List<GestorDespacho> gestorDespachoList = despachoExternoManager.buscaDespachosPorUsuario(idUsuario);
		List<Long> idsDespachosUsuario = new ArrayList<Long>();
		for (GestorDespacho gestorDespacho : gestorDespachoList) {
			Long id = gestorDespacho // USD_USUARIOS_DESPACHOS
					.getDespachoExterno() // DES_DESPACHO_EXTERNO
					.getId();
			idsDespachosUsuario.add(id);
		}
		
		// Limpia los despachos que no puede ver
		for (int i=listaDespachos.size()-1; i>=0; i--) {
			DespachoExterno despacho = listaDespachos.get(i);
			if (!idsDespachosUsuario.contains(despacho.getId()))
				listaDespachos.remove(i);
		}
		
		return listaDespachos;
	}

	/**
	 * Devuelve una lista con los tipos de gestor que pertenecen al usuario determinado
	 * 
	 * @return
	 */
	@BusinessOperation(GET_LIST_TIPO_GESTOR_DE_USUARIO)
	public List<EXTDDTipoGestor> getListTipoGestorDeUsuario(Long idUsuario, boolean adicional, boolean procuradorAdicional) {
		
		// Todos los tipo gestor.
		List<EXTDDTipoGestor> listaTipoGestor = getListTipoGestorAdicional();

		// Quita ahora los qye nopuede ver
		List<GestorDespacho> gestorDespachoList = despachoExternoManager.buscaDespachosPorUsuario(idUsuario);
		List<String> tiposDespachoValidos = new ArrayList<String>();
		for (GestorDespacho gestorDespacho : gestorDespachoList) {
			String codigo = gestorDespacho // USD_USUARIOS_DESPACHOS
					.getDespachoExterno() // DES_DESPACHO_EXTERNO
					.getTipoDespacho() // DD_TDE_TIPO_DESPACHO
					.getCodigo();
			tiposDespachoValidos.add(codigo);
		}
		
		// Eliminamos los que no puede ver
		Set<EXTDDTipoGestor> encontrados = new HashSet<EXTDDTipoGestor>();
		List<EXTTipoGestorPropiedad> listaTGP = tipoGestorPropiedadDao.getByClave(EXTTipoGestorPropiedad.TGP_CLAVE_DESPACHOS_VALIDOS);
		for (EXTTipoGestorPropiedad propiedad : listaTGP) {
			EXTDDTipoGestor tipoGestor = propiedad.getTipoGestor();
			if (propiedad.getValor()==null) {
				continue;
			}
			// Si estamos hablando de datos adicionales "GEST" no se elimina
			// TODO: Esto hay que mejorarlo porque está hardcodeado GEST
			if (adicional &&
					tipoGestor.getCodigo().equals("GEST") &&
					!encontrados.contains(tipoGestor)) {
				encontrados.add(tipoGestor);
				continue;
			}
			// Si estamos hablando de datos procuradores adicionales "PROC" no se elimina
			if (procuradorAdicional &&
					tipoGestor.getCodigo().equals("PROC") &&
					!encontrados.contains(tipoGestor)) {
				encontrados.add(tipoGestor);
				continue;
			}
			String valor = String.format(",%s,", propiedad.getValor());
			boolean encontrado = false;
			for (String codigoDes : tiposDespachoValidos) {
				// Si no lo contiene elimina el tipo gestor.
				if (valor.contains(String.format(",%s,", codigoDes))) {
					encontrado = true;
					break;
				}
			}
			if (encontrado &&  !encontrados.contains(tipoGestor)) {
				encontrados.add(tipoGestor);
			}
		}
		
		for (int j=listaTipoGestor.size()-1; j>=0; j--) {
			EXTDDTipoGestor tipoGestor = listaTipoGestor.get(j);
			if (!encontrados.contains(tipoGestor)) {
				listaTipoGestor.remove(j);
			}
		}

		// Con esto tenemos los tipo gestor.
		return listaTipoGestor;
	}

	
	@Override
	@BusinessOperation(GET_LIST_ALL_USUARIOS)
	public List<Usuario> getListAllUsuariosData(long idTipoDespacho, boolean incluirBorrados) {
		
		List<Usuario> listaUsuarios = gestoresDao.getGestoresByDespacho(idTipoDespacho, incluirBorrados);
		if (listaUsuarios.size() > 0 ){
			Locale locale = new Locale("es_ES");
			Collator c = Collator.getInstance();
			c.setStrength(Collator.PRIMARY);
			Collections.sort(listaUsuarios, new EXTUsuarioComparatorByApellidosNombre(c));
		}
		return listaUsuarios;
		
		
	}

	@Override
	@BusinessOperation(GET_LIST_TIPO_PROCEDIMIENTO_BY_PROPIEDAD_ASUNTO)
	public List<TipoProcedimiento> getListTipoProcedimientosPorTipoActuacionByPropiedadAsunto(String codigoTipoAct, Long prcId) {
		if (codigoTipoAct != null) {
			Filter fIdTipoActuacion = genericDao.createFilter(FilterType.EQUALS, "tipoActuacion.codigo", codigoTipoAct);
			Filter fIdTipoActuacion2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			List<TipoProcedimiento> list = (ArrayList<TipoProcedimiento>) genericDao.getList(TipoProcedimiento.class, fIdTipoActuacion, fIdTipoActuacion2);

			if (!Checks.estaVacio(list) && "AP".equals(codigoTipoAct)) {
				String propiedad = null;
				MEJProcedimiento prc = (MEJProcedimiento) proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
				if (!Checks.esNulo(prc)) {
					EXTAsunto asu = genericDao.get(EXTAsunto.class, genericDao.createFilter(FilterType.EQUALS, "id", prc.getAsunto().getId()));
					String eliminar;
					propiedad = asu.getPropiedadAsunto().getCodigo();
					if (DDPropiedadAsunto.PROPIEDAD_BANKIA.equals(propiedad)) {
						eliminar = "P409";
					} else {
						eliminar = "P401";
					}
					for (TipoProcedimiento tipo : list)
						if (eliminar.equals(tipo.getCodigo())) {
							list.remove(tipo);
							break;
						}
				}
			}
			return list;
		}
		return null;
	}

}
