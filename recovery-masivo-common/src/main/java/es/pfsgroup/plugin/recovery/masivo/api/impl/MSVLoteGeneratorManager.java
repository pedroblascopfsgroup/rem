package es.pfsgroup.plugin.recovery.masivo.api.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.masivo.api.MSVLoteGeneratorApi;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVLote;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;

/**
 * Clase que implementa la interfaz del generador de lotes.
 * 
 * @author manuel
 *
 */
@SuppressWarnings("deprecation")
@Service
public class MSVLoteGeneratorManager implements MSVLoteGeneratorApi{

	@Autowired
	GenericABMDao genericDao;
	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.lotefactory.MSVLoteGenerator#getNumeroLote(es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel, es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva)
	 */
	@Override
	public String getNumeroLote(MSVHojaExcel exc, MSVDDOperacionMasiva tipoOperacion) {

		String codigoOperacion = "";
		
		if (tipoOperacion != null){
			codigoOperacion = tipoOperacion.getCodigo();
		}
			
		String loteDesc = this.creaLote(codigoOperacion, new Date());
		
		this.guardaLote(loteDesc);
		
		return loteDesc;
	}
	
	/**
	 * Crea un lote para asociarlo a una operación masiva.
	 * Guarda el lote en la tabla de lotes.
	 * @param codigoOperacion código de la operación masiva.
	 * @param fecha fecha de liberación del proceso.
	 * @return String con el formato CCC-YYYYMMDD-HHMISS
	 * donde CCC es el código de operación, 
	 * y YYYMMDD-HHMISS es la fecha.
	 *
	 */
	private String creaLote(String codigoOperacion, Date fecha) {
		
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd-HHmmSS");
		String loteDesc = (new StringBuffer(codigoOperacion).append("-").append(df.format(fecha))).toString();
		return loteDesc;
	}

	/**
	 * Crea un objeto {@link MSVLote} y lo guarda en la base de datos.
	 * @param loteDesc String número de lote.
	 */
	private void guardaLote(String loteDesc) {
		
		MSVLote lote = new  MSVLote();
		lote.setDescripcion(loteDesc);
		lote.setDescripcionLarga(loteDesc);
		genericDao.save(MSVLote.class, lote);
		
	}

	@Override
	public int getPrioridad() {
		return 0;
	}

}
