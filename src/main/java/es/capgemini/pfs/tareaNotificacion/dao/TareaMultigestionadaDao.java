package es.capgemini.pfs.tareaNotificacion.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;

public interface TareaMultigestionadaDao extends AbstractDao<EXTTareaNotificacion, Long>{

	Page buscarTareasPendienteMultigestor(DtoBuscarTareaNotificacion dto);

}
