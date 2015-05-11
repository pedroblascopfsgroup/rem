package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys;

import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;

public interface MSVFactoriaQuerysSQL {

	String getSql(String colName);

	Map<Integer, MSVResultadoValidacionSQL> getConfig(String colName);

}
