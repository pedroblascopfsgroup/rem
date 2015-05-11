package es.capgemini.pfs.exceptuar.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.exceptuar.dto.DtoExceptuacion;
import es.capgemini.pfs.exceptuar.model.Exceptuacion;

public interface ExceptuacionDao extends AbstractDao<Exceptuacion, Long> {

	@Deprecated
	public Exceptuacion get(DtoExceptuacion dto);


}
