package es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.subastas.dao.LoteBienDao;

/**
 * Implementacion de BienDao.
 *
 */
@Repository("LoteBienDao")
public class LoteBienDaoImpl extends AbstractEntityDao<LoteBien, Long> implements LoteBienDao {

	@Override
	public void delete(LoteBien arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Long save(LoteBien arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void saveOrUpdate(LoteBien arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void update(LoteBien arg0) {
		// TODO Auto-generated method stub
		
	}

}
