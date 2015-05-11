package es.capgemini.pfs.registro;

import java.util.Date;

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
