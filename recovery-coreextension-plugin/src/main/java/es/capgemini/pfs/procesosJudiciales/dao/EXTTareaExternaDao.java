package es.capgemini.pfs.procesosJudiciales.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface EXTTareaExternaDao extends AbstractDao<EXTTareaExterna, Long> {

    List<EXTTareaExterna> buscaTareasPorTipoGestorYProcedimiento(Long idProcedimiento);

    List<? extends TareaExterna> obtenerTareasGestorConfeccionExpediente(Long idProcedimiento);

    List<? extends TareaExterna> obtenerTareasSupervisorConfeccionExpediente(Long idProcedimiento);

    List<? extends TareaExterna> obtenerTareasPorSubtipoTareaYProcedimiento(Long idProcedimiento, String codSubTarea);

    List<? extends TareaExterna> obtenerTareasPorUsuarioYProcedimientoConOptimizacion(Long idUsuario, Long idProcedimiento);
    
    List<? extends TareaExterna> obtenerTareasPorUsuarioYProcedimientoConOptimizacion(Long idUsuario, List<Long> idProcedimiento);

}
