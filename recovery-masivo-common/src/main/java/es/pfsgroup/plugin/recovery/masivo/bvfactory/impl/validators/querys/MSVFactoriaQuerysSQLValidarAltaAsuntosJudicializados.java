package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys;

import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAltaContratosColumns;


/**
 * Factoría que recupera las querys necesarias para la validación del excel de alta de asuntos.
 * Las querys se encuentran en un xml que inicializa este bean.
 *   
 * @author manuel
 *
 */
public class MSVFactoriaQuerysSQLValidarAltaAsuntosJudicializados extends MSVFactoriaQuerysSQLGenericAlta {

	/**
	 * Inicializamos el el mapa para poder obtener las query en función del valor de la constante y no al revés.
	 */	
	public void init(){
		super.init(MSVAltaContratosColumns.class);
	}

}
