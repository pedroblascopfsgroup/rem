package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosLiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.ConceptoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.RecibosLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

@Component
public class DatosPlantillaAval extends DatosPlantillaPrestamoAbstract implements DatosPlantillaFactory {
	
	// Codigo de la liquidacion a la que aplica los datos
	private static final String CODIGO_TIPO_LIQUIDACION = "AVAL";

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
		List<InteresesContratoLiqVO> interesesContratoLiq = datosLiquidacionDao.getInteresesContratoLiquidacionOrdinario(idLiquidacion);
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
		datosLiquidacion.putAll(generarInteresesContrato(interesesContratoLiq));
		datosLiquidacion.putAll(generarCamposConceptosFijosLeasing(datosGenerales.get(0), recibosLiq, interesesContratoLiq));
		datosLiquidacion.put("FECHA_FIRMA", datosGenerales.get(0).FEVACM());
		datosLiquidacion.put("CIUDAD_FIRMA", "Madrid");

		return datosLiquidacion;
	}
	
	/**
	 * @param datosGeneralesLiq
	 * @param recibosLiq
	 * @param interesesContratoLiq
	 * 
	 * @return HashMap keys
	 * 
	 * CONCEPTOS	->  List<ConceptoLiqVO>
	 */
	//funcion similar a la de arriba, pero para aval
	protected HashMap<String, Object> generarCamposConceptosFijosLeasing(final DatosGeneralesLiqVO datosGeneralesLiq, final List<RecibosLiqVO> recibosLiq, final List<InteresesContratoLiqVO> interesesContratoLiq) {
		List<ConceptoLiqVO> conceptos = new ArrayList<ConceptoLiqVO>();

		if (recibosLiq.isEmpty()) {
			throw new BusinessOperationException("GenerarLiquidacionBankiaManager.obtenerDatosLiquidacion: No se encuentra datos LQ04");
		}

		// saldo variable calculado en cada concepto respecto al anterior
		BigDecimal saldo = BigDecimal.ZERO;

		// Capital inicial
		BigDecimal capitalInical = datosGeneralesLiq.getDGC_IMCCNS();
		saldo = calculateSaldo(saldo, capitalInical, null);
		conceptos.add(new ConceptoLiqVO(datosGeneralesLiq.getDGC_FEFOEZ(), "Capital inicial", capitalInical, null, saldo));
		
		// Capital amortizado
		BigDecimal capitalAmortizado = datosGeneralesLiq.getDGC_IMCPAM();
		saldo = calculateSaldo(saldo, null, capitalAmortizado);
		conceptos.add(new ConceptoLiqVO(recibosLiq.get(0).getRCB_FEVCTR(), "Capital amortizado", null, capitalAmortizado, saldo));
		
		
				// Comisión
				BigDecimal tipoInteresAgrupado = null;
				BigDecimal sumIntereses = BigDecimal.ZERO;
				int i = 0;
				for (RecibosLiqVO recibo : recibosLiq) {
					i++;
					// nuevo concepto basado en la sumatoria de los intereses anteriores
					sumIntereses = sumIntereses.add(recibo.getRCB_IMCGTA());
					// En caso de que sea el ultimo registro de la lista se añade un nuevo concepto
					if (i == recibosLiq.size()) {
						saldo = calculateSaldo(saldo, sumIntereses, null);
						conceptos.add(new ConceptoLiqVO(datosGeneralesLiq.getDGC_FEVACM(), "Comisión", sumIntereses, null, saldo));
					}
				}
		
				// Intereses ordinarios
				tipoInteresAgrupado = null;
				sumIntereses = BigDecimal.ZERO;
				i = 0;
				for (RecibosLiqVO recibo : recibosLiq) {
					i++;

					BigDecimal tipoInteresActual = recibo.getRCB_CDINTS();

					// Primera iteracion no tiene un tipo definido
					if (tipoInteresAgrupado == null) {
						tipoInteresAgrupado = tipoInteresActual;
					}

					// agrupacion de intereses ordinarios del mismo tipo de interes
					if (tipoInteresAgrupado.equals(tipoInteresActual)) {
						sumIntereses = sumIntereses.add(recibo.getRCB_IMPRTV());
					} else {
						if (!BigDecimal.ZERO.equals(recibo.getRCB_CDINTS())) {
							sumIntereses = sumIntereses.add(recibo.getRCB_IMPRTV());
							tipoInteresAgrupado = tipoInteresActual;
						}
					}

					// En caso de que sea el ultimo registro de la lista se añade un nuevo concepto
					if (i == recibosLiq.size()) {
						saldo = calculateSaldo(saldo, sumIntereses, null);
						conceptos.add(new ConceptoLiqVO(recibo.getRCB_FEVCTR(), "Intereses", sumIntereses, null, saldo));
					}
				}

				// Intereses de demora
				tipoInteresAgrupado = null;
				sumIntereses = BigDecimal.ZERO;
				i = 0;
				for (RecibosLiqVO recibo : recibosLiq) {
					i++;
				
					BigDecimal tipoInteresActual = recibo.getRCB_CDINTM();

					// Primera iteracion no tiene un tipo definido
					if (tipoInteresAgrupado == null) {
						tipoInteresAgrupado = tipoInteresActual;
					}

					// agrupacion de intereses demora del mismo tipo de interes
					if (tipoInteresAgrupado.equals(tipoInteresActual)) {
						sumIntereses = sumIntereses.add(recibo.getRCB_IMINDR());
					} else {
						if (!BigDecimal.ZERO.equals(recibo.getRCB_CDINTM())) {
							sumIntereses = sumIntereses.add(recibo.getRCB_IMINDR());
							tipoInteresAgrupado = tipoInteresActual;
						}
					}

					// En caso de que sea el ultimo registro de la lista se añade un nuevo concepto
					if (i == recibosLiq.size()) {
						saldo = calculateSaldo(saldo, sumIntereses, null);
						conceptos.add(new ConceptoLiqVO(datosGeneralesLiq.getDGC_FEVACM(), "Intereses de demora", sumIntereses, null, saldo));
					}
				}
				
				// I.V.A.
				sumIntereses = BigDecimal.ZERO;
				i = 0;
				for (RecibosLiqVO recibo : recibosLiq) {
					i++;
					// nuevo concepto basado en la sumatoria de los intereses anteriores
					sumIntereses = sumIntereses.add(recibo.getRCB_IMBIM4());
					// En caso de que sea el ultimo registro de la lista se añade un nuevo concepto
					if (i == recibosLiq.size()) {
						saldo = calculateSaldo(saldo, sumIntereses, null);
						conceptos.add(new ConceptoLiqVO(datosGeneralesLiq.getDGC_FEVACM(), "I.V.A.", sumIntereses, null, saldo));
					}
				}
				
				HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();
				datosLiquidacion.put("CONCEPTOS", conceptos);
				return datosLiquidacion;
				
			}
}

