package es.pfsgroup.plugin.recovery.procuradores.recordatorio.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.dao.RECRecordatorioDao;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.dto.RECRecordatorioDto;
import es.pfsgroup.plugin.recovery.procuradores.recordatorio.model.RECRecordatorio;

@Repository("RECRecordatorioDao")
public class RECRecordatorioDaoImpl extends AbstractEntityDao<RECRecordatorio, Long> implements RECRecordatorioDao{


	@Override
	public Page getListaRecordatorios(RECRecordatorioDto dto) {
		
		HQLBuilder hb = new HQLBuilder(" from RECRecordatorio rec ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rec.titulo", dto.getTitulo(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "rec.open", dto.getOpen());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rec.usuario.id", dto.getUsuario().getId(), true);
		
		if (!Checks.esNulo(dto.getSort()) && !Checks.esNulo(dto.getDir())){
			hb.orderBy(dto.getSort(), dto.getDir().toLowerCase() );
		}else{
			hb.orderBy("rec.fecha", HQLBuilder.ORDER_DESC );
		}
		

		return HibernateQueryUtils.page(this, hb, dto);
		
	}
	
	@Override
	public Page getListaTareasRecordatorios(RECRecordatorioDto dto) {
		
		HQLBuilder hb = new HQLBuilder(" from EXTTareaNotificacion tar ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "tar.descripcionTarea", dto.getTitulo(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.subtipoTarea.codigoSubtarea", "TAREA_RECORDATORIO");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.destinatarioTarea.id", dto.getUsuario().getId());
		hb.appendWhere("tar.tareaFinalizada is null OR tar.tareaFinalizada = 0");
		
		if (!Checks.esNulo(dto.getSort()) && !Checks.esNulo(dto.getDir())){
			hb.orderBy(dto.getSort(), dto.getDir().toLowerCase() );
		}else{
			hb.orderBy("tar.fechaVenc", HQLBuilder.ORDER_ASC );	
		}
		

		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public RECRecordatorio getRecRecordatorio(Long idRecordatorio) {
		
		HQLBuilder hb = new HQLBuilder(" from RECRecordatorio rec ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rec.id", idRecordatorio, true);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	@Override
	public Long getCountListadoRecordatorios(Long idUsuario) {
		
		HQLBuilder hb = new HQLBuilder(" from RECRecordatorio rec ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "rec.usuario", idUsuario, true);
		HQLBuilder.addFiltroIgualQue(hb, "rec.open", true);

		return (long) HibernateQueryUtils.list(this, hb).size();
	}
	
	@Override
	public Long getCountListadoTareasRecordatorios(Long idUsuario) {
		
		HQLBuilder hb = new HQLBuilder(" from EXTTareaNotificacion tar ");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.subtipoTarea.codigoSubtarea", "TAREA_RECORDATORIO");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tar.destinatarioTarea.id", idUsuario);
		hb.appendWhere("tar.tareaFinalizada is null OR tar.tareaFinalizada = 0");
		
		return (long) HibernateQueryUtils.list(this, hb).size();
	}

	@Override
	public RECRecordatorio getRecordatorioByTarea(Long idTarea) {
		
		HQLBuilder hb = new HQLBuilder(" from RECRecordatorio rec ");
		hb.appendWhere(" rec.tareaUno.id = "+idTarea+" OR rec.tareaDos.id = "+idTarea+" OR rec.tareaTres.id = "+idTarea);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
		
	}



	
}
