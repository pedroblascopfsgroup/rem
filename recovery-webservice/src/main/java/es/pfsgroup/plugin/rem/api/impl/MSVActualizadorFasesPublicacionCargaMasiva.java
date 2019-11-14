
package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDFasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubfasePublicacion;
import es.pfsgroup.recovery.api.ExpedienteApi;

@Component
public class MSVActualizadorFasesPublicacionCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {
	private static final int FILA_CABECERA = 0;
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int ACT_NUM_ACTIVO = 0;
	private static final int FASE_PUBLICACION = 1;
	private static final int SUBFASE_PUBLICACION = 2;
	private static final int COMENTARIO = 3;
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FASES_PUBLICACION;
	}
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, ACT_NUM_ACTIVO)));
		
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Filter filtroFechaFin = genericDao.createFilter(FilterType.NULL, "fechaFin");
		HistoricoFasePublicacionActivo historicoFasesPublicacion = genericDao.get(HistoricoFasePublicacionActivo.class, filtroActivo, filtroFechaFin);
		if(!Checks.esNulo(historicoFasesPublicacion)) {
			historicoFasesPublicacion.setFechaFin(new Date());
			genericDao.save(HistoricoFasePublicacionActivo.class, historicoFasesPublicacion);
		}
		historicoFasesPublicacion = new HistoricoFasePublicacionActivo();	
		DDFasePublicacion fasePublicacion = genericDao.get(DDFasePublicacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo",exc.dameCelda(fila, FASE_PUBLICACION)));
		DDSubfasePublicacion subfasePublicacion = genericDao.get(DDSubfasePublicacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo",exc.dameCelda(fila, SUBFASE_PUBLICACION)));
		String comentario = exc.dameCelda(fila, COMENTARIO);
		historicoFasesPublicacion.setActivo(activo);
		historicoFasesPublicacion.setFechaInicio(new Date());
		historicoFasesPublicacion.setFasePublicacion(fasePublicacion);
		historicoFasesPublicacion.setSubFasePublicacion(subfasePublicacion);
		historicoFasesPublicacion.setUsuario(genericAdapter.getUsuarioLogado());
		if(!Checks.esNulo(comentario)){
			historicoFasesPublicacion.setComentario(comentario);
		}
		genericDao.save(HistoricoFasePublicacionActivo.class, historicoFasesPublicacion);
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

}