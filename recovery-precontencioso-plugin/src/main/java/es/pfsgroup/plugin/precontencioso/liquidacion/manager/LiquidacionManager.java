package es.pfsgroup.plugin.precontencioso.liquidacion.manager;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.dao.GestorDespachoDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.ProcedimientoPCODao;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.ProcedimientoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.assembler.LiquidacionAssembler;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.LiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.InclusionLiquidacionProcedimientoDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDEstadoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.api.ProcedimientoApi;

@Service("liquidacionManager")
public class LiquidacionManager implements LiquidacionApi {

	@Autowired
	private LiquidacionDao liquidacionDao;

	@Autowired
	private GestorDespachoDao gestorDespachoDao;

	@Autowired
	private ContratoDao contratoDao;
	
	@Autowired
	private ProcedimientoPCODao procedimientoPCODao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private ParametrizacionDao parametrizacionDao;
	
	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public List<LiquidacionDTO> getLiquidacionesPorIdProcedimientoPCO(Long idProcedimientoPCO) {
		List<LiquidacionPCO> liquidaciones = liquidacionDao.getLiquidacionesPorIdProcedimientoPCO(idProcedimientoPCO);

		List<LiquidacionDTO> liquidacionesDto = LiquidacionAssembler.entityToDto(liquidaciones);
		return liquidacionesDto;
	}

	@Override
	public LiquidacionDTO getLiquidacionPorId(Long id) {
		LiquidacionPCO liquidacion = liquidacionDao.get(id);
		LiquidacionDTO liquidacionDto = LiquidacionAssembler.entityToDto(liquidacion);
		return liquidacionDto;
	}

	@Override
	@Transactional(readOnly = false)
	public void confirmar(LiquidacionDTO liquidacionDto) {
		DDEstadoLiquidacionPCO estadoConfirmada = (DDEstadoLiquidacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoLiquidacionPCO.class, DDEstadoLiquidacionPCO.CONFIRMADA);
		LiquidacionPCO liquidacion = liquidacionDao.get(liquidacionDto.getId());
		liquidacion.setEstadoLiquidacion(estadoConfirmada);
		liquidacion.setFechaConfirmacion(new Date());
		liquidacionDao.saveOrUpdate(liquidacion);
	}

	@Override
	@Transactional(readOnly = false)
	public void editarValoresCalculados(LiquidacionDTO liquidacionDto) {
		LiquidacionPCO liquidacion = liquidacionDao.get(liquidacionDto.getId());

		liquidacion.setId(liquidacionDto.getId());
		liquidacion.setCapitalVencido(liquidacionDto.getCapitalVencido());
		liquidacion.setCapitalNoVencido(liquidacionDto.getCapitalNoVencido());
		liquidacion.setInteresesOrdinarios(liquidacionDto.getInteresesOrdinarios());
		liquidacion.setInteresesDemora(liquidacionDto.getInteresesDemora());
		liquidacion.setTotal(liquidacionDto.getTotal());
		liquidacion.setComisiones(liquidacionDto.getComisiones());
		liquidacion.setGastos(liquidacionDto.getGastos());
		liquidacion.setImpuestos(liquidacionDto.getImpuestos());

		if (liquidacionDto.getFechaCierre() != null) {
			liquidacion.setFechaCierre(liquidacionDto.getFechaCierre());
		}

		GestorDespacho apoderado = obtenerApoderado(liquidacionDto);
		if (apoderado != null) {
			liquidacion.setApoderado(apoderado);
		}

		DDEstadoLiquidacionPCO estado = liquidacion.getEstadoLiquidacion();
		if (estado != null && !DDEstadoLiquidacionPCO.CALCULADA.equals(estado.getCodigo())) {
			DDEstadoLiquidacionPCO estadoCalculado = (DDEstadoLiquidacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoLiquidacionPCO.class, DDEstadoLiquidacionPCO.CALCULADA);
			liquidacion.setEstadoLiquidacion(estadoCalculado);
		}

		liquidacionDao.saveOrUpdate(liquidacion);
	}

	@Override
	@Transactional(readOnly = false)
	public void solicitar(LiquidacionDTO liquidacionDto) {
		DDEstadoLiquidacionPCO estadoSolicitada = (DDEstadoLiquidacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoLiquidacionPCO.class, DDEstadoLiquidacionPCO.SOLICITADA);

		LiquidacionPCO liquidacion = liquidacionDao.get(liquidacionDto.getId());
		liquidacion.setEstadoLiquidacion(estadoSolicitada);

		// Actualizacion sobre la fecha de cierre y solicitud
		liquidacion.setFechaCierre(liquidacionDto.getFechaCierre());
		liquidacion.setFechaSolicitud(new Date());

		// Se eliminan los datos antiguos de la liquidacion
		liquidacion.setCapitalVencido(null);
		liquidacion.setCapitalNoVencido(null);
		liquidacion.setInteresesOrdinarios(null);
		liquidacion.setInteresesDemora(null);
		liquidacion.setComisiones(null);
		liquidacion.setGastos(null);
		liquidacion.setImpuestos(null);
		liquidacion.setTotal(null);

		//Se registra el usd_id del solicitante
		if(!Checks.esNulo(usuarioManager)){
			List<GestorDespacho> listaGestorDespacho = gestorDespachoDao.getGestorDespachoByUsuId(usuarioManager.getUsuarioLogado().getId());
			if(!Checks.esNulo(listaGestorDespacho.get(0))){
				liquidacion.setSolicitante(listaGestorDespacho.get(0));
			}
		}
		liquidacionDao.saveOrUpdate(liquidacion);
	}

