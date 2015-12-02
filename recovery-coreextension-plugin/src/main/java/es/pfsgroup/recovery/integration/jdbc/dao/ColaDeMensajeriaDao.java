package es.pfsgroup.recovery.integration.jdbc.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.integration.jdbc.model.MensajeIntegracion;

public interface ColaDeMensajeriaDao extends AbstractDao<MensajeIntegracion, Long> {

	List<MensajeIntegracion> getPendientes(String cola, int maxValues);
	boolean tieneAlgunError(String cola, String guid);
	
}
