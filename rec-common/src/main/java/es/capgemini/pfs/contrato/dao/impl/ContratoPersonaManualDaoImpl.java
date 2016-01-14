package es.capgemini.pfs.contrato.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.dao.ContratoPersonaManualDao;
import es.capgemini.pfs.contrato.model.ContratoPersonaManual;
import es.capgemini.pfs.dao.AbstractEntityDao;


@Repository("ContratoPersonaManualDao")
public class ContratoPersonaManualDaoImpl extends AbstractEntityDao<ContratoPersonaManual, Long>implements ContratoPersonaManualDao{


}
