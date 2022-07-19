package es.pfsgroup.plugin.rem.api.impl;

import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

@Component
public class MSVActualizadorEstadosGastos extends AbstractMSVActualizador implements MSVLiberator {

	private final int FILA_CABECERA = 0;
	private final int FILA_DATOS = 1;

	private final int COL_NUM_GASTO = 0;

	private final int COL_AUTORIZA_RECHAZA = 1;
	private final int COL_MOTIVO_RECHAZO = 2;
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private GenericAdapter genericAdapter;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ESTADOS_GASTOS;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {


		return new ResultadoProcesarFila();

	}

}