package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVBorradoTrabajosValidator;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class MSVBorradoTrabajosCargaMasiva extends AbstractMSVActualizador implements MSVLiberator{
	private static final int FILA_CABECERA = 0;
	private static final int DATOS_PRIMERA_FILA = 1;
	
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
        try {
			Long numTrabajo = Long.parseLong(exc.dameCelda(fila, MSVBorradoTrabajosValidator.COL_NUM_TRABAJO));
			String valor = exc.dameCelda(fila, MSVBorradoTrabajosValidator.COL_ANULAR_BORRAR);
			boolean borrar = "B".equals(valor) || "b".equals(valor);
			Trabajo trabajo = trabajoApi.getTrabajoByNumeroTrabajo(numTrabajo);
			
			List <ActivoTramite> activosTramite = activoTramiteApi.getTramitesActivoTrabajoList(trabajo.getId());
			
			if(activosTramite.size() > 0) {
				for (ActivoTramite activoTramite : activosTramite) {
					if (activoTramite.getTareas() != null && !activoTramite.getTareas().isEmpty()) {
						Set<TareaActivo> tareasActivo = activoTramite.getTareas();
						
						if(tareasActivo.size() > 0) {
							for (TareaActivo tareaActivo :tareasActivo) {
								tareaActivoApi.deleteTareaActivoOnCascade(tareaActivo);                         
							}
						}
					}
					
					DDEstadoProcedimiento estadoCerrado = genericDao.get(DDEstadoProcedimiento.class, 
							genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO));
					
					if(estadoCerrado != null)
						activoTramite.setEstadoTramite(estadoCerrado);
					
					if(borrar)
						genericDao.deleteById(ActivoTramite.class, activoTramite.getId());
					else
						genericDao.update(ActivoTramite.class, activoTramite);
				}
        	}
			
			DDEstadoTrabajo estadoAnulado = genericDao.get(DDEstadoTrabajo.class, 
					genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoTrabajo.ESTADO_ANULADO));
			
			if(estadoAnulado != null)
				trabajo.setEstado(estadoAnulado);
			
			if(borrar)
				genericDao.deleteById(Trabajo.class, trabajo.getId());
			else
				genericDao.update(Trabajo.class, trabajo);
			
        }catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
	    
	    return new ResultadoProcesarFila();
		
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

}
