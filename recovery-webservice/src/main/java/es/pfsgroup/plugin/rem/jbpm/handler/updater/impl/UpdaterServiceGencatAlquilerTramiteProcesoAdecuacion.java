package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.AdecuacionGencatApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;

@Component
public class UpdaterServiceGencatAlquilerTramiteProcesoAdecuacion implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
            
    @Autowired
    private AdecuacionGencatApi adecuacionGencatApi;
    
    private static final String NECESITA_REFORMA = "necesitaReforma";
    private static final String FECHA_REVISION = "fechaRevision";
    private static final String IMPORTE = "importe";
    private static final String OBSERVACIONES = "observaciones";
    
	private static final String CODIGO_T016_PROCESO_ADECUACION = "T016_ProcesoAdecuacion";
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
				
		AdecuacionGencat adecuacionGencat = adecuacionGencatApi.getByIdActivo(tramite.getActivo().getNumActivo());
				
		if(!Checks.esNulo(tramite) && !Checks.esNulo(adecuacionGencat)) {
			
			for(TareaExternaValor valor : valores) {
				if(NECESITA_REFORMA.equals(valor.getNombre())) {
						
					if(valor.getValor().equals("Si")) {
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
					
					adecuacionGencat.setImporteReforma(Double.parseDouble(valor.getValor()));
									
				} else if(OBSERVACIONES.equals(valor.getNombre())) {
					//TODO El funcional no indica donde se guarda el campo.
				}
			}
			
			genericDao.save(AdecuacionGencat.class, adecuacionGencat);
			
		}
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T016_PROCESO_ADECUACION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
