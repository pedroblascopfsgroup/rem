package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgendaEvolucion;
import es.pfsgroup.plugin.rem.model.dd.DDCesionSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDClasificacionApple;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDServicerActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoAdmision;

/***
 * Clase que procesa el fichero de carga masiva valores perímetro Apple
 */
@Component
public class MSVActualizadorEstadosAdmision extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int FILA_DATOS = 1;

		static final int ACTIVO = 0;
		static final int ESTADO_ADMISION = 1;
		static final int SUBESTADO_ADMISION = 2;
	}

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ESTADOS_ADMISION;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		final String[] LISTA_SI = { "SI", "S" };
		final String FILTRO_CODIGO = "codigo";

		final String celdaActivo = exc.dameCelda(fila, COL_NUM.ACTIVO);
		final String celdaEstadoAdmision = exc.dameCelda(fila, COL_NUM.ESTADO_ADMISION);
		final String celdaSubestadoAdmision = exc.dameCelda(fila, COL_NUM.SUBESTADO_ADMISION);
		try {
			
			Activo activo = activoApi.getByNumActivo(Long.parseLong(celdaActivo));
			DDEstadoAdmision estadoAdmision = null;
			DDSubestadoAdmision subestadoAdmision = null;		
			
			// Estado admision
			if (!celdaEstadoAdmision.isEmpty()) {
				Filter filtroEstadoAdmision = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaEstadoAdmision.toUpperCase());
				estadoAdmision = genericDao.get(DDEstadoAdmision.class, filtroEstadoAdmision);
			}
			
			// Subestado admision
			if (!celdaSubestadoAdmision.isEmpty()) {
				Filter filtroSubestadoAdmision = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaSubestadoAdmision.toUpperCase());
				subestadoAdmision = genericDao.get(DDSubestadoAdmision.class, filtroSubestadoAdmision);
			}
			
			if(estadoAdmision != null) {
				ActivoAgendaEvolucion agendaEvolucion = new ActivoAgendaEvolucion();
				agendaEvolucion.setActivo(activo);			
				activo.setEstadoAdmision(estadoAdmision);
				activo.setSubestadoAdmision(subestadoAdmision);
				agendaEvolucion.setEstadoAdmision(estadoAdmision);
				agendaEvolucion.setSubEstadoAdmision(subestadoAdmision);
				genericDao.save(ActivoAgendaEvolucion.class, agendaEvolucion);				
					
				genericDao.update(Activo.class, activo);
			}
			
			return new ResultadoProcesarFila();
		}catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
	}

}
