package es.pfsgroup.plugin.rem.api.impl;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionAgrupacion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

@Component
public class MSVActualizadorPublicarAlquiler extends AbstractMSVActualizador implements MSVLiberator {

	private static final Integer COL_ID_ACTIVO = 0;
	private static final Integer COL_OCULTAR_PRECIO = 1;
	private static final Integer COL_PUBLICAR_SIN_PRECIO = 2;

	@Autowired
	ActivoApi activoApi;
	
	@Autowired
	ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_PUBLICAR_ACTIVOS_ALQUILER;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, COL_ID_ACTIVO)));

		DtoDatosPublicacionAgrupacion dto = new DtoDatosPublicacionAgrupacion();
		dto.setIdActivo(activo.getId());
		dto.setPublicarAlquiler(true);

		if (!Checks.esNulo(exc.dameCelda(fila, COL_OCULTAR_PRECIO))) {
			dto.setNoMostrarPrecioAlquiler(this.obtenerBooleanExcel(exc.dameCelda(fila, COL_OCULTAR_PRECIO)));
		}

		if (!Checks.esNulo(exc.dameCelda(fila, COL_PUBLICAR_SIN_PRECIO))) {
			dto.setPublicarSinPrecioAlquiler(this.obtenerBooleanExcel(exc.dameCelda(fila, COL_PUBLICAR_SIN_PRECIO)));
		}
	
		if (activoApi.isActivoIntegradoAgrupacionRestringida(activo.getId())) {
			if (activoApi.isActivoPrincipalAgrupacionRestringida(activo.getId())) {
				ActivoAgrupacionActivo aga = activoApi.getActivoAgrupacionActivoAgrRestringidaPorActivoID(activo.getId());
				if (!Checks.esNulo(aga)) {
					activoEstadoPublicacionApi.setDatosPublicacionAgrupacion(aga.getAgrupacion().getId(), dto);
				}
			}

		} else {
			activoEstadoPublicacionApi.setDatosPublicacionActivo(dto);
		}
		
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(activo, null, false,false);

		return new ResultadoProcesarFila();
	}

	/**
	 * Este método devuelve un objeto Boolean regulado de la celda excel.
	 *
	 * @param celdaExcel : valor Boolean de la celda excel a analizar.
	 * @return Devuelve False si la celda está vacía, True si el String es S/SI o False en cualquier otro caso.
	 */
	private Boolean obtenerBooleanExcel(String celdaExcel) {
		return !Checks.esNulo(celdaExcel) && (celdaExcel.equalsIgnoreCase("s") || celdaExcel.equalsIgnoreCase("si"));
	}

}
