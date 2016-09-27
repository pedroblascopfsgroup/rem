package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

public interface ResolucionComiteApi {


	final Long RESOLUCION_APROBADA = new Long(1);
	final Long RESOLUCION_DENEGADA = new Long(3);
	final Long RESOLUCION_CONTRAOFERTA = new Long(4);
	
	final String COMITE_DGVIER = "2";
	final String COMITE_PLATAFORMA = "3";
	final String COMITE_ACTIVIDAD_INMOBILIARIA = "4";
	final String COMITE_GESTIÓN_INMOBILIARIA = "5";
	final String COMITE_INMOBILIARIO = "6";
	final String COMITE_DIRECCION = "7";
	final String COMITE_CONSEJO_ADMIN = "8";
	final String COMITE_FTA = "9";
	
	final String DENEGACION_BAJO_IMPORTE = "1";
	final String DENEGACION_OFERTAS_MEJORES = "2";
	final String DENEGACION_NO_ACEPTA_IMPORTE_RESERVA = "3";
	final String DENEGACION_NO_ACEPTA_PLAZO_RESERVA = "4";
	final String DENEGACION_NO_ASUME_GASTOS_COMPRAVENTA = "5";
	final String DENEGACION_NO_ASUME_CARGAS_NO_CANCELABLES = "6";
	final String DENEGACION_NO_ASUME_SITUACION_URBANISTICA = "7";
	final String DENEGACION_NO_ASUME_TIPO_IMPOSITIVO = "8";
	final String DENEGACION_NO_ASUME_SITUACION_FISICA = "9";
	final String DENEGACION_NO_ASUME_SITUACION_ARRENDATICIA = "10";
	final String DENEGACION_EMPLEADO_NO_CUBRE_MINIMO = "11";
	final String DENEGACION_DEUDOR_NO_ACREDITA_FINANCIACION = "12";
	final String DENEGACION_DEUDOR_NO_CUBRE_VALOR = "13";
	final String DENEGACION_DEUDOR_NO_ACEPTA_CONDICIONES = "14";
	final String DENEGACION_DECISION_DEL_COMITE = "15";
	final String DENEGACION_DECISION_DEL_AREA = "16";
	final String DENEGACION_OTROS = "17";
	final String DENEGACION_IMPORTE_INFERIOR_PRECIO_MÍNIMO = "18";
	
	/**
	 * Este método almacena en la DDBB o ejecuta un BPM asociado a aprobación por parte del comite de resolución.
	 * 
	 * @param resolucionComiteDto: Datos relacionados con la resolución del comite
	 */
	public void aprobada(ResolucionComiteDto resolucionComiteDto);
	
	/**
	 * Este método almacena en la DDBB o ejecuta un BPM asociado a la denegación por parte del comite de resolución.
	 * 
	 * @param resolucionComiteDto: Datos relacionados con la resolución del comite
	 */
	public void denegada(ResolucionComiteDto resolucionComiteDto);
	
	/**
	 * Este método almacena en la DDBB o ejecuta un BPM asociado a una contraoferta.
	 * 
	 * @param resolucionComiteDto: Datos relacionados con la resolución del comite
	 */
	public void contraofertada(ResolucionComiteDto resolucionComiteDto);
	
}
