package es.capgemini.pfs.contrato.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.dao.DDEstadoContratoDao;
import es.capgemini.pfs.contrato.model.DDEstadoContrato;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * Clase que implementa los métodos de la interfaz DDEstadoFinancieroDao.
 *
 */
@Repository("DDEstadoContratoDao")
public class DDEstadoContratoDaoImpl extends AbstractEntityDao<DDEstadoContrato, Long> implements DDEstadoContratoDao {

}
