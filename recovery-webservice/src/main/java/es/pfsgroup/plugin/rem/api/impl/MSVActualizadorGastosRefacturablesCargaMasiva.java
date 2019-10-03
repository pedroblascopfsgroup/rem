package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

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
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;

@Component
public class MSVActualizadorGastosRefacturablesCargaMasiva extends AbstractMSVActualizador {
	
	@Autowired
	private GenericABMDao genericDao;
	
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
		
		Long numGastoProveedor = Long.valueOf(exc.dameCelda(fila, COL_GASTO_PADRE));
		Long numGastoProveedorRefacturado =	Long.valueOf(exc.dameCelda(fila, COL_GASTO_HIJO));				
		
		Filter filtroGastoProveedor = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", numGastoProveedor);
		GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, filtroGastoProveedor);
		
		Filter filtroGastoProveedorRefacturado = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", numGastoProveedorRefacturado);
		GastoProveedor gastoProveedorRefacturado = genericDao.get(GastoProveedor.class, filtroGastoProveedorRefacturado);		
		
		GastoRefacturable gasto = new GastoRefacturable();
		gasto.setGastoProveedor(gastoProveedor.getId());
		gasto.setGastoProveedorRefacturado(gastoProveedorRefacturado.getId());		
		
		genericDao.save(GastoRefacturable.class, gasto);		
		
		return new ResultadoProcesarFila();
	}

}
