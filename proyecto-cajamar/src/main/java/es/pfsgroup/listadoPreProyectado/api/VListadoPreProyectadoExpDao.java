package es.pfsgroup.listadoPreProyectado.api;

import java.util.List;

import es.pfsgroup.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoExp;

public interface VListadoPreProyectadoExpDao {

	List<VListadoPreProyectadoExp> getListadoPreProyectadoExp(ListadoPreProyectadoDTO dto);

	Integer getListadoPreProyectadoExpCount(ListadoPreProyectadoDTO dto);
}