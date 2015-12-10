package es.pfsgroup.plugin.precontencioso.expedienteJudicial.assembler;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.ObjectUtils;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.BurofaxGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.DocumentoGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.LiquidacionGridDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid.ProcedimientoPcoGridDTO;

/**
 * Ensamblar ProcedimientoPcoGridDTO
 * 
 * @author jmartin
 */
public class ProcedimientoPcoGridDTOAssembler {

	/**
	 * fill ProcedimientoPcoGridDTO from procedimientos List<HashMap<String, Object>>
	 */
	public static List<ProcedimientoPcoGridDTO> fromProcedimientosListHashMap(List<HashMap<String, Object>> procedimientos) {
		List<ProcedimientoPcoGridDTO> out = new ArrayList<ProcedimientoPcoGridDTO>();

		for (HashMap<String, Object> procedimiento : procedimientos) {
			ProcedimientoPcoGridDTO procedimientoGridDto = new ProcedimientoPcoGridDTO();

			// Nombre del procedimiento
			if (procedimiento.get("procedimiento") != null) {
				Procedimiento prc = (Procedimiento) procedimiento.get("procedimiento");
				procedimientoGridDto.setNombreProcedimiento(prc.getNombreProcedimiento());
			}

			procedimientoGridDto.setPrcId(ObjectUtils.toString(procedimiento.get("prcId")));
			procedimientoGridDto.setCodigo(ObjectUtils.toString(procedimiento.get("codigo")));
			procedimientoGridDto.setNombreExpediente(ObjectUtils.toString(procedimiento.get("nombreExpJudicial")));
			procedimientoGridDto.setEstadoExpediente(ObjectUtils.toString(procedimiento.get("estadoActualProcedimiento")));
			procedimientoGridDto.setDiasEnGestion((Integer) procedimiento.get("diasEnGestion"));
			procedimientoGridDto.setFechaEstado((Date) procedimiento.get("fechaEstadoProcedimiento"));
			procedimientoGridDto.setTipoProcPropuesto(ObjectUtils.toString(procedimiento.get("tipoProcPropuesto")));
			procedimientoGridDto.setTipoPreparacion(ObjectUtils.toString(procedimiento.get("tipoPreparacion")));
			procedimientoGridDto.setFechaInicioPreparacion((Date) procedimiento.get("fechaInicioPreparacion"));
			procedimientoGridDto.setDiasEnPreparacion((Integer) procedimiento.get("diasEnPreparacion"));
			procedimientoGridDto.setTotalLiquidacion((BigDecimal) procedimiento.get("totalLiquidacion"));
			procedimientoGridDto.setFechaEnvioLetrado((Date) procedimiento.get("fechaEnvioLetrado"));
			procedimientoGridDto.setAceptadoLetrado(Boolean.valueOf(ObjectUtils.toString(procedimiento.get("aceptadoLetrado"))));
			procedimientoGridDto.setTodosDocumentos(Boolean.valueOf(ObjectUtils.toString(procedimiento.get("todosDocumentos"))));
			procedimientoGridDto.setTodasLiquidaciones(Boolean.valueOf(ObjectUtils.toString(procedimiento.get("todasLiquidaciones"))));
			procedimientoGridDto.setTodosBurofaxes(Boolean.valueOf(ObjectUtils.toString(procedimiento.get("todosBurofaxes"))));
			procedimientoGridDto.setImporte((Float)(procedimiento.get("importe")));

			out.add(procedimientoGridDto);
		}

		return out;
	}

	/**
	 * fill ProcedimientoPcoGridDTO from documentos List<HashMap<String, Object>>
	 */
	public static List<ProcedimientoPcoGridDTO> fromDocumentosListHashMap(List<HashMap<String, Object>> documentos) {
		List<ProcedimientoPcoGridDTO> out = new ArrayList<ProcedimientoPcoGridDTO>();

		for (HashMap<String, Object> documento : documentos) {
			ProcedimientoPcoGridDTO prcPcoGridDto = defaultProcedimientoPcoGridDtoFromHashMap(documento);

			DocumentoGridDTO docGridDto = new DocumentoGridDTO();

			docGridDto.setEstado(ObjectUtils.toString(documento.get("estado")));
			docGridDto.setUltimaRespuesta(ObjectUtils.toString(documento.get("ultimaRespuesta")));

			if (documento.get("ultimoActor") != null) {
				GestorDespacho actor = (GestorDespacho) documento.get("ultimoActor");
				if (actor.getUsuario() != null) {
					docGridDto.setUltimoActor(actor.getUsuario().getApellidoNombre());	
				}
			}
			
			docGridDto.setFechaResultado((Date) documento.get("fechaResultado"));
			docGridDto.setFechaEnvio((Date) documento.get("fechaEnvio"));
			docGridDto.setFechaRecepcion((Date) documento.get("fechaRecepcion"));

			prcPcoGridDto.setDocumento(docGridDto);

			out.add(prcPcoGridDto);
		}

		return out;
	}

