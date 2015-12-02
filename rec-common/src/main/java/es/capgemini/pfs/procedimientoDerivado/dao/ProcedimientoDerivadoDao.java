package es.capgemini.pfs.procedimientoDerivado.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;

/**
 * Creado el Thu Jan 15 12:48:24 CET 2009.
 *
 * @author: Lisandro Medrano
 */
public interface ProcedimientoDerivadoDao extends AbstractDao<ProcedimientoDerivado, Long> {
	
	public ProcedimientoDerivado getByGuid(String guid);
}
