package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.util.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.List;

import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;

@Component
public class MSVMasivaFechasTituloYPosesion extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private GenericAdapter genericAdapter;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FECHA_TITULO_Y_POSESION;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException {

		Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoAdjudicacionNoJudicial actNoJudicial = genericDao.get(ActivoAdjudicacionNoJudicial.class, filtro);
		ActivoSituacionPosesoria  sitPosesoria = genericDao.get(ActivoSituacionPosesoria.class, filtro);
		
		if (exc.dameCelda(fila, 1) != null && !exc.dameCelda(fila, 1).isEmpty() ) {

			String fechaTitulo = exc.dameCelda(fila, 1);
			String pattern = "dd/MM/yyyy";
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
			Date fchTitulo = simpleDateFormat.parse(fechaTitulo);

			actNoJudicial.setFechaTitulo(fchTitulo);
		}
		if (exc.dameCelda(fila, 2) != null && !exc.dameCelda(fila, 2).isEmpty()) {

			String fechaPosesion = exc.dameCelda(fila, 2);
			String pattern = "dd/MM/yyyy";
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
			Date fchPosesion = simpleDateFormat.parse(fechaPosesion);

			actNoJudicial.setFechaPosesion(fchPosesion);
		}
		if((DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo()) || 
				DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo()) ||
				DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo())) &&
				exc.dameCelda(fila, 2) != null) {
			
			String fechaPosesion = exc.dameCelda(fila, 2);
			String pattern = "dd/MM/yyyy";
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
			Date fchPosesion = simpleDateFormat.parse(fechaPosesion);
			
			actNoJudicial.setFechaPosesion(fchPosesion);
			sitPosesoria.setFechaTomaPosesion(fchPosesion);
			
		}
		

		genericDao.save(ActivoAdjudicacionNoJudicial.class, actNoJudicial);
		return new ResultadoProcesarFila();

	}

}