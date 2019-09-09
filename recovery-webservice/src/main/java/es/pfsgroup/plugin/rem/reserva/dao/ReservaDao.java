package es.pfsgroup.plugin.rem.reserva.dao;


import java.util.Date;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Reserva;


public interface ReservaDao extends AbstractDao<Reserva, Long>{
	

	public Long getNextNumReservaRem();

	public Date getFechaFirmaReservaByIdExpediente(Long idExpediente);

}
