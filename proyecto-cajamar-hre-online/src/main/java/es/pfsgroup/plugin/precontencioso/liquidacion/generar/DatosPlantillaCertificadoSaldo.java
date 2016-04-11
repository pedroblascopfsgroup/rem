package es.pfsgroup.plugin.precontencioso.liquidacion.generar;

import java.util.Date;
import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;

/**
 * Clase que obtiene los datos necesarios para rellenar las plantillas de certificado de saldo
 * 
 * @author pedro.blasco
 */
@Component
public class DatosPlantillaCertificadoSaldo extends DatosGenerarDocumentoCajamarAbstract implements DatosPlantillaFactory {

	// Codigo de la liquidacion a la que aplica los datos
	private static final String SUFIJO_TIPO_CERTIFICADO_DE_SALDO = "CS_";

	public static final String GEN_LOC2 = "GEN_LOC2";
	public static final String DIROFI = "DIROFI";
	public static final String FECHAHOY = "FECHAHOY";
	public static final String GEN_S_FECHADIAC = "GEN_S_FECHADIAC";


	/* CAMPOS DE ALGUNOS DOCUMENTOS */
	public static final String CAL_RUT_POLIZA = "CAL_RUT_POLIZA";
	public static final String FECFORMALIZ = "FECFORMALIZ";
	public static final String INTMORATEL = "INTMORATEL";
	public static final String COMISAPER = "COMISAPER";
	public static final String FECVENCIM = "FECVENCIM";
	public static final String FECHALIQTELEGRAM = "FECHALIQTELEGRAM";
	public static final String CAPITALCER = "CAPITALCER";
	public static final String INTERESCER = "INTERESCER";
	public static final String IMPINTERESTELEG = "IMPINTERESTELEG";
	public static final String IMPCOMITELEG = "IMPCOMITELEG";
	public static final String DEMORACER = "DEMORACER";
	public static final String TEXTO_FECVENCIMTELEG = "TEXTO_FECVENCIMTELEG";
	public static final String VIVHABITUAL = "VIVHABITUAL";
	public static final String INTERESINITELEG = "INTERESINITELEG";
	public static final String COMIAPERTEL = "COMIAPERTEL";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private LiquidacionApi liquidacionApi;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String codigoTipoLiquidacion() {
		return SUFIJO_TIPO_CERTIFICADO_DE_SALDO;
	}

	@Override
	public HashMap<String, Object> obtenerDatos(Long idLiquidacion) {
		
		HashMap<String, Object> datosDoc = new HashMap<String, Object>();

		LiquidacionPCO liquidacion = liquidacionApi.getLiquidacionPCOById(idLiquidacion);
		datosDoc.putAll(obtenerDatosLiquidacionPco(liquidacion));

		datosDoc.put(GEN_LOC2, obtenerLocalidadTitularPrincipal(liquidacion, GEN_LOC2));
		datosDoc.put(DIROFI, obtenerDireccionTitularPrincipal(liquidacion, DIROFI));
		datosDoc.put(GEN_S_FECHADIAC, formateaFecha(new Date()));
		datosDoc.put(FECHAHOY, obtenerFechaConfirmacion(liquidacion, FECHAHOY));

		Contrato cnt = liquidacion.getContrato();
		datosDoc.put(CAL_RUT_POLIZA,obtenerImportePrestamo(liquidacion, CAL_RUT_POLIZA));
		datosDoc.put(FECFORMALIZ, obtenerFechaFormalizacion(cnt, FECFORMALIZ));
		datosDoc.put(INTMORATEL, obtenerTipoInteresDemora(cnt, INTMORATEL));
		datosDoc.put(COMISAPER, obtenerTipoComision(liquidacion, COMISAPER));
		datosDoc.put(FECVENCIM, obtenerFechaVencimiento(cnt, FECVENCIM));
		datosDoc.put(FECHALIQTELEGRAM, obtenerFechaLiquidacion(liquidacion, FECHALIQTELEGRAM));
		datosDoc.put(CAPITALCER, obtenerImporteCapitalPendiente(liquidacion, CAPITALCER));
		datosDoc.put(INTERESCER, obtenerImporteInteresesRemuneratorios(liquidacion, INTERESCER));
		datosDoc.put(IMPINTERESTELEG, obtenerImporteIntereseCreditoDispuesto(liquidacion, IMPINTERESTELEG));
		datosDoc.put(IMPCOMITELEG, obtenerImporteComisionesPagadas(liquidacion, IMPCOMITELEG));
		datosDoc.put(DEMORACER, obtenerImporteInteresesMoratorios(liquidacion, DEMORACER));
		datosDoc.put(TEXTO_FECVENCIMTELEG, obtenerTextoVencimientoAnticipado(liquidacion, TEXTO_FECVENCIMTELEG));
		datosDoc.put(VIVHABITUAL, obtenerTextoViviendaHabitual(cnt, VIVHABITUAL));
		datosDoc.put(INTERESINITELEG, obtenerTipoInteresPrestamo(cnt, INTERESINITELEG));
		datosDoc.put(COMIAPERTEL, obtenerTipoComisionApert(liquidacion, COMIAPERTEL));
		datosDoc.put(NUMCUENTATELE, obtenerNumeroCuentaCompleto((EXTContrato) cnt, NUMCUENTATELE));

		return datosDoc;
	}

