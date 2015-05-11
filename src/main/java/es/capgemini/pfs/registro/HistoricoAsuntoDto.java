package es.capgemini.pfs.registro;

import java.util.Date;

public interface HistoricoAsuntoDto {
	
	String getDescripcionTarea();
	
	String getSubtipoTarea();
	
	String getTipoRegistro();
	
	long getTipoEntidad();

	long getIdEntidad();

	boolean getRespuesta();

	long getIdProcedimiento();

	String getNombreTarea();

	Date getFechaRegistro();

	Date getFechaIni();

	Date getFechaVencimiento();

	Date getFechaFin();

	String getNombreUsuario();

	Long getIdTarea();

	Long getIdTraza();
	
	String getTipoTraza();
	
	String getGroup();
}
