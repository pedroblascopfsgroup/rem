package es.pfsgroup.plugin.recovery.itinerarios.ddAmbitoExpediente.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.pfsgroup.plugin.recovery.itinerarios.ddAmbitoExpediente.dao.ITIDDAmbitoExpedienteDao;

@Repository("ITIDDAmbitoExpedienteDao")
public class ITIDDAmbitoExpedienteDaoImpl extends AbstractEntityDao<DDAmbitoExpediente, Long> implements ITIDDAmbitoExpedienteDao {

}
