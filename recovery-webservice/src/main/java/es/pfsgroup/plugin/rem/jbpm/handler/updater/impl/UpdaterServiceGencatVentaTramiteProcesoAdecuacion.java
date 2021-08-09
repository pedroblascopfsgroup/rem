package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.AdecuacionGencatApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;

@Component
public class UpdaterServiceGencatVentaTramiteProcesoAdecuacion implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
            
    @Autowired
    private AdecuacionGencatApi adecuacionGencatApi;
    
    private static final String NECESITA_REFORMA = "necesitaReforma";
    private static final String FECHA_REVISION = "fechaRevision";
    private static final String IMPORTE = "importeReforma";
    private static final String OBSERVACIONES = "observaciones";
    private static final String NECESITA_REFORMA_SI = "01";
    
	public static final String CODIGO_T016_PROCESO_ADECUACION = "T016_ProcesoAdecuacion";
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		List<Activo> activos = tramite.getActivos();
		for (Activo activo : activos) {
		AdecuacionGencat adecuacionGencat = adecuacionGencatApi.getAdecuacionByIdActivo(activo.getId());		
			if(!Checks.esNulo(tramite) && !Checks.esNulo(adecuacionGencat)) {
				for(TareaExternaValor valor : valores) {
					if(NECESITA_REFORMA.equals(valor.getNombre())) {
							
						if(valor.getValor().equals(NECESITA_REFORMA_SI)) {
							adecuacionGencat.setNecesitaReforma(true);
						} else {
							adecuacionGencat.setNecesitaReforma(false);
						}
						
					} else if(FECHA_REVISION.equals(valor.getNombre())) {
	
						try {						
							adecuacionGencat.setFechaRevision(ft.parse(valor.getValor()));						
						} catch (ParseException e) {
							e.printStackTrace();
						}
						
					} else if(IMPORTE.equals(valor.getNombre())) {
						if(!Checks.esNulo(valor.getValor())) {
							String valorString=valor.getValor();
							if(valorString.contains(",")) {
								valorString = valorString.replace(",", ".");
							}
							adecuacionGencat.setImporteReforma(Double.valueOf(valorString));
						}
										
					} else if(OBSERVACIONES.equals(valor.getNombre())) {
						//TODO El funcional no indica donde se guarda el campo.
					}
				}
				
				genericDao.save(AdecuacionGencat.class, adecuacionGencat);
				
			}
		}
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T016_PROCESO_ADECUACION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
