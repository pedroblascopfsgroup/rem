
package es.pfsgroup.plugin.gestorDocumental.model;

import java.util.HashMap;

public class GestorDocumentalConstants {

	public enum Contenedor {
		Activo,
		ExpedienteComercial,
		Gasto
	}

	public static final String CODIGO_TIPO_EXPEDIENTE_REO = "AI";
	public static final String CODIGO_TIPO_EXPEDIENTE_ACTIVOS_FINANCIEROS = "AF";
	public static final String CODIGO_TIPO_EXPEDIENTE_ENTIDADES = "EN";
	public static final String CODIGO_TIPO_PROVEEDORES = "EN";
	public static final String CODIGO_TIPO_EXPEDIENTE_GARANTIAS = "GA";
	public static final String CODIGO_TIPO_EXPEDIENTE_HAYA_CORPORATIVO = "HA";
	public static final String CODIGO_TIPO_EXPEDIENTE_OPERACIONES = "OP";
	public static final String CODIGO_TIPO_EXPEDIENTE_PROPUESTAS = "PR";
	public static final String CODIGO_TIPO_JUNTA = "OP";
	public static final String CODIGO_TIPO_PLUSVALIAS = "OP";
	
	public static final String CODIGO_CLASE_EXPEDIENTE_PROYECTO = "01";
	public static final String CODIGO_CLASE_EXPEDIENTE_PROMOCION = "02";
	public static final String CODIGO_CLASE_PROVEEDORES = "02";
	public static final String CODIGO_CLASE_EXPEDIENTE_ACTIVO = "03";
	public static final String CODIGO_CLASE_GASTO = "07";
	public static final String CODIGO_CLASE_PROMOCIONES = "09";
	public static final String CODIGO_CLASE_PROYECTO = "09";
	public static final String CODIGO_CLASE_AGRUPACIONES = "08";
	public static final String CODIGO_CLASE_OP = "12";
	public static final String CODIGO_CLASE_ACTUACION_TECNICA = "13";
	public static final String CODIGO_CLASE_TRABAJO = "13";

	public static final String CODIGO_CLASE_TRIBUTOS = "32";
	public static final String CODIGO_CLASE_JUNTA = "33";
	public static final String CODIGO_CLASE_PLUSVALIAS = "34";
	
	public static final String TIPO_CONSULTA_RELACION_EXPEDIENTE = "Tipo Expediente";
	public static final String TIPO_CONSULTA_RELACION_GLOBAL = "Global";
	public static final String OPERACION = "\"Operación\":";
	public static final String AGRUPACION_REO = "\"Reo\":";
	public static final String AGRUPACION_PROMOCION = "\"Promoción\":";
	public static final String ENTIDAD = "\"Entidad\":";
	public static final String GASTOS = "\"Gastos\":";
	
	public static final String[] generalDocumento = {"Número Registro:", "Fecha Documento:", "Fecha Baja Lógica:", "Fecha Caducidad:", "Fecha Expurgo:", "Proceso Carga:", "LOPD:", "Serie Documental:", "TDN1:", "TDN2:"};
	public static final String[] generalDocumentoModif = {"Número Registro:", "Fecha Baja Lógica:", "Fecha Caducidad:", "Fecha Expurgo:", "Proceso Carga:", "LOPD:", "Serie Documental:", "TDN1:", "TDN2:"};
	public static final String[] archivoFisico = {"Proveedor Custodia:", "Referencia Custodia:", "Contenedor:", "Lote:", "Posición:", "Documento Original:"};
	public static final String[] modificarMetadatos = {"\"General documento\":","\"LOPD\":", "\"Serie Documental\":", "\"TDN1\":","\"TDN2\":", "\"Proceso Carga\":","\"Archivo físico\":","\"Contenedor\":"};
	public static final String[] metadataComunicaciones = {"\"General documento\":","\"Fecha documento\":", "\"Serie Documental\":", "\"TDN1\":", "\"TDN2\":", "\"Proceso Carga\":","\"Archivo físico\":","\"Contenedor\":"};
	
	public static final String[] gastoMetadatos = {"'ID':", "'ID Gasto':", "'ID Reo':", "'Fecha gasto':", "'Cliente':"};
	public static final String[] metadataCrearContenedor = {"\"ID\":", "\"ID Externo\":", "\"ID Sistema Origen\":", "\"Cliente\":"};

	public static final String[] metadataEspecifica = {"\"Aplica\":","\"Fecha emision\":", "\"Fecha caducidad\":", "\"Fecha obtencion\":", "\"Fecha etiqueta\":", "\"Registro\":"};

	
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