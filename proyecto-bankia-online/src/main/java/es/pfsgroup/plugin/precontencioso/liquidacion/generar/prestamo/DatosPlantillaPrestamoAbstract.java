package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.BienLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.CabeceraLiquidacionLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.ConceptoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.RecibosLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBInformacionRegistralBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.ext.impl.contrato.model.EXTInfoAdicionalContrato;

/**
 * Contiene el codigo comun para generar datos para las plantillas de tipo Hipotecario, Personal y Leasing
 * @author jmartin
 */
public abstract class DatosPlantillaPrestamoAbstract {
	
	@Autowired
	private LiquidacionApi liquidacionApi;
	
	@Autowired
	private GenericABMDao genericDao;

	/**
	 * @param liquidacion
	 * 
	 * @return HashMap keys:
	 * 
	 * NOMBRES_TITULARES			-> String
	 * NOMBRES_FIADORES				-> String
	 * NOMBRE_APODERADO				-> String
	 * NOMBRE_TITULAR_PRINCIPAL		-> String
	 */
	protected HashMap<String, Object> obtenerDatosLiquidacionPco(final LiquidacionPCO liquidacion) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();

		if (liquidacion.getContrato() == null) {
			throw new BusinessOperationException("obtenerDatosLiquidacionPco: No se encuentra el contrato de la liquidacion");
		}

		// Contrato
		datosLiquidacion.put("NOMBRES_TITULARES", obtenerNombresTitulares(liquidacion));
		datosLiquidacion.put("NOMBRES_FIADORES", obtenerNombresFiadores(liquidacion));
		datosLiquidacion.put("NOMBRE_APODERADO", obtenerNombreApoderado(liquidacion));

		if (!liquidacion.getContrato().getTitulares().isEmpty()) {
			Persona titualPrincipal = liquidacion.getContrato().getTitulares().get(0);
			datosLiquidacion.put("NOMBRE_TITULAR_PRINCIPAL", titualPrincipal.getNom50());
		} else {
			throw new BusinessOperationException("obtenerDatosLiquidacionPco: No se encuentra el titular del contrato");
		}

		String infoEntidadBankia = "de Bankia, S.A. con NIF A-14010342, domiciliada en c/ Pintor Sorolla, 8 - 46002 Valencia";
		String infoEntidadBFA = "de Banco Financiero y de Ahorros, S.A. con NIF A-86085685, domiciliada en C/ Paseo de la Castellana, 189 – 28046 Madrid";
		String nombreEntidadBankia = "Bankia S.A.";
		String nombreEntidadBfa = "Banco Financiero y de Ahorros S.A.";
		String sucursal_mayor_deuda_exp_bankia = "Bankia";
		String sucursal_mayor_deuda_exp_bfa = "Banco Financiero y de Ahorros";
		if(esBfa(liquidacion.getId())){
			datosLiquidacion.put("INFO_ENTIDAD", infoEntidadBFA);
			datosLiquidacion.put("NOMBRE_ENTIDAD", nombreEntidadBfa);
			datosLiquidacion.put("SUCURSAL_MAYOR_DEUDA", sucursal_mayor_deuda_exp_bfa);
			
		}else{
			datosLiquidacion.put("INFO_ENTIDAD", infoEntidadBankia);
			datosLiquidacion.put("NOMBRE_ENTIDAD", nombreEntidadBankia);
			datosLiquidacion.put("SUCURSAL_MAYOR_DEUDA", sucursal_mayor_deuda_exp_bankia);
		}
		
