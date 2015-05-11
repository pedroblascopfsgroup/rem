package es.capgemini.pfs.embargoProcedimiento.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.embargoProcedimiento.dao.EmbargoProcedimientoDao;
import es.capgemini.pfs.embargoProcedimiento.model.EmbargoProcedimiento;

/**
 * Creado el Thu Jan 08 09:32:17 CET 2009.
 *
 * @author: Lisandro Medrano
 */
@Repository("EmbargoProcedimientoDao")
public class EmbargoProcedimientoDaoImpl extends AbstractEntityDao<EmbargoProcedimiento, Long> implements EmbargoProcedimientoDao {
}
