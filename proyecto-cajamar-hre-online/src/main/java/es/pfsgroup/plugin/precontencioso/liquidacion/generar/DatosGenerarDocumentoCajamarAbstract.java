package es.pfsgroup.plugin.precontencioso.liquidacion.generar;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

/**
 * Contiene el codigo comun para generar datos para los documentos de Precontencioso para Cajamar
 * @author pedro.blasco
 */
public abstract class DatosGenerarDocumentoCajamarAbstract {

	/* CAMPOS COMUNES DE TODOS LOS DOCUMENTOS */
	public static final String DATOS_TITULARES = "DATOS_TITULARES";
	public static final String DATOS_FIADORES = "DATOS_FIADORES";
	public static final String NOMAPOTELEGRAMA = "NOMAPOTELEGRAMA";

	public static final String NOMOFI = "NOMOFI";
	public static final String NUMCUENTATELE = "NUMCUENTATELE";
	public static final String IMPCER = "IMPCER";
	
	public static final String NOMBRE_TITULAR_PRINCIPAL = "NOMBRE_TITULAR_PRINCIPAL";

	protected static final String CONECTOR_ESPACIO = " ";
	protected static final String CONECTOR_COMA = ", ";
	protected static final String CONECTOR_CONJUNCION = " y ";
	protected static final String CONECTOR_CON = " con ";

	private static final String INICIO_NO_DISP = "[CAMPO ";
	private static final String FIN_NO_DISP = " NO DISPONIBLE]";	

