package es.pfsgroup.plugin.rem.gestor;

import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.thread.MaestroDePersonas;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadHistoricoDao;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionServiceFactoryApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.TrabajoUserAssigantionService;

@Component
public class GestorExpedienteComercialManager implements GestorExpedienteComercialApi {
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteApi;
	
	@Autowired
	GestorEntidadDao gestorEntidadDao;
	
	@Autowired
	GestorEntidadHistoricoDao gestorEntidadHistoricoDao;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private UserAssigantionServiceFactoryApi userAssigantionServiceFactoryApi;
	
	@Autowired
	private GestorExpedienteComercialDao gestorExpedienteComercialDao;
	
	@Override
	public String[] getCodigosTipoGestorExpedienteComercial() {
		
		return new String[]{CODIGO_GESTOR_COMERCIAL_RETAIL, CODIGO_GESTOR_COMERCIAL_BACKOFFICE, CODIGO_GESTOR_COMERCIAL_SINGULAR,
				CODIGO_GESTOR_FORMALIZACION, CODIGO_GESTORIA_FORMALIZACION, CODIGO_SUPERVISOR_COMERCIAL_RETAIL, CODIGO_SUPERVISOR_COMERCIAL_SINGULAR,
				CODIGO_SUPERVISOR_FORMALIZACION, CODIGO_GESTOR_RESERVA_CAJAMAR, CODIGO_GESTOR_MINUTA_CAJAMAR, CODIGO_SUPERVISOR_RESERVA_CAJAMAR, 
				CODIGO_SUPERVISOR_MINUTA_CAJAMAR, CODIGO_GESTOR_CONTROLLER, CODIGO_GESTOR_CIERRE_VENTA};
	}
	
	@Override
	public String[] getCodigosTipoGestorExpedienteComercialAlquiler() {
		
		return new String[]{CODIGO_GESTORIA_FORMALIZACION,CODIGO_GESTOR_FORMALIZACION};
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean insertarGestorAdicionalExpedienteComercial(GestorEntidadDto dto) {
		Boolean inserccionOK = true;
		if(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL.equals(dto.getTipoEntidad())){
		
			if (!Checks.esNulo(dto.getIdEntidad()) && !Checks.esNulo(dto.getIdUsuario())/* && !Checks.esNulo(dto.getIdTipoDespacho())*/) {

				EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoGestor()));
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", dto.getIdEntidad());
				Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", dto.getIdTipoGestor());
				GestorExpedienteComercial gec = genericDao.get(GestorExpedienteComercial.class, filtro, filtroTipoGestor);
				
				Usuario usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdUsuario()));
				ExpedienteComercial expediente = expedienteApi.findOne(dto.getIdEntidad());
				
				if (Checks.esNulo(gec)) {
					gec = new GestorExpedienteComercial();
					gec.setExpedienteComercial(expediente);
					gec.setTipoGestor(tipoGestor);
					gec.setAuditoria(Auditoria.getNewInstance());
					gec.setUsuario(usu);
					gestorEntidadDao.save(gec);
					this.guardarHistoricoGestorAdicionalEntidad(gec, expediente);
				}
				else {
					if (!dto.getIdUsuario().equals(gec.getUsuario().getId())) {
						this.actualizaFechaHastaHistoricoGestorAdicionalExpedienteComercial(gec);
						gec.setUsuario(usu);
						gec.setAuditoria(Auditoria.getNewInstance());
						this.guardarHistoricoGestorAdicionalEntidad(gec, expediente);
					}
					gestorEntidadDao.saveOrUpdate(gec);
					
					//Actualizamos usuarios de las tareas
					if (!Checks.esNulo(expediente.getTrabajo())) {
						actualizarTareas(expediente.getTrabajo().getId());
					}
					
				}
				actualizarGestoresIdPersonaHaya(expediente);
			}
		}
		
		return inserccionOK;
	}
	
	@Override
	public void actualizarTareas(Long idTrabajo) {
		
		List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(idTrabajo);

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
		GestorExpedienteComercialHistorico geh = new GestorExpedienteComercialHistorico();
		geh.setUsuario(gee.getUsuario());
		geh.setAuditoria(Auditoria.getNewInstance());
		geh.setExpedienteComercial((ExpedienteComercial) obj);
		geh.setTipoGestor(gee.getTipoGestor());
		geh.setFechaDesde(new Date());
		gestorEntidadHistoricoDao.save(geh);
	}
	
	private void actualizaFechaHastaHistoricoGestorAdicionalExpedienteComercial(GestorExpedienteComercial gec) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "expedienteComercial.id", gec.getExpedienteComercial().getId() );
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "tipoGestor.id", gec.getTipoGestor().getId());
		List<GestorEntidadHistorico> geh = genericDao.getList(GestorEntidadHistorico.class, filtroTipoGestor, filtro);

		Date hoy = new Date();
		for (GestorEntidadHistorico g : geh) {
			if (Checks.esNulo(g.getFechaHasta())) {
				g.setFechaHasta(hoy);
				gestorEntidadHistoricoDao.saveOrUpdate(g);
			}
		}
	}
	
	@Override
	public List<GestorEntidadHistorico> getListGestoresAdicionalesHistoricoData(GestorEntidadDto dto) {
		List<GestorEntidadHistorico> listado = gestorEntidadHistoricoDao.getListOrderedByEntidad(dto);

		return listado;
	}

	@Override
	public Usuario getGestorByExpedienteComercialYTipo(ExpedienteComercial expediente, String tipo) {
		
		return gestorExpedienteComercialDao.getUsuarioGestorBycodigoTipoYExpedienteComercial(tipo, expediente);
	}

	public void actualizarGestoresIdPersonaHaya(ExpedienteComercial expedienteComercial){

		final String CODIGO_NOTARIA = "NOTARI";
		final String CODIGO_GESTORIA_FORMALIZACION = "GIAFORM";
		MaestroDePersonas maestroDePersonas = null;
		List <GestorExpedienteComercial> listGex = genericDao.getList(GestorExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"expedienteComercial.id",expedienteComercial.getId()));

		for (GestorExpedienteComercial gec: listGex) {
			if ((gec.getTipoGestor()!= null && CODIGO_NOTARIA.equals(gec.getTipoGestor().getCodigo())) || (gec.getTipoGestor()!= null && CODIGO_GESTORIA_FORMALIZACION.equals(gec.getTipoGestor().getCodigo())) && gec.getUsuario() != null){
				List<ActivoProveedorContacto> listActProveedor = genericDao.getList(ActivoProveedorContacto.class,genericDao.createFilter(FilterType.EQUALS,"usuario.id",gec.getUsuario().getId()));
				for (ActivoProveedorContacto activoProveedorContacto: listActProveedor) {
					if (activoProveedorContacto != null && activoProveedorContacto.getProveedor() != null && activoProveedorContacto.getProveedor().getIdPersonaHaya() == null){
						if (maestroDePersonas == null)
							maestroDePersonas = new MaestroDePersonas();
						activoProveedorContacto.getProveedor().setIdPersonaHaya(maestroDePersonas.getIdPersonaHayaByDocumentoProveedor(activoProveedorContacto.getProveedor().getDocIdentificativo(),activoProveedorContacto.getProveedor().getCodigoProveedorRem()));
						genericDao.save(ActivoProveedor.class,activoProveedorContacto.getProveedor());
					}
				}
			}
		}
	}
}
