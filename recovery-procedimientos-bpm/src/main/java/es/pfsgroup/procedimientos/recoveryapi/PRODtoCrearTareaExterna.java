package es.pfsgroup.procedimientos.recoveryapi;

public interface PRODtoCrearTareaExterna {
	String getCodigoSubtipoTarea();
	Long getPlazo();
	String getDescripcion();
	Long getIdProcedimiento();
	Long getIdTareaProcedimiento();
    Long getTokenIdBpm();

}
