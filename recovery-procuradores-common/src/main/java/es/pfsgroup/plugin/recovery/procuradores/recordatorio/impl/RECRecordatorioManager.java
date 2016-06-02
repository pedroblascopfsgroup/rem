package es.pfsgroup.plugin.recovery.procuradores.recordatorio.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.api.RECRecordatorioApi;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.dao.RECRecordatorioDao;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.dto.RECRecordatorioDto;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.model.RECRecordatorio;
import es.pfsgroup.recovery.api.UsuarioApi;

/**
 * Implementación de la api de {@link RECRecordatorio}
 * @author carlos gil
 *
 */
@Service("RECRecordatorio")
@Transactional(readOnly = false)
public class RECRecordatorioManager  implements RECRecordatorioApi {

	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private RECRecordatorioDao recRecordatorioDao;

	@Autowired
	private TareaNotificacionDao tareaNotificacionDao;

	
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_GET_LISTA_RECORDATORIOS)
	public Page getListaRecordatorios(RECRecordatorioDto dto) {
		dto.setUsuario(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado());
		dto.setOpen(true);
		return recRecordatorioDao.getListaRecordatorios(dto);
	}

	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_GET_RECORDATORIO)
	public RECRecordatorio getRecRecordatorio(Long idRecordatorio) {
		return recRecordatorioDao.getRecRecordatorio(idRecordatorio);
	}

	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_SAVE_RECORDATORIO)
	public Long saveRecRecordatorio(RECRecordatorioDto dto) {	
		
		RECRecordatorio recRecordatorio = new RECRecordatorio();
		recRecordatorio.setDescripcion(dto.getDescripcion());
		recRecordatorio.setTitulo(dto.getTitulo());
		recRecordatorio.setOpen(true);
		recRecordatorio.setFecha(dto.getFecha());
		
		Usuario user = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		recRecordatorio.setUsuario(user);
		
		if(!Checks.esNulo(dto.getCategoria())){
			recRecordatorio.setCategoria(proxyFactory.proxy(CategoriaApi.class).getCategoria(dto.getCategoria().getId()));
		}
		
		recRecordatorioDao.save(recRecordatorio);
		
		return recRecordatorio.getId();		
		
	}
	
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_GET_LISTA_TAREAS_RECORDATORIOS)
	public Page getListaTareasRecordatorios(RECRecordatorioDto dto) {
		dto.setUsuario(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado());
		dto.setOpen(true);
		return recRecordatorioDao.getListaTareasRecordatorios(dto);
	}

	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_COUNT_LISTA_RECORDATORIOS)
	public Long getCountListadoRecordatorios() {
		return recRecordatorioDao.getCountListadoRecordatorios(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getId());
	}
	
	
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_COUNT_LISTA_TAREAS_RECORDATORIOS)
	public Long getCountListadoTareasRecordatorios() {
		return recRecordatorioDao.getCountListadoTareasRecordatorios(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getId());
	}

	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_RESULEVE_RECORDATORIO)
	public void resolverRecordatorio(long idRecordatorio) {

		RECRecordatorio recordatorio = recRecordatorioDao.getRecRecordatorio(idRecordatorio);
		recordatorio.setOpen(false);
		recRecordatorioDao.update(recordatorio);
		
		if(!Checks.esNulo(recordatorio.getTareaUno())){
			TareaNotificacion tn = recordatorio.getTareaUno();
			tn.setTareaFinalizada(true);
			tareaNotificacionDao.update(tn);
		}
		
		if(!Checks.esNulo(recordatorio.getTareaDos())){
			TareaNotificacion tn = recordatorio.getTareaDos();
			tn.setTareaFinalizada(true);
			tareaNotificacionDao.update(tn);
		}
		
		if(!Checks.esNulo(recordatorio.getTareaTres())){
			TareaNotificacion tn = recordatorio.getTareaTres();
			tn.setTareaFinalizada(true);
			tareaNotificacionDao.update(tn);
		}
		
	}
	
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_RESULEVE_TAREA_RECORDATORIO)
	public void resolverTareaRecRecordatorio(long idTarea) {
		TareaNotificacion tarea = proxyFactory.proxy(TareaNotificacionApi.class).get(idTarea);
		tarea.setTareaFinalizada(true);
		tareaNotificacionDao.update(tarea);
	}


}
