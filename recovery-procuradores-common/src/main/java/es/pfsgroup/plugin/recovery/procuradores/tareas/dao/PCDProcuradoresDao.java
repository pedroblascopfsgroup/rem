package es.pfsgroup.plugin.recovery.procuradores.tareas.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.procuradores.tareas.dto.PCDProcuradoresDto;
import es.pfsgroup.plugin.recovery.procuradores.tareas.model.PCDProcuradores; 
import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;

public interface PCDProcuradoresDao  extends AbstractDao<PCDProcuradores, Long>{

	public Page getListadoTareasPendientesValidar(PCDProcuradoresDto dto);

	public Long getCountListadoTareasPendientesValidar(List<Long> listaUsuariosGrupo);
	
//	public Page buscarTareasPendientes(DtoBuscarTareaNotificacion dto, String comboEstado, Long comboCtgResol, Long idCategorizacion);
	public Page buscarTareasPendientes(DtoBuscarTareaNotificacion dto, String comboEstado, Long comboCtgResol, Long idCategorizacion, Usuario usuarioLogado, Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass);
	
	public Page getListadoTareasPendientesValidarPausadas(PCDProcuradoresDto dto);

}