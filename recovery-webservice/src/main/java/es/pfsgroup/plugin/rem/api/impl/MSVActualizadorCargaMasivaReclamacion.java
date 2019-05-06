package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatDao;
import es.pfsgroup.plugin.rem.activo.dao.ReclamacionGencatDao;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;

@Component
public class MSVActualizadorCargaMasivaReclamacion extends AbstractMSVActualizador implements MSVLiberator {
	
	private SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
	
	@Autowired
	private ComunicacionGencatDao comunicacionGencatDao;
	
	@Autowired 
	private ReclamacionGencatDao reclamacionGencatDao;
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_RECLAMACIONES;
	}
	
	private static final int POSICION_COLUMNA_NUMERO_ACTIVO = 0;
	private static final int POSICION_COLUMNA_FECHA_RECLAMACION = 1;
	
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException, JsonViewerException, SQLException {
		
		ComunicacionGencat comunicacionGencat = comunicacionGencatDao.getComunicacionByActivoIdAndEstadoComunicado(exc.dameCelda(fila, POSICION_COLUMNA_NUMERO_ACTIVO ));
		
		ReclamacionGencat reclamacionGencat = reclamacionGencatDao.getReclamacionByComunicacionGencatId(comunicacionGencat.getId());
				
		if (Checks.esNulo(reclamacionGencat)) {
			reclamacionGencat = new ReclamacionGencat();
			reclamacionGencat.setComunicacion(comunicacionGencat);
			reclamacionGencat.setAuditoria(new Auditoria());
		} 
		
		reclamacionGencat.setFechaReclamacion(formatoFecha.parse(exc.dameCelda(fila, POSICION_COLUMNA_FECHA_RECLAMACION))); 
		
		reclamacionGencatDao.save(reclamacionGencat);
		
		
		return new ResultadoProcesarFila();
	}
}
