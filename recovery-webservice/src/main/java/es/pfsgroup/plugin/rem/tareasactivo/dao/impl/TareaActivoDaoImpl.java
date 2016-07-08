package es.pfsgroup.plugin.rem.tareasactivo.dao.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.tareasactivo.dao.TareaActivoDao;

@Repository("TareaActivoDao")
public class TareaActivoDaoImpl extends AbstractEntityDao<TareaActivo, Long> implements TareaActivoDao{

	@Resource
	private PaginationManager paginationManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	/**
	 * Devuelve las tareas activo asociadas a un trámite
	 * @param idTramite el id del trámite
	 * @return la lista de tareas del trámite
	 */
    @Override
	public List<TareaActivo> getTareasActivoTramiteHistorico(Long idTramite){
		
		List<TareaActivo> listaTareas = new ArrayList<TareaActivo>();
		HQLBuilder hb = new HQLBuilder(" from TareaActivo tac");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.id", idTramite);
		hb.orderBy("tac.id", HQLBuilder.ORDER_ASC);
		
		listaTareas = HibernateQueryUtils.list(this, hb);
		
		return listaTareas;
	}

}
