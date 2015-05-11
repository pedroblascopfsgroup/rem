package es.capgemini.pfs.procedimientoDerivado.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procedimientoDerivado.dao.ProcedimientoDerivadoDao;
import es.capgemini.pfs.procedimientoDerivado.model.ProcedimientoDerivado;

/**
 * Creado el Thu Jan 15 12:48:24 CET 2009.
 *
 * @author: Lisandro Medrano
 */
@Repository("ProcedimientoDerivadoDao")
public class ProcedimientoDerivadoDaoImpl extends AbstractEntityDao<ProcedimientoDerivado, Long> implements ProcedimientoDerivadoDao {
}
