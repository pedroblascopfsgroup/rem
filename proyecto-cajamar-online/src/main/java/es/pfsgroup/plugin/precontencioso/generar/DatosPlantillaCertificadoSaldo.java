package es.pfsgroup.plugin.precontencioso.generar;

import java.util.Date;
import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

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

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private LiquidacionApi liquidacionApi;

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

		return datosDoc;
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
				Persona titularPrincipal = liquidacion.getContrato().getTitulares().get(0);
				resultado = titularPrincipal.getDirecciones().get(0).getLocalidad().getDescripcion();
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
				Persona titularPrincipal = liquidacion.getContrato().getTitulares().get(0);
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
