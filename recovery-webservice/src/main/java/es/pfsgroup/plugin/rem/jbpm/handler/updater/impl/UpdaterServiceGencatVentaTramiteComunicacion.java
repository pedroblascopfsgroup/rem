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
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;

@Component
public class UpdaterServiceGencatVentaTramiteComunicacion implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
            
    @Autowired
    private ComunicacionGencatApi comunicacionGencatApi;
    
    @Autowired
	private GencatApi gencatApi;
    
    private static final String FECHA_COMUNICACION = "fechaComunicacion";
    
	public static final String CODIGO_T016_COMUNICAR_GENCAT = "T016_ComunicarGENCAT";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {				
		if(!Checks.esNulo(tramite)) {
			List<Activo> activos = tramite.getActivos();
			for (Activo activo : activos) {
				ComunicacionGencat comunicacionGencat = comunicacionGencatApi.getByIdActivoCreado(activo.getId());
				if(!Checks.esNulo(comunicacionGencat)) {
					for(TareaExternaValor valor : valores) {
						if(FECHA_COMUNICACION.equals(valor.getNombre())) {
							
							try {
								comunicacionGencat.setFechaComunicacion(ft.parse(valor.getValor()));						
							} catch (ParseException e) {
								e.printStackTrace();
							}
											
						}
					}
					
					genericDao.save(ComunicacionGencat.class, comunicacionGencat);
					gencatApi.cambiarEstadoComunicacionGENCAT(comunicacionGencat);
					gencatApi.informarFechaSancion(comunicacionGencat);
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
