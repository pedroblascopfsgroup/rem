package es.pfsgroup.plugin.rem.visita.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;

public interface VisitaDao extends AbstractDao<Visita, Long>{
	
	public Long getNextNumVisitaRem();
	
	public List<Visita> getListaVisitas(VisitaDto visitaDto);

}
