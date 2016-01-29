package es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.ReglasVigenciaPolitica;
import es.pfsgroup.plugin.recovery.itinerarios.reglasVigenciaPolitica.dao.model.ITIReglasVigenciaPolitica;

public interface ITIReglasVigenciaPoliticaDao extends AbstractDao<ITIReglasVigenciaPolitica, Long> {

	public List<ReglasVigenciaPolitica> findByEstado(List<Estado> estadosItinerario) ;

	public ITIReglasVigenciaPolitica getReglasConsensoEstado(Long id);

	public ITIReglasVigenciaPolitica getReglasExclusionEstado(Long id);

	public ITIReglasVigenciaPolitica createNewReglaVigenciaPolitica();
	
	

}
