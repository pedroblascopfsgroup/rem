package es.pfsgroup.plugin.rem.concurrencia.dao;


import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Concurrencia;


public interface ConcurrenciaDao extends AbstractDao<Concurrencia, Long>{

	boolean isAgrupacionEnConcurrencia(Long agrId);

	boolean isAgrupacionConOfertasDeConcurrencia(Long agrId);
	

}
