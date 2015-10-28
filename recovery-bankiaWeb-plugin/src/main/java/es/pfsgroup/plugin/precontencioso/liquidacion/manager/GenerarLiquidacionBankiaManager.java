package es.pfsgroup.plugin.precontencioso.liquidacion.manager;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarLiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;

@Service
public class GenerarLiquidacionBankiaManager implements GenerarLiquidacionApi {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private LiquidacionApi liquidacionApi;

	@Autowired
	private ParametrizacionDao parametrizacionDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Override
	public FileItem generarDocumento(Long idLiquidacion) {
		LiquidacionPCO liquidacion = proxyFactory.proxy(LiquidacionApi.class).getLiquidacionPCOById(idLiquidacion);

		HashMap<String, String> mapaVariables = new HashMap<String, String>();

		SimpleDateFormat fechaFormat = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY, MessageUtils.DEFAULT_LOCALE);

		if (!Checks.esNulo(liquidacion.getContrato())) {
			mapaVariables.put("numContrato", liquidacion.getContrato().getNroContratoFormat());
		} else {
			mapaVariables.put("numContrato", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getContrato().getTipoProductoEntidad())) {
			mapaVariables.put("tipoProducto", liquidacion.getContrato().getTipoProductoEntidad().getDescripcion());
		} else {
			mapaVariables.put("tipoProducto", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getEstadoLiquidacion())) {
			mapaVariables.put("estadoLiquidacion", liquidacion.getEstadoLiquidacion().getDescripcion());
		} else {
			mapaVariables.put("estadoLiquidacion", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getFechaSolicitud())) {
			mapaVariables.put("fechaSolicitud", fechaFormat.format(liquidacion.getFechaSolicitud()));
		} else {
			mapaVariables.put("fechaSolicitud", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getFechaRecepcion())) {
			mapaVariables.put("fechaRecepcion", fechaFormat.format(liquidacion.getFechaRecepcion()));
		} else {
			mapaVariables.put("fechaRecepcion", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getFechaConfirmacion())) {
			mapaVariables.put("fechaConfirmacion", fechaFormat.format(liquidacion.getFechaConfirmacion()));
		} else {
			mapaVariables.put("fechaConfirmacion", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getFechaCierre())) {
			mapaVariables.put("fechaCierre", fechaFormat.format(liquidacion.getFechaCierre()));
		} else {
			mapaVariables.put("fechaCierre", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getCapitalVencido())) {
			mapaVariables.put("capitalVencido", NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(liquidacion.getCapitalVencido()));
		} else {
			mapaVariables.put("capitalVencido", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getCapitalNoVencido())) {
			mapaVariables.put("capitalNoVencido", liquidacion.getCapitalNoVencido().toString());
		} else {
			mapaVariables.put("capitalNoVencido", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getInteresesOrdinarios())) {
			mapaVariables.put("interesesOrdinarios", NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(liquidacion.getInteresesOrdinarios()));
		} else {
			mapaVariables.put("interesesOrdinarios", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getInteresesDemora())) {
			mapaVariables.put("interesesDemora", NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(liquidacion.getInteresesDemora()));
		} else {
			mapaVariables.put("interesesDemora", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getComisiones())) {
			mapaVariables.put("comisiones", NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(liquidacion.getComisiones()));
		} else {
			mapaVariables.put("comisiones", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getGastos())) {
			mapaVariables.put("gastos", NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(liquidacion.getGastos()));
		} else {
			mapaVariables.put("gastos", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getImpuestos())) {
			mapaVariables.put("impuestos", NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(liquidacion.getImpuestos()));
		} else {
			mapaVariables.put("impuestos", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getTotal())) {
			mapaVariables.put("total", NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(liquidacion.getTotal()));
		} else {
			mapaVariables.put("total", "[ERROR - No existe valor]");
		}
		if (!Checks.esNulo(liquidacion.getApoderado())) {
			mapaVariables.put("apoderado", liquidacion.getApoderado().getUsuario().getApellidoNombre());
		} else {
			mapaVariables.put("apoderado", "[ERROR - No existe valor]");
		}

		String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();

		InputStream is;
		try {
			is = new FileInputStream(directorio + "plantillaLiquidacion.docx");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}

		FileItem resultado = new FileItem();
		try {
//			resultado = proxyFactory.proxy(GENINFInformesApi.class).generarEscritoConVariables(mapaVariables, "plantillaLiquidacion.docx", is);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}

		return resultado;
	}
	
	@Override
	public List<DDTipoLiquidacionPCO> getPlantillasLiquidacion(){
		List<DDTipoLiquidacionPCO> plantillas = diccionarioApi.dameValoresDiccionario(DDTipoLiquidacionPCO.class);
		return plantillas;
	}
}
