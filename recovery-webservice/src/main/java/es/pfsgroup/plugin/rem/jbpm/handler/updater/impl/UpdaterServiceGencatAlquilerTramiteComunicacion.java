package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;

@Component
public class UpdaterServiceGencatAlquilerTramiteComunicacion implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
            
    @Autowired
    private ComunicacionGencatApi comunicacionGencatApi;
    
    private static final String FECHA_COMUNICACION = "fechaComunicacion";
    
	private static final String CODIGO_T016_COMUNICAR_GENCAT = "T016_ComunicarGENCAT";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		
		ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivoEstadoCreado(tramite.getActivo().getNumActivo());
						
		if(!Checks.esNulo(tramite)) {
			
			for(TareaExternaValor valor : valores) {
				if(FECHA_COMUNICACION.equals(valor.getNombre())) {
					
					try {
						comunicacionGencat.setFechaComunicacion(ft.parse(valor.getValor()));
					} catch (ParseException e) {
						e.printStackTrace();
					}
					
					genericDao.save(ComunicacionGencat.class, comunicacionGencat);
										
					break;
				}
			}
			
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T016_COMUNICAR_GENCAT};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