		String nombreFiadores = obtenerNombresFiadores(liquidacion);
		String nombreFiadoresL = nombreFiadores;
		if(nombreFiadores == "" || nombreFiadores.isEmpty()){
			datosLiquidacion.put("NOMBRES_FIADORES_C", nombreFiadores);
			datosLiquidacion.put("NOMBRES_FIADORES_L", nombreFiadores);
		}else{
			nombreFiadoresL = "se ha practicado la liquidación con la garantía de D(a) "+nombreFiadores+" de ";
			nombreFiadores = "con la garantía de D(a)  "+nombreFiadores;
			datosLiquidacion.put("NOMBRES_FIADORES_C", nombreFiadores);
			datosLiquidacion.put("NOMBRES_FIADORES_L", nombreFiadoresL);
		}
		return datosLiquidacion;
	}

	/**
	 * @param liquidacion
	 * 
	 * @return HashMap keys:
	 * 
	 * BIENES 				-> List<BienLiqVo>
	 * BIENES_CONCATENADOS 	-> String
	 */
	protected HashMap<String, Object> obtenerDatosBienes(final LiquidacionPCO liquidacion) {
		HashMap<String, Object> datosBienes = new HashMap<String, Object>();

		// Bienes
		List<BienLiqVO> bienes = new ArrayList<BienLiqVO>(); 

		StringBuffer bienesConcatenados = new StringBuffer();
		int size = liquidacion.getContrato().getBienes().size();
		int i=0;

		for (Bien bien : liquidacion.getContrato().getBienes()) {
			NMBBien nmbBien = (NMBBien) bien;

			NMBInformacionRegistralBienInfo infoRegistral = nmbBien.getDatosRegistralesActivo();
			NMBLocalizacionesBienInfo localizacion = nmbBien.getLocalizacionActual();

			// Numero finca
			String numFinca = "";
			if (infoRegistral != null && infoRegistral.getNumFinca() != null) {
				numFinca = " FINCA " + infoRegistral.getNumFinca();	
				bienesConcatenados.append(numFinca);
			}

			// Numero Registro
			String numRegistro = "";
			if (infoRegistral != null && infoRegistral.getNumRegistro() != null) {
				numRegistro = " NUM.R " + infoRegistral.getNumRegistro();
				bienesConcatenados.append(numRegistro);
			}

			// Localizacion registro
			String locRegistro = "";
			if (infoRegistral != null && infoRegistral.getLocalidad() != null && infoRegistral.getLocalidad().getDescripcion() != null) {
				locRegistro = " LOC.R " + infoRegistral.getLocalidad().getDescripcion();
				bienesConcatenados.append(locRegistro);
			}

			String nombreVia = "";
			if (localizacion != null && localizacion.getNombreVia() != null) {
				nombreVia = localizacion.getNombreVia();
			}

			String numeroDomicilio = "";
			if (localizacion != null && localizacion.getNumeroDomicilio() != null) {
				numeroDomicilio = localizacion.getNumeroDomicilio();				
			}

			// Direccion
			String direccion = nombreVia + " " + numeroDomicilio + " ";
			bienesConcatenados.append(direccion);

			// Localidad
			String localidad = "";
			if (localizacion != null && localizacion.getLocalidad() != null && localizacion.getLocalidad().getDescripcion() != null) {
				localidad = localizacion.getLocalidad().getDescripcion();
				bienesConcatenados.append(localidad);
			}
			
			i++;
			if(i == size-1) bienesConcatenados.append(" y ");
			else if(i<size) bienesConcatenados.append(", ");			

			BienLiqVO bienVo = new BienLiqVO(numFinca + numRegistro + locRegistro, direccion, localidad);
			bienes.add(bienVo);
		}

		datosBienes.put("BIENES", bienes);
		datosBienes.put("BIENES_CONCATENADOS", bienesConcatenados.toString());

		return datosBienes;
	}

	/**
	 * @param recibosLiq
	 * 
	 * @return HashMap keys
	 * 
	 * SUM_LQ04_IMCPRC	->	String
	 * SUM_LQ04_IMPRTV	->	String
	 * SUM_LQ04_IMCGTA	->	String
	 * SUM_LQ04_IMINDR	->	String
	 * SUM_LQ04_IMBIM4	->	String
	 * SUM_LQ04_IMDEUD	->	String
	 */
	protected HashMap<String, Object> generarCamposSumRecibos(List<RecibosLiqVO> recibosLiq) {
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

		Locale localeEs = new Locale("es", "ES");

		datosLiquidacion.put("SUM_LQ04_IMCPRC", NumberFormat.getInstance(localeEs).format(imcprc));
		datosLiquidacion.put("SUM_LQ04_IMPRTV", NumberFormat.getInstance(localeEs).format(imprtv));
		datosLiquidacion.put("SUM_LQ04_IMCGTA", NumberFormat.getInstance(localeEs).format(imcgta));
		datosLiquidacion.put("SUM_LQ04_IMINDR", NumberFormat.getInstance(localeEs).format(imindr));
		datosLiquidacion.put("SUM_LQ04_IMBIM4", NumberFormat.getInstance(localeEs).format(imbim4));
		datosLiquidacion.put("SUM_LQ04_IMDEUD", NumberFormat.getInstance(localeEs).format(imdeud));

		return datosLiquidacion;
	}

	/**
	 * @param interesesContratoLiq
	 * 
	 * @return HashMap keys
	 * 
	 * INI_LQ07_CDINTS	->	String 
	 */
	protected HashMap<String, Object> generarInteresesContrato(List<InteresesContratoLiqVO> interesesContratoLiq) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();

		if (interesesContratoLiq.isEmpty()) {
			datosLiquidacion.put("INI_LQ07_CDINTS", "[NO-DISPONIBLE]");
			return datosLiquidacion;
		}

		datosLiquidacion.put("INI_LQ07_CDINTS", interesesContratoLiq.get(0).CDINTS());

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
	protected HashMap<String, Object> generarCamposConceptosFijos(final DatosGeneralesLiqVO datosGeneralesLiq, final List<RecibosLiqVO> recibosLiq, final List<InteresesContratoLiqVO> interesesContratoLiq) {
		List<ConceptoLiqVO> conceptos = new ArrayList<ConceptoLiqVO>();

		if (recibosLiq.isEmpty()) {
			return new HashMap<String, Object>();
		}

		// saldo variable calculado en cada concepto respecto al anterior
		BigDecimal saldo = BigDecimal.ZERO;

		// Capital Inicial
		BigDecimal capitalInical = datosGeneralesLiq.getDGC_IMCCNS();
		saldo = calculateSaldo(saldo, capitalInical, null);
		conceptos.add(new ConceptoLiqVO(datosGeneralesLiq.getDGC_FEFOEZ(), "Capital inicial", capitalInical, null, saldo));

		// Capital Amortizado
		BigDecimal capitalAmortizado = datosGeneralesLiq.getDGC_IMCPAM();
		saldo = calculateSaldo(saldo, null, capitalAmortizado);
		conceptos.add(new ConceptoLiqVO(recibosLiq.get(0).getRCB_FEVCTR(), "Capital amortizado", null, capitalAmortizado, saldo));

		// Comision
		conceptos.add(new ConceptoLiqVO(datosGeneralesLiq.getDGC_FEVACM(), "Comisión", BigDecimal.ZERO, null, saldo));

		// Intereses ordinarios
		BigDecimal tipoInteresAgrupado = null;
		BigDecimal sumIntereses = BigDecimal.ZERO;
		int i = 0;
		Date fechaAuxIntOrd = null;
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
				fechaAuxIntOrd = recibo.getRCB_FEVCTR();
			} else {
				if (!BigDecimal.ZERO.equals(recibo.getRCB_CDINTS())) {
					// nuevo concepto basado en la sumatoria de los intereses anteriores
					saldo = calculateSaldo(saldo, sumIntereses, null);
					conceptos.add(new ConceptoLiqVO(fechaAuxIntOrd, "Intereses al " + formateaImporteDecimal(tipoInteresAgrupado) + " %", sumIntereses, null, saldo));
	
					sumIntereses = BigDecimal.ZERO;
					sumIntereses = sumIntereses.add(recibo.getRCB_IMPRTV());
					tipoInteresAgrupado = tipoInteresActual;
					fechaAuxIntOrd = recibo.getRCB_FEVCTR();
				}
			}

			// En caso de que sea el ultimo registro de la lista se añade un nuevo concepto
			if (i == recibosLiq.size()) {
				saldo = calculateSaldo(saldo, sumIntereses, null);
				conceptos.add(new ConceptoLiqVO(recibo.getRCB_FEVCTR(), "Intereses al " + formateaImporteDecimal(tipoInteresAgrupado) + " %", sumIntereses, null, saldo));
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
					// nuevo concepto basado en la sumatoria de los intereses anteriores
					saldo = calculateSaldo(saldo, sumIntereses, null);
					conceptos.add(new ConceptoLiqVO(datosGeneralesLiq.getDGC_FEVACM(), "Intereses de demora al " + formateaImporteDecimal(tipoInteresAgrupado) + " %", sumIntereses, null, saldo));
	
					sumIntereses = BigDecimal.ZERO;
					sumIntereses = sumIntereses.add(recibo.getRCB_IMINDR());
					tipoInteresAgrupado = tipoInteresActual;
				}
			}

			// En caso de que sea el ultimo registro de la lista se añade un nuevo concepto
			if (i == recibosLiq.size()) {
				saldo = calculateSaldo(saldo, sumIntereses, null);
				conceptos.add(new ConceptoLiqVO(datosGeneralesLiq.getDGC_FEVACM(), "Intereses de demora al " + formateaImporteDecimal(tipoInteresAgrupado) + " %", sumIntereses, null, saldo));
			}
		}

		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();
		datosLiquidacion.put("CONCEPTOS", conceptos);
		return datosLiquidacion;
	}
	

	// --------------------------
	// Helpper Methods / private
	// --------------------------

	protected String formateaImporteDecimal(BigDecimal importe) {
		return importe.toString().replace(".", ",");
	}

	// saldo = saldo + debe - haber
	protected BigDecimal calculateSaldo(BigDecimal saldo, final BigDecimal debe, final BigDecimal haber) {

		if (debe != null) {
			saldo = saldo.add(debe);		
		}

		if (haber != null) {
			saldo = saldo.subtract(haber);
		}

		return saldo;
	}

	public String obtenerNombresFiadores(final LiquidacionPCO liquidacion) {
		StringBuilder nombresFiadores = new StringBuilder("");
		List<ContratoPersona> contratosPersona = liquidacion.getContrato().getContratoPersona();
		
		int cuentaAvalista=0;
		int cuentaTmp=0;
		int i = 0;
		for(ContratoPersona cp : contratosPersona) {
			i++;
			if (cp.isAvalista()) {
				cuentaAvalista++;
			}
		}
		
		for (ContratoPersona cp : contratosPersona) {
            i++;
            if (cp.isAvalista()) {
            	cuentaTmp++;
            	nombresFiadores.append(cp.getPersona().getNom50());

                // mientras no sea el ultimo registro se concatenan los nombres con y
                /*if (contratosPersona.size() > i) {
                	nombresFiadores.append(" y ");
                }*/
            	//mientras no sea el último registro y exista más de un avalista concatenamos una y o una coma
            	if(cuentaAvalista > 1 && cuentaTmp < cuentaAvalista){
	            	if(cuentaTmp == (cuentaAvalista - 1)){
	            		nombresFiadores.append("y ");
	            	}else{
	            		nombresFiadores.append(", ");
	            	}
            	}
            }
        }
		
		return nombresFiadores.toString();
	}

	private String obtenerNombresTitulares(final LiquidacionPCO liquidacion) {
		StringBuilder nombresTitulares = new StringBuilder("");
		List<Persona> personasTitulares = liquidacion.getContrato().getTitulares();

		int i = 0;
		for (Persona p : personasTitulares) {
            i++;
            nombresTitulares.append(p.getNom50());

            // mientras no sea el ultimo registro se concatenan los nombres con y
            if (personasTitulares.size() > i) {
            	nombresTitulares.append(" y ");
            }
        }

		return nombresTitulares.toString();
	}

    private String obtenerNombreApoderado(final LiquidacionPCO liquidacion) {
    	StringBuilder nombreApoderado = new StringBuilder("");

    	if (liquidacion.getApoderado() == null) {
    		nombreApoderado.append("[NO-DISPONIBLE]");
    		return nombreApoderado.toString();
    	}

    	Usuario apoderado = liquidacion.getApoderado().getUsuario();

    	if (apoderado.getNombre() != null) {
        	nombreApoderado.append(apoderado.getNombre()).append(" ");
        }

        if (apoderado.getApellidos() != null) {
        	nombreApoderado.append(apoderado.getApellidos());
        }

        return nombreApoderado.toString();
    }
    
	/**
	 * @param CabeceraLiquidacionLiqVO
	 * 
	 * @return HashMap keys
	 * 
	 * 115_FIN_IMLIAC	->	String
	 * 115_FIN_FANTLQ	->	String
	 * 115_FIN_FEVALQ	->	String
	 */
	protected HashMap<String, Object> generarUltimaCabeceraLiquidacion(List<CabeceraLiquidacionLiqVO> cabeceraLiquidacion) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();

		if (cabeceraLiquidacion.isEmpty()) {
			datosLiquidacion.put("C15_FIN_IMLIAC", "[NO-DISPONIBLE]");
			datosLiquidacion.put("C15_FIN_FANTLQ", "[NO-DISPONIBLE]");
			datosLiquidacion.put("C15_FIN_FEVALQ", "[NO-DISPONIBLE]");
			datosLiquidacion.put("C15_FIN_FEFCON", "[NO-DISPONIBLE]");
			datosLiquidacion.put("C15_FIN_POINDB", "[NO-DISPONIBLE]");
			datosLiquidacion.put("C15_FIN_NCTAOP", "[NO-DISPONIBLE]");
			datosLiquidacion.put("C15_FIN_DESLIQ", "[NO-DISPONIBLE]");
			return datosLiquidacion;
		}
		
		int tam = cabeceraLiquidacion.size();
		datosLiquidacion.put("C15_FIN_IMLIAC", cabeceraLiquidacion.get(tam-1).IMLIAC());
		datosLiquidacion.put("C15_FIN_FANTLQ", cabeceraLiquidacion.get(tam-1).FANTLQ());
		datosLiquidacion.put("C15_FIN_FEVALQ", cabeceraLiquidacion.get(tam-1).FEVALQ());
		datosLiquidacion.put("C15_FIN_FEFCON", cabeceraLiquidacion.get(tam-1).FEFCON());
		datosLiquidacion.put("C15_FIN_POINDB", cabeceraLiquidacion.get(tam-1).POINDB());
		datosLiquidacion.put("C15_FIN_NCTAOP", cabeceraLiquidacion.get(tam-1).NCTAOP());
		datosLiquidacion.put("C15_FIN_DESLIQ", cabeceraLiquidacion.get(tam-1).DESLIQ());
		return datosLiquidacion;
	}
	
	protected boolean esBfa(Long idLiquidacion) {
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
}
