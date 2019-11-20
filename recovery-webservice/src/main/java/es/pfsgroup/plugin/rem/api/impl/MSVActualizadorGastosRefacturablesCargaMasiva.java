package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;

@Component
public class MSVActualizadorGastosRefacturablesCargaMasiva extends AbstractMSVActualizador {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	private final String VALID_OPERATION = MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_SUPER_GASTOS_REFACTURABLES;
	
	private final int COL_GASTO_PADRE = 0;
	private final int COL_GASTO_HIJO = 1;

	@Override
	public String getValidOperation() {
		
		return VALID_OPERATION;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		List<String> gastosRefacturablesLista = new ArrayList<String>();
		gastosRefacturablesLista.add(exc.dameCelda(fila, COL_GASTO_HIJO));
		gastoProveedorApi.anyadirGastosRefacturadosAGastoExistente(exc.dameCelda(fila, COL_GASTO_PADRE), gastosRefacturablesLista);
		
		return new ResultadoProcesarFila();
	}

}
