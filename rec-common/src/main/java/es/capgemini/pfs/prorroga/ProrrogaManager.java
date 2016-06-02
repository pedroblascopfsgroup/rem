package es.capgemini.pfs.prorroga;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.prorroga.dao.CausaProrrogaDao;
import es.capgemini.pfs.prorroga.dao.ProrrogaDao;
import es.capgemini.pfs.prorroga.dao.RespuestaProrrogaDao;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.prorroga.model.CausaProrroga;
import es.capgemini.pfs.prorroga.model.DDTipoProrroga;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.prorroga.model.RespuestaProrroga;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Prorroga Manager.
 * @author jbosnjak
 *
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, readOnly = false)
public class ProrrogaManager {

	@Autowired
	private Executor executor;
	
	@Autowired
    private ProrrogaDao prorrogaDao;

    @Autowired
    private RespuestaProrrogaDao respuestaProrrogaDao;

    @Autowired
    private CausaProrrogaDao causaProrrogaDao;

    /**
     * save.
     * @param prorroga prorroga
     * @return id
     */
    @BusinessOperation(InternaBusinessOperation.BO_PRORR_MGR_SAVE)
    public Long save(Prorroga prorroga) {
        return prorrogaDao.save(prorroga);
    }

    /**
     * save or update.
     * @param prorroga prorroga
     */
    @BusinessOperation(InternaBusinessOperation.BO_PRORR_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(Prorroga prorroga) {
        prorrogaDao.saveOrUpdate(prorroga);
    }

    /**
     * retorna una prorroga.
     * @param idProrroga id
     * @return prorroga
     */
    @BusinessOperation(InternaBusinessOperation.BO_PRORR_MGR_GET)
    public Prorroga get(Long idProrroga) {
        return prorrogaDao.get(idProrroga);
    }

    /**
     * obtiene todas las causas.
     * @param codigoTipoProrroga String
     * @return causas
     */
    @BusinessOperation(InternaBusinessOperation.BO_PRORR_MGR_OBTENER_CAUSAS)
    public List<CausaProrroga> obtenerCausas(String codigoTipoProrroga) {
        if (codigoTipoProrroga == null) {
            codigoTipoProrroga = DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA;
        }
        return causaProrrogaDao.getList(codigoTipoProrroga);
    }

    /**
     * obtiene todas las respuestas.
     * @param codigoTipoProrroga String
     * @return causas
     */
    @BusinessOperation(InternaBusinessOperation.BO_PRORR_MGR_OBTENER_RESPUESTAS)
    public List<RespuestaProrroga> obtenerRespuestas(String codigoTipoProrroga) {
        if (codigoTipoProrroga == null) {
            codigoTipoProrroga = DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA;
        }
        return respuestaProrrogaDao.getList(codigoTipoProrroga);
    }

    /**
     * crea una nueva prorroga.
     * @param dto dto
     * @return prorroga creada
     */
    @BusinessOperation(InternaBusinessOperation.BO_PRORR_MGR_CREAR_NUEVA_PRORROGA)
    public Prorroga crearNuevaProrroga(DtoSolicitarProrroga dto) {
        Prorroga prorroga = new Prorroga();
        CausaProrroga causa = causaProrrogaDao.buscarPorCodigo(dto.getCodigoCausa());
        prorroga.setCausaProrroga(causa);
        prorroga.setFechaPropuesta(dto.getFechaPropuesta());
        TareaNotificacion tareaAsociada = null;
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(dto.getIdTipoEntidadInformacion())) {
            TareaExterna tareaExterna = (TareaExterna)executor.execute(
            		ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET, dto.getIdTareaAsociada());;
            tareaAsociada = tareaExterna.getTareaPadre();
        } else {
        	tareaAsociada = (TareaNotificacion)executor.execute(
            		ComunBusinessOperation.BO_TAREA_MGR_GET, dto.getIdTareaAsociada());
        }
        if (tareaAsociada.getProrrogaAsociada() != null) {
            //Ya existe una prorroga solicitada.
            throw new BusinessOperationException("prorroga.prorrogaYaSolicitada");
        }
        prorroga.setTareaAsociada(tareaAsociada);
        this.save(prorroga);
        return prorroga;
    }

    /**
     * genera la respuesta de la prorroga.
     * @param dto dto
     * @return prorroga
     */
    @BusinessOperation(InternaBusinessOperation.BO_PRORR_MGR_RESPONDER_PRORROGA)
    public Prorroga responderProrroga(DtoSolicitarProrroga dto) {
        Prorroga prorroga = this.get(dto.getIdProrroga());
        if (prorroga.getAuditoria().isBorrado()) {
            throw new BusinessOperationException("prorroga.prorrogaYaContestada");
        }
        RespuestaProrroga respuesta = respuestaProrrogaDao.buscarPorCodigo(dto.getCodigoRespuesta());
        prorroga.setRespuestaProrroga(respuesta);
        prorrogaDao.delete(prorroga);
        return prorroga;
    }

    /**
     * @param idTareaOriginal
     * @param idTareaOriginal id
     * @return Prorrogas
     */
    @BusinessOperation(InternaBusinessOperation.BO_PRORR_MGR_OBTENER_DECISION_PRORROGA)
    public Prorroga obtenerDecisionProrroga(Long idTareaOriginal) {
        return prorrogaDao.obtenerDecisionProrroga(idTareaOriginal);
    }

