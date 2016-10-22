package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

public interface ResolucionComiteApi {

	
	public static final String NOTIF_RESOL_COMITE_TITEL_MSG = "Resolución comité Bankia sobre la oferta número ";
	public static final String NOTIF_RESOL_COMITE_BODY_MSG = "El comité decisor de Bankia, ha tomado una resolución sobre una oferta de un activo. Por favor, acceda a la agenda para finalizar la tarea pendiente.";
	
	
	/**
	 * Crea una nueva ResolucionComite a partir de la información pasada por
	 * parámetro.
	 * 
	 * @param resolucionComiteDto con la información de la resolucion a dar de alta
	 * @return ResolucionComiteBankia
	 */
	public ResolucionComiteBankia saveResolucionComite(ResolucionComiteDto resolucionComiteDto) throws Exception ;

}
