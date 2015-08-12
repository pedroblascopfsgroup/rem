package es.pfsgroup.recovery.integration.jdbc.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.integration.jdbc.model.MensajeIntegracion;

@Repository
public interface ColaDeMensajeriaDao extends AbstractDao<MensajeIntegracion, Long> {

	List<MensajeIntegracion> getPendientes(String direccion, int maxValues);
	boolean tieneAlgunError(String direccion, String guid);
	
}
