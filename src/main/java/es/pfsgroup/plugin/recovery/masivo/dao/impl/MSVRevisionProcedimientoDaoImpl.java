package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.api.RevisionProcedimientoCoreDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVRevisionProcedimiento;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVRevisionProcedimientoDao;

@Repository("MSVRevisionProcedimientoDao")
public class MSVRevisionProcedimientoDaoImpl implements
		MSVRevisionProcedimientoDao {

	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public boolean saveRevision(RevisionProcedimientoCoreDto rp,
			Long procMasivoId) {

		MSVRevisionProcedimiento rev = new MSVRevisionProcedimiento();
		Procedimiento prc = new Procedimiento();
		if (rp.getIdActuacion() != null && rp.getIdTipoProcedimiento() != null && rp.getIdTarea() != null && rp.getInstrucciones() != null && rp.getIdAsunto() != null
				&& rp.getIdProcedimiento() != null) {
			rev.setTacId(rp.getIdActuacion());
			rev.setTpoId(rp.getIdTipoProcedimiento());
			rev.setTarId(rp.getIdTarea());
			rev.setInstrucciones(rp.getInstrucciones());
			rev.setAsuId(rp.getIdAsunto());
			rev.setProcMasivoId(procMasivoId);

			prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", rp.getIdProcedimiento()));
			
			rev.setProcedimiento(prc);

			// Primero guardamos el registro en la tabla revisiones
			genericDao.save(MSVRevisionProcedimiento.class, rev);


		}
		return false;
	}

}
