package es.pfsgroup.plugin.precontencioso.liquidacion.manager;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarLiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;

@Service
public class GenerarLiquidacionBankiaManager implements GenerarLiquidacionApi {

	@Autowired
	private ParametrizacionDao parametrizacionDao;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private GENINFInformesApi informesApi;

	@Autowired
	private List<DatosPlantillaFactory> datosPlantillaFactoryList;

	@Override
	public List<DDTipoLiquidacionPCO> getPlantillasLiquidacion(){
		List<DDTipoLiquidacionPCO> plantillas = diccionarioApi.dameValoresDiccionario(DDTipoLiquidacionPCO.class);
		return plantillas;
	}

	@Override
	public FileItem generarDocumento(Long idLiquidacion, Long idPlantilla) {
		DDTipoLiquidacionPCO tipoLiquidacion = (DDTipoLiquidacionPCO) diccionarioApi.dameValorDiccionario(DDTipoLiquidacionPCO.class, idPlantilla);
		String nombrePlantilla = tipoLiquidacion.getPlantilla();

		HashMap<String, Object> datosPlantilla = obtenerDatosParaPlantilla(idLiquidacion, tipoLiquidacion);

		FileItem ficheroLiquidacion;

		try {

			String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();

			InputStream is = new FileInputStream(directorio + nombrePlantilla);
			ficheroLiquidacion = informesApi.generarEscritoConVariables(datosPlantilla, nombrePlantilla, is);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}

		return ficheroLiquidacion;
	}

	/**
	 * Se obtiene los datos para rellenar la plantilla en base al tipo de liquidacion y el identificador de la liquidacion
	 * 
	 * @param idLiquidacion id de la liquidacion de la que se quiere generar los datos para el informe
	 * @param tipoLiquidacion tipo de liquidacion
	 * @return
	 */
	private HashMap<String, Object> obtenerDatosParaPlantilla(Long idLiquidacion, DDTipoLiquidacionPCO tipoLiquidacion) {

		for (DatosPlantillaFactory datosPlantilla : datosPlantillaFactoryList) {

			// se busca la clase que se encarga de generar los datos para esa plantilla.
			if (datosPlantilla.codigoTipoLiquidacion().equals(tipoLiquidacion.getCodigo())) {
				return datosPlantilla.obtenerDatos(idLiquidacion);
			}
		}

		throw new RuntimeException("");
	}
}
