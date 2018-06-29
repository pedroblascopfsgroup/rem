package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import es.pfsgroup.commons.utils.Checks;

import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;

@Component
public class MSVAgruparActivosRestringido extends AbstractMSVActualizador implements MSVLiberator {
	
	private static final Integer COL_ID_ACTIVO = 1;
	private static final Integer COL_ID_ACTIVO_PRINC_AGRUP = 2;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Autowired
	AgrupacionAdapter agrupacionAdapter;
	
	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	ActivoAgrupacionApi activoAgrupacionApi;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPATION_RESTRICTED;
	}

	@Override
	@Transactional(readOnly = false)
	public void procesaFila(MSVHojaExcel exc, int fila) throws IOException, ParseException, JsonViewerException, SQLException {
		
		Long agrupationId = activoAgrupacionApi.getAgrupacionIdByNumAgrupRem(new Long(exc.dameCelda(fila, 0)));
		agrupacionAdapter.createActivoAgrupacion(new Long(exc.dameCelda(fila, 1)), agrupationId, new Integer(exc.dameCelda(fila, 2)));

	}
	
	@Override
	@Transactional(readOnly = false)
	public void postProcesado(MSVHojaExcel exc) throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		
		if (this.getValidOperation().equals(MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPATION_RESTRICTED)) {
			Integer numFilas = exc.getNumeroFilas();
	
			for (int fila = this.getFilaInicial(); fila < numFilas; fila++) {
				Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, COL_ID_ACTIVO_PRINC_AGRUP)));
				
				DtoDatosPublicacionActivo dto = new DtoDatosPublicacionActivo();
				dto.setIdActivo(activo.getId());
				
				if (activoApi.isActivoIntegradoAgrupacionRestringida(activo.getId())) {
					if (activoApi.isActivoPrincipalAgrupacionRestringida(activo.getId())) {
						ActivoAgrupacionActivo aga = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId());
						if (!Checks.esNulo(aga)) {
							activoEstadoPublicacionApi.setDatosPublicacionAgrupacion(aga.getAgrupacion().getId(), dto);
						}
					}
				}
			}
		}
	}

}
