package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.util.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Arrays;
import java.util.List;

import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;

@Component
public class MSVActualizadorOkTecnicoSelloCalidad extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	private List<String> comprobacionTrue = Arrays.asList("S","SI");
	private List<String> comprobacionFalse = Arrays.asList("N","NO");
	
	

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CENTRAL_TECNICA_OK_TECNICO_SELLO_CALIDAD;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		String oktecnico = exc.dameCelda(fila, 1);
		String selloCalidad = exc.dameCelda(fila, 2);
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		if (activo != null && (comprobacionTrue.contains(oktecnico) || comprobacionFalse.contains(oktecnico)) || (comprobacionTrue.contains(selloCalidad) || comprobacionFalse.contains(selloCalidad))) {
			
			if(comprobacionTrue.contains(oktecnico)){
				activo.setTieneOkTecnico(true);
			}else if(comprobacionFalse.contains(oktecnico)){
				activo.setTieneOkTecnico(false);
			}

			if (comprobacionTrue.contains(selloCalidad)) {
				activo.setSelloCalidad(true);
				activo.setGestorSelloCalidad(usuarioLogado);
				activo.setFechaRevisionSelloCalidad(new Date());
			}else if(comprobacionFalse.contains(selloCalidad)) {
				activo.setSelloCalidad(false);
				activo.setGestorSelloCalidad(usuarioLogado);
				activo.setFechaRevisionSelloCalidad(new Date());
			}

			activoApi.saveOrUpdate(activo);
			activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
			
		}

		return new ResultadoProcesarFila();
		
		/*if(!Checks.esNulo(oktecnico) && (activarOkTecnicoValidos.contains(oktecnico) || desactivarOkTecnicoValidos.contains(oktecnico)) && !Checks.esNulo(activo)) {
			
			if(activarOkTecnicoValidos.contains(oktecnico)){
				activo.setTieneOkTecnico(true);
			}else if(desactivarOkTecnicoValidos.contains(oktecnico)){
				activo.setTieneOkTecnico(false);
				
			}
			
			activoApi.saveOrUpdate(activo);

			activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
		}*/

	}

}