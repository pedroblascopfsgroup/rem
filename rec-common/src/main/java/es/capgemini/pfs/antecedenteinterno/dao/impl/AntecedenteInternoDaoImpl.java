package es.capgemini.pfs.antecedenteinterno.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.antecedenteinterno.dao.AntecedenteInternoDao;
import es.capgemini.pfs.antecedenteinterno.model.AntecedenteInterno;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 */
@Repository("AntecedenteInternoDao")
public class AntecedenteInternoDaoImpl extends AbstractEntityDao<AntecedenteInterno, Long> implements AntecedenteInternoDao {

}
