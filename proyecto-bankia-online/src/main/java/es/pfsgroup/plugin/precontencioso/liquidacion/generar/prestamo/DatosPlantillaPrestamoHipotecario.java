package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosLiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.RecibosLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

/**
 * Clase que obtiene los datos necesarios para rellenar la plantilla de prestamo hipotecario
 * 
 * @author jmartin
 */
@Component
public class DatosPlantillaPrestamoHipotecario extends DatosPlantillaPrestamoAbstract implements DatosPlantillaFactory {

	// Codigo de la liquidacion a la que aplica los datos
	private static final String CODIGO_TIPO_LIQUIDACION = "HIPOTECARIO";

	@Autowired
	private DatosLiquidacionDao datosLiquidacionDao;

	@Autowired
	private LiquidacionApi liquidacionApi;

	@Override
	public String codigoTipoLiquidacion() {
		return CODIGO_TIPO_LIQUIDACION;
	}

	@Override
	public HashMap<String, Object> obtenerDatos(Long idLiquidacion) {
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
		datosLiquidacion.putAll(obtenerDatosBienes(liquidacion));
		datosLiquidacion.putAll(generarCamposSumRecibos(recibosLiq));
		datosLiquidacion.putAll(generarInteresesContrato(interesesContratoLiq));
		datosLiquidacion.putAll(generarCamposConceptosFijos(datosGenerales.get(0), recibosLiq, interesesContratoLiq));

		datosLiquidacion.put("NUM_CONTRATO", datosGenerales.get(0).IDPRIG());
		datosLiquidacion.put("FECHA_FIRMA", datosGenerales.get(0).FEVACM());
		datosLiquidacion.put("CIUDAD_FIRMA", "Madrid");

		return datosLiquidacion;
	}
}
