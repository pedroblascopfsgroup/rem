package es.pfsgroup.recovery.geninformes;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

public class GENINFUtils {

	private static final String TIPO_ACTUACION_TRAMITE = "TR";

	/**
	 * Devuelve el procedimiento más reciente (no tramite), seteando la variable "soloActivos" solo tendrá en cuenta los prc activos.
	 * @param asunto
	 * @param soloActivos
	 * @return
	 */
	private static Procedimiento devuelveProcedimiento(EXTAsunto asunto, boolean soloActivos) {
		Procedimiento procedimientoResultado = null;

		List<Procedimiento> procedimientos;
		if (asunto.getProcedimientos() != null) {
			procedimientos = asunto.getProcedimientos();
			for (Procedimiento procedimiento : procedimientos) {
				if (((DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO.equals(procedimiento.getEstadoProcedimiento().getCodigo()))
						|| (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO.equals(procedimiento.getEstadoProcedimiento().getCodigo()))) 
						|| (!soloActivos)) {
					//Sólo tendremos en cuenta los procedimientos principales (los trámites no)
					if (procedimiento != null && procedimiento.getTipoProcedimiento() != null 
							&& procedimiento.getTipoProcedimiento().getTipoActuacion() != null
							&& procedimiento.getTipoProcedimiento().getTipoActuacion().getCodigo() != null
							&& !procedimiento.getTipoProcedimiento().getTipoActuacion().getCodigo().equals(TIPO_ACTUACION_TRAMITE)) {
						procedimientoResultado = procedimientoMasReciente(
								procedimiento, procedimientoResultado);
					}
				}
			}
		}
		return procedimientoResultado;

	}
	
	/**
	 * devuelve el procedimiento activo más reciente (NO TRÁMITES)
	 * @param asunto
	 * @return
	 */
	public static Procedimiento devuelveProcedimientoActivo(EXTAsunto asunto) {
		return devuelveProcedimiento(asunto, true);
	}

	/**
	 * devuelve el procedimiento más reciente independiente de su estado (NO TRÁMITES)
	 * @param asunto
	 * @return
	 */
	public static Procedimiento devuelveProcedimiento(EXTAsunto asunto) {
		return devuelveProcedimiento(asunto, false);
	}
	
	private static Procedimiento procedimientoMasReciente(Procedimiento proc1,
			Procedimiento proc2) {

		Auditoria auditoriaProc1;
		Date fechaUltimaModificacion1;
		Date fechaUltimaCreacion1;
		Auditoria auditoriaProc2;
		Date fechaUltimaModificacion2;
		Date fechaUltimaCreacion2;

		//Procedimiento procResultado;
		if (Checks.esNulo(proc1)) {
			return proc2;
		} else if (Checks.esNulo(proc2)) {
			return proc1;
		}
		auditoriaProc1 = proc1.getAuditoria();
		auditoriaProc2 = proc2.getAuditoria();
		if (Checks.esNulo(auditoriaProc1)) {
			return proc2;
		} else if (Checks.esNulo(auditoriaProc2)) {
			return proc1;
		}
		fechaUltimaModificacion1 = auditoriaProc1.getFechaModificar();
		fechaUltimaModificacion2 = auditoriaProc2.getFechaModificar();
		fechaUltimaCreacion1 = auditoriaProc1.getFechaCrear();
		fechaUltimaCreacion2 = auditoriaProc2.getFechaCrear();
		if (Checks.esNulo(fechaUltimaModificacion1)
				&& Checks.esNulo(fechaUltimaModificacion2)) {
			if (Checks.esNulo(fechaUltimaCreacion1)) {
				return proc2;
			} else if (Checks.esNulo(fechaUltimaCreacion2)) {
				return proc1;
			} else if (fechaUltimaCreacion1.after(fechaUltimaCreacion2)) {
				return proc1;
			} else {
				return proc2;
			}
		} else if (Checks.esNulo(fechaUltimaModificacion1)
				&& !Checks.esNulo(fechaUltimaModificacion2)) {
			if (Checks.esNulo(fechaUltimaCreacion1)) {
				return proc2;
			} else if (fechaUltimaCreacion1.after(fechaUltimaModificacion2)) {
				return proc1;
			} else {
				return proc2;
			}
		} else if (!Checks.esNulo(fechaUltimaModificacion1)
				&& Checks.esNulo(fechaUltimaModificacion2)) {
			if (Checks.esNulo(fechaUltimaCreacion2)) {
				return proc1;
			} else if (fechaUltimaCreacion2.after(fechaUltimaModificacion1)) {
				return proc2;
			} else {
				return proc1;
			}
		} else {
			if (fechaUltimaModificacion2.after(fechaUltimaModificacion1)) {
				return proc2;
			} else {
				return proc1;
			}
		}

	}


}
