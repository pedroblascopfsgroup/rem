package es.pfsgroup.plugin.rem.gestor;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionServiceFactoryApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.DefaultUserAssigantionService;
import es.pfsgroup.plugin.rem.model.Activo;
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
	

	@Transactional(readOnly = false)
	public void insertarGestorAdicionalActivo(GestorEntidadDto dto) {
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
			}
		}else{
			//super.insertarGestorAdicionalEntidad(dto);
		}
	}
	
	private void actualizarTareas(Long idActivo){
		
		List<ActivoTramite> listaTramites = activoTramiteApi.getListaTramitesActivo(idActivo);

		for (ActivoTramite tramite : listaTramites) {
			List<TareaExterna> listaTareas = activoTareaExternaApi.getTareasByIdTramite(tramite.getId());
			for(TareaExterna tareaExterna : listaTareas){
				EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento) tareaExterna.getTareaProcedimiento();
				
				UserAssigantionService userAssigantionService = userAssigantionServiceFactoryApi.getService(tareaProcedimiento.getCodigo());
				
				if(userAssigantionService instanceof DefaultUserAssigantionService)
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
	
	public List<GestorEntidadHistorico> getListGestoresAdicionalesHistoricoData(GestorEntidadDto gestorEntidadDto){
		return gestorEntidadApi.getListGestoresAdicionalesHistoricoData(gestorEntidadDto);
	}
	
	public Usuario getGestorByActivoYTipo(Activo activo, Long tipo){
		if (((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipo, activo).size()>0)
			return ((GestorActivoDao) gestorEntidadDao).getListUsuariosGestoresActivoByTipoYActivo(tipo, activo).get(0);
		else
			return null;
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

}