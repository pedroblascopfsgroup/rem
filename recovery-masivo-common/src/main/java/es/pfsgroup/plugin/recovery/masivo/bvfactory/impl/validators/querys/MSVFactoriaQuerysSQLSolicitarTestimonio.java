package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys;

//import java.util.Map;
//
//import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.types.MSVColumnMultiResultSQL;
//import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVResultadoValidacionSQL;
//import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVConfirmContratoOriginalColumns;
//import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVSolicitarTestimonioColumns;

/**
 * Factoría que devuelve configuraciones del resultado de la validación para el
 * fichero de Solicitar testimonio
 * 
 * @author Carlos
 * 
 */
public class MSVFactoriaQuerysSQLSolicitarTestimonio extends
		MSVFactoriaQuerysSQLGenericContrato {
/**
 * Carlos
 * 
 * Si se deja comentado a base de plantilla para ver como actuar 
 * en caso de querer validar más campos
 *
 */
//	private String sqlValidacionFechaSolicitud;
//	private Map<Integer, MSVResultadoValidacionSQL> configValidacionFechaSolicitud;
//
//	@Override
//	public Map<Integer, MSVResultadoValidacionSQL> getConfig(String colName) {
//		if (MSVSolicitarTestimonioColumns.FECHA_SOLICITUD.equals(colName)) {
//			return this.configValidacionFechaSolicitud;
//		} else {
//			return super.getConfig(colName);
//		}
//	}
//
//	@Override
//	public String getSql(String colName) {
//		if (MSVSolicitarTestimonioColumns.FECHA_SOLICITUD.equals(colName)) {
//			return this.sqlValidacionFechaSolicitud;
//		} else {
//			return super.getSql(colName);
//		}
//	}
//
//	public void setSqlValidacionFechaSolicitud(
//			String sqlValidacionFechaSolicitud) {
//		this.sqlValidacionFechaSolicitud = sqlValidacionFechaSolicitud
//				.replaceAll("VALUETOKEN", MSVColumnMultiResultSQL.VALUE_TOKEN)
//				.replaceAll("\\t", "").replaceAll("\\n", "");
//	}
//
//	public Map<Integer, MSVResultadoValidacionSQL> getConfigValidacionFechaSolicitud() {
//		return configValidacionFechaSolicitud;
//	}
//
//	public void setConfigValidacionFechaSolicitud(
//			Map<Integer, MSVResultadoValidacionSQL> configValidacionFechaSolicitud) {
//		this.configValidacionFechaSolicitud = configValidacionFechaSolicitud;
//	}
}
