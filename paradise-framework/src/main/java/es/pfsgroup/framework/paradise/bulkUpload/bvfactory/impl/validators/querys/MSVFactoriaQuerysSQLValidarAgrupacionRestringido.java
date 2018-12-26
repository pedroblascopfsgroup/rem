package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.querys;


import es.pfsgroup.framework.paradise.bulkUpload.utils.filecolumns.MSVAgrupacionColumns;


/**
 * Factoría que recupera las querys necesarias para la validación del excel de alta de asuntos.
 * Las querys se encuentran en un xml que inicializa este bean.
 *   
 * @author manuel
 *
 */
public class MSVFactoriaQuerysSQLValidarAgrupacionRestringido extends MSVFactoriaQuerysSQLGenericAlta {

	/**
	 * Inicializamos el el mapa para poder obtener las query en función del valor de la constante y no al revés.
	 */	
	public void init(){
		super.init(MSVAgrupacionColumns.class);
	}

}
