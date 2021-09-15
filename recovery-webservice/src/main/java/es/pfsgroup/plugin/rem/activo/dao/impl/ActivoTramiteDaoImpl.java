package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManager;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoScreening;

/**
 * Clase de acceso a datos de los trámites de Activo.
 * @author Daniel Gutiérrez
 */
@Repository("ActivoTramiteDao")
public class ActivoTramiteDaoImpl extends AbstractEntityDao<ActivoTramite, Long> implements ActivoTramiteDao{

	@Autowired
	private ActivoDao activoDao;
	/**
	 * Devuelve los trámites asociados a un activo.
	 * @param idActivo el id del activo
	 * @return la lista de trámites
	 */
	public Page getTramitesActivo(Long idActivo, WebDto webDto){
		
		//HQLBuilder hb = new HQLBuilder("select tra from ActivoTramite tra, ActivoTrabajo tbj");
		//hb.appendWhere("tra.trabajo.id = tbj.trabajo");
		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tbj.activo", idActivo);
		
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.activo.id", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
						
		return HibernateQueryUtils.page(this, hb, webDto);
	}
	
	public List<ActivoTramite> getListaTramitesActivo(Long idActivo){
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.activo.id", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
		
		return HibernateQueryUtils.list(this, hb);
	}
	
	public Page getTramitesActivoTrabajo(Long idTrabajo, WebDto webDto){
		//List<ActivoTramite> listaTramites = new ArrayList<ActivoTramite>();
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		
		//Activo activo = activoDao.get(idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.trabajo.id", idTrabajo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
		
		return HibernateQueryUtils.page(this, hb, webDto);
		
	}
	
	public List<ActivoTramite> getTramitesActivoTrabajoList(Long idTrabajo){
		//List<ActivoTramite> listaTramites = new ArrayList<ActivoTramite>();
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		
		//Activo activo = activoDao.get(idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.trabajo.id", idTrabajo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
		
		return HibernateQueryUtils.list(this, hb);
		
	}

	public List<ActivoTramite> getListaTramitesActivoAdmision(Long idActivo){
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.activo.id", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.tipoTramite.codigo", "T001");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
		return HibernateQueryUtils.list(this, hb);
	}
	
	public List<ActivoTramite> getListaTramitesFromActivoTrabajo(Long idActivo) {
		
		HQLBuilder hb = new HQLBuilder("select tra from ActivoTramite tra, VBusquedaTramitesActivo v");
		hb.appendWhere("tra.id = v.idTramite");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "v.idActivo", idActivo);
		
		return HibernateQueryUtils.list(this, hb);
	}
	
	public List<ActivoTramite> getTramitesByTipoAndTrabajo(Long idTrabajo, String codigoTramite) {
		
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.trabajo.id", idTrabajo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.tipoTramite.codigo", codigoTramite);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
		
		return HibernateQueryUtils.list(this, hb);
		
	}
	
	public Boolean tieneTramiteVigenteByActivoYProcedimiento(Long idActivo, String codigoTipoProcedimiento){
		
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.activo.id", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.tipoTramite.codigo", codigoTipoProcedimiento);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.estadoTramite.codigo", JBPMActivoTramiteManager.ESTADO_PROCEDIMIENTO_EN_TRAMITE);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
		
		return !HibernateQueryUtils.list(this, hb).isEmpty();
	}
	
	public ActivoTramite getTramiteComercialVigenteByTrabajo(Long idTrabajo){
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.trabajo.id", idTrabajo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.tipoTramite.codigo", "T013");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.estadoTramite.codigo", JBPMActivoTramiteManager.ESTADO_PROCEDIMIENTO_EN_TRAMITE);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}
	
	public Boolean creaTareaValidacion(String username, String numExpediente){
		String procedureHQL = "BEGIN SP_CREAR_TAREA(:usernameParam, :expedienteParam, :tareaDestinoParam, null, null, :salida);  END;";


		Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
		callProcedureSql.setParameter("usernameParam", username);
		callProcedureSql.setParameter("expedienteParam", numExpediente);
		callProcedureSql.setParameter("tareaDestinoParam", ComercialUserAssigantionService.CODIGO_T013_VALIDACION_CLIENTES);
		callProcedureSql.setParameter("salida", new String());

		int resultado = callProcedureSql.executeUpdate();
		
		return resultado == 1;
	}
	
	@Override
	public Boolean creaTareas(DtoScreening dto){
		String procedureHQL = "BEGIN SP_CREAR_TAREA(:usernameParam, :expedienteParam, :tareaDestinoParam, null, null, :salida);  END;";


		Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
		callProcedureSql.setParameter("usernameParam", dto.getUsuarioLogado());
		callProcedureSql.setParameter("expedienteParam", dto.getNumExpedienteComercial());
		callProcedureSql.setParameter("tareaDestinoParam", dto.getCodigoTarea());
		callProcedureSql.setParameter("salida", new String());

		int resultado = callProcedureSql.executeUpdate();
		
		return resultado == 1;
	}
	
	@Override
	public ActivoTramite getTramiteComercialVigenteByTrabajoT017 (Long idTrabajo){
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.trabajo.id", idTrabajo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.tipoTramite.codigo", "T017");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.estadoTramite.codigo", JBPMActivoTramiteManager.ESTADO_PROCEDIMIENTO_EN_TRAMITE);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}
	
	@Override
	public ActivoTramite getTramiteComercialVigenteByTrabajoT015 (Long idTrabajo){
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.trabajo.id", idTrabajo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.tipoTramite.codigo", "T015");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.estadoTramite.codigo", JBPMActivoTramiteManager.ESTADO_PROCEDIMIENTO_EN_TRAMITE);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.auditoria.borrado", false);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}
	
}