	private static final Locale localeSpa = new java.util.Locale("es", "ES");
	protected static final SimpleDateFormat formatFecha = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY, localeSpa);
	protected static final NumberFormat currencyInstance = NumberFormat.getCurrencyInstance(localeSpa);
	protected static final NumberFormat numberInstance = NumberFormat.getInstance(localeSpa);

	protected final Log logger = LogFactory.getLog(getClass());

	// Ver más formas de obtener datos en DatosPlantillaPrestamoAbstract
	
	/**
	 * @param liquidacion
	 * 
	 * @return HashMap keys:
	 * 
	 */
	protected HashMap<String, Object> obtenerDatosLiquidacionPco(final LiquidacionPCO liquidacion) {
		HashMap<String, Object> datosDocumento = new HashMap<String, Object>();

		if (liquidacion.getContrato() == null) {
			throw new BusinessOperationException(this.getClass().toString() + ".obtenerDatosLiquidacionPco: No se encuentra el contrato de la liquidacion");
		}

		// Contrato
		datosDocumento.put(DATOS_TITULARES, obtenerDatosTitulares(liquidacion));
		datosDocumento.put(DATOS_FIADORES, obtenerDatosFiadores(liquidacion));
		datosDocumento.put(NOMAPOTELEGRAMA, obtenerNombreApoderado(liquidacion));

		datosDocumento.put(NOMBRE_TITULAR_PRINCIPAL, obtenerNombreTitularPrincipal(liquidacion));

		datosDocumento.put(NOMOFI, obtenerNombreOficina(liquidacion.getContrato(), NOMOFI));
		datosDocumento.put(NUMCUENTATELE, obtenerNumeroCuenta(liquidacion.getContrato(), NUMCUENTATELE));
		datosDocumento.put(IMPCER, obtenerImporteLiquidacion(liquidacion, IMPCER));
		
		return datosDocumento;
	}

	private String obtenerNombreTitularPrincipal(final LiquidacionPCO liquidacion) {
		
		if (!liquidacion.getContrato().getTitulares().isEmpty()) {
			Persona titularPrincipal = liquidacion.getContrato().getTitulares().get(0);
			return titularPrincipal.getNom50();
		} else {
			return NOMBRE_TITULAR_PRINCIPAL;
		}
	}

	private String obtenerDatosTitulares(final LiquidacionPCO liquidacion) {
		
		StringBuilder datosTitulares = new StringBuilder("");
		List<Persona> personasTitulares = liquidacion.getContrato().getTitulares();
		int i = 0;
		for (Persona p : personasTitulares) {
            i++;
            datosTitulares.append(p.getNom50());
            datosTitulares.append(CONECTOR_ESPACIO);
            datosTitulares.append(p.getTipoDocumento().getDescripcion());
            datosTitulares.append(CONECTOR_ESPACIO);
            datosTitulares.append(p.getDocId());
            if (personasTitulares.size() > i-1) {
            	datosTitulares.append(CONECTOR_COMA);
            } else if (personasTitulares.size() == i-1) {
            	datosTitulares.append(CONECTOR_CONJUNCION);
            }
        }

		return datosTitulares.toString();
	}

	private String obtenerDatosFiadores(final LiquidacionPCO liquidacion) {
		
		StringBuilder nombresFiadores = new StringBuilder("");
		List<ContratoPersona> contratosPersona = liquidacion.getContrato().getContratoPersona();
		
		int cuentaAvalista=0;
		int cuentaTmp=0;
		for(ContratoPersona cp : contratosPersona) {
			if (cp.isAvalista()) {
				cuentaAvalista++;
			}
		}
		
		for (ContratoPersona cp : contratosPersona) {
            if (cp.isAvalista()) {
            	cuentaTmp++;
            	Persona p = cp.getPersona();
            	nombresFiadores.append(p.getNom50());
            	nombresFiadores.append(CONECTOR_CON);
            	nombresFiadores.append(p.getTipoDocumento().getDescripcion());
            	nombresFiadores.append(CONECTOR_ESPACIO);
            	nombresFiadores.append(p.getDocId());
            	//mientras no sea el último registro y exista más de un avalista concatenamos una y o una coma
            	if(cuentaAvalista > 1 && cuentaTmp < cuentaAvalista){
	            	if(cuentaTmp == (cuentaAvalista - 1)){
	            		nombresFiadores.append(CONECTOR_CONJUNCION);
	            	}else{
	            		nombresFiadores.append(CONECTOR_COMA);
	            	}
            	}
            }
        }

		return nombresFiadores.toString();
	}

	private String obtenerNombreApoderado(final LiquidacionPCO liquidacion) {
	
		StringBuilder nombreApoderado = new StringBuilder("");
	
		if (liquidacion.getApoderado() == null) {
			nombreApoderado.append(noDisponible(NOMAPOTELEGRAMA));
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

	// --------------------------
	// Helpper Methods / private
	// --------------------------
	protected String noDisponible(String campo) {
		logger.debug(campo + " no disponible"); 
		return INICIO_NO_DISP + campo + FIN_NO_DISP;
	}

	private String obtenerNumeroCuenta(Contrato contrato, String nombreCampo) {
		String resultado = "";
		try {
			resultado = contrato.getNroContratoFormat();
		} catch (NullPointerException e) {
			resultado = noDisponible(nombreCampo);
		}
		return resultado;
	}

	private String obtenerImporteLiquidacion(LiquidacionPCO liq, String nombreCampo) {
		String resultado = "";
		try {
			resultado = numberInstance.format(liq.getTotal());
		} catch (NullPointerException e) {
			resultado = noDisponible(nombreCampo);
		}
		return resultado;
	}

	protected String formateaFecha(Date fecha) {
		return formatFecha.format(fecha);
	}

	private String obtenerNombreOficina(Contrato contrato, String nombreCampo) {
		String resultado = "";
		try {
			resultado = contrato.getOficina().getNombre();
		} catch (NullPointerException e) {
			resultado = noDisponible(nombreCampo);
		}
		return resultado;
	}

//	protected String formateaImporteDecimal(BigDecimal importe) {
//		return importe.toString().replace(".", ",");
//	}
//
//	// saldo = saldo + debe - haber
//	protected BigDecimal calculateSaldo(BigDecimal saldo, final BigDecimal debe, final BigDecimal haber) {
//
//		if (debe != null) {
//			saldo = saldo.add(debe);		
//		}
//
//		if (haber != null) {
//			saldo = saldo.subtract(haber);
//		}
//
//		return saldo;
//	}
//
}
