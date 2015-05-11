package es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.dto.INSDtoBusquedaInstrucciones;
import es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.model.INSInstruccionesTareasExterna;

public interface INSInstruccionesTareasExternaDao extends AbstractDao<INSInstruccionesTareasExterna	, Long>{

	Page findInstruciones(INSDtoBusquedaInstrucciones dto);

}