	private String obtenerNumeroCuentaCompleto(EXTContrato cnt,	String campo) 
	{
		String resultado = noDisponible(campo);
		if(!Checks.esNulo(cnt.getCharextra8())) {
			resultado = cnt.getCharextra8();
		}
		
		return resultado;
	}

	private String obtenerTipoComisionApert(LiquidacionPCO liquidacion,	String campo) {
		String resultado = noDisponible(campo);
		if (!Checks.esNulo(liquidacion.getComisiones())) {
			resultado = numberInstance.format( liquidacion.getComisiones());
		}
		return resultado;
	}

	private String obtenerImporteComisionesPagadas(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo);
		if (!Checks.esNulo(liquidacion.getComisiones())) {
			resultado = numberInstance.format( liquidacion.getComisiones());
		}
		return resultado;
	}

	private String obtenerImporteIntereseCreditoDispuesto(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo);
		if (!Checks.esNulo(liquidacion.getInteresesOrdinarios())) {
			resultado = numberInstance.format( liquidacion.getInteresesOrdinarios());
		}
		return resultado;
	}

	private String obtenerTipoComision(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo);
		if (!Checks.esNulo(liquidacion.getComisiones())) {
			resultado = numberInstance.format( liquidacion.getComisiones());
		}
		return resultado;
	}

	private String obtenerTipoInteresPrestamo(Contrato contrato, String campo) {
		String resultado = noDisponible(campo); 
		try {
			resultado = numberInstance.format(contrato.getTipoInteres());
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		return resultado;
	}

	private String obtenerTextoViviendaHabitual(Contrato contrato, String campo) {
		boolean isViviendaHabitual = false;
		try {
			if (!Checks.esNulo(contrato) && !Checks.estaVacio(contrato.getBienes())) {
				for (Bien bien : contrato.getBienes()) {
					NMBBien nmbBien = (NMBBien) bien;
					if ("1".equals(nmbBien.getViviendaHabitual())) {
						isViviendaHabitual = true;
					}
				}
			}
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		StringBuffer sb = new StringBuffer("");
		if (isViviendaHabitual) {
			sb.append("Se hace constar que esta Entidad considera, salvo error, que el bien hipotecado constituye la Vivienda Habitual del/los deudor/es, ");
			sb.append("por lo que la presente liquidación se ha efectuado conforme a lo pactado por las partes y bajo el amparo de los límites establecidos ");
			sb.append("en la Ley 1/2013 de 14 de Mayo de Medidas para Reforzar la Protección a los Deudores Hipotecarios, Reestructuración de Deuda y Alquiler Social, ");
			sb.append("y en concreto por lo preceptuado en su Disposición Transitoria Segunda y en la nueva redacción del Art 114 de la Ley Hipotecaria.");			
		} else {
			sb.append("Esta Entidad hace constar que, salvo error, el/los bien/es hipotecado/s no constituye/n la vivienda habitual del/los deudor/es.");
		}
		return sb.toString();
	}

	private String obtenerImporteInteresesMoratorios(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo); 
		try {
			resultado = numberInstance.format(liquidacion.getInteresesDemora());
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		return resultado;
	}

	private String obtenerTextoVencimientoAnticipado(LiquidacionPCO liquidacion, String campo) {
		String resultado = "";
		if (!Checks.esNulo(liquidacion.getFechaCierre())) {
			StringBuffer sb = new StringBuffer(", al haberse dado por vencido anticipadamente el crédito con fecha ");
			sb.append(formateaFecha(liquidacion.getFechaCierre()));
			sb.append(", con reclamación del total de la deuda pendiente de pago, así como los intereses y gastos ");
			sb.append("correspondientes en virtud de lo pactado en  las CONDICIONES GENERALES,  Cláusula “8“, Apartado “A” de la referida póliza)");
			resultado = sb.toString();
		} 
		return resultado;
	}

	private String obtenerImporteInteresesRemuneratorios(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo); 
		try {
			resultado = numberInstance.format(liquidacion.getInteresesOrdinarios());
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		return resultado;
	}

	private String obtenerImporteCapitalPendiente(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo); 
		try {
			resultado = numberInstance.format(liquidacion.getCapitalNoVencido());
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		return resultado;
	}

	private String obtenerFechaLiquidacion(LiquidacionPCO liquidacion, String campo) {
		String resultado = "";
		if (!Checks.esNulo(liquidacion.getFechaConfirmacion())) {
			resultado = formateaFecha(liquidacion.getFechaConfirmacion());
		} else {
			logger.debug(campo + " es nulo");
			resultado = noDisponible(campo);
		}
		return resultado;
	}

	private String obtenerFechaVencimiento(Contrato contrato, String campo) {
		String resultado = "";
		if (!Checks.esNulo(contrato.getFechaVencimiento())) {
			resultado = formateaFecha(contrato.getFechaVencimiento());
		} else {
			logger.debug(campo + " es nulo");
			resultado = noDisponible(campo);
		}
		return resultado;
	}

	private String obtenerTipoInteresDemora(Contrato contrato,	String campo) {
		
		String resultado = noDisponible(campo);
		if (!Checks.esNulo(contrato.getInteresesDemora())) {
			resultado = contrato.getInteresesDemora(); 
		}
		return resultado;
	}

	private String obtenerFechaFormalizacion(Contrato contrato, String campo) {
		String resultado = "";
		if (!Checks.esNulo(contrato.getFechaCreacion())) {
			resultado = formateaFecha(contrato.getFechaCreacion());
		} else {
			logger.debug(campo + " es nulo");
			resultado = noDisponible(campo);
		}
		return resultado;
	}

	private String obtenerImportePrestamo(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo); 
		try {
			resultado = numberInstance.format(liquidacion.getCapitalVencido().add(liquidacion.getCapitalNoVencido()));
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		return resultado;
	}

	private String obtenerFechaConfirmacion(LiquidacionPCO liq, String nombreCampo) {
		String resultado = "";
		if (!Checks.esNulo(liq.getFechaConfirmacion())) {
			resultado = formateaFecha(liq.getFechaConfirmacion());
		} else {
			logger.debug(nombreCampo + " es nulo");
			resultado = noDisponible(nombreCampo);
		}
		return resultado;
	}
	
	private String obtenerLocalidadTitularPrincipal(final LiquidacionPCO liquidacion, final String nombreCampo) {
		
		String resultado = noDisponible(nombreCampo);
		if (!liquidacion.getContrato().getTitulares().isEmpty()) {
			try {
				Persona titularPrincipal = liquidacion.getContrato().getPrimerTitular();
				Direccion dir = titularPrincipal.getDirecciones().get(0);
				if (!Checks.esNulo(dir)) {
					if (!Checks.esNulo(dir.getLocalidad()) && !Checks.esNulo(dir.getLocalidad().getDescripcion())) {
						resultado = dir.getLocalidad().getDescripcion();
					} else if (!Checks.esNulo(dir.getNomPoblacion())) {
						resultado = (genericDao.get(Localidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dir.getNomPoblacion()))).getDescripcion();
					} else if (!Checks.esNulo(dir.getMunicipio())) {
						resultado = dir.getMunicipio();
					}
				}
				resultado = dir.getLocalidad().getDescripcion();
			} catch (NullPointerException e) {
				logger.debug(nombreCampo + " es nulo");
			} catch (IndexOutOfBoundsException e) {
				logger.debug(nombreCampo + " no tiene titular o direcciones asociadas.");
			}
		}
		return resultado;

	}

	private String obtenerDireccionTitularPrincipal(final LiquidacionPCO liquidacion, final String nombreCampo) {
		
		String resultado = noDisponible(nombreCampo);
		if (!liquidacion.getContrato().getTitulares().isEmpty()) {
			try {
				Persona titularPrincipal = liquidacion.getContrato().getPrimerTitular();
				resultado = construyeDireccion(titularPrincipal.getDirecciones().get(0));
			} catch (NullPointerException e) {
				logger.debug(nombreCampo + " es nulo");
			} catch (IndexOutOfBoundsException e) {
				logger.debug(nombreCampo + " no tiene titular o direcciones asociadas.");
			}
		}
		return resultado;

	}

	private String construyeDireccion(Direccion dir) {
		
		String resultado = "";
		if (!Checks.esNulo(dir.getTipoVia()) && !Checks.esNulo(dir.getTipoVia().getDescripcion())) {			
			resultado += dir.getTipoVia().getDescripcion().trim();
		}
		if (!Checks.esNulo(dir.getDomicilio())) {			
			resultado += " " + dir.getDomicilio().trim();
		}
		if (!Checks.esNulo(dir.getDomicilio_n())) {
			resultado += " " + dir.getDomicilio_n().trim();
		}
		return resultado.trim().toUpperCase();
	}

}
