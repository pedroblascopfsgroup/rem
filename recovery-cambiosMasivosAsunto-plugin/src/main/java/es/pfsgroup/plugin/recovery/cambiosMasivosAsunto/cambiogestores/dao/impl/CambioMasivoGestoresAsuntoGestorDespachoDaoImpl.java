package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.CambioMasivoGestoresAsuntoGestorDespachoDao;

@Repository
public class CambioMasivoGestoresAsuntoGestorDespachoDaoImpl extends AbstractEntityDao<GestorDespacho, Long> implements CambioMasivoGestoresAsuntoGestorDespachoDao {

	@Override
	public List<GestorDespacho> buscaGestoresByDespachoTipoGestor(Long despacho, Long tipoGestor, boolean conAsunto) {
		String sql = "";
		if (conAsunto) {
			sql = "select distinct gd from GestorDespacho gd, VTARAsuntoVsUsuario asu";
		} else {
			sql = "select distinct gd from GestorDespacho gd";
		}
		HQLBuilder hql = new HQLBuilder(sql);
	
		if (conAsunto) {
			hql.appendWhere("gd.despachoExterno.id = asu.despachoExterno and gd.usuario.id = asu.usuario");
			HQLBuilder.addFiltroIgualQue(hql, "asu.tipoGestor", tipoGestor);
		}
		
		HQLBuilder.addFiltroIgualQue(hql, "gd.despachoExterno.id", despacho);

		return HibernateQueryUtils.list(this, hql);
	}

}
