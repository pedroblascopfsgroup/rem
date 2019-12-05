package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;

@Component
public class MSVBorradoTrabajosCargaMasiva extends AbstractMSVActualizador implements MSVLiberator{
	private static final int FILA_CABECERA = 0;
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int COL_NUM_TRABAJO = 0;
	
	@Autowired
    private GenericABMDao genericDao;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private TareaActivoApi tareaActivoApi;
	
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SUPER_BORRADO_TRABAJOS;
	}
	
    @Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
        
	        Long numTrabajo = Long.parseLong(exc.dameCelda(fila, COL_NUM_TRABAJO)); 
	        if (Boolean.FALSE.equals(Checks.esNulo(numTrabajo)) ) {             
	                Trabajo trabajo = trabajoApi.getTrabajoByNumeroTrabajo(numTrabajo);
	                List <ActivoTramite> activosTramite = activoTramiteApi.getTramitesActivoTrabajoList(trabajo.getId());
	                for (ActivoTramite activoTramite : activosTramite) {
	                    genericDao.deleteById(ActivoTramite.class, activoTramite.getId());
	                    genericDao.update(ActivoTramite.class, activoTramite);
	                     
	                    if (activoTramite.getTareas() != null && !activoTramite.getTareas().isEmpty()) {
	                        Set<TareaActivo> tareasActivo = activoTramite.getTareas();
	                        for (TareaActivo tareaActivo :tareasActivo) {
	                            tareaActivoApi.deleteTareaActivoOnCascade(tareaActivo);	                        
	                        }
	                        
	                    }
	                }              
	                genericDao.deleteById(Trabajo.class, trabajo.getId());
	                genericDao.update(Trabajo.class, trabajo);
	                
	        } else {
	          throw new ParseException("Error al procesar la fila ", fila);
	        }
	    

	    return new ResultadoProcesarFila();
		
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

}
