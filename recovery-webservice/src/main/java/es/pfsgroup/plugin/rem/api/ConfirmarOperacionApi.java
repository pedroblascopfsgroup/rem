package es.pfsgroup.plugin.rem.api;

import java.util.HashMap;

import es.pfsgroup.plugin.rem.rest.dto.ConfirmacionOpDto;

public interface ConfirmarOperacionApi {
	
	public static final String COBRO_RESERVA = "1";
	public static final String ANUL_COBRO_RESERVA = "2";
	public static final String COBRO_VENTA = "3";
	public static final String ANUL_COBRO_VENTA = "4";
	public static final String DEVOLUCION_RESERVA = "5";
	public static final String ANUL_DEVOLUCION_RESERVA = "6";
	public static final String REINTEGRO_RESERVA = "7";


	/**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones POST.
	 * @param ConfirmacionOpDto con los parametros de entrada
	 * @param jsonFields estructura de parámetros para validar campos en caso de venir informados
	 * @return HashMap<String, String>  
	 */
	public HashMap<String, String> validateConfirmarOperacionPostRequestData(ConfirmacionOpDto confirmacionOpDto, Object jsonFields) throws Exception;
	
	
	/**
	 * Registra el cobro de la reserva. Insertar en entregas a cuentas en positivo,
	 * actualizar fecha firma reserva y fecha envío reserva, 
	 * estado del expediente como RESERVADO y el estado de la reserva a FIRMADA
	 * @param ConfirmacionOpDto con los datos necesarios para registrar el cobro de la reserva
	 * @return void
	 */
	public void cobrarReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception;
	
	
	/**
	 * Registra el cobro de la venta. Insertar en entregas a cuentas en positivo,
	 * actualizar fecha contabilizacionPropietario, fecha venta,
	 * @param ConfirmacionOpDto con los datos necesarios para registrar el cobro de la venta
	 * @return void 
	 */
	public void cobrarVenta(ConfirmacionOpDto confirmacionOpDto) throws Exception;
	
	
	/**
	 * Registra la devolución de la reserva. Insertar en entregas a cuentas en negativo,
	 * Actualiza estado reserva a CODIGO_RESUELTA_DEVUELTA, el estado de la oferta CODIGO_RECHAZADA, el estado del expediente ANULADO,
	 * Poner fecha de devolución e importe devolución
	 * @param ConfirmacionOpDto con los datos necesarios para registrar la devolución de la reserva
	 * @return void
	 */
	public void devolverReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception;
	
	
	/**
	 * Registra el reintegro de la reserva. Insertar en entregas a cuentas en negativo,
	 * Actualiza estado reserva a CODIGO_RESUELTA_REINTEGRADA,
	 * Poner estadoReserva "Resuelta. Importe reintegrado".
	 * @param ConfirmacionOpDto con los datos necesarios para registrar el reintegro de la reserva
	 * @return void 
	 */
	public void reintegrarReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception;
	

	/**
	 * Anula el cobro de la reserva si es en el mismo día que el cobro.
	 * Borra de entregas a cuentas la reserva,
	 * Actualiza fecha firma reserva y fecha envío reserva a null
	 * Actualiza el estado del expediente como "Aprobado" y el estado de la reserva a "Pendiente firma"
	 * @param ConfirmacionOpDto con los datos necesarios para registrar el cobro de la reserva
	 * @return void
	 */
	public void  anularCobroReserva(ConfirmacionOpDto confirmacionOpDto)throws Exception;
	
	
	
	/**
	 * Anula el cobro de la venta si es en el mismo día que el cobro.
	 * Borra de entregas a cuentas la venta,
	 * Actualiza fecha contabilizacionPropietario y fecha venta a null
	 * @param ConfirmacionOpDto con los datos necesarios para registrar el cobro de la venta
	 * @return void 
	 */
	public void  anularCobroVenta(ConfirmacionOpDto confirmacionOpDto)throws Exception;
	
	
	/**
	 * Anula la devolución del cobro de la reserva si es en el mismo día que la devolución. 
	 * Borra de entregas a cuentas la devolución.
	 * Actualiza estado reserva a "Pendiente de devolución", el estado de la oferta "Aceptada", el estado del expediente "En devolución",
	 * Poner fecha de devolución e importe devolución a null,
	 * @param ConfirmacionOpDto con los datos necesarios para registrar la devolución de la reserva
	 * @return void
	 */
	public void  anularDevolucionReserva(ConfirmacionOpDto confirmacionOpDto)throws Exception;
	
}
