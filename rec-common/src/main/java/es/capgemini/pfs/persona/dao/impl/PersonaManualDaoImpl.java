package es.capgemini.pfs.persona.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.dao.PersonaManualDao;
import es.capgemini.pfs.persona.model.PersonaManual;

/**
 * dao de personas manuales.
 * @author carlos gil gimeno
 *
 */
@Repository("PersonaManualDao")
public class PersonaManualDaoImpl extends AbstractEntityDao<PersonaManual, Long> implements PersonaManualDao {



}
