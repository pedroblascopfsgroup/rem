package es.pfsgroup.plugin.precontencioso.liquidacion.manager;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarLiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.DatosLiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.vo.RecibosLiqVO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;

@Service
public class GenerarLiquidacionBankiaManager implements GenerarLiquidacionApi {

	@Autowired
	private LiquidacionApi liquidacionApi;

	@Autowired
	private ParametrizacionDao parametrizacionDao;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private DatosLiquidacionDao datosLiquidacionDao;

	@Autowired
	private GENINFInformesApi informesApi;

	@Override
	public FileItem generarDocumento(Long idLiquidacion, Long idPlantilla) {
		HashMap<String, Object> datosLiquidacion = obtenerDatosLiquidacion(idLiquidacion);

		String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();

		String nombrePlantilla = obtenerNombrePlantilla(idPlantilla);
		FileItem resultado;

		try {

			InputStream is = new FileInputStream(directorio + nombrePlantilla);
			resultado = informesApi.generarEscritoConVariables(datosLiquidacion, nombrePlantilla, is);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}

		return resultado;
	}

	private String obtenerNombrePlantilla(Long idPlantilla) {
		DDTipoLiquidacionPCO tipoLiquidacion = (DDTipoLiquidacionPCO) diccionarioApi.dameValorDiccionario(DDTipoLiquidacionPCO.class, idPlantilla);
		String nombrePlantilla = tipoLiquidacion.getPlantilla();
		return nombrePlantilla;
	}

	private HashMap<String, Object> obtenerDatosLiquidacion(Long idLiquidacion) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();

		// data
		List<DatosGeneralesLiqVO> datosGenerales = datosLiquidacionDao.getDatosGeneralesContratoLiquidacion(idLiquidacion);
		List<RecibosLiqVO> recibosLiq = datosLiquidacionDao.getRecibosLiquidacion(idLiquidacion);
		List<InteresesContratoLiqVO> interesesContratoLiq = datosLiquidacionDao.getInteresesContratoLiquidacion(idLiquidacion);
		LiquidacionPCO liquidacion = liquidacionApi.getLiquidacionPCOById(idLiquidacion);

		if (datosGenerales.isEmpty()) {
			throw new BusinessOperationException("GenerarLiquidacionBankiaManager.obtenerDatosLiquidacion: No se encuentra datos LQ03");
		}

		// add data
		datosLiquidacion.put("LQ03", datosGenerales.get(0));
		datosLiquidacion.put("LQ04", recibosLiq);
		datosLiquidacion.put("LQ07", interesesContratoLiq);

		// calculated data
		datosLiquidacion.putAll(obtenerDatosLiquidacionPco(liquidacion));
		datosLiquidacion.putAll(generarCamposSumRecibos(recibosLiq));

		datosLiquidacion.put("FECHA_FIRMA", "[NO DISPONIBLE]");
		datosLiquidacion.put("CIUDAD_FIRMA", "[NO DISPONIBLE]");
		datosLiquidacion.put("INI_LQ07_CDINTS", "[NO DISPONIBLE]");

		return datosLiquidacion;
	}

	private HashMap<String, Object> obtenerDatosLiquidacionPco(final LiquidacionPCO liquidacion) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();

		if (liquidacion.getContrato() == null) {
			throw new BusinessOperationException("GenerarLiquidacionBankiaManager.obtenerDatosLiquidacionPco: No se encuentra el contrato de la liquidacion");
		}

		// Contrato
		datosLiquidacion.put("NOMBRES_TITULARES", liquidacion.getContrato().getNombresTitulares());
		datosLiquidacion.put("NOMBRES_FIADORES", obtenerNombreFiadores(liquidacion));
		datosLiquidacion.put("NUM_CONTRATO", liquidacion.getContrato().getNroContratoFormat());
		datosLiquidacion.put("NOMBRE_APODERADO", liquidacion.getApoderado().getUsuario().getApellidoNombre());

		// Bienes
		List<Bien> bienes = liquidacion.getContrato().getBienes();
		datosLiquidacion.put("BIENES", bienes);

		if (!liquidacion.getContrato().getTitulares().isEmpty()) {
			Persona titualPrincipal = liquidacion.getContrato().getTitulares().get(0);
			datosLiquidacion.put("NOMBRE_TITULAR_PRINCIPAL", titualPrincipal.getNom50());
		} else {
			throw new BusinessOperationException("GenerarLiquidacionBankiaManager.obtenerDatosLiquidacionPco: No se encuentra el titular del contrato");
		}

		return datosLiquidacion;
	}

	private String obtenerNombreFiadores(final LiquidacionPCO liquidacion) {
		StringBuilder nombresFiadores = new StringBuilder("");
		for (ContratoPersona cp : liquidacion.getContrato().getContratoPersona()) {
            if (cp.isAvalista()) {
            	nombresFiadores.append(" ").append(cp.getPersona().getNom50());
            }
        }

		return nombresFiadores.toString();
	}

	private HashMap<String, Object> generarCamposSumRecibos(List<RecibosLiqVO> recibosLiq) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();

		BigDecimal imcprc = BigDecimal.ZERO;
		BigDecimal imprtv = BigDecimal.ZERO;
		BigDecimal imcgta = BigDecimal.ZERO;
		BigDecimal imindr = BigDecimal.ZERO;
		BigDecimal imbim4 = BigDecimal.ZERO;
		BigDecimal imdeud = BigDecimal.ZERO;

		for (RecibosLiqVO recibo : recibosLiq) {
			imcprc = imcprc.add(recibo.getRCB_IMCPRC());
			imprtv = imprtv.add(recibo.getRCB_IMPRTV());
			imcgta = imcgta.add(recibo.getRCB_IMCGTA());
			imindr = imindr.add(recibo.getRCB_IMINDR());
			imbim4 = imbim4.add(recibo.getRCB_IMBIM4());
			imdeud = imdeud.add(recibo.getRCB_IMDEUD());
		}

		datosLiquidacion.put("SUM_LQ04_IMCPRC", imcprc);
		datosLiquidacion.put("SUM_LQ04_IMPRTV", imprtv);
		datosLiquidacion.put("SUM_LQ04_IMCGTA", imcgta);
		datosLiquidacion.put("SUM_LQ04_IMINDR", imindr);
		datosLiquidacion.put("SUM_LQ04_IMBIM4", imbim4);
		datosLiquidacion.put("SUM_LQ04_IMDEUD", imdeud);

		return datosLiquidacion;
	}

	@Override
	public List<DDTipoLiquidacionPCO> getPlantillasLiquidacion(){
		List<DDTipoLiquidacionPCO> plantillas = diccionarioApi.dameValoresDiccionario(DDTipoLiquidacionPCO.class);
		return plantillas;
	}
}
