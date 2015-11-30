package es.pfsgroup.plugin.precontencioso.liquidacion.manager;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarLiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.DatosLiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.vo.BienLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.vo.ConceptoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.vo.InteresesContratoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.vo.RecibosLiqVO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBInformacionRegistralBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
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
		datosLiquidacion.putAll(generarInteresesContrato(interesesContratoLiq));
		datosLiquidacion.putAll(generarCamposConceptosFijos(datosGenerales.get(0), recibosLiq, interesesContratoLiq));

		datosLiquidacion.put("NUM_CONTRATO", datosGenerales.get(0).IDPRIG());
		datosLiquidacion.put("FECHA_FIRMA", datosGenerales.get(0).FEVACM());
		datosLiquidacion.put("CIUDAD_FIRMA", "Madrid");

		return datosLiquidacion;
	}

	private HashMap<String, Object> obtenerDatosLiquidacionPco(final LiquidacionPCO liquidacion) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();

		if (liquidacion.getContrato() == null) {
			throw new BusinessOperationException("GenerarLiquidacionBankiaManager.obtenerDatosLiquidacionPco: No se encuentra el contrato de la liquidacion");
		}

		// Contrato
		datosLiquidacion.put("NOMBRES_TITULARES", obtenerNombresTitulares(liquidacion));
		datosLiquidacion.put("NOMBRES_FIADORES", obtenerNombresFiadores(liquidacion));
		datosLiquidacion.put("NOMBRE_APODERADO", obtenerNombreApoderado(liquidacion));

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

		datosLiquidacion.put("BIENES", bienes);
		datosLiquidacion.put("BIENES_CONCATENADOS", bienesConcatenados.toString());

		if (!liquidacion.getContrato().getTitulares().isEmpty()) {
			Persona titualPrincipal = liquidacion.getContrato().getTitulares().get(0);
			datosLiquidacion.put("NOMBRE_TITULAR_PRINCIPAL", titualPrincipal.getNom50());
		} else {
			throw new BusinessOperationException("GenerarLiquidacionBankiaManager.obtenerDatosLiquidacionPco: No se encuentra el titular del contrato");
		}

		return datosLiquidacion;
	}

	private String obtenerNombresFiadores(final LiquidacionPCO liquidacion) {
		StringBuilder nombresFiadores = new StringBuilder("");
		List<ContratoPersona> contratosPersona = liquidacion.getContrato().getContratoPersona();

		int i = 0;
		for (ContratoPersona cp : contratosPersona) {
            i++;
            if (cp.isAvalista()) {
            	nombresFiadores.append(cp.getPersona().getNom50());

                // mientras no sea el ultimo registro se concatenan los nombres con y
                if (contratosPersona.size() > i) {
                	nombresFiadores.append(" y ");
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

		datosLiquidacion.put("SUM_LQ04_IMCPRC", NumberFormat.getInstance(new Locale("es", "ES")).format(imcprc));
		datosLiquidacion.put("SUM_LQ04_IMPRTV", NumberFormat.getInstance(new Locale("es", "ES")).format(imprtv));
		datosLiquidacion.put("SUM_LQ04_IMCGTA", NumberFormat.getInstance(new Locale("es", "ES")).format(imcgta));
		datosLiquidacion.put("SUM_LQ04_IMINDR", NumberFormat.getInstance(new Locale("es", "ES")).format(imindr));
		datosLiquidacion.put("SUM_LQ04_IMBIM4", NumberFormat.getInstance(new Locale("es", "ES")).format(imbim4));
		datosLiquidacion.put("SUM_LQ04_IMDEUD", NumberFormat.getInstance(new Locale("es", "ES")).format(imdeud));

		return datosLiquidacion;
	}

	private HashMap<String, Object> generarInteresesContrato(List<InteresesContratoLiqVO> interesesContratoLiq) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();

		if (interesesContratoLiq.isEmpty()) {
			datosLiquidacion.put("INI_LQ07_CDINTS", "[NO-DISPONIBLE]");
			return datosLiquidacion;
		}

		datosLiquidacion.put("INI_LQ07_CDINTS", interesesContratoLiq.get(0).CDINTS());

		return datosLiquidacion;
	}

	private HashMap<String, Object> generarCamposConceptosFijos(final DatosGeneralesLiqVO datosGeneralesLiq, final List<RecibosLiqVO> recibosLiq, final List<InteresesContratoLiqVO> interesesContratoLiq) {
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
		Date fechaAuxIntOrd = new Date();
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

	private String formateaImporteDecimal(BigDecimal importe) {
		return importe.toString().replace(".", ",");
	}

	// saldo = saldo + debe - haber
	private BigDecimal calculateSaldo(BigDecimal saldo, final BigDecimal debe, final BigDecimal haber) {

		if (debe != null) {
			saldo = saldo.add(debe);		
		}

		if (haber != null) {
			saldo = saldo.subtract(haber);
		}

		return saldo;
	}

	@Override
	public List<DDTipoLiquidacionPCO> getPlantillasLiquidacion(){
		List<DDTipoLiquidacionPCO> plantillas = diccionarioApi.dameValoresDiccionario(DDTipoLiquidacionPCO.class);
		return plantillas;
	}
}
