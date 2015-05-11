package es.capgemini.pfs.asunto;

import java.util.List;

import es.capgemini.pfs.asunto.dto.DtoReportFaseComun;
import es.capgemini.pfs.asunto.dto.DtoReportLIQCobroPago;
import es.capgemini.pfs.asunto.dto.DtoReportAnotacionAgenda;
import es.capgemini.pfs.asunto.dto.DtoReportAsunto;
import es.capgemini.pfs.asunto.dto.DtoReportAsuntoActuacion;
import es.capgemini.pfs.asunto.dto.DtoReportAsuntoDemandados;
import es.capgemini.pfs.asunto.dto.DtoReportComunicacion;
import es.capgemini.pfs.asunto.dto.DtoReportInstrucciones;
import es.capgemini.pfs.asunto.dto.DtoReportProrroga;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.recurso.model.Recurso;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

public interface ReportAsuntoApi {

	
/*
	private static final String GET_DETALLES_ECONOMICOS_GASTOS_LITIGIO_REPORT = "plugin.asunto.report.obtenerDetallesEconomicosGastosAsuntoLitigio";
	private static final String GET_DETALLES_ECONOMICOS_ENTREGAS_LITIGIO_REPORT = "plugin.asunto.report.obtenerDetallesEconomicosEntregasAsuntoLitigio";

 	private static final String GET_DATOS_CONCURSO_REPORT = "plugin.ugas.asunto.report.getDatosConcurso";
	private static final String GET_TAREAS_ASUNTO_REPORT = "plugin.ugas.asunto.report.obtenerTareasAsunto";
	private static final String GET_ANOTACIONES_ASUNTO_REPORT = "plugin.ugas.asunto.report.obtenerAnotacionesAsunto";
	private static final String GET_DATOS_ECONOMICOS_LITIGIO_REPORT = "plugin.ugas.asunto.report.obtenerDatosEconomicosAsuntoLitigio";
	private static final String GET_DETALLES_ECONOMICOS_MINUTAS_LITIGIO_REPORT = "plugin.ugas.asunto.report.obtenerDetallesEconomicosMinutasAsuntoLitigio";
	private static final String GET_DETALLES_ECONOMICOS_PROVISIONES_LITIGIO_REPORT = "plugin.ugas.asunto.report.obtenerDetallesEconomicosProvisionesAsuntoLitigio";
	private static final String GET_DETALLES_ECONOMICOS_PROVISIONES_INSOLVENCIA_LITIGIO_REPORT = "plugin.ugas.asunto.report.obtenerDetallesEconomicosProvisionesInsolvenciaAsuntoLitigio";
	private static final String GET_SOLVENCIA_INGRESOS_LITIGIO_REPORT = "plugin.ugas.asunto.report.obtenerSolvenciaIngresosAsuntoLitigio";
	private static final String GET_CORREOS_LITIGIO_REPORT = "plugin.ugas.asunto.report.obtenerCorreosAsuntoLitigio";
	private static final String GET_COMUNICACIONES_ASUNTO_REPORT = "plugin.ugas.asunto.report.obtenerComunicacionesAsunto";
	private static final String GET_DEMANDAS_RESCISORIAS_REPORT  = "plugin.ugas.asunto.report.obtenerDemandasRescisorias";
	*/
	
}
