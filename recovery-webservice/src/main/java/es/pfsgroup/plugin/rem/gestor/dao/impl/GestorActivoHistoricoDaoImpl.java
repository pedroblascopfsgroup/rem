package es.pfsgroup.plugin.rem.gestor.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.impl.GestorEntidadHistoricoDaoImpl;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoHistoricoDao;
import es.pfsgroup.plugin.rem.model.Activo;

@Repository("GestorActivoHistoricoDao")
public class GestorActivoHistoricoDaoImpl extends GestorEntidadHistoricoDaoImpl implements GestorActivoHistoricoDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<Usuario> getListUsuariosGestoresActivoByTipoYActivo(Long idTipoGestor, Activo activo) {
		HQLBuilder hb = new HQLBuilder("select distinct(geh.usuario) from GestorActivoHistorico geh");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "geh.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "geh.activo.id", activo.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "geh.tipoGestor.id", idTipoGestor);
		HQLBuilder.addFiltroIsNull(hb, "geh.fechaHasta");
		
		Query query = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
	
		List<Usuario> listado = query.list();
		
		return listado;
	}

}
