package es.pfsgroup.framework.paradise.gestorEntidad.dao.impl;

import java.util.List;

import org.hibernate.Query;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadDao;


public class GestorEntidadDaoImpl extends AbstractEntityDao<GestorEntidad, Long> implements GestorEntidadDao {

	@Override
	@SuppressWarnings("unchecked")
	public List<EXTDDTipoGestor> getListTipoGestorEditables(Long idTipoGestor) {
		
		HQLBuilder hb = new HQLBuilder("from EXTDDTipoGestor ges");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ges.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ges.editableWeb", true);
		
		Query query = getSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<EXTDDTipoGestor> listado = query.list();
		
		return listado;
		
	}

	@Override
	@SuppressWarnings("unchecked")
	public List<Usuario> getListUsuariosGestoresExpedientePorTipo(Long idTipoGestor) {
		
		HQLBuilder hb = new HQLBuilder("select distinct(gee.usuario) from GestorExpediente gee");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.tipoGestor.id", idTipoGestor);
		
		Query query = getSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<Usuario> listado = query.list();
		
		return listado;
	}

}
