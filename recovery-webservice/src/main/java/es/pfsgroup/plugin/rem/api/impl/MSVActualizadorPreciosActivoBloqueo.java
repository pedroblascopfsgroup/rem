package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;

@Component
public class MSVActualizadorPreciosActivoBloqueo extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
    @Autowired
    private GenericAdapter adapter;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_BLOQUEO;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		Usuario gestorBloqueoPrecio = adapter.getUsuarioLogado();
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		
		activo.setBloqueoPrecioFechaIni(new Date());
		activo.setGestorBloqueoPrecio(gestorBloqueoPrecio);
		activoApi.saveOrUpdate(activo);
		return new ResultadoProcesarFila();
	}

}
