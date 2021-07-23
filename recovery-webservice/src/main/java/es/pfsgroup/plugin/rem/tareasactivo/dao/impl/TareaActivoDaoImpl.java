package es.pfsgroup.plugin.rem.tareasactivo.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.tareasactivo.dao.TareaActivoDao;

@Repository("TareaActivoDao")
public class TareaActivoDaoImpl extends AbstractEntityDao<TareaActivo, Long> implements TareaActivoDao{

	
	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Resource
	private PaginationManager paginationManager;

    @Override
	public List<TareaActivo> getTareasActivoTramiteHistorico(Long idTramite){
		
		List<TareaActivo> listaTareas = new ArrayList<TareaActivo>();
		HQLBuilder hb = new HQLBuilder(" from TareaActivo tac");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.id", idTramite);
		hb.orderBy("tac.id", HQLBuilder.ORDER_ASC);
		
		listaTareas = HibernateQueryUtils.list(this, hb);
		
		return listaTareas;
	}
    
	@Override
   	public List<TareaActivo> getTareasActivoTramiteBorrados(Long idTramite){
    	
   		HQLBuilder hb = new HQLBuilder(" from TareaActivo tac");
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.id", idTramite);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.auditoria.borrado", true);
   		hb.orderBy("tac.id", HQLBuilder.ORDER_ASC);
   		
   		return HibernateQueryUtils.list(this, hb);
   	}

	@Override
	public TareaActivo getUltimaTareaActivoPorIdTramite(Long idTramite) {
		HQLBuilder hb = new HQLBuilder(" from TareaActivo tac");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.id", idTramite);
		hb.orderBy("tac.id", HQLBuilder.ORDER_DESC);

		return HibernateQueryUtils.list(this, hb).get(0);
	}
	
	@Override
	public List<TareaActivo> getTareasActivoPorIdActivo(Long idActivo) {
		HQLBuilder hb = new HQLBuilder(" from TareaActivo tac");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.activo.id", idActivo);
		hb.orderBy("tac.id", HQLBuilder.ORDER_DESC);

		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public List<TareaActivo> getTareasActivoPorIdActivoAndTramite(Long idActivo, String codigoTipoTramite) {
		HQLBuilder hb = new HQLBuilder(" from TareaActivo tac");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.activo.id", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tac.tramite.tipoTramite.codigo", codigoTipoTramite);
		hb.orderBy("tac.id", HQLBuilder.ORDER_DESC);

		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public void doFlush() {
		getHibernateTemplate().flush();
	}

	@Override
	public void finalizarTareasActivoPorIdActivoAndCodigoTramite(Long idActivo, String codigoTipoTramite) {
			
		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session.createSQLQuery("UPDATE TAR_TAREAS_NOTIFICACIONES"
		 		+ " SET TAR_TAREA_FINALIZADA = 1, TAR_FECHA_FIN = SYSDATE"
		 		+ " WHERE TAR_ID IN (SELECT TAR.TAR_ID FROM TAR_TAREAS_NOTIFICACIONES TAR"
				+ " JOIN TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID"
				+ " JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID"
				+ " JOIN TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID"
				+ " JOIN ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID"
				+ " JOIN DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID"
				+ " WHERE TPO.DD_TPO_CODIGO = :codigoTipoTramite"
				+ " AND ACT.ACT_ID = :idActivo AND TAR.BORRADO = 0"
				+ " AND TAR.TAR_TAREA_FINALIZADA = 0)");
		
		query.setParameter("codigoTipoTramite", codigoTipoTramite);
		query.setParameter("idActivo", idActivo);

		query.executeUpdate();
	}
	
	
	
	

}
