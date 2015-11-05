package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoExp;

public interface VListadoPreProyectadoExpDao {

	Page getListadoPreProyectadoExp(ListadoPreProyectadoDTO dto);
}