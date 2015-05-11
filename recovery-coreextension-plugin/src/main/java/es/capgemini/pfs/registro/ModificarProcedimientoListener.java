package es.capgemini.pfs.registro;

import es.capgemini.pfs.generico.GenericListener;

public interface ModificarProcedimientoListener extends GenericListener{
	
	public static final String ID_PROCEDIMIENTO = "idProcedimiento";
	public static final String CLAVE_TIPO_RECLAMACION_ANTERIOR = "treOld"; 
    public static final String CLAVE_TIPO_RECLAMACION_POSTERIOR = "treNew";
	public static final String CLAVE_JUZGADO_ANTERIOR = "juzOld";
	public static final String CLAVE_JUZGADO_POSTERIOR = "juzNew";
	public static final String CLAVE_PRINCIPAL_ANTERIOR = "pplOld";
	public static final String CLAVE_PRINCIPAL_POSTERIOR = "pplNew";
	public static final String CLAVE_PLAZO_ANTERIOR = "plaOld";
	public static final String CLAVE_PLAZO_POSTERIOR = "plaNew";
	public static final String CLAVE_ESTIMACION_ANTERIOR = "estOld";
	public static final String CLAVE_ESTIMACION_POSTERIOR = "estNew";
	public static final String CLAVE_NUMERO_AUTOS_ANTERIOR = "numAutosOld";
	public static final String CLAVE_NUMERO_AUTOS_POSTERIOR = "numAutosNew";

}
