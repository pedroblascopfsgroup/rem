package es.capgemini.pfs.exceptuar.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.exceptuar.dao.ExceptuacionDao;
import es.capgemini.pfs.exceptuar.dto.DtoExceptuacion;
import es.capgemini.pfs.exceptuar.model.Exceptuacion;

@Repository("ExceptuacionDao")
public class ExceptuacionDaoImpl extends AbstractEntityDao<Exceptuacion, Long> implements ExceptuacionDao {

	@Override
	@Deprecated
	public Exceptuacion get(DtoExceptuacion dto) {
		return null;
	}
	
	

	
	

}
