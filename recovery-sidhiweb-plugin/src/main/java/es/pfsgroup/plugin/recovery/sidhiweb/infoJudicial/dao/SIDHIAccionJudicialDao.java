package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIAccionJudicialDto;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIAccionJudicial;

public interface SIDHIAccionJudicialDao extends AbstractDao<SIDHIAccionJudicial, Long>{


	Page findAccionesByIdAsunto(SIDHIDtoBuscarAcciones dto);

	Page findAccionesByIdExpediente(SIDHIDtoBuscarAcciones dto);
	
	List<SIDHIAccionJudicial> getAccionJudicial( SIDHIAccionJudicialDto dto );
	
	void updateAccionJudicial( SIDHIAccionJudicial accionJudicial );

}
