package es.pfsgroup.plugin.rem.activo.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.rem.model.*;

public interface TareaValoresDao extends AbstractDao<TareaExternaValor, Long>{
	String getValorCampoTarea(String codTarea, Long numExpediente, String nombreCampo);
}
