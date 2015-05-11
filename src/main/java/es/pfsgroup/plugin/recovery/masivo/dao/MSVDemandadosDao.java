package es.pfsgroup.plugin.recovery.masivo.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.plugin.recovery.masivo.model.notificacion.MSVInfoDemandado;

public interface MSVDemandadosDao {
	
	List<MSVInfoDemandado> getDemandadosYDomicilios(Long idProcedimiento);
	
	List<MSVInfoDemandado> getDemandadosYDomicilios(Procedimiento procedimiento);

}
