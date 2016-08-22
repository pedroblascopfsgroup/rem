package es.pfsgroup.plugin.rem.gestor.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.impl.GestorEntidadDaoImpl;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoDao;
import es.pfsgroup.plugin.rem.model.Activo;

@Repository("GestorActivoDao")
public class GestorActivoDaoImpl extends GestorEntidadDaoImpl implements GestorActivoDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<Usuario> getListUsuariosGestoresActivoByTipoYActivo(Long idTipoGestor, Activo activo) {
		
		HQLBuilder hb = new HQLBuilder("select distinct(gee.usuario) from GestorActivo gee");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.activo.id", activo.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.tipoGestor.id", idTipoGestor);
		
		Query query = getSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<Usuario> listado = query.list();
		
		return listado;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Usuario> getListUsuariosGestoresActivoBycodigoTipoYActivo(String codigoTipoGestor, Activo activo){
		
		HQLBuilder hb = new HQLBuilder("select distinct(gee.usuario) from GestorActivo gee");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb,  "gee.activo.id", activo.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.tipoGestor.codigo", codigoTipoGestor);
		
		Query query = getSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<Usuario> listado = query.list();
		
		return listado;
	}

}
