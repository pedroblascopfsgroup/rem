package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;

public interface ProcedimientoPCODao extends AbstractDao<ProcedimientoPCO, Long> {
	
	ProcedimientoPCO getProcedimientoPcoPorIdProcedimiento(Long idProcedimiento);
	
	List<ProcedimientoPCO> getProcedimientosPcoPorFiltro(FiltroBusquedaProcedimientoPcoDTO filtro);

}
