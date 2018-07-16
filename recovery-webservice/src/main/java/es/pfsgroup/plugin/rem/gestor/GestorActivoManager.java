package es.pfsgroup.plugin.rem.gestor;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.api.GestorEntidadApi;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadHistoricoDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.manager.GestorEntidadManager;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionServiceFactoryApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.TrabajoUserAssigantionService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.GestorActivo;
import es.pfsgroup.plugin.rem.model.GestorActivoHistorico;
import es.pfsgroup.plugin.rem.model.TareaActivo;

@Component
@Service("gestorActivoManager")
public class GestorActivoManager extends GestorEntidadManager implements GestorActivoApi  {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GestorEntidadDao gestorEntidadDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private UserAssigantionServiceFactoryApi userAssigantionServiceFactoryApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private GestorEntidadHistoricoDao gestorEntidadHistoricoDao;
	
	@Autowired
	private GestorEntidadApi gestorEntidadApi;
	
	@Autowired
	private GestorActivoDao gestorActivoDao;

	@Transactional(readOnly = false)
	public Boolean insertarGestorAdicionalActivo(GestorEntidadDto dto) {
		Boolean inserccionOK = true;
		if(GestorEntidadDto.TIPO_ENTIDAD_ACTIVO.equals(dto.getTipoEntidad())){
			if (!Checks.esNulo(dto.getIdEntidad()) && !Checks.esNulo(dto.getIdUsuario())/* && !Checks.esNulo(dto.getIdTipoDespacho())*/) {

				EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoGestor()));
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", dto.getIdEntidad());
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", dto.getIdTipoGestor());
				GestorActivo gac =  genericDao.get(GestorActivo.class, filtro, filtroTipoGestor);

				Usuario usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdUsuario()));
				Activo act = activoApi.get(dto.getIdEntidad());

				if (Checks.esNulo(gac)) {
					gac = new GestorActivo();
					gac.setActivo(act);
					gac.setTipoGestor(tipoGestor);
					gac.setAuditoria(Auditoria.getNewInstance());
					gac.setUsuario(usu);
					gestorEntidadDao.save(gac);
					this.guardarHistoricoGestorAdicionalEntidad(gac, act);
				} else {
					//Comprobamos que el activo cumpla las condiciones para poder cambiar de gestor
					if(gac.getTipoGestor().getCodigo().equals("GPREC")){
						if(this.validarTramitesNoMultiActivo(dto.getIdEntidad())) {
							if (!dto.getIdUsuario().equals(gac.getUsuario().getId())) {
								this.actualizaFechaHastaHistoricoGestorAdicionalActivo(gac);
								gac.setUsuario(usu);
								gac.setAuditoria(Auditoria.getNewInstance());
								this.guardarHistoricoGestorAdicionalEntidad(gac, act);
							}
							gestorEntidadDao.saveOrUpdate(gac);
							
							//Actualizamos usuarios de las tareas
							actualizarTareas(dto.getIdEntidad());
						}
						else {
							inserccionOK = false;
						}
					}else{
						//if (!dto.getIdUsuario().equals(gac.getUsuario().getId())) {
							this.actualizaFechaHastaHistoricoGestorAdicionalActivo(gac);
							gac.setUsuario(usu);
							gac.setAuditoria(Auditoria.getNewInstance());
							this.guardarHistoricoGestorAdicionalEntidad(gac, act);
						//}
						gestorEntidadDao.saveOrUpdate(gac);
						
						//Actualizamos usuarios de las tareas
						actualizarTareas(dto.getIdEntidad());
					}
				}
			}
		}else{
			//super.insertarGestorAdicionalEntidad(dto);
		}
		
		return inserccionOK;
	}
	
	@Override
	public void actualizarTareas(Long idActivo) {
		
		List<ActivoTramite> listaTramites = activoTramiteApi.getListaTramitesActivo(idActivo);

		for (ActivoTramite tramite : listaTramites) {
			List<TareaExterna> listaTareas = activoTareaExternaApi.getActivasByIdTramiteTodas(tramite.getId());
			for(TareaExterna tareaExterna : listaTareas){
				EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento) tareaExterna.getTareaProcedimiento();
				
				UserAssigantionService userAssigantionService = userAssigantionServiceFactoryApi.getService(tareaProcedimiento.getCodigo());
				
				if(!(userAssigantionService instanceof TrabajoUserAssigantionService))
				{
					Usuario gestor = userAssigantionService.getUser(tareaExterna);
				
					if(!Checks.esNulo(gestor)){
						TareaActivo tareaActivo = ((TareaActivo)tareaExterna.getTareaPadre());
						tareaActivo.setUsuario(gestor);
					}
				}
			}
		}

			

	}
	
	private void guardarHistoricoGestorAdicionalEntidad(GestorEntidad gee, Object obj) {
		GestorActivoHistorico gah = new GestorActivoHistorico();
		gah.setUsuario(gee.getUsuario());
		gah.setAuditoria(Auditoria.getNewInstance());
		gah.setActivo((Activo) obj);
		gah.setTipoGestor(gee.getTipoGestor());
		gah.setFechaDesde(new Date());
		gestorEntidadHistoricoDao.save(gah);
	}
	
	private void actualizaFechaHastaHistoricoGestorAdicionalActivo(GestorActivo gac) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", gac.getActivo().getId() );
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", gac.getTipoGestor().getId());
		List<GestorEntidadHistorico> geh = genericDao.getList(GestorEntidadHistorico.class, filtroTipoGestor, filtro);

		Date hoy = new Date();
		for (GestorEntidadHistorico g : geh) {
			if (Checks.esNulo(g.getFechaHasta())) {
				g.setFechaHasta(hoy);
				gestorEntidadHistoricoDao.saveOrUpdate(g);
			}
		}
		
	}
	
	public List<GestorEntidadHistorico> getListGestoresActivosAdicionalesHistoricoData(GestorEntidadDto gestorEntidadDto){
		return gestorEntidadApi.getListGestoresActivosAdicionalesHistoricoData(gestorEntidadDto);
	}
	
	public List<GestorEntidadHistorico> getListGestoresAdicionalesHistoricoData(GestorEntidadDto gestorEntidadDto){
		return gestorEntidadApi.getListGestoresAdicionalesHistoricoData(gestorEntidadDto);
	}
	
	public Usuario getGestorByActivoYTipo(Activo activo, Long tipo){
		List<Usuario> usuariosGestoresList = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipo, activo);
		
		if(usuariosGestoresList != null && !usuariosGestoresList.isEmpty()) {
			return usuariosGestoresList.get(0);
		} else {
			return null;
		}
	}
	
	public Usuario getGestorByActivoYTipo(Activo activo, String codigoTipo){
		Usuario gestor = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipo);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtro);
		if(tipoGestor != null){
			gestor = this.getGestorByActivoYTipo(activo, tipoGestor.getId());
		}
		return gestor;		
	}
	
	public Boolean isGestorActivo(Activo activo, Usuario usuario){

		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_GESTOR_ACTIVO);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		List<Usuario> usuariosActivos = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipoGestor.getId(),activo);		
		return usuariosActivos.contains(usuario);
	}
	



	public Boolean isSupervisorActivo(Activo activo, Usuario usuario){

		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_SUPERVISOR_ACTIVOS);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		List<Usuario> usuariosActivos = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipoGestor.getId(),activo);		
		return !Checks.esNulo(usuariosActivos) ? usuariosActivos.contains(usuario) : false;
	}
	
	public Boolean isGestorAdmision(Activo activo, Usuario usuario){

		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_GESTOR_ADMISION);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		List<Usuario> usuariosAdmision = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipoGestor.getId(),activo);		
		return usuariosAdmision.contains(usuario);
	}
	
	public Boolean isGestorActivoOAdmision(Activo activo, Usuario usuario){
		if (isGestorActivo(activo, usuario) || isGestorAdmision(activo, usuario)){
			return true;
		} else {
			return false;
		}
	}
	
	public Boolean isGestorActivoYTipo(Usuario usuario, Activo activo, String codigoGestor){
		if(Checks.esNulo(codigoGestor))
			return false;
		else{
			List<Usuario> usuarios = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoBycodigoTipoYActivo(codigoGestor, activo);
			return (usuarios.contains(usuario)? true : false);
		}
	}
	
	public Boolean isUsuarioGestorAdmision(Usuario usuario){
		 Perfil GESTOADM = genericDao.get(Perfil.class,
		 genericDao.createFilter(FilterType.EQUALS, "codigo", "HAYAGESTADM"));

		 return usuario.getPerfiles().contains(GESTOADM);
	}

	// Comprobaciones para Gestores de Precios y Marketing ------------------------------------------------
	
	public Boolean isGestorPrecios(Activo activo, Usuario usuario){
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_GESTOR_PRECIOS);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		List<Usuario> usuariosActivos = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipoGestor.getId(),activo);		
		return usuariosActivos.contains(usuario);
	}

	public Boolean isGestorMarketing(Activo activo, Usuario usuario){
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_GESTOR_MARKETING);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		List<Usuario> usuariosActivos = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipoGestor.getId(),activo);		
		return usuariosActivos.contains(usuario);
	}
	
	
	
	
	public Boolean isGestorPreciosOMarketing(Activo activo, Usuario usuario){
		if (isGestorPrecios(activo, usuario) || isGestorMarketing(activo, usuario)){
			return true;
		} else {
			return false;
		}
	}
	
	
	@Override
	public Usuario userFromTarea(String codigoTarea, Long idTramite){
		
		List<TareaExterna> listaTareas = activoTareaExternaApi.getTareasByIdTramite(idTramite);
		for(TareaExterna tarea : listaTareas){
			if(codigoTarea.equals(tarea.getTareaProcedimiento().getCodigo()))
			{
				TareaActivo tareaActivo = (TareaActivo) tarea.getTareaPadre();
				return tareaActivo.getUsuario();
			}
		}
		return null;
	}
	
	@Override
	public Boolean existeGestorEnActivo(Activo activo, String codGestor) {
		
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", codGestor);
		EXTDDTipoGestor gestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		Usuario gestor = this.getGestorByActivoYTipo(activo, gestorActivo.getId());
		
		if(!Checks.esNulo(gestor))
			return true;
		else
			return false;
	}
	
	/**
	 * Comprueba que el activo no tenga trámites MULTIACTIVO con tareas activas
	 * @param listaTramites
	 * @return
	 */
	@Override
	public Boolean validarTramitesNoMultiActivo(Long idActivo) {
		
		List<ActivoTramite> listaTramites = activoTramiteApi.getListaTramitesActivo(idActivo);
		
		for(ActivoTramite tramite : listaTramites) {
			if(tramite.getActivos().size() > 1 && Checks.esNulo(tramite.getFechaFin()))
				return false;
		}
		
		return true;
	}
	
	@Override
	public Usuario getGestorComercialActual(Activo activo, String codGestor) {
		
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", codGestor);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		Usuario usuario = getGestorByActivoYTipo(activo,tipoGestor.getId());
		if(Checks.esNulo(usuario)) {
			filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", "GCOM");
			tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
			usuario = getGestorByActivoYTipo(activo,tipoGestor.getId());
		}
		
		return usuario;
	}

	@Override
	public ActivoProveedor obtenerProveedorTecnico(Long idActivo) {
		GestorActivo proveedorTecnico = null;
		ActivoProveedor pve = null;
		if (idActivo != null) {
			Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			Filter filterAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			List<GestorActivo> gestoresActivo = genericDao.getList(GestorActivo.class, filterActivo, filterAuditoria);
			for (GestorActivo gestorActivo : gestoresActivo) {
				if ("PTEC".equals(gestorActivo.getTipoGestor().getCodigo())) {
					proveedorTecnico = gestorActivo;
					break;
				}
			}
			if (!Checks.esNulo(proveedorTecnico)) {
				Filter filterGee = genericDao.createFilter(FilterType.EQUALS, "id", proveedorTecnico.getId());
				GestorEntidad gestorEntidad = genericDao.get(GestorEntidad.class, filterGee, filterAuditoria);
				Filter filterPvc = genericDao.createFilter(FilterType.EQUALS, "usuario.id",
						gestorEntidad.getUsuario().getId());
				List<ActivoProveedorContacto> pvc = genericDao.getList(ActivoProveedorContacto.class, filterAuditoria,
						filterPvc);
				if (!Checks.estaVacio(pvc)) {
					if (!Checks.esNulo(pvc.get(0))) {
						pve = pvc.get(0).getProveedor();

					}
				}
			}
		}
		return pve;
	}

	@Override
	public Boolean isGestorSuelos(Activo activo, Usuario usuario) {
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_GESTOR_SUELOS);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		List<Usuario> usuariosActivos = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipoGestor.getId(),activo);		
		return usuariosActivos.contains(usuario);
	}

	@Override
	public Boolean isGestorEdificaciones(Activo activo, Usuario usuario) {
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_GESTOR_EDIFICACIONES);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		List<Usuario> usuariosActivos = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipoGestor.getId(),activo);		
		return usuariosActivos.contains(usuario);
	}

	@Override
	public Boolean isGestorAlquileres(Activo activo, Usuario usuario){

		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_GESTOR_ALQUILERES);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		List<Usuario> usuariosActivos = ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipoGestor.getId(),activo);		
		return usuariosActivos.contains(usuario);
	}
	
	@Override
	@Transactional(readOnly = false)
	public void borrarGestorAdicionalEntidad(GestorEntidadDto dto) {

		Filter filtroAuditoria = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", dto.getIdUsuario());
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", dto.getIdEntidad());
		
		GestorActivo gestorActivo = genericDao.get(GestorActivo.class,filtroUsuario,filtroActivo,filtroAuditoria);
		
		if (gestorActivo != null) {
			this.actualizaFechaHastaHistoricoGestorAdicional(gestorActivo);
			gestorActivoDao.delete(gestorActivo);
		}

	}
	
	private void actualizaFechaHastaHistoricoGestorAdicional(GestorActivo gac) {

		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", gac.getTipoGestor().getId());
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", gac.getUsuario().getId());
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", gac.getActivo().getId());
		
		List<GestorActivoHistorico> gah = genericDao.getList(GestorActivoHistorico.class, filtroTipoGestor,filtroUsuario,filtroActivo);

		Date hoy = new Date();
		for (GestorActivoHistorico g : gah) {
			if (Checks.esNulo(g.getFechaHasta())) {
				g.setFechaHasta(hoy);
				gestorEntidadHistoricoDao.saveOrUpdate(g);
			}
		}
	}

}