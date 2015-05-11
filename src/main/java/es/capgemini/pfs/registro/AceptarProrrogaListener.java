package es.capgemini.pfs.registro;

import es.capgemini.pfs.generico.GenericListener;

public interface AceptarProrrogaListener extends GenericListener{
	
	public static final String CLAVE_ID_TAREA_NOTIFICACION = "tarId";
	public static final String CLAVE_FECHA_VENCIMIENTO_ORIGINAL = "tarFecVencOld";
	public static final String CLAVE_FECHA_VENCIMIENTO_PROPUESTA = "tarFecVencNew";
	public static final String CLAVE_PRORROGA_ASOCIADA = "idProrroga";
	public static final String CLAVE_MOTIVO = "motivo";
	public static final String CLAVE_DETALLE = "detalle";

}
