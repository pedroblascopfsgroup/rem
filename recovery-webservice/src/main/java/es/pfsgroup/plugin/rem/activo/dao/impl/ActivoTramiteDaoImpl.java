package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoTramiteDao;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

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
						
		return HibernateQueryUtils.page(this, hb, webDto);
	}
	
	public List<ActivoTramite> getListaTramitesActivo(Long idActivo){
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.activo.id", idActivo);
		
		return HibernateQueryUtils.list(this, hb);
	}
	
	public Page getTramitesActivoTrabajo(Long idTrabajo, WebDto webDto){
		//List<ActivoTramite> listaTramites = new ArrayList<ActivoTramite>();
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		
		//Activo activo = activoDao.get(idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.trabajo.id", idTrabajo);
		
		return HibernateQueryUtils.page(this, hb, webDto);
		
	}

	public List<ActivoTramite> getListaTramitesActivoAdmision(Long idActivo){
		HQLBuilder hb = new HQLBuilder(" from ActivoTramite tra");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.activo.id", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tra.tipoTramite.codigo", "T001");
		
		return HibernateQueryUtils.list(this, hb);
	}
	
}