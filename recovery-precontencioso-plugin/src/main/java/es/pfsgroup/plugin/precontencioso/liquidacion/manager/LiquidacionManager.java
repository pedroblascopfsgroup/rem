package es.pfsgroup.plugin.precontencioso.liquidacion.manager;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.assembler.LiquidacionAssembler;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.LiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDEstadoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Service
public class LiquidacionManager implements LiquidacionApi {

	@Autowired
	private LiquidacionDao liquidacionDao;

	@Autowired
	private UsuarioDao usuarioDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

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
	public void editar(LiquidacionDTO liquidacionDto) {
		LiquidacionPCO liquidacion = liquidacionDao.get(liquidacionDto.getId());

		liquidacion.setId(liquidacionDto.getId());
		liquidacion.setCapitalVencido(liquidacionDto.getCapitalVencido());
		liquidacion.setCapitalNoVencido(liquidacionDto.getCapitalNoVencido());
		liquidacion.setInteresesOrdinarios(liquidacionDto.getInteresesOrdinarios());
		liquidacion.setInteresesDemora(liquidacionDto.getInteresesDemora());
		liquidacion.setTotal(liquidacionDto.getTotal());
		
		Long apoderadoId = liquidacionDto.getApoderadoId();

		if (apoderadoId != null) {
			liquidacion.setApoderado(usuarioDao.get(apoderadoId));			
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
		liquidacion.setTotal(null);

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
}