	@Override
	@Transactional(readOnly = false)
	public void descartar(LiquidacionDTO liquidacionDto) {
		DDEstadoLiquidacionPCO estadoDescartada = (DDEstadoLiquidacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoLiquidacionPCO.class, DDEstadoLiquidacionPCO.DESCARTADA);

		LiquidacionPCO liquidacion = liquidacionDao.get(liquidacionDto.getId());
		liquidacion.setEstadoLiquidacion(estadoDescartada);

		liquidacionDao.saveOrUpdate(liquidacion);
	}

	/**
	 * Helper Method - editar
	 * Recupera el GestorDespacho (apoderado)
	 *
	 * @param liquidacionDto contiene los datos usu_id y des_id para realizar la busqueda del gestordespacho
	 * @return
	 */
	private GestorDespacho obtenerApoderado(final LiquidacionDTO liquidacionDto) {
		Long apoderadoUsuarioId = liquidacionDto.getApoderadoUsuarioId();
		Long apoderadoDespachoId = liquidacionDto.getApoderadoDespachoId();

		GestorDespacho gestorDespacho = null;
		if (apoderadoUsuarioId != null && apoderadoDespachoId != null) {
			gestorDespacho = gestorDespachoDao.getGestorDespachoPorUsuarioyDespacho(apoderadoUsuarioId, apoderadoDespachoId);
		}

		return gestorDespacho;
	}
	
    /**
	 * Incluye los contratos al expediente.
	 * 
	 * @param dto
	 *            DtoExclusionContratoExpediente
	 */
	@Override
	@BusinessOperation(PRECONTENCIOSO_BO_PRC_INCLUIR_LIQUIDACION_AL_PROCEDIMIENTO)
	@Transactional(readOnly = false)
    public void incluirLiquidacionAlProcedimiento(InclusionLiquidacionProcedimientoDTO dto){
		//ProcedimientoPCO prcPCO = procedimientoPCODao.getProcedimientoPcoPorIdProcedimiento(dto.getIdProcedimiento());
		ProcedimientoPCO prcPCO = genericDao.get(ProcedimientoPCO.class, 
				genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", dto.getIdProcedimiento()));			
		if(prcPCO != null && 
				(DDEstadoPreparacionPCO.EN_ESTUDIO.equals(prcPCO.getEstadoActual().getCodigo()) ||
				DDEstadoPreparacionPCO.PREPARACION.equals(prcPCO.getEstadoActual().getCodigo()) ||
				DDEstadoPreparacionPCO.SUBSANAR.equals(prcPCO.getEstadoActual().getCodigo())
				)
			) {
			List<Contrato> contratos = contratoDao.getContratosById(dto.getContratos());
	    	Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(dto.getIdProcedimiento());
			
			if ((!Checks.estaVacio(contratos)) && procedimiento != null) {
				Expediente expediente = procedimiento.getAsunto().getExpediente();
				if (expediente != null) {
					for (Contrato contrato : contratos) {
						LiquidacionPCO liquidacion = settearLiquidacionPCO(procedimiento, prcPCO, contrato); 
						liquidacionDao.save(liquidacion);
					}
				}
				HibernateUtils.merge(procedimiento);
			}
		}
    }
	
	private LiquidacionPCO settearLiquidacionPCO(Procedimiento procedimiento, ProcedimientoPCO prcPCO, Contrato contrato){
		LiquidacionPCO liquidacion = new LiquidacionPCO();
		
		DDEstadoLiquidacionPCO estadoCalculada = (DDEstadoLiquidacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoLiquidacionPCO.class, DDEstadoLiquidacionPCO.PENDIENTE);
		liquidacion.setProcedimientoPCO(prcPCO);
		liquidacion.setEstadoLiquidacion(estadoCalculada);
		liquidacion.setContrato(contrato);
		
		return liquidacion;
	}
	
	@Override
	@BusinessOperation(LIQUIDACION_PRECONTENCIOSO_BY_ID)
	public LiquidacionPCO getLiquidacionPCOById(Long idLiquidacion) {
		return liquidacionDao.get(idLiquidacion);
	}

	@Override
	@Transactional(readOnly = false)
    public void visar(LiquidacionDTO liquidacionDto) 
	{
		try {
			DDEstadoLiquidacionPCO estadoVisada = (DDEstadoLiquidacionPCO) proxyFactory.proxy(UtilDiccionarioApi.class).dameValorDiccionarioByCod(DDEstadoLiquidacionPCO.class, DDEstadoLiquidacionPCO.VISADA);
			LiquidacionPCO liquidacion = liquidacionDao.get(liquidacionDto.getId());
			liquidacion.setEstadoLiquidacion(estadoVisada);
			liquidacion.setFechaVisado(new Date());
			liquidacionDao.saveOrUpdate(liquidacion);
		}
		catch(Exception e) {
			logger.error("Error en el método visar: " + e.getMessage());
			throw new FrameworkException("Ocurrió un error inesperado durante la operación. Por favor, vuelva a intentarlo más tarde.");
		}
	}

	@Override
	public BigDecimal getTotalLiquidacionPCO(Long idProcedimientoPCO) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BigDecimal getTotalLiquidacion(Long idProcedimiento) {
		// TODO Auto-generated method stub
		return null;
	}
}