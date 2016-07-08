package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.querys;


import es.pfsgroup.framework.paradise.bulkUpload.utils.filecolumns.MSVAgrupacionColumns;


/**
 * Factor�a que recupera las querys necesarias para la validaci�n del excel de alta de asuntos.
 * Las querys se encuentran en un xml que inicializa este bean.
 *   
 * @author manuel
 *
 */
public class MSVFactoriaQuerysSQLValidarAgrupacionObraNueva extends MSVFactoriaQuerysSQLGenericAlta {

	/**
	 * Inicializamos el el mapa para poder obtener las query en funci�n del valor de la constante y no al rev�s.
	 */	
	public void init(){
		super.init(MSVAgrupacionColumns.class);
	}

}
