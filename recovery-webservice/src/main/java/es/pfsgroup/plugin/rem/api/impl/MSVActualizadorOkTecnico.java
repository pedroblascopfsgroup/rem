package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class MSVActualizadorOkTecnico extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	ActivoApi activoApi;

	@Autowired
	ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Autowired UpdaterStateApi updaterStateApi;
	
	private List<String> activarOkTecnicoValidos = Arrays.asList("S","SI");
	private List<String> desactivarOkTecnicoValidos = Arrays.asList("N","NO");
	private String motivo = "Publicación Ok Técnico";

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CENTRAL_TECNICA_OK_TECNICO;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		String oktecnico = exc.dameCelda(fila, 1);
		if(!Checks.esNulo(oktecnico) && (activarOkTecnicoValidos.contains(oktecnico) || desactivarOkTecnicoValidos.contains(oktecnico)) && !Checks.esNulo(activo)) {
			if(activarOkTecnicoValidos.contains(oktecnico)){
				activo.setTieneOkTecnico(true);
			}else if(desactivarOkTecnicoValidos.contains(oktecnico)){
				activo.setTieneOkTecnico(false);
			}
			
			activoApi.saveOrUpdate(activo);
			
			DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion = activoEstadoPublicacionApi.getState(activo.getId());
			
			dtoCambioEstadoPublicacion.setActivo(activo.getId());
			dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
			dtoCambioEstadoPublicacion.setPublicacionForzada(false);
			dtoCambioEstadoPublicacion.setMotivoPublicacion(motivo);
			
			activoEstadoPublicacionApi.publicacionChangeState(dtoCambioEstadoPublicacion);
			
		}
		return new ResultadoProcesarFila();
	}
	

}
