package es.pfsgroup.plugin.rem.concurrencia.dao;


import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosConcurrencia;


public interface ConcurrenciaDao extends AbstractDao<Concurrencia, Long>{

	boolean isAgrupacionEnConcurrencia(Long agrId);

	boolean isAgrupacionConOfertasDeConcurrencia(Long agrId);

	List<VGridOfertasActivosConcurrencia> getListOfertasVivasConcurrentes(Long idActivo, Long idConcurrencia);
	
	boolean isActivoEnConcurrencia(Long idActivo);

	boolean isOfertaEnPlazoEntrega(Long idOferta);

	String getPeriodoConcurrencia(Long idConcurrencia);
	

}
