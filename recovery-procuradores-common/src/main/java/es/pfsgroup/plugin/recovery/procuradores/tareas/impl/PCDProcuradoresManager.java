package es.pfsgroup.plugin.recovery.procuradores.tareas.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.EXTAbstractTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.coreextension.utils.EXTModelClassFactory;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi;
import es.pfsgroup.plugin.recovery.procuradores.tareas.api.PCDProcuradoresApi;
import es.pfsgroup.plugin.recovery.procuradores.tareas.dao.PCDProcuradoresDao;
import es.pfsgroup.plugin.recovery.procuradores.tareas.dto.PCDProcuradoresDto;
import es.pfsgroup.recovery.api.UsuarioApi;
import es.pfsgroup.recovery.ext.api.tareas.EXTTareasApi;
import es.pfsgroup.recovery.ext.factory.dao.dto.DtoResultadoBusquedaTareasBuzones;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.VTARBusquedaOptimizadaTareasDao;
import es.pfsgroup.recovery.ext.impl.optimizacionBuzones.dao.impl.ResultadoBusquedaTareasBuzonesDto;


@Component
public class PCDProcuradoresManager extends EXTAbstractTareaNotificacionManager  implements PCDProcuradoresApi {

	@Autowired
	private PCDProcuradoresDao pcdprocuradoresDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private ConfiguracionDespachoExternoApi configuracionDespachoExternoApi;
	
    @Autowired
    private EXTModelClassFactory modelClassFactory;
    

	@Override
	@BusinessOperation(PCD_COUNT_LISTADO_TAREAS_PENDIENTES)
	public Long getCountListadoTareasPendientes(Long idUsuario) {
		return pcdprocuradoresDao.getCountListadoTareasPendientesValidar(idUsuario);
	}
	
	@Override
	@BusinessOperation(PCD_GET_LISTADO_TAREAS_PENDIENTES)
	public Page getListadoTareasPendientesValidar(PCDProcuradoresDto dto){
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		dto.setUsuarioLogado(usuarioLogado);
		Long idCategorizacion = configuracionDespachoExternoApi.activoCategorizacion();
		dto.setIdCategorizacion(idCategorizacion);
		Page p = pcdprocuradoresDao.getListadoTareasPendientesValidar(dto);
		return p;
	}
	
	@Override
	@BusinessOperation(PCD_GET_LISTADO_TAREAS_PENDIENTES_PAUSADAS)
	public Page getListadoTareasPendientesValidarPausadas(PCDProcuradoresDto dto){
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		dto.setUsuarioLogado(usuarioLogado);
		Long idCategorizacion = configuracionDespachoExternoApi.activoCategorizacion();
		dto.setIdCategorizacion(idCategorizacion);
		Page p = pcdprocuradoresDao.getListadoTareasPendientesValidarPausadas(dto);
		return p;
	}
	
	@Override
	@BusinessOperation(PCD_BUSCAR_TAREAS_PENDIENTES)
	@Transactional
	public Page buscarTareasPendientesDelegator(DtoBuscarTareaNotificacion dto,  String comboEstado, Long comboCtgResol) {
		//return proxyFactory.proxy(EXTTareasApi.class).buscarTareasPendientesDelegator(dto);
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		dto.setUsuarioLogado(usuarioLogado);
		dto.setPerfiles(usuarioLogado.getPerfiles());
		dto.setZonas(usuarioLogado.getZonas());
		Long idCategorizacion = configuracionDespachoExternoApi.activoCategorizacion();
		final Class<? extends DtoResultadoBusquedaTareasBuzones> modelClass = modelClassFactory.getModelFor(EXTTareasApi.EXT_BUSCAR_TAREAS_PENDIENTES_CARTERIZACION,DtoResultadoBusquedaTareasBuzones.class);
		try {
			pcdprocuradoresDao.buscarTareasPendientes(dto, comboEstado, comboCtgResol, idCategorizacion , usuarioLogado, modelClass);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return pcdprocuradoresDao.buscarTareasPendientes(dto, comboEstado, comboCtgResol, idCategorizacion , usuarioLogado, modelClass);

	}

	@Override
	public String managerName() {
		return "tareaNotificacionManager";
	}

}