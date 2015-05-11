package es.pfsgroup.plugin.recovery.expediente.incidencia.manager;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.gestorEntidad.model.GestorExpediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.dao.impl.PageSql;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils;
import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.expediente.incidencia.api.IncidenciaExpedienteApi;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dao.IncidenciaExpedienteDao;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.DtoFiltroIncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.DtoIncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.dto.IncidenciaExpedienteDto;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.IncidenciaExpediente;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.SituacionIncidencia;
import es.pfsgroup.plugin.recovery.expediente.incidencia.model.TipoIncidencia;


/**
 * Mánager de la entidad incidencia expdediente.
 * 
 * @author Oscar
 * 
 */
@Component
public class IncidenciaExpedienteManager implements IncidenciaExpedienteApi {
	
	public static final String TODAS_LAS_INCIDENCIAS_SIN_AGENCIA="TODAS_LAS_INCIDENCIAS_SIN_AGENCIA";

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private Executor executor;
	
	@Autowired
	IncidenciaExpedienteDao incidenciaExpedienteDao;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	private FuncionManager funcionManager;

	@Override
	@BusinessOperation(BO_GET_LISTADO_INCIDENCIA_EXPEDIENTE)
	public Page getListadoIncidenciaExpediente(DtoFiltroIncidenciaExpediente dto) {

		return incidenciaExpedienteDao.getListadoIncidenciaExpediente(dto);
	}
	
