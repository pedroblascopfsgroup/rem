package es.pfsgroup.plugin.rem.api;

import java.util.HashMap;

import es.pfsgroup.plugin.rem.rest.dto.AnulacionDto;
import es.pfsgroup.plugin.rem.rest.dto.ConfirmacionOpDto;

public interface AnulacionesApi {

	/**
	 * Valida la petición de anulacion del cobro de la reserva
	 * 
	 * @param anulacionDto
	 * @param jsonFields
	 * @return
	 * @throws Exception
	 */
	public HashMap<String, String> validateAnulacionCobroReservaPostRequestData(AnulacionDto anulacionDto,
			Object jsonFields) throws Exception;

	/**
	 * Valida la petición de anulacion del cobro de la venta
	 * 
	 * @param anulacionDto
	 * @param jsonFields
	 * @return
	 * @throws Exception
	 */
	public HashMap<String, String> validateAnulacionCobroVentaPostRequestData(AnulacionDto anulacionDto,
			Object jsonFields) throws Exception;

	/**
	 * Valida la petición de anulacion de la devolución de la reserva
	 * 
	 * @param anulacionDto
	 * @param jsonFields
	 * @return
	 * @throws Exception
	 */
	public HashMap<String, String> validateAnulacionDevolucionReservaPostRequestData(AnulacionDto anulacionDto,
			Object jsonFields) throws Exception;

	/**
	 * Anula el cobro de la reserva
	 * 
	 * @param confirmacionOpDto
	 * @throws Exception
	 */
	public void anularCobroReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception;

	/**
	 * Anula el cobro de la venta
	 * 
	 * @param confirmacionOpDto
	 * @throws Exception
	 */
	public void anularCobroVenta(ConfirmacionOpDto confirmacionOpDto) throws Exception;

	/**
	 * Anula la petición de anulacion de la devolución de la reserva
	 * 
	 * @param confirmacionOpDto
	 * @throws Exception
	 */
	public void anularDevolucionReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception;

}
