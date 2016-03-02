package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosLiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosLiquidacionDescuentosDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.EfectosLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.EntregasLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

/**
 * Clase que obtiene los datos necesarios para rellenar la plantilla de prestamo hipotecario
 * 
 * @author jmartin
 */
@Component
public class DatosPlantillaDescuento extends DatosPlantillaPrestamoAbstract implements DatosPlantillaFactory {

	// Codigo de la liquidacion a la que aplica los datos
	private static final String CODIGO_TIPO_LIQUIDACION = "DESCUENTO";

	@Autowired
	private DatosLiquidacionDao datosLiquidacionDao;
	
	@Autowired
	private DatosLiquidacionDescuentosDao datosDescuentoDao;

	@Autowired
	private LiquidacionApi liquidacionApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String codigoTipoLiquidacion() {
		return CODIGO_TIPO_LIQUIDACION;
	}

	@Override
	public HashMap<String, Object> obtenerDatos(Long idLiquidacion) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();
		
		// data
		List<DatosGeneralesLiqVO> datosGenerales = datosLiquidacionDao.getDatosGeneralesContratoLiquidacion(idLiquidacion);
		List<EfectosLiqVO> efectosLiquidacionImpagos = datosDescuentoDao.getEfectosLiquidacion(idLiquidacion, "I");
		List<EfectosLiqVO> efectosLiquidacionCurso = datosDescuentoDao.getEfectosLiquidacion(idLiquidacion, "C");
		List<EntregasLiqVO> entregasLiquidacion = datosDescuentoDao.getEntregasCuentasLiquidacion(idLiquidacion);
		LiquidacionPCO liquidacion = liquidacionApi.getLiquidacionPCOById(idLiquidacion);

		if (datosGenerales.isEmpty()) {
			throw new BusinessOperationException("GenerarLiquidacionBankiaManager.obtenerDatosLiquidacion: No se encuentra datos LQ03");
		}

		// add data
		datosLiquidacion.put("LQ03", datosGenerales.get(0));
		datosLiquidacion.put("LQ05I", efectosLiquidacionImpagos);
		datosLiquidacion.put("LQ05C", efectosLiquidacionCurso);
		datosLiquidacion.put("LQ06", entregasLiquidacion);

		// calculated data
		datosLiquidacion.putAll(obtenerDatosLiquidacionPco(liquidacion));
		datosLiquidacion.putAll(datosDeudaDocumentos(efectosLiquidacionImpagos, entregasLiquidacion));

		datosLiquidacion.put("FECHA_FIRMA", datosGenerales.get(0).FEVACM());
		datosLiquidacion.put("CIUDAD_FIRMA", "Madrid");
		datosLiquidacion.put("TOTAL_DEUDA", datosGenerales.get(0).IMDEUD());

		return datosLiquidacion;
	}

	private HashMap<String, Object> datosDeudaDocumentos(List<EfectosLiqVO> efectosLiquidacionImpagos, List<EntregasLiqVO> entregasLiquidacion) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();
		//efectos
		BigDecimal imdeud05 = BigDecimal.ZERO;
		BigDecimal imprtv = BigDecimal.ZERO;
		//entregas
		BigDecimal imdeud06 = BigDecimal.ZERO;
		BigDecimal imineo = BigDecimal.ZERO;

		for (EfectosLiqVO efectos : efectosLiquidacionImpagos) {
			imdeud05 = imdeud05.add(efectos.getDEF_IMDEUD());
			imprtv = imprtv.add(efectos.getDEF_IMPRTV());
		}
		
		for (EntregasLiqVO entregas : entregasLiquidacion) {
			imdeud06 = imdeud06.add(entregas.getECL_IMDEUD());
			imineo = imineo.add(entregas.getECL_IMINEO());
		}
		
		Locale localeEs = new Locale("es", "ES");

		datosLiquidacion.put("SUM_DEUDA_DOC", NumberFormat.getInstance(localeEs).format(imdeud05));
		datosLiquidacion.put("SUM_LQ05_IMPRTV", NumberFormat.getInstance(localeEs).format(imprtv));

		datosLiquidacion.put("IMPORTE_ENTREGAS", NumberFormat.getInstance(localeEs).format(imdeud06));
		datosLiquidacion.put("SUM_LQ06_IMINEO", NumberFormat.getInstance(localeEs).format(imineo));
		
		return datosLiquidacion;
	}
}
