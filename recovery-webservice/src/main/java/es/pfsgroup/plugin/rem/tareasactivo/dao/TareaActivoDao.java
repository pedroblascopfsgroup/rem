package es.pfsgroup.plugin.rem.tareasactivo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.rem.model.TareaActivo;

public interface TareaActivoDao extends AbstractDao<TareaActivo, Long>{
	
	public List<TareaActivo> getTareasActivoTramiteHistorico(Long idTramite);

}
