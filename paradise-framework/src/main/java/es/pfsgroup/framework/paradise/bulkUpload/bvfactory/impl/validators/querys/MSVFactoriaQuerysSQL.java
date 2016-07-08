package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.querys;

import java.util.Map;

import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVResultadoValidacionSQL;

public interface MSVFactoriaQuerysSQL {

	String getSql(String colName);

	Map<Integer, MSVResultadoValidacionSQL> getConfig(String colName);

}
