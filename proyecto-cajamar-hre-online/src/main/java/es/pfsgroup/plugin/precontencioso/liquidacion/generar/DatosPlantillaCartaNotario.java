package es.pfsgroup.plugin.precontencioso.liquidacion.generar;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
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
 * Clase que obtiene los datos necesarios para rellenar la plantilla de carta de notario
 * 
 * @author pedro.blasco
 */
@Component
public class DatosPlantillaCartaNotario extends DatosGenerarDocumentoCajamarAbstract implements DatosPlantillaFactory {

	// Codigo de la liquidacion a la que aplica los datos
	private static final String SUFIJO_TIPO_CARTA_NOTARIO = "CARTA_NOTARIO";

	public static final String GEN_S_FECHADIAC = "GEN_S_FECHADIAC";

	public static final String NUMEXP = "NUMEXP";
	public static final String NOMBRES_TITULARES = "NOMBRES_TITULARES";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private LiquidacionApi liquidacionApi;

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String codigoTipoLiquidacion() {
		return SUFIJO_TIPO_CARTA_NOTARIO;
	}

	@Override
	public HashMap<String, Object> obtenerDatos(Long idLiquidacion) {
		
		HashMap<String, Object> datosDoc = new HashMap<String, Object>();

		LiquidacionPCO liquidacion = liquidacionApi.getLiquidacionPCOById(idLiquidacion);
		datosDoc.putAll(obtenerDatosLiquidacionPco(liquidacion));

		datosDoc.put(NOMBRES_TITULARES, obtenerNombresTitulares(liquidacion));
		datosDoc.put(NUMEXP, obtenerNumeroExpediente(liquidacion, NUMEXP));
		datosDoc.put(GEN_S_FECHADIAC, formateaFecha(new Date()));
		
		return datosDoc;
	}

	private String obtenerNombresTitulares(final LiquidacionPCO liquidacion) {
		
		StringBuilder datosTitulares = new StringBuilder("");
		List<Persona> personasTitulares = liquidacion.getContrato().getTitulares();
		int i = 0;
		for (Persona p : personasTitulares) {
            i++;
            datosTitulares.append(p.getNom50());
            if (personasTitulares.size() > i-1) {
            	datosTitulares.append(CONECTOR_COMA);
            } else if (personasTitulares.size() == i-1) {
            	datosTitulares.append(CONECTOR_CONJUNCION);
            }
        }

		return datosTitulares.toString();
	}

	private String obtenerNumeroExpediente(LiquidacionPCO liquidacion, String nombreCampo) {
		String resultado = "";
		try {
			resultado = liquidacion.getContrato().getIban();
		} catch (NullPointerException e) {
			resultado = noDisponible(nombreCampo);
		}
		return resultado;
	}


}
