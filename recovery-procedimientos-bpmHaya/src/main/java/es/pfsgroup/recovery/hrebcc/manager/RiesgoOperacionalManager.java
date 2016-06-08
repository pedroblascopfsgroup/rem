package es.pfsgroup.recovery.hrebcc.manager;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.dao.EXTContratoDao;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.haya.integration.bpm.IntegracionBpmService;
import es.pfsgroup.recovery.hrebcc.Dao.RiesgoOperacionalVencidosDao;
import es.pfsgroup.recovery.hrebcc.api.RiesgoOperacionalApi;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.hrebcc.model.CntRiesgoOperacional;
import es.pfsgroup.recovery.hrebcc.model.DDRiesgoOperacional;
import es.pfsgroup.recovery.hrebcc.model.Vencidos;

@Service
public class RiesgoOperacionalManager implements RiesgoOperacionalApi {

	private static final String SIN_RIESGO_OPERACIONAL_NO_PROCEDE = "00";

	@Autowired
	EXTContratoDao contratoDao;
	
	@Autowired
	UtilDiccionarioApi utilDiccionario;
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired

	RiesgoOperacionalVencidosDao riesgoOperacionalVencidosDao;
	
	@Autowired

	ProcedimientoManager procedimientoManager;
	
	@Autowired
	private IntegracionBpmService bpmIntegracionService;
	
	@Override
	@Transactional(readOnly=false)
	public void actualizarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto) {
		if (!Checks.esNulo(dto.getIdContrato()) && !Checks.esNulo(dto.getCodRiesgoOperacional())) {
			//Obtenemos el contrato enviado
			EXTContrato contrato = (EXTContrato)contratoDao.get(dto.getIdContrato());
			
			//Obtenemos el objeto del riesgo operacional
			DDRiesgoOperacional riesgoOperacional = (DDRiesgoOperacional)utilDiccionario.dameValorDiccionarioByCod(DDRiesgoOperacional.class, dto.getCodRiesgoOperacional());
			
			//Si tenemos ambos objetos actualizamos el contrato
			if (!Checks.esNulo(contrato) && !Checks.esNulo(riesgoOperacional)) {
				
				//Ahora creamos un nuevo registro
				CntRiesgoOperacional cntRiesgo = new CntRiesgoOperacional();
				cntRiesgo.setContrato(contrato);
				cntRiesgo.setRiesgoOperacional(riesgoOperacional);
				cntRiesgo.setObservaciones(dto.getObservaciones());
				
				genericDao.save(CntRiesgoOperacional.class, cntRiesgo);
				
				if(dto.isEnviarDatos()) {
					bpmIntegracionService.enviarDatos(dto);
				}
			}
		}
	}
	
	@Override
	@Transactional(readOnly=false)
	public void borrarRiesgoOperacional(ActualizarRiesgoOperacionalDto dto){
		//Obtenemos el contrato enviado
		EXTContrato contrato = (EXTContrato)contratoDao.get(dto.getIdContrato());

		//Si tenemos ambos objetos actualizamos el contrato
		if (!Checks.esNulo(contrato)) {
			//Primero obtenemos la relación del contrato con algún riesgo operacional
			CntRiesgoOperacional cntRiesgo = genericDao.get(CntRiesgoOperacional.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", contrato.getId())
														,genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			if (!Checks.esNulo(cntRiesgo)) {
				//Si ya tiene uno lo borramos
				genericDao.deleteById(CntRiesgoOperacional.class, cntRiesgo.getId());
			}
		}
	}
	
	@Override
	@BusinessOperation(overrides = PrimariaBusinessOperation.BO_CNT_MGR_GET_RIESGO)
	public HashMap<String, Object> obtenerRiesgoOperacionalContratoHash(Long cntId) throws IllegalAccessException, InvocationTargetException {
		HashMap<String, Object> h = null;
		
		DDRiesgoOperacional riesgo = this.obtenerRiesgoOperacionalContrato(cntId);
		
		if (!Checks.esNulo(riesgo)) {
			h = new HashMap<String, Object>();

			h.put("id", riesgo.getId());
			h.put("codigo", riesgo.getCodigo());
			h.put("descripcion", riesgo.getDescripcion());
			h.put("descripcionLarga", riesgo.getDescripcionLarga());
			h.put("auditoria", riesgo.getAuditoria());
		}
		
		return h;
	}
	
	public DDRiesgoOperacional obtenerRiesgoOperacionalContrato(Long cntId) {
		DDRiesgoOperacional resultado = null;
		
		if (!Checks.esNulo(cntId)) {
			//Obtenemos el riesgo operacional del contrato
			CntRiesgoOperacional cntRiesgo = genericDao.get(CntRiesgoOperacional.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", cntId)
					,genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			
			if (!Checks.esNulo(cntRiesgo)) {
				//Si tiene un riesgo se devuelve
				resultado = cntRiesgo.getRiesgoOperacional();
			}
		}
		
		return resultado;
	}
	
	public CntRiesgoOperacional getRiesgoOperacionalContrato(Long cntId) {
		CntRiesgoOperacional resultado = null;
		
		if (!Checks.esNulo(cntId)) {
			//Obtenemos el riesgo operacional del contrato
			CntRiesgoOperacional cntRiesgo = genericDao.get(CntRiesgoOperacional.class, genericDao.createFilter(FilterType.EQUALS, "contrato.id", cntId)
					,genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			
			if (!Checks.esNulo(cntRiesgo)) {
				//Si tiene un riesgo se devuelve
				resultado = cntRiesgo;
			}
		}
		
		return resultado;
	}
	
	@Override
	@BusinessOperation(overrides = PrimariaBusinessOperation.BO_CNT_MGR_GET_VENCIDOS)
	public HashMap<String, Object> obtenerVencidosByCntIdHash(Long cntId) throws IllegalAccessException, InvocationTargetException{
		HashMap<String, Object> h = null;
		
		Vencidos resulVencidos = null;
		
		if(!Checks.esNulo(cntId)){

			List<Vencidos> vencidos = riesgoOperacionalVencidosDao.getListVencidos(cntId);
			
			if(!Checks.esNulo(vencidos) && vencidos.size() > 0){
				resulVencidos = vencidos.get(0);
			}
		}
		
		if (!Checks.esNulo(resulVencidos)) {
			h = new HashMap<String, Object>();
			
			h.put("id", resulVencidos.getId());
			h.put("cndId", resulVencidos.getCntId());
			h.put("tipoVencido", resulVencidos.getTipoVencido());
			h.put("tipoVencidoAnterior", resulVencidos.getTipoVencidoAnterior());
			h.put("auditoria", resulVencidos.getAuditoria());
			
		}
		
		return h;
	}
	
	/**
	 * Comprobamos que todos los contratos del asunto del procedimiento tienen un riesgo operacional asociado
	 */
	@Override
	@Transactional(readOnly = false)
	public Boolean comprobarRiesgoProcedimiento(Long idProcedimiento) {
		Boolean resultado = true;
		
		Procedimiento prc = procedimientoManager.getProcedimiento(idProcedimiento);
		if (Checks.esNulo(prc)) {
			resultado = false;
		} else {
			Set<Contrato> contratos = prc.getAsunto().getContratos();
			for (Contrato contrato : contratos) {
				Long idContrato = contrato.getId();
				if (Checks.esNulo(this.obtenerRiesgoOperacionalContrato(idContrato))) {
					// Modificado según CMREC-1472 
					ActualizarRiesgoOperacionalDto dto = new ActualizarRiesgoOperacionalDto();
					dto.setCodRiesgoOperacional(SIN_RIESGO_OPERACIONAL_NO_PROCEDE);
					dto.setIdContrato(idContrato);
					dto.setEnviarDatos(true);
					actualizarRiesgoOperacional(dto);
					// resultado = false;
				}
			}
		}
		
		return resultado;
	}
	
	@Override
	@BusinessOperation(overrides=PrimariaBusinessOperation.BO_CNT_MGR_COMPRUEBA_TIPO_EXP)
	public Boolean compruebaTipoExpediente(Long idContrato){
		Boolean flag=false;
		Filter filterCnt=genericDao.createFilter(FilterType.EQUALS, "id", idContrato);
		Contrato cnt=genericDao.get(Contrato.class, filterCnt);
		
		List<ExpedienteContrato> listaExpedientes=cnt.getExpedienteContratos();
		for(ExpedienteContrato expCnt: listaExpedientes){
			if(!Checks.esNulo(expCnt.getExpediente().getTipoExpediente())){
				String tipoExpediente=expCnt.getExpediente().getTipoExpediente().getCodigo();
				if(tipoExpediente.equals(DDTipoExpediente.TIPO_EXPEDIENTE_RECUPERACION) || tipoExpediente.equals(DDTipoExpediente.TIPO_EXPEDIENTE_SEGUIMIENTO)){
					flag=true;
					break;
				}
			}
		}
		
		return flag;
	}
	
	@Override
	@BusinessOperation(overrides=PrimariaBusinessOperation.BO_CNT_MGR_COMPRUEBA_TIPO_ASUNTO)
	public Boolean compruebaAsunto(Long idContrato){
		Boolean flag=false;
		Filter filterCnt=genericDao.createFilter(FilterType.EQUALS, "id", idContrato);
		Contrato cnt=genericDao.get(Contrato.class, filterCnt);
		
		List<Asunto> listaAsuntos=cnt.getAsuntosActivos();
		for(Asunto asu:listaAsuntos){
			if(!Checks.esNulo(asu.getTipoAsunto())){
				if(asu.getTipoAsunto().getCodigo().equals(DDTiposAsunto.CONCURSAL) || asu.getTipoAsunto().getCodigo().equals(DDTiposAsunto.LITIGIO)){
					List<Procedimiento> listaProcedimientos=asu.getProcedimientos();
					for(Procedimiento prc: listaProcedimientos){
						if(prc.getTipoProcedimiento().getCodigo().equals(TipoProcedimiento.TIPO_PRECONTENCIOSO)){
							flag=true;
							break;
						}
					}
					
				}
			}
		
		}
		
		return flag;
	}
}
