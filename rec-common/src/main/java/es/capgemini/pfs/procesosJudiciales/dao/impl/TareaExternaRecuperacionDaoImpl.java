package es.capgemini.pfs.procesosJudiciales.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaRecuperacionDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaRecuperacion;

/**
 * Implementación del dao de TareaExternaRecuperacionDao para Hibenate.
 *
 * @author pajimene
 *
 */
@Repository("TareaExternaRecuperacionDao")
public class TareaExternaRecuperacionDaoImpl extends AbstractEntityDao<TareaExternaRecuperacion, Long> implements TareaExternaRecuperacionDao {
}
