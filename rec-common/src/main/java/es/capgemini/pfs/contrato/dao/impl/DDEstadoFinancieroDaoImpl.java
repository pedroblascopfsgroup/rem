package es.capgemini.pfs.contrato.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.dao.DDEstadoFinancieroDao;
import es.capgemini.pfs.contrato.model.DDEstadoFinanciero;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz DDEstadoFinancieroDao.
 *
 */
@Repository("DDEstadoFinancieroDao")
public class DDEstadoFinancieroDaoImpl extends AbstractEntityDao<DDEstadoFinanciero, Long> implements DDEstadoFinancieroDao {

}
