package es.pfsgroup.plugin.recovery.mejoras.api.revisionProcedimientos;

import java.util.List;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.coreextension.api.RevisionProcedimientoCoreApi;
import es.pfsgroup.plugin.recovery.coreextension.api.RevisionProcedimientoCoreDto;
import es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.dto.RevisionProcedimientoDto;

public interface RevisionProcedimientoApi extends RevisionProcedimientoCoreApi{

	String REVISION_PROCEDIMIENTO_GET_LIST_TIPO_ACTUACION = "plugin.mejoras.revisionProcedimiento.getListTipoActuacion";
	String REVISION_PROCEDIMIENTO_GET_LIST_TIPO_PROCEDIMIENTO = "plugin.mejoras.revisionProcedimiento.getListTipoProcedimiento";
	String REVISION_PROCEDIMIENTO_GET_LIST_TIPO_TAREA = "plugin.mejoras.revisionProcedimiento.getListTipoTarea";
	String REVISION_PROCEDIMIENTO_GET_INSTRUCCIONES = "plugin.mejoras.revisionProcedimiento.getInstrucciones";
	String REVISION_PROCEDIMIENTO_SAVE_REVISION = "plugin.mejoras.revisionProcedimiento.saveRevision";
	String REVISION_PROCEDIMIENTO_GET_LIST_PROCEDIMIENTOS = "plugin.mejoras.revisionProcedimiento.getListProcedimientosData";

	@BusinessOperationDefinition(REVISION_PROCEDIMIENTO_GET_LIST_TIPO_ACTUACION)
	List<DDTipoActuacion> getListTipoActuacion();

	@BusinessOperationDefinition(REVISION_PROCEDIMIENTO_GET_LIST_TIPO_PROCEDIMIENTO)
	List<TipoProcedimiento> getListTipoProcedimiento(Long idTipoAct);
	
	@BusinessOperationDefinition(REVISION_PROCEDIMIENTO_GET_LIST_TIPO_TAREA)
	List<TareaProcedimiento> getListTipoTarea(Long idTipoPro);

	@BusinessOperationDefinition(REVISION_PROCEDIMIENTO_GET_INSTRUCCIONES)
	String getInstrucciones(Long idTipoTar);

	@BusinessOperationDefinition(REVISION_PROCEDIMIENTO_SAVE_REVISION)
	//boolean saveRevision(Long idActuacion, Long idTipoProcedimiento, Long idTarea, String instrucciones, Long idAsunto, Long idProcedimiento);
	boolean saveRevision(RevisionProcedimientoCoreDto rp);

	@BusinessOperationDefinition(REVISION_PROCEDIMIENTO_GET_LIST_PROCEDIMIENTOS)
	List<RevisionProcedimientoDto> getListProcedimientosData(Long idAsunto);

}