	/**
	 * {@inheritDoc}
	 * @param dto
	 * @return
	 */
	@Override
	@BusinessOperation(BO_GET_LISTADO_INCIDENCIA_EXPEDIENTE_USU)
	public Page getListadoIncidenciaExpedienteUsuario(
			DtoFiltroIncidenciaExpediente dto) {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (!usuarioTieneVisibilidadCompleta(usuarioLogado)){
			dto.setIdUsuario(usuarioLogado.getId());
		}
		Page listaIncidencias = this.getListadoIncidenciaExpediente(dto);
		List<IncidenciaExpedienteDto> listaMapeada = new ArrayList<IncidenciaExpedienteDto>();
		
		for (Object inc : listaIncidencias.getResults()){
			if (inc.getClass().equals(IncidenciaExpediente.class)){
				IncidenciaExpediente incidencia = (IncidenciaExpediente) inc;
				IncidenciaExpedienteDto incidenciaDto = new IncidenciaExpedienteDto();
				incidenciaDto.setIncidencia(incidencia);
				String agencia = "---";
				if (!usuarioLogado.getUsuarioExterno()){
					agencia = incidencia.getUsuario().getApellidoNombre();
				} else {
					if (usuarioLogado.getId().equals(incidencia.getUsuario().getId())){
						agencia = incidencia.getUsuario().getApellidoNombre();
					}
				}
				
				incidenciaDto.setAgencia(agencia);
				listaMapeada.add(incidenciaDto);
			}
		}
		Page incidenciasMapeadasPage = new PageSql();
		((PageSql) incidenciasMapeadasPage).setResults(listaMapeada);
		((PageSql) incidenciasMapeadasPage).setTotalCount(listaIncidencias.getTotalCount());
		
		return incidenciasMapeadasPage;
	}


	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_CREAR_INCINDENCIA)
	public void crearIncidencia(DtoIncidenciaExpediente dto) {

		IncidenciaExpediente iex = new IncidenciaExpediente();
		Persona p = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdPersona()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		iex.setPersona(p);

		if (!Checks.esNulo(dto.getIdContrato())) {
			Contrato c = genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdContrato()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			iex.setContrato(c);
		}

		if (!Checks.esNulo(dto.getIdTipoIncidencia())) {
			TipoIncidencia t = genericDao.get(TipoIncidencia.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoIncidencia()),
					genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			iex.setTipoIncidencia(t);
		}
		
		SituacionIncidencia sii = genericDao.get(SituacionIncidencia.class, genericDao.createFilter(FilterType.EQUALS, "codigo", "3"),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		iex.setSituacionIncidencia(sii);

		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		iex.setUsuario(usuario);

		Expediente exp = genericDao.get(Expediente.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdExpediente()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		iex.setExpediente(exp);

		iex.setObservaciones(dto.getObservaciones());

		DespachoExterno des = buscarDespachoUnico(usuario);
		if (!Checks.esNulo(des)) {
			iex.setDespachoExterno(des);
		}

		incidenciaExpedienteDao.save(iex);
		
		//crearTareaExpediente(iex.getExpediente());

	}
	
	//TODO Finalizar el m�todo
	private void crearTareaExpediente(Expediente expediente) {
		
//		proxyFactory.proxy(TareaNotificacionApi.class).crearNotificacion(
//				 expediente.getId(),
//				 "2", "13",
//				"Revisión expediente");
		
		Date hoy = new Date();
		
		EXTTareaNotificacion tar = new EXTTareaNotificacion();
		tar.setExpediente(expediente);
		tar.setCodigoTarea("2");
		tar.setVencimiento(VencimientoUtils.getFecha(7 * 24 * 60 * 60 * 1000L, TipoCalculo.TODO));
				
		tar.setEstadoItinerario(genericDao.get(DDEstadoItinerario.class, genericDao.createFilter(FilterType.EQUALS, "id", 4L), genericDao.createFilter(FilterType.EQUALS, "borrado", false)));
		tar.setTipoEntidad(genericDao.get(DDTipoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "id", 2L), genericDao.createFilter(FilterType.EQUALS, "borrado", false)));
		tar.setSubtipoTarea(genericDao.get(SubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "id", 3L), genericDao.createFilter(FilterType.EQUALS, "borrado", false)));
		tar.setTarea("RE");
		tar.setDescripcionTarea("Revisión expediente");
		tar.setFechaInicio(new Date());
		tar.setEspera(Boolean.FALSE);
		tar.setAlerta(Boolean.FALSE);
		
		genericDao.save(TareaNotificacion.class, tar);
		
		
	}

	private DespachoExterno buscarDespachoUnico(Usuario usuario) {

		List<GestorDespacho> listado = genericDao.getList(GestorDespacho.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId()),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		if (listado.size() == 1) {
			return listado.get(0).getDespachoExterno();
		}

		return null;
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_BORRAR_INCIDENCIA)
	public void borrarIncidencia(Long id) {

		incidenciaExpedienteDao.deleteById(id);
	}

	@Override
	@BusinessOperation(BO_GET_INCIDENCIA_EXPEDIENTE)
	public IncidenciaExpediente get(Long id) {

		return incidenciaExpedienteDao.get(id);

	}

	@Override
	@BusinessOperation(BO_GET_LISTADO_PERSONAS_EXPEDIENTE)
	public List<Persona> getListadoPersonasExpediente(Long id) {

		List<Persona> personas = new ArrayList<Persona>();
		List<ExpedientePersona> listado = genericDao.getList(ExpedientePersona.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", id),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		for (ExpedientePersona exp : listado) {
			personas.add(exp.getPersona());
		}

		return personas;
	}

	@Override
	@BusinessOperation(BO_GET_LISTADO_CONTRATOS_EXPEDIENTE)
	public List<Contrato> getListadoContratosExpediente(Long id) {

		List<Contrato> contratos = new ArrayList<Contrato>();
		List<ExpedienteContrato> listado = genericDao.getList(ExpedienteContrato.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", id),
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		for (ExpedienteContrato exp : listado) {
			contratos.add(exp.getContrato());
		}

		return contratos;
	}

	@Override
	@BusinessOperation(BO_GET_LISTADO_TIPOS_INCIDENCIAS)
	public List<TipoIncidencia> getListadoTiposIncidencia() {

		return genericDao.getList(TipoIncidencia.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	@BusinessOperation(BO_GET_LISTADO_PROVEEDORES)
	public List<DespachoExterno> getListadoProveedores() {

		return genericDao.getList(DespachoExterno.class, genericDao.createFilter(FilterType.EQUALS, "tipoDespacho.codigo", DDTipoDespachoExterno.CODIGO_AGENCIA_RECOBRO));
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(BO_GET_LISTADO_PROVEEDORES_USU)
	public List<DespachoExterno> getListadoProveedoresUsuario() {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (usuarioLogado.getUsuarioExterno()){
			return getListadoDespachosUsuario(usuarioLogado.getId());
		} else {
			return this.getListadoProveedores();
		}
	}

	private List<DespachoExterno> getListadoDespachosUsuario(Long id) {
		Filter filtroTipoDespacho = genericDao.createFilter(FilterType.EQUALS, "despachoExterno.tipoDespacho.codigo", DDTipoDespachoExterno.CODIGO_AGENCIA_RECOBRO);
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", id);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<GestorDespacho> listaGestoresDespacho = genericDao.getList(GestorDespacho.class, filtroTipoDespacho, filtroUsuario, filtroBorrado);
		List<DespachoExterno> listaDespachos = new ArrayList<DespachoExterno>();
		for (GestorDespacho gd : listaGestoresDespacho){
			listaDespachos.add(gd.getDespachoExterno());
		}
		return listaDespachos;
	}

	@Override
	@BusinessOperation(BO_CREAR_NOTIFICACION)
	@Deprecated
	public void creaNotificacion(IncidenciaExpediente iex) {

	}

	@Override
	@BusinessOperation(BO_ES_GESTOR_RECOBRO)
	public Boolean esGestorRecobro(Usuario usu) {
		
		GestorEntidad gee = genericDao.get(GestorEntidad.class, genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo" , EXTDDTipoGestor.CODIGO_TIPO_GESTOR_AGENCIA_RECOBRO),
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", usu.getId()),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		
		if(!Checks.esNulo(gee)){
			return true;
		}

		return false;
	}
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(BO_ES_GESTOR_RECOBRO_EXPEDIENTE)
	public Boolean esGestorRecobroExpediente(Usuario usu, Long idExpediente){
		Filter filtroTipoGestor=genericDao.createFilter(FilterType.EQUALS, "tipoGestor.codigo" , EXTDDTipoGestor.CODIGO_TIPO_GESTOR_AGENCIA_RECOBRO);
		Filter filtroUsuario=genericDao.createFilter(FilterType.EQUALS, "usuario.id", usu.getId());
		Filter filtroBorrado=genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroExpediente= genericDao.createFilter(FilterType.EQUALS, "expediente.id", idExpediente);
		
		GestorExpediente gee = genericDao.get(GestorExpediente.class,filtroTipoGestor ,filtroBorrado,filtroExpediente);
		
		if(!Checks.esNulo(gee)){
			return true;
		}

		return false;
	}

	@Override
	@BusinessOperation(BO_GET_LISTADO_SITUACION_INCIDENCIA)
	public List<SituacionIncidencia> getListadoSituacionIncidencia() {

		return genericDao.getList(SituacionIncidencia.class, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_UPDATE_SITUACION_INCIDENCIA)
	public void updateIncidencia(Long id, Long situacion) {

		IncidenciaExpediente iex = incidenciaExpedienteDao.get(id);

		iex.setSituacionIncidencia(genericDao.get(SituacionIncidencia.class, genericDao.createFilter(FilterType.EQUALS, "id", situacion)));

		incidenciaExpedienteDao.saveOrUpdate(iex);

	}
	
	private Boolean usuarioTieneVisibilidadCompleta(Usuario usuarioLogado) {
		Boolean tieneVisibilidadCompleta=false;
		if (!usuarioLogado.getUsuarioExterno()){
			tieneVisibilidadCompleta=true;
		} else {
			if (funcionManager.tieneFuncion(usuarioLogado, TODAS_LAS_INCIDENCIAS_SIN_AGENCIA)){
				tieneVisibilidadCompleta = true;
			}	
		}
		
		return tieneVisibilidadCompleta;
	}


	
	

}
