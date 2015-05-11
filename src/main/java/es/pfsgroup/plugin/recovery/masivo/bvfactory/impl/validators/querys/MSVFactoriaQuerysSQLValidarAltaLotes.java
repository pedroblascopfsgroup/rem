package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys;

import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAltaLotesColumns;

/**
 * Factoría que recupera las querys necesarias para la validación del excel de alta de lotes.
 * Las querys se encuentran en un xml que inicializa este bean.
 *   
 * @author manuel
 *
 */
public class MSVFactoriaQuerysSQLValidarAltaLotes extends MSVFactoriaQuerysSQLGenericAlta{
	
	/**
	 * Inicializamos el el mapa para poder obtener las query en función del valor de la constante y no al revés.
	 */	
	public void init(){
		super.init(MSVAltaLotesColumns.class);
	}

}
