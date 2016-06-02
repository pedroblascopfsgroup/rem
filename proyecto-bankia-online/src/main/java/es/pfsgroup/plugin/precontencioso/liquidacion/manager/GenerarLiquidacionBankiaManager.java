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
import es.capgemini.pfs.core.api.parametrizacion.ParametrizacionApi;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarLiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.api.contrato.model.EXTDDTipoInfoContratoInfo;
import es.pfsgroup.recovery.ext.impl.contrato.model.EXTDDTipoInfoContrato;
import es.pfsgroup.recovery.ext.impl.contrato.model.EXTInfoAdicionalContrato;
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
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private LiquidacionApi liquidacionApi;
	
	@Autowired
	private ParametrizacionApi parametrizacionApi;

	@Override
	public List<DDTipoLiquidacionPCO> getPlantillasLiquidacion(){
		List<DDTipoLiquidacionPCO> plantillas = diccionarioApi.dameValoresDiccionario(DDTipoLiquidacionPCO.class);
		return plantillas;
	}

	@Override
	public FileItem generarDocumento(Long idLiquidacion, Long idPlantilla) {
		DDTipoLiquidacionPCO tipoLiquidacion = (DDTipoLiquidacionPCO) diccionarioApi.dameValorDiccionario(DDTipoLiquidacionPCO.class, idPlantilla);
		String nombrePlantilla = tipoLiquidacion.getPlantilla();
		
		Parametrizacion temp = parametrizacionApi.buscarParametroPorNombre("directorioPlantillasLiquidacion");
		String rutaPenParam = temp.getValor();
		String rutaLogo = rutaPenParam + "logos/";
		//String rutaLogo = "/home/asoler/plantillas/logos/";
		HashMap<String, Object> datosPlantilla = obtenerDatosParaPlantilla(idLiquidacion, tipoLiquidacion);

		FileItem ficheroLiquidacion;
		EXTDDTipoInfoContrato tmp = (EXTDDTipoInfoContrato) diccionarioApi.dameValorDiccionarioByCod(EXTDDTipoInfoContrato.class, "char_extra4");
		Long idTmp = tmp.getId();//tenemos el id de char_extra4 (BFA)
		
		try {

			String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();

			if(esBfa(idLiquidacion)){
				rutaLogo+="bfa.jpg";
			}else{
				rutaLogo+="bankia.jpg";
			}
			
			InputStream is = new FileInputStream(directorio + nombrePlantilla);
			//ficheroLiquidacion = informesApi.generarEscritoConVariables(datosPlantilla, nombrePlantilla, is);
			ficheroLiquidacion = informesApi.generarEscritoConVariablesYLogo(datosPlantilla, nombrePlantilla, is, rutaLogo);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}

		return ficheroLiquidacion;
	}

	private boolean esBfa(Long idLiquidacion) {
		LiquidacionPCO liquidacion = liquidacionApi.getLiquidacionPCOById(idLiquidacion);
		Long idCcontrato = liquidacion.getContrato().getId();
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idCcontrato);
		Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "tipoInfoContrato.codigo", "char_extra4");
		List<EXTInfoAdicionalContrato> infoAdicional=(List<EXTInfoAdicionalContrato>) genericDao.getList(EXTInfoAdicionalContrato.class, filtro1,filtro2);

		String ofiCodigo = liquidacion.getContrato().getOficinaContable().getCodigo().toString();
		
		for (EXTInfoAdicionalContrato elemento : infoAdicional){
			if(ofiCodigo.equals("842700")){
				return true;
			}
			if(Checks.esNulo(elemento.getValue()) || !elemento.getValue().equalsIgnoreCase("S")){
				return false;
			}
		}
		return true;
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
