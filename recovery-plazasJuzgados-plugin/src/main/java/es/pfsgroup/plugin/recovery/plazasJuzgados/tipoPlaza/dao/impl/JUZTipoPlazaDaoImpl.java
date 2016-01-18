package es.pfsgroup.plugin.recovery.plazasJuzgados.tipoPlaza.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.recovery.plazasJuzgados.tipoPlaza.dao.JUZTipoPlazaDao;

@Repository("JUZTipoPlazaDao")
public class JUZTipoPlazaDaoImpl extends AbstractEntityDao<TipoPlaza, Long> implements JUZTipoPlazaDao{

	@Override
	public TipoPlaza createNewTipoPlaza() {
		TipoPlaza tipoPlaza = new TipoPlaza();
		tipoPlaza.setId(getLastId()+1);
		return tipoPlaza;
	}
	
	public Long getLastId() {
		HQLBuilder b = new HQLBuilder("select max(id) from TipoPlaza");
		return (Long) getSession().createQuery(b.toString()).uniqueResult();
	}

}
