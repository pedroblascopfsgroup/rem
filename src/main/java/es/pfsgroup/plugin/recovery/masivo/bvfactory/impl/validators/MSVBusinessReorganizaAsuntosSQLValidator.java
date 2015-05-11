package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessCompositeValidatorsAutowiredSupport;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidatorsAutowiredSupport;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys.MSVFactoriaMultiQuerySQLReorganizaAsu;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys.MSVFactoriaQuerysSQLReorganizaAsu;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.types.MSVColumnMultiResultSQL;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

@Component
public class MSVBusinessReorganizaAsuntosSQLValidator implements
		MSVBusinessValidatorsAutowiredSupport,
		MSVBusinessCompositeValidatorsAutowiredSupport {

	@Autowired(required=false)
	MSVFactoriaQuerysSQLReorganizaAsu msvQuerys;

	@Autowired(required=false)
	MSVFactoriaMultiQuerySQLReorganizaAsu msvMultiQuerys;

	@Override
	public String getCodigoTipoOperacion() {
		return MSVDDOperacionMasiva.CODIGO_REORGANIZACION_ASUNTOS;
	}

	@Override
	public MSVColumnValidator getValidatorForColumn(String colName) {
		if (Checks.esNulo(colName)){
			return null;
		}else{
			String sql = msvQuerys.getSql(colName);
			if (!Checks.esNulo(sql)){
				return new MSVColumnMultiResultSQL(sql, msvQuerys.getConfig(colName));
			}
		}
		return null;
	}

	@Override
	public List<MSVMultiColumnValidator> getValidatorForColumns(List<String> listaTodasColumnas) {
		
		List<MSVMultiColumnValidator> listaValidadores = null; 
		if (!listaTodasColumnas.isEmpty()) {
			listaValidadores = new ArrayList<MSVMultiColumnValidator>();
			for (String listaColumnasCombinacion : msvMultiQuerys.getCombinacionesValidacion()) {
				List<String> columnasCombinacion = Arrays.asList(listaColumnasCombinacion.split(";"));
				if (listaTodasColumnas.containsAll(columnasCombinacion)) {
					Map<Integer, MSVResultadoValidacionSQL> mapaConfiguracion = msvMultiQuerys.getConfigCombinacion(listaColumnasCombinacion);
					String sqlValidacion = msvMultiQuerys.getSQLValidacion(listaColumnasCombinacion);
					MSVMultiColumnValidator val = new MSVMultiColumnValidatorImpl();
					val.setCombinacionColumnas(columnasCombinacion);
					val.setResultConfig(mapaConfiguracion);
					val.setSqlValidacion(sqlValidacion);
					listaValidadores.add(val);
				}
			}
		}
		return listaValidadores;
	}
}
