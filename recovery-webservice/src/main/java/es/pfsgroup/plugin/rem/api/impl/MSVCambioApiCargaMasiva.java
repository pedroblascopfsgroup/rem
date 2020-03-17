package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.management.Query;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activotrabajo.dao.ActivoTrabajoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

@Component
public class MSVCambioApiCargaMasiva extends AbstractMSVActualizador{
	private static final int FILA_CABECERA = 0;
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int ACT_NUM_ACTIVO = 0;
	private static final int PVE_COD_REM = 1;
	

	
	@Autowired
	private GenericAdapter adapter;
	
	@Autowired
	private ProveedoresApi proveedoresApi;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_API_VALIDATOR;
	}
	
	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		String numActivo = exc.dameCelda(fila, ACT_NUM_ACTIVO);
		String pveCodRem = exc.dameCelda(fila, PVE_COD_REM);
		String userName = adapter.getUsuarioLogado().getUsername();
		if (proveedoresApi.cambiaMediador(numActivo, pveCodRem, userName)) {
			return new ResultadoProcesarFila();
		}else{
			throw new ParseException("Error al procesar la fila ", fila);
		}
		
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

}