    /**
     * Recupera el plazo de la solicitud de prorroga en función de la entidad que lo pide.
     * @param idTipoEntidadInformacion Tipo de entidad que pide la prorroga
     * @param idEntidadInformacion Id de la entidad
     * @return Plazo en días
     */
    @BusinessOperation(InternaBusinessOperation.BO_PRORR_MGR_OBTENER_PLAZO)
    public Long obtenerPlazo(String idTipoEntidadInformacion, Long idEntidadInformacion) {

        Long plazo = null;

        //Si es un expediente, tiene una singularidad a la hora de elegir plazos
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(idTipoEntidadInformacion)) {
            Expediente exp = (Expediente)executor.execute(
            		InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, 
            		idEntidadInformacion);

            if (exp != null) {

            	Itinerario itinerario = ((Arquetipo)executor.execute(
                		ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_WITH_ESTADO, 
                		exp.getArquetipo().getId())).getItinerario();
                Estado estadoCE = itinerario.getEstado(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
                Estado estadoRE = itinerario.getEstado(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);
                Estado estadoDC = itinerario.getEstado(DDEstadoItinerario.ESTADO_DECISION_COMIT);
                Estado estadoENSAN = itinerario.getEstado(DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION);
                Estado estadoSANC = itinerario.getEstado(DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO);

                Long now = System.currentTimeMillis();
                Long fechaIni = exp.getAuditoria().getFechaCrear().getTime();
                Long plazoUtil = 0L;

                //Calculamos el plazo máximo de la tarea
                if (DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(exp.getEstadoItinerario().getCodigo())) {
                    Long fechaVenc = fechaIni + estadoCE.getPlazo();

                    //Si ya hemos sobrepasado el día de vencimiento calculamos lo que le puede quedar
                    if (now > fechaVenc) {
                        plazoUtil = fechaIni - now + estadoCE.getPlazo() + estadoRE.getPlazo();
                    } else {
                        //Si no, el plazo será todo el tiempo disponible de la siguiente etapa
                        plazoUtil = estadoRE.getPlazo();
                    }

                } else if (DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(exp.getEstadoItinerario().getCodigo())) {
                    Long fechaVenc = fechaIni + estadoCE.getPlazo() + estadoRE.getPlazo();

                    //Si ya hemos sobrepasado el día de vencimiento calculamos lo que le puede quedar
                    if (now > fechaVenc) {
                    	if(DDTipoItinerario.ITINERARIO_GESTION_DEUDA.equals(itinerario.getdDtipoItinerario())){
                    		plazoUtil = fechaIni - now + estadoCE.getPlazo() + estadoRE.getPlazo() + estadoENSAN.getPlazo();
                    	}else{
                    		plazoUtil = fechaIni - now + estadoCE.getPlazo() + estadoRE.getPlazo() + estadoDC.getPlazo();
                    	}
                    } else {
                        //Si no, el plazo será todo el tiempo disponible de la siguiente etapa
                    	if(DDTipoItinerario.ITINERARIO_GESTION_DEUDA.equals(itinerario.getdDtipoItinerario())){
                    		plazoUtil = estadoENSAN.getPlazo();
                    	}else{
                    		plazoUtil = estadoDC.getPlazo();
                    	}
                    }
                } else if (DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(exp.getEstadoItinerario().getCodigo())) {
                    //El plazo será el plazo de la tarea por defecto
                    PlazoTareasDefault plazoDefault = (PlazoTareasDefault)executor.execute(
                    		ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO, 
                    		PlazoTareasDefault.CODIGO_PLAZO_PRORROGA_DC);
                    
                    plazoUtil = plazoDefault.getPlazo();
                } else if(DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION.equals(exp.getEstadoItinerario().getCodigo())){
                	Long fechaVenc = fechaIni + estadoCE.getPlazo() + estadoRE.getPlazo() + estadoENSAN.getPlazo();
                	
                	//Si ya hemos sobrepasado el día de vencimiento calculamos lo que le puede quedar
                	if (now > fechaVenc) {
                         plazoUtil = fechaIni - now + estadoCE.getPlazo() + estadoRE.getPlazo() + estadoENSAN.getPlazo() + estadoSANC.getPlazo();
                     } else {
                         //Si no, el plazo será todo el tiempo disponible de la siguiente etapa
                         plazoUtil = estadoSANC.getPlazo();
                     }
                }  else if (DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO.equals(exp.getEstadoItinerario().getCodigo())) {
                    //El plazo será el plazo de la tarea por defecto
                    PlazoTareasDefault plazoDefault = (PlazoTareasDefault)executor.execute(
                    		ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO, 
                    		PlazoTareasDefault.CODIGO_PLAZO_PRORROGA_DC);
                    
                    plazoUtil = plazoDefault.getPlazo();
                }

                //Calculamos los dias que quedan para llegar a ese plazo máximo
                if (plazoUtil < 0) {
                    plazo = 0L;
                } else {
                    plazo = plazoUtil / APPConstants.MILISEGUNDOS_DIA;
                }
            }
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(idTipoEntidadInformacion)) {
            PlazoTareasDefault plazoDefault = (PlazoTareasDefault)executor.execute(
            		ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO, 
            		PlazoTareasDefault.CODIGO_PLAZO_PRORROGA_EXTERNA);
            plazo = plazoDefault.getPlazo() / APPConstants.MILISEGUNDOS_DIA;
        }

        if (plazo == null) {
            PlazoTareasDefault plazoDefault = (PlazoTareasDefault)executor.execute(
            		ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO, 
            		PlazoTareasDefault.CODIGO_PLAZO_PRORROGA_DEFAULT);
            plazo = plazoDefault.getPlazo() / APPConstants.MILISEGUNDOS_DIA;
        }

        return plazo;
    }
}
