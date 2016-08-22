package es.pfsgroup.plugin.rem.activo.dao.impl;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoHistDao;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivoHistorico;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;

@Repository("ActivoAgrupacionActivoHistDao")
public class ActivoAgrupacionActivoHistDaoImpl extends AbstractEntityDao<ActivoAgrupacionActivoHistorico, Long> implements ActivoAgrupacionActivoHistDao{

	@Resource
	private PaginationManager paginationManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private EXTGrupoUsuariosDao extGrupoUsuariosDao;

	@Override
	public ActivoAgrupacionActivoHistorico getHistoricoAgrupacionByActivoAndAgrupacion(long idActivo, long idAgrupacion) {
		
		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivoHistorico aah");
		
   	  	HQLBuilder.addFiltroLikeSiNotNull(hb, "aah.activo.id", idActivo, true);
   	  	HQLBuilder.addFiltroLikeSiNotNull(hb, "aah.agrupacion.id", idAgrupacion, true);
   	  	hb.appendWhere("aah.fechaHasta is null");

		return HibernateQueryUtils.uniqueResult(this, hb);
	}  

}
