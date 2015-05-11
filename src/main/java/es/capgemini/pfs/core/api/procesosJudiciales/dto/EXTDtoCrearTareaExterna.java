package es.capgemini.pfs.core.api.procesosJudiciales.dto;

import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;

public interface EXTDtoCrearTareaExterna {

	String getCodigoSubtipoTarea();
	Long getPlazo();
	String getDescripcion();
	Long getIdProcedimiento();
	Long getIdTareaProcedimiento();
    Long getTokenIdBpm();
    TipoCalculo getTipoCalculo();
}
