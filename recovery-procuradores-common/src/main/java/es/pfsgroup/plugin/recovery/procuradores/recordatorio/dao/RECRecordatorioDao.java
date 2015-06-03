package es.pfsgroup.plugin.recovery.procuradores.recordatorio.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.dto.RECRecordatorioDto;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.model.RECRecordatorio;


public interface RECRecordatorioDao  extends AbstractDao<RECRecordatorio, Long>{

	public Page getListaRecordatorios(RECRecordatorioDto dto);
	
	public Page getListaTareasRecordatorios(RECRecordatorioDto dto);
	
	public RECRecordatorio getRecRecordatorio(Long idRecordatorio);
	
	public Long getCountListadoRecordatorios(Long idUsuario);
	
	public Long getCountListadoTareasRecordatorios(Long idUsuario);
	
	public RECRecordatorio getRecordatorioByTarea(Long idTarea);
}
