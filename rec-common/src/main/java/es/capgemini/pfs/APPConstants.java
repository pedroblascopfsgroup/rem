package es.capgemini.pfs;

/**
 * Clase para constantes genericas referentes a la aplicacion.
 *
 * @author lgiavedo
 *
 */
public class APPConstants {

    protected APPConstants() {
        // Para que no moleste el checkstyle
    }

    public static final int TAREA_NOTIFICACION_MAX_DESCRIPCION = 3500;
    public static final long MILISEGUNDOS_DIA = 1000 * 60 * 60 * 24;
    public static final String ENTITY_SESSION_FACTORY = "entitySessionFactory";
    public static final String MASTER_SESSION_FACTORY = "masterSessionFactory";
    public static final String APP_PREFIX = "es.capgemini.pfs";
    public static final long SEIS_MESES = 1000L * 60L * 60L * 24L * 30L * 6L;

    //===Del coreextension==//
    public static final String CODIGO_TAREA_SOLICITUD_PRORROGA_TOMADECISION = "503";
	public static final String CODIGO_DESPACHO_CONFECCION_EXPEDIENTE = "3";

	public static final String CNT_IAC_TIPO_PROCEDIMIENTO = "TPR";
	public static final String CNT_IAC_CODIGO_PERSONA_TITULAR = "CPT";
	public static final String CNT_IAC_CODIGO_ENTIDAD_ORIGEN = "CODEXTRA1";
	public static final String CNT_IAC_CODIGO_OFICINA_ORIGEN = "CODEXTRA2";
	public static final String CNT_IAC_CODIGO_CONTRATO_ORIGEN = "CODEXTRA3";
	public static final String CNT_IAC_CODIGO_TIPO_PRODUCTO_ORIGEN = "INFEXTRA5";
	public static final String CNT_IAC_CCC_LITIGIOS = "char_extra2"; // 32
	public static final String CNT_IAC_CODIGO_LITIGIO = "char_extra4"; // 34
	public static final String CNT_IAC_CODIGO_PRINCIPAL = "char_extra1"; // 31
	public static final String CNT_IAC_FASE_RECUPERACION = "flag_extra1"; // 21
	public static final String CNT_IAC_ESTADO_LITIGIO = "flag_extra2"; // 22
	public static final String CNT_IAC_SITUACION_LITIGIO = "flag_extra5"; // 22
	public static final String CNT_IAC_GASTOS_LITIGIO = "num_extra6";
	public static final String CNT_IAC_PROVISION_PROCURADOR = "num_extra7";
	public static final String CNT_IAC_INTERESES_DEMORA = "num_extra8";
	public static final String CNT_IAC_MINUTA_LETRADO = "num_extra9";
	public static final String CNT_IAC_ENTREGAS_LITIGIO = "num_extra10";

	public static final String CNT_IAC_NUM_EXTRA2 = "num_extra2";
	
	public static final String COD_PROCEDIMIENTO_EXTRAJUDICIAL = "EXTRA";
	public static final String COD_PROCEDIMIENTO_CONFECCION_EXPEDIENTE = "CEXP";
	public static final String COD_PROCEDIMIENTO_CONTRATOS_BLOQUEADOS = "CB";

	public static final String ID_TIPO_PROCEDIMIENTO_BLOQUEADO = "P22";
	public static final String ID_TIPO_ACTUACION_BLOQUEADO = "04";
	public static final String ID_TIPO_RECLAMACION_BLOQUEADO = "01";

	public static final String MEJ_EXP_GET_CONTRATOS_PARA_CONCURSO = "plugin.mejoras.expediente.getContratosParaConcurso";
	public static final String MEJ_EXP_GET_CONTRATOS_PARA_NO_CONCURSO = "plugin.mejoras.expediente.getContratosParaNoConcurso";
	
	public static final String OPERADOR_MAYOR_IGUAL = ">=";
	public static final String OPERADOR_MENOR_IGUAL = "<=";
	public static final String OPERADOR_IGUAL = "=";
	
    public static final String ESTADO_PROCEDIMIENTO_REORGANIZADO = "9";

    //FIXME Mover esto al plugin de Lindorff
	public static final String CNT_IAC_CREDITOR = "char_extra3"; // 33
	
	public static final String CNT_IAC_COD_ENTIDAD_PROPIETARIA ="char_extra1";
	public static final String CNT_IAC_NUMERO_ESPEC = "NUMERO_ESPEC";
	
	public static final String CNT_BEAN_PROPERTIES = "appProperties";
	public static final String CNT_PROP_FORMATO_CONTRATO = "contrato.codigoFormato";
	public static final String CNT_IAC_NUMERO_CONTRATO = "NUMERO_CONTRATO";
	public static final String CNT_PROP_FORMAT_SUBST_INI = "contrato.codigo.subStringIni";
	public static final String CNT_PROP_FORMAT_SUBST_FIN = "contrato.codigo.subStringFin";

	public static final String CNT_PROP_CONTRATO_SIN_ENTIDAD = "contrato.codigoSinEntidad";
	
	public static final String CNT_IAC_ESTADO_CONTRATO_ENTIDAD = "DD_ECE_CODIGO";
	
	//BANKIA
	public static final String NUM_EXTRA1 = "num_extra1";
	public static final String NUM_EXTRA2 = "num_extra2";
	public static final String NUM_EXTRA3 = "num_extra3";
	public static final String NUM_EXTRA4 = "num_extra4";
	public static final String NUM_EXTRA5 = "num_extra5";
	public static final String DATE_EXTRA1 = "date_extra1";
	public static final String DATE_EXTRA2 = "date_extra2";
	public static final String DATE_EXTRA3 = "date_extra3";
	public static final String DATE_EXTRA4 = "date_extra4";
	public static final String DATE_EXTRA5 = "date_extra5";
	public static final String DATE_EXTRA6 = "date_extra6";
	public static final String FLAG_EXTR3 = "flag_extra3";
	public static final String FLAG_EXTRA2 = "flag_extra2";
	public static final String FLAG_EXTRA1 = "flag_extra1";
	public static final String FLAG_EXTRA4 = "flag_extra4";
	public static final String CHAR_EXTRA8 = "char_extra8";
	public static final String CHAR_EXTRA7 = "char_extra7";
	public static final String CHAR_EXTRA6 = "char_extra6";
	public static final String CHAR_EXTRA5 = "char_extra5";
	public static final String CHAR_EXTRA4 = "char_extra4";
	public static final String CHAR_EXTRA3 = "char_extra3";
	public static final String CHAR_EXTRA2 = "char_extra2";
	public static final String CHAR_EXTRA1 = "char_extra1";
	public static final String CHAR_EXTRA9 = "char_extra9";
	public static final String CHAR_EXTRA10 = "char_extra10";
	public static final String PROYECTO = "proyecto";
}
