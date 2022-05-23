package es.pfsgroup.plugin.rem.concurrencia.dao;


import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionConcurrencia;


public interface ConcurrenciaDao extends AbstractDao<Concurrencia, Long>{

	boolean isAgrupacionEnConcurrencia(Long agrId);

	boolean isAgrupacionConOfertasDeConcurrencia(Long agrId);

	List<VGridOfertasActivosAgrupacionConcurrencia> getListOfertasVivasConcurrentes(Long idActivo);
	
	boolean isActivoEnConcurrencia(Long idActivo);

	boolean isOfertaEnPlazoEntrega(Long idOferta);
	

}
