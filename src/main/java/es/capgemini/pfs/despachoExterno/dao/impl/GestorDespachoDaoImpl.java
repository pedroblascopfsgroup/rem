package es.capgemini.pfs.despachoExterno.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

/**
 * Implementación del dao de GestorDespacho.
 * @author pamuller
 *
 */
@Repository("GestorDespachoDao")
public class GestorDespachoDaoImpl extends AbstractEntityDao<GestorDespacho,Long> implements GestorDespachoDao{

}
