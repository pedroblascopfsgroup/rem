package es.pfsgroup.procedimientos;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaRecuperacionDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaRecuperacion;
import es.capgemini.pfs.recuperacion.dao.RecuperacionDao;
import es.capgemini.pfs.recuperacion.model.Recuperacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.procedimientos.recoveryapi.PRODtoCrearTareaExterna;
import es.pfsgroup.procedimientos.recoveryapi.TareaExternaOverridedApi;

@Component
public class PROTareaExternaManagerOverrider extends
		BusinessOperationOverrider<TareaExternaOverridedApi> implements
		TareaExternaOverridedApi {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private TareaExternaDao tareaExternaDao;
	
	@Autowired
	private RecuperacionDao recuperacionDao;
	
	@Autowired
	private TareaExternaRecuperacionDao tareaExternaRecuperacionDao;


	@Override
	public String managerName() {
		return "tareaExternaManager";
	}

	@Override
	@Transactional(readOnly = false)
	public Long crearTareaExterna(String codigoSubtipoTarea, Long plazo,
			String descripcion, Long idProcedimiento,
			Long idTareaProcedimiento, Long tokenIdBpm) {
		return parent().crearTareaExterna(codigoSubtipoTarea, plazo,
				descripcion, idProcedimiento, idTareaProcedimiento, tokenIdBpm);
//		return proxyFactory.proxy(TareaExternaApi.class).crearTareaExterna(codigoSubtipoTarea, plazo,
//				descripcion, idProcedimiento, idTareaProcedimiento, tokenIdBpm);
	}

	@Override
	@BusinessOperation(PRO_BO_TAREA_EXTERNA_MGR_CREAR_TAREA_EXTERNA_OVERRIDED)
	@Transactional(readOnly = false)
	public Long crearTareaExterna(PRODtoCrearTareaExterna dto) {
		return parent().crearTareaExterna(dto.getCodigoSubtipoTarea(),
				dto.getPlazo(), dto.getDescripcion(), dto.getIdProcedimiento(),
				dto.getIdTareaProcedimiento(), dto.getTokenIdBpm());
//		
//		return proxyFactory.proxy(TareaExternaApi.class).crearTareaExterna(dto.getCodigoSubtipoTarea(),
//				dto.getPlazo(), dto.getDescripcion(), dto.getIdProcedimiento(),
//				dto.getIdTareaProcedimiento(), dto.getTokenIdBpm());
		/*
		EXTDtoGenerarTarea dtoGenerarTarea = new EXTDtoGenerarTarea(dto.getIdProcedimiento(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, dto.getCodigoSubtipoTarea(), false, false,
                dto.getPlazo(), dto.getDescripcion());
		dtoGenerarTarea.setTipoCalculo(TipoCalculo.TODO);
        long idTarea = (Long) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA, dtoGenerarTarea);

        //Cambiamos el nombre de la tarea
        TareaNotificacion tareaPadre = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTarea);
        tareaPadre.setTarea(dto.getDescripcion());
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tareaPadre);

        TareaExterna tarea = new TareaExterna();
        tarea.setTareaPadre(tareaPadre);
        tarea.setTareaProcedimiento((TareaProcedimiento) executor.execute(ComunBusinessOperation.BO_TAREA_PROC_MGR_GET, dto.getIdTareaProcedimiento()));
        tarea.setTokenIdBpm(dto.getTokenIdBpm());
        tarea.setDetenida(false);

        Long idTareaExterna = tareaExternaDao.save(tarea);
        registraRecuperacionContrato(tarea);

        return idTareaExterna;*/
	}
	
	/**
     * Registra los pasos de recuperación de contratos en el momento de creación de la tarea.
     * @param tarea
     */
    @Transactional(readOnly = false)
    private void registraRecuperacionContrato(TareaExterna tarea) {

        //Recuperamos los contratos asociados a la tarea
        List<ExpedienteContrato> list = tarea.getTareaPadre().getProcedimiento().getExpedienteContratos();

        for (ExpedienteContrato ec : list) {
            Contrato contrato = ec.getContrato();
            TareaExternaRecuperacion ter = new TareaExternaRecuperacion();

            Recuperacion recuperacion = recuperacionDao.getUltimaRecuperacionByContrato(contrato.getId());

            ter.setTareaExterna(tarea);
            ter.setRecuperacionAsociada(recuperacion);
            ter.setFechaRegistroRecuperacion(new Date());

            tareaExternaRecuperacionDao.save(ter);
        }

    }

}
