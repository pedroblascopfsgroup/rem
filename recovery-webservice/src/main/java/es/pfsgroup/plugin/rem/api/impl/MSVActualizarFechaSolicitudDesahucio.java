package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;

@Component
public class MSVActualizarFechaSolicitudDesahucio extends AbstractMSVActualizador implements MSVLiberator {

	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	
    protected final Log logger = LogFactory.getLog(getClass());
    
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Resource
    MessageService messageServices;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_FECHA_SOLICITUD_DESAHUCIO;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void procesaFila(MSVHojaExcel exc, int fila) throws IOException, ParseException, JsonViewerException, SQLException {
		
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		
		if (!Checks.esNulo(exc.dameCelda(fila, 1))) {
			activo.getSituacionPosesoria().setFechaSolDesahucio(sdf.parse(exc.dameCelda(fila, 1)));
		}else {
			activo.getSituacionPosesoria().setFechaSolDesahucio(null);
		}
		
		activoApi.saveOrUpdate(activo);
				
	}



}
