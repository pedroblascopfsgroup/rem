package es.pfsgroup.plugin.recovery.masivo.dao;

import es.pfsgroup.plugin.recovery.masivo.dto.MSVCarterizarAcreditadosDto;

public interface MSVCarterizacionAcreditadosDao {
	
	boolean insertarRegistroOPMCarterizacion(MSVCarterizarAcreditadosDto dto);

}
