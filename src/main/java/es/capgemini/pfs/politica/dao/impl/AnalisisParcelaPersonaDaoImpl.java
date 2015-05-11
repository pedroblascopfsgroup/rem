package es.capgemini.pfs.politica.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.AnalisisParcelaPersonaDao;
import es.capgemini.pfs.politica.model.AnalisisParcelaPersona;

/**
 * Implementacion de AnalisisPersonaPoliticaDao.
 * @author Pablo Müller
 *
 */
@Repository("AnalisisParcelaPersonaDao")
public class AnalisisParcelaPersonaDaoImpl extends AbstractEntityDao<AnalisisParcelaPersona, Long>  implements AnalisisParcelaPersonaDao {


}
