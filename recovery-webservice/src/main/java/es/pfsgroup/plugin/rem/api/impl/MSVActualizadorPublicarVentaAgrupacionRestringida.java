package es.pfsgroup.plugin.rem.api.impl;

import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;

@Component
public class MSVActualizadorPublicarVentaAgrupacionRestringida extends AbstractMSVActualizador implements MSVLiberator {

	private static final Integer COL_ID_ACTIVO_PRINCIPAL = 0;

	@Autowired
	ProcessAdapter processAdapter;
	@Autowired
	ActivoApi activoApi;
	@Autowired
	ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	@Autowired
	ActivoAgrupacionApi activoAgrupacionApi;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPACION_VENTA_RESTRINGIDA;
	}

	@Override
	@Transactional(readOnly = false)
	public void procesaFila(MSVHojaExcel exc, int fila) throws IOException, ParseException, JsonViewerException, SQLException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, COL_ID_ACTIVO_PRINCIPAL)));
 		List<ActivoAgrupacionActivo> agrupacionesActivo = activo.getAgrupaciones();
 		for(ActivoAgrupacionActivo aga : agrupacionesActivo) {
 			if(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(aga.getAgrupacion().getTipoAgrupacion().getCodigo())) {
 	 			DtoDatosPublicacionActivo dto = new DtoDatosPublicacionActivo();
 	 			dto.setIdActivo(activo.getId());
 	 			dto.setPublicarVenta(true);
 	 			activoEstadoPublicacionApi.setDatosPublicacionAgrupacion(aga.getAgrupacion().getId(), dto);
 			}
 		}
	}

}
 