package es.pfsgroup.plugin.gestorDocumental.model;

import java.util.HashMap;

public class GestorDocumentalConstants {

	public static final String CODIGO_TIPO_EXPEDIENTE_REO = "AI";
	public static final String CODIGO_TIPO_EXPEDIENTE_ACTIVOS_FINANCIEROS = "AF";
	public static final String CODIGO_TIPO_EXPEDIENTE_ENTIDADES = "EN";
	public static final String CODIGO_TIPO_EXPEDIENTE_GARANTIAS = "GA";
	public static final String CODIGO_TIPO_EXPEDIENTE_HAYA_CORPORATIVO = "HA";
	public static final String CODIGO_TIPO_EXPEDIENTE_OPERACIONES = "OP";
	public static final String CODIGO_TIPO_EXPEDIENTE_PROPUESTAS = "PR";
	
	public static final String CODIGO_CLASE_EXPEDIENTE_PROYECTO = "01";
	public static final String CODIGO_CLASE_EXPEDIENTE_PROMOCION = "02";
	public static final String CODIGO_CLASE_EXPEDIENTE_ACTIVO = "03";
	
	public static final String TIPO_CONSULTA_RELACION_EXPEDIENTE = "Tipo Expediente";
	public static final String TIPO_CONSULTA_RELACION_GLOBAL = "Global";
	
	public static final String ERROR_NO_EXISTE_CONTENEDOR = "No se puede almacenar este TIPO de archivo. Contacte con su administrador - [ERROR: No existe contenedor adecuado].";
	public static final String ERROR_NO_EXISTE_MAPEO_TIPO_ARCHIVO = "TIPO de archivo incorrecto para ser almacenado. Contacte con su administrador - [ERROR: No existe mapeo para este tipo de archivo].";
	
	public static final String[] generalDocumento = {"Número Registro:", "Fecha Documento:", "Fecha Baja Lógica:", "Fecha Caducidad:", "Fecha Expurgo:", "Proceso Carga:", "LOPD:", "Serie Documental:", "TDN1:", "TDN2:"};
	public static final String[] generalDocumentoModif = {"Número Registro:", "Fecha Baja Lógica:", "Fecha Caducidad:", "Fecha Expurgo:", "Proceso Carga:", "LOPD:", "Serie Documental:", "TDN1:", "TDN2:"};
	public static final String[] archivoFisico = {"Proveedor Custodia:", "Referencia Custodia:", "Contenedor:", "Lote:", "Posición:", "Documento Original:"};
	public static final String[] propuestaMetadatos = {"ID:", "ID Externo:", "ID Sistema Origen:", "Estado del Expediente:", "IBAN:", "Entidad:", "Oficina:", "DC:", "Cuenta:", "Avalista:", "Acreditado:", "Cliente:"};
	
	public final static HashMap<String, String> tipoExpedientePorCodigo;

    static
    {
    	tipoExpedientePorCodigo = new HashMap<String, String>();
    	tipoExpedientePorCodigo.put(CODIGO_TIPO_EXPEDIENTE_REO, CODIGO_TIPO_EXPEDIENTE_REO);
    	tipoExpedientePorCodigo.put(CODIGO_TIPO_EXPEDIENTE_ACTIVOS_FINANCIEROS, CODIGO_TIPO_EXPEDIENTE_ACTIVOS_FINANCIEROS);
    	tipoExpedientePorCodigo.put(CODIGO_TIPO_EXPEDIENTE_ENTIDADES, CODIGO_TIPO_EXPEDIENTE_ENTIDADES);
    	tipoExpedientePorCodigo.put(CODIGO_TIPO_EXPEDIENTE_GARANTIAS, CODIGO_TIPO_EXPEDIENTE_GARANTIAS);
    	tipoExpedientePorCodigo.put(CODIGO_TIPO_EXPEDIENTE_HAYA_CORPORATIVO, CODIGO_TIPO_EXPEDIENTE_HAYA_CORPORATIVO);
    	tipoExpedientePorCodigo.put(CODIGO_TIPO_EXPEDIENTE_OPERACIONES, CODIGO_TIPO_EXPEDIENTE_OPERACIONES);
    	tipoExpedientePorCodigo.put(CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, CODIGO_TIPO_EXPEDIENTE_PROPUESTAS);
    }   
    
	public final static HashMap<String, String> claseExpedientePorCodigo;

    static
    {
    	claseExpedientePorCodigo = new HashMap<String, String>();
    	claseExpedientePorCodigo.put(CODIGO_CLASE_EXPEDIENTE_PROYECTO, CODIGO_CLASE_EXPEDIENTE_PROYECTO);
    	claseExpedientePorCodigo.put(CODIGO_CLASE_EXPEDIENTE_PROMOCION, CODIGO_CLASE_EXPEDIENTE_PROMOCION);
    	claseExpedientePorCodigo.put(CODIGO_CLASE_EXPEDIENTE_ACTIVO, CODIGO_CLASE_EXPEDIENTE_ACTIVO);
    }   
			
}