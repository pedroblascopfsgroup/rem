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

	@SuppressWarnings("unchecked")
	public String getCodigoGestorPorUsuario(Long idUsuario) {
		
		HQLBuilder hb = new HQLBuilder("select distinct(gee.tipoGestor.codigo) from GestorEntidad gee");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.usuario.id", idUsuario);
		
		Query query = getSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<String> listado = query.list();
		
		String codigosGestor = listado.toString().substring(1,listado.toString().length()-1);
		
		return codigosGestor.trim();
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<Usuario> getListUsuariosGestoresPorTipoCodigo(String codigoTipoGestor) {
		
		HQLBuilder hb = new HQLBuilder("select distinct(gee.usuario) from GestorEntidad gee");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gee.tipoGestor.codigo", codigoTipoGestor);
		
		Query query = getSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<Usuario> listado = query.list();
		
		return listado;
	}
	
}