	/**
	 * fill ProcedimientoPcoGridDTO from liquidaciones List<HashMap<String, Object>>
	 */
	public static List<ProcedimientoPcoGridDTO> fromLiquidacionesListHashMap(List<HashMap<String, Object>> liquidaciones) {
		List<ProcedimientoPcoGridDTO> out = new ArrayList<ProcedimientoPcoGridDTO>();

		for (HashMap<String, Object> liquidacion : liquidaciones) {
			ProcedimientoPcoGridDTO prcPcoGridDto = defaultProcedimientoPcoGridDtoFromHashMap(liquidacion);

			LiquidacionGridDTO liqGridDto = new LiquidacionGridDTO();

			liqGridDto.setEstado(ObjectUtils.toString(liquidacion.get("estado")));
			liqGridDto.setContrato(ObjectUtils.toString(liquidacion.get("contrato")));
			liqGridDto.setFechaConfirmacion((Date) liquidacion.get("fechaConfirmacion"));
			liqGridDto.setFechaCierre((Date) liquidacion.get("fechaCierre"));
			liqGridDto.setFechaRecepcion((Date) liquidacion.get("fechaRecepcion"));
			liqGridDto.setTotal((Float) liquidacion.get("total"));

			prcPcoGridDto.setLiquidacion(liqGridDto);

			out.add(prcPcoGridDto);
		}

		return out;
	}

	/**
	 * fill ProcedimientoPcoGridDTO from burofaxes List<HashMap<String, Object>>
	 */
	public static List<ProcedimientoPcoGridDTO> fromBurofaxesListHashMap(List<HashMap<String, Object>> burofaxes) {
		List<ProcedimientoPcoGridDTO> out = new ArrayList<ProcedimientoPcoGridDTO>();

		for (HashMap<String, Object> burofax : burofaxes) {
			ProcedimientoPcoGridDTO proPcoGridDto = defaultProcedimientoPcoGridDtoFromHashMap(burofax);

			BurofaxGridDTO burofaxGridDto = new BurofaxGridDTO();

			if (burofax.get("demandado") != null) {
				Persona demandado = (Persona) burofax.get("demandado");

				burofaxGridDto.setNif(demandado.getDocId());
				burofaxGridDto.setApellidoNombre(demandado.getApellidoNombre());
			}

			burofaxGridDto.setEstado(ObjectUtils.toString(burofax.get("estado")));
			burofaxGridDto.setFechaSolicitud((Date) burofax.get("fechaSolicitud"));
			burofaxGridDto.setFechaEnvio((Date) burofax.get("fechaEnvio"));
			burofaxGridDto.setFechaAcuse((Date) burofax.get("fechaAcuse"));
			burofaxGridDto.setResultado(Boolean.valueOf(ObjectUtils.toString(burofax.get("resultado"))));

			proPcoGridDto.setBurofax(burofaxGridDto);

			out.add(proPcoGridDto);
		}

		return out;
	}

	private static ProcedimientoPcoGridDTO defaultProcedimientoPcoGridDtoFromHashMap(HashMap<String, Object> row) {
		ProcedimientoPcoGridDTO prcPcoGridDto = new ProcedimientoPcoGridDTO();

		// Nombre del procedimiento
		if (row.get("procedimiento") != null) {
			Procedimiento prc = (Procedimiento) row.get("procedimiento");
			prcPcoGridDto.setNombreProcedimiento(prc.getNombreProcedimiento());
		}
		
		prcPcoGridDto.setPrcId(ObjectUtils.toString(row.get("prcId")));
		prcPcoGridDto.setCodigo(ObjectUtils.toString(row.get("codigo")));
		prcPcoGridDto.setNombreExpediente(ObjectUtils.toString(row.get("nombreExpJudicial")));
		prcPcoGridDto.setEstadoExpediente(ObjectUtils.toString(row.get("estadoActualProcedimiento")));
		prcPcoGridDto.setImporte((Float)row.get("importe"));
		prcPcoGridDto.setFechaEstado((Date) row.get("fechaEstadoProcedimiento"));
		prcPcoGridDto.setTipoProcPropuesto(ObjectUtils.toString(row.get("tipoProcPropuesto")));
		prcPcoGridDto.setTipoPreparacion(ObjectUtils.toString(row.get("tipoPreparacion")));

		return prcPcoGridDto;
	}
}
