package es.pfsgroup.plugin.rem.observacionesExpediente.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ObservacionesExpedienteComercial;

public interface ObservacionExpedienteDao extends AbstractDao<ObservacionesExpedienteComercial, Long> {
	
	List<ObservacionesExpedienteComercial> getObservacionesByIdExpediente(Long idExpediente);

}
