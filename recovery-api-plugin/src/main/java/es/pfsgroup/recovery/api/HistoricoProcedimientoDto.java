package es.pfsgroup.recovery.api;

import java.util.Date;

/**
 * Datos del hist�rico de un procedimiento
 * @author bruno
 *
 */
public interface HistoricoProcedimientoDto {

	
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
}
