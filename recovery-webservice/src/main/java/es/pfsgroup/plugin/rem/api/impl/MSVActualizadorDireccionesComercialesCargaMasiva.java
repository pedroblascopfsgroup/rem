package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.dd.DDTerritorio;

@Component
public class MSVActualizadorDireccionesComercialesCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	GenericABMDao genericDao;
	
	

	protected static final Log logger = LogFactory.getLog(MSVActualizadorDireccionesComercialesCargaMasiva.class);

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_DIRECCIONES_COMERCIALES;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			Long numActivo = Long.parseLong(exc.dameCelda(fila, 0));
			String direccion = exc.dameCelda(fila, 1);
			
			if (!Checks.esNulo(numActivo) && !Checks.esNulo(direccion)){
				
				Filter dirComFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", direccion);
				DDTerritorio ddTerritorio = genericDao.get(DDTerritorio.class, dirComFilter);
				Activo activo = activoApi.getByNumActivo(numActivo);
				
				if (!Checks.esNulo(activo) && !Checks.esNulo(ddTerritorio)){
					activo.setTerritorio(ddTerritorio);
					genericDao.save(Activo.class, activo);					
				}
			}
		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}

}
