package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.cajamadrid.servicios.GM.GMPETS07_INS.GMPETS07_INS;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.UvemManagerApi.MOTIVO_ANULACION_OFERTA;
import es.pfsgroup.plugin.rem.model.DtoClienteUrsus;
import es.pfsgroup.plugin.rem.rest.dto.DatosClienteDto;
import es.pfsgroup.plugin.rem.rest.dto.InstanciaDecisionDto;
import es.pfsgroup.plugin.rem.rest.dto.ResultadoInstanciaDecisionDto;

/**
 * Interface operaciones UVEM
 * 
 * @author rllinares
 *
 */
public interface UvemManagerApi {

	public enum MOTIVO_ANULACION {
		COMPRADOR_NO_INTERESADO, DECISION_AREA, NO_DISPONE_DINERO_FINANCIACION, CIRCUSTANCIAS_DISTINTAS_PACTADAS, NO_CUMPLEN_CONDICIONANTES, NO_DESEAN_ESCRITURAR, DECISION_HAYA
	}

	public enum INDICADOR_DEVOLUCION_RESERVA {
		DEVOLUCION_RESERVA, NO_DEVOLUCION_RESERVA
	}
	
	public enum CODIGO_SERVICIO_MODIFICACION {
		PROPUESTA_ANULACION_RESERVA_FIRMADA, ANULACION_PROPUESTA_ANULACION_RESERVA_FIRMADA
	}
	
	public enum MOTIVO_ANULACION_OFERTA {
		COMPRADOR_NO_INTERESADO_OPERACION, INTERESADO_OTRO_INMUEBLE_AREA, INTERESADO_OTRO_INMUEBLE_OTRO_AREA, COMPRADOR_NO_INTERESADO_NADA, EXCESIVO_TIEMPO_FIRMA_RESERVA, NO_LOCALIZADO_CLIENTE,
		LOCALIZADO_SIN_INTERES_FIRMAR, FALTA_FINANCIACION, MAS_1_MES_FIRMAR_RESERVA, NO_TIENE_DINERO_SIN_FINANCIACION, CIRCURNSTANCIA_DISTINTAS_PACTADAS_DPT_COMERCIAL, NO_FIRMA_RESERVA_SIN_VISITA,
		CAUSAS_FISCALES, CAUSAS_RELATIVAS_GASTOS, CAUSAS_RELATIVAS_ESTADO_FISICO, CARGAS_NO_PLANTEADAS, NO_CUMPLE_CONDICION_BANKIA, CLIENTE_NO_AMPLIACION_VALIDEZ, NO_CUMPLE_CONDICION, FUTURO_CUMPLIMIENTO_CONDICION,
		SOLICITADA_AREA, DETECTADO_IRREGULARIDADES_DPTO_COMERCIAL, DETECTADO_IRREGULARIDADES_DPTO_ADM_TECNICO, DETECTADO_IRREGULARIDADES_DIRECCION, NO_RATIFICADA, MEJOR_OFERTA_POSTERIOR, SAREB_RETIRADA_OBRA_CURSO,
		VENTA_SKY, VENTA_EXTERNA, ANULADAS_ESCRITURACION, NO_PRESENTADOS_FIRMA_REQUERIDOS, INCUMPLIMIENTO_PLAZOS_FORMA, ERROR_USUARIO_1, ERROR_USUARIO_2
	}

	/******************************************* TASACIONES ***************************************************/

	/**
	 * Solicitar tasación de un bien
	 * 
	 * @param numActivoUvem
	 * @param userName
	 * @param email
	 * @param telefono
	 * @return
	 * @throws Exception
	 */
	public Integer ejecutarSolicitarTasacionTest(Long numActivoUvem, String userName, String email, String telefono)
			throws Exception;

	/**
	 * Solicitar tasación de un bien
	 * 
	 * @param numActivoUvem
	 * @param nombreGestor
	 * @param gestion
	 * @return
	 * @throws Exception
	 */
	public Integer ejecutarSolicitarTasacion(Long numActivoUvem, Usuario usuarioGestor) throws Exception;

	/**
	 * Obtiene el identificador de la tasacion
	 * 
	 * @return
	 */
	public GMPETS07_INS resultadoSolicitarTasacion();

	/*******************************************
	 * CLIENTES URSUS
	 ***************************************************/

	/**
	 * 
	 * (DE CLIENTE SOLO DEBERIA USARSE ESTE) Devuelve los clientes partir de los
	 * datos pasados por parámetro
	 * 
	 * @param nDocumento:
	 *            documento identificativo del cliente a consultar
	 * @param tipoDocumento:Clase
	 *            De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3 Tarjeta
	 *            Residente. 4 Pasaporte 5 C.I.F país extranjero. 7 D.N.I país
	 *            extranjero. 8 Tarj. identif. diplomática 9 Menor. F Otros
	 *            persona física. J Otros persona jurídica.
	 * @param qcenre:
	 *            Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia
	 *            habitat 05021
	 */
	DatosClienteDto ejecutarDatosClientePorDocumento(DtoClienteUrsus dtoCliente) throws Exception;

	/**
	 * Servicio GMPAJC11_INS que a partir del nº y tipo de documento, así como
	 * Entidad del Cliente (y tipo) devolverá el/los nº cliente/s Ursus
	 * coincidentes
	 * 
	 * @param nDocumento:
	 *            Documento según lo expresado en COCLDO. DNI, CIF, etc
	 * @param tipoDocumento:
	 *            Clase De Documento Identificador Cliente. 1 D.N.I 2 C.I.F. 3
	 *            Tarjeta Residente. 4 Pasaporte 5 C.I.F país extranjero. 7
	 *            D.N.I país extranjero. 8 Tarj. identif. diplomática 9 Menor. F
	 *            Otros persona física. J Otros persona jurídica.
	 * @param qcenre:
	 *            Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia
	 *            habitat 05021
	 */
	public List<DatosClienteDto> ejecutarNumCliente(String nDocumento, String tipoDocumento, String qcenre)
			throws Exception;

	// TODO: cuando se pruebe borrar este método.
	public List<DatosClienteDto> ejecutarNumClienteTest(String nDocumento, String tipoDocumento, String qcenre)
			throws Exception;

	/**
	 * Servicio GMPAJC93_INS que a partir del nº cliente URSUS se devuelvan los
	 * datos del mismo, tanto identificativos como de cara a poder dar
	 * cumplimiento a la normativa relativa a PBC.
	 * 
	 * @param numcliente:
	 *            numero cliente Ursus (idclow)
	 * @param qcenre:
	 *            Cód. Entidad Representada Cliente Ursus, Bankia 00000, Bankia
	 *            habitat 05021
	 */
	public DatosClienteDto ejecutarDatosCliente(Integer numcliente, String qcenre) throws Exception;

	// TODO: cuando se pruebe borrar este método.
	public DatosClienteDto ejecutarDatosClienteTest(Integer numcliente, String qcenre) throws Exception;

	/*******************************************
	 * INSTANCIA DECISION
	 ***************************************************/

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para consultar una instancia de
	 * decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	public ResultadoInstanciaDecisionDto consultarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto)
			throws Exception;

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para dar de alta un instancia
	 * de decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	public ResultadoInstanciaDecisionDto altaInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto)
			throws Exception;

	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para modificar una instancia de
	 * decisión de una oferta
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	public ResultadoInstanciaDecisionDto modificarInstanciaDecision(InstanciaDecisionDto instanciaDecisionDto)
			throws Exception;

	/*******************************************
	 * CONSULTA PRESTAMO
	 ***************************************************/

	/**
	 * Invoca al servicio GMPAJC34_INS de BANKIA para consultar los datos de un
	 * prestamo
	 * 
	 * @param numExpedienteRiesgo12
	 * @param tipoRiesgo
	 * @return IMPORTE CONCEDIDO Multiplicado por 100 (para que no tenga
	 *         decimales).
	 */
	public Long consultaDatosPrestamo(String numExpedienteRiesgo12, int tipoRiesgo) throws Exception;

	/******************************************* RESERVAS ***************************************************/

	/**
	 * Invoca al servicio O-RB-DEVOL para generar la propuesta de anulación de
	 * reserva firmada o la anulación de la propuesta de anulación reserva
	 * firmada
	 * 
	 * @throws Exception
	 */
	public void notificarDevolucionReserva(String codigoDeOfertaHaya, MOTIVO_ANULACION motivoAnulacionReserva,
			INDICADOR_DEVOLUCION_RESERVA indicadorDevolucionReserva,CODIGO_SERVICIO_MODIFICACION codigoServicioModificacion) throws Exception;
	
	public void anularOferta(String codigoDeOfertaHaya, MOTIVO_ANULACION_OFERTA motivoAnulacionOferta) throws Exception;
	
	/**
	 * Invoca al servicio GMPDJB13_INS de BANKIA para modificar una instancia de
	 * decisión de una oferta (MOD3)
	 * 
	 * @param instanciaDecisionDto
	 * @return
	 */
	public ResultadoInstanciaDecisionDto modificarInstanciaDecisionTres(InstanciaDecisionDto instanciaDecisionDto)
			throws Exception;

}
