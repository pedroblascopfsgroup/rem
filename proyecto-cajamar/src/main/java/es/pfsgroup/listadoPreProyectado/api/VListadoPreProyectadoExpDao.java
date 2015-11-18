package es.pfsgroup.listadoPreProyectado.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoExp;

public interface VListadoPreProyectadoExpDao {

	Page getListadoPreProyectadoExp(ListadoPreProyectadoDTO dto);
}