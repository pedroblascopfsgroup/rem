package es.pfsgroup.plugin.recovery.masivo.dao;

import es.pfsgroup.plugin.recovery.coreextension.api.RevisionProcedimientoCoreDto;

public interface MSVRevisionProcedimientoDao {

	boolean saveRevision(RevisionProcedimientoCoreDto rp, Long procMasivoId);
	
}
