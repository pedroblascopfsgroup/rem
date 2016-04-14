package es.capgemini.pfs.expediente;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.actitudAptitudActuacion.dao.ActitudAptitudActuacionDao;
import es.capgemini.pfs.actitudAptitudActuacion.dto.DtoActitudAptitudActuacion;
import es.capgemini.pfs.actitudAptitudActuacion.model.ActitudAptitudActuacion;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.arquetipo.dao.ArquetipoDao;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.asunto.dto.DtoAsunto;
import es.capgemini.pfs.asunto.dto.ProcedimientoDto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.dto.DtoListadoExpedientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.cliente.model.EstadoCliente;
import es.capgemini.pfs.cliente.process.ClienteBPMConstants;
import es.capgemini.pfs.comite.dto.DtoAsistente;
import es.capgemini.pfs.comite.dto.DtoSesionComite;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.comite.model.DecisionComite;
import es.capgemini.pfs.comite.model.DecisionComiteAutomatico;
import es.capgemini.pfs.comite.model.PuestosComite;
import es.capgemini.pfs.comite.model.SesionComite;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.exceptions.NonRollbackException;
import es.capgemini.pfs.exceptions.ParametrizationException;
import es.capgemini.pfs.exclusionexpedientecliente.dao.ExclusionExpedienteClienteDao;
import es.capgemini.pfs.exclusionexpedientecliente.dto.DtoExclusionExpedienteCliente;
import es.capgemini.pfs.exclusionexpedientecliente.model.ExclusionExpedienteCliente;
import es.capgemini.pfs.expediente.api.ExpedienteManagerApi;
import es.capgemini.pfs.expediente.dao.AdjuntoExpedienteDao;
import es.capgemini.pfs.expediente.dao.ExpedienteContratoDao;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.dao.ExpedientePersonaDao;
import es.capgemini.pfs.expediente.dao.PropuestaExpedienteManualDao;
import es.capgemini.pfs.expediente.dao.SolicitudCancelacionDao;
import es.capgemini.pfs.expediente.dto.DtoBuscarExpedientes;
import es.capgemini.pfs.expediente.dto.DtoCreacionManualExpediente;
import es.capgemini.pfs.expediente.dto.DtoExpedienteContrato;
import es.capgemini.pfs.expediente.dto.DtoInclusionExclusionContratoExpediente;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.DDMotivoExpedienteManual;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.expediente.model.PropuestaExpedienteManual;
import es.capgemini.pfs.expediente.model.SolicitudCancelacion;
import es.capgemini.pfs.expediente.process.ExpedienteBPMConstants;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoReglasElevacion;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.itinerario.model.ReglasElevacion;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.dao.CicloMarcadoPoliticaDao;
import es.capgemini.pfs.politica.dto.DtoPersonaPoliticaExpediente;
import es.capgemini.pfs.politica.dto.DtoPersonaPoliticaUlt;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.politica.model.DDEstadoPolitica;
import es.capgemini.pfs.politica.model.Objetivo;
import es.capgemini.pfs.politica.model.Politica;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.process.TareaBPMConstants;
import es.capgemini.pfs.titulo.model.Titulo;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.FormatUtils;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

/**
 * Clase manager de la entidad Expediente.
 */
@Service
public class ExpedienteManager implements ExpedienteBPMConstants, ExpedienteManagerApi {

    private static final String MAP_CONTRATOS_PASE = "contratosPase";
    private static final String MAP_CONTRATOS_GRUPO = "contratosGrupo";
    private static final String MAP_CONTRATOS_GENERACION_1 = "contratosGeneracion1";
    private static final String MAP_CONTRATOS_GENERACION_2 = "contratosGeneracion2";

    private static final String MAP_PERSONAS_PASE = "personasPase";
    private static final String MAP_PERSONAS_GRUPO = "personasGrupo";
    private static final String MAP_PERSONAS_GENERACION_1 = "personasGeneracion1";
    private static final String MAP_PERSONAS_GENERACION_2 = "personasGeneracion2";

    @Autowired
    private Executor executor;

    @Autowired
    private DictionaryManager dictionaryManager;

    @Autowired
    private ExpedienteDao expedienteDao;

    @Autowired
    private ExclusionExpedienteClienteDao exclusionExpedienteClienteDao;

    @Autowired
    private ExpedienteContratoDao expedienteContratoDao;

    @Autowired
    private ExpedientePersonaDao expedientePersonaDao;

    //Analizar a partir de aqui

    @Autowired
    private ActitudAptitudActuacionDao actitudAptitudActuacionDao;

    @Autowired
    private PropuestaExpedienteManualDao propuestaExpedienteManualDao;

    @Autowired
    private SolicitudCancelacionDao solicitudCancelacionDao;

    @Autowired
    private AdjuntoExpedienteDao adjuntoExpedienteDao;
    
    @Autowired
    private ArquetipoDao arquetipoDao;
    
    @Autowired
    private CicloMarcadoPoliticaDao cicloMarcadoPoliticaDao; 
    
    @Autowired
	GenericABMDao genericDao;

    private final Log logger = LogFactory.getLog(getClass());

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_PAGINATED)
    public Page findExpedientesPaginated(DtoBuscarExpedientes expedientes) {
    	EventFactory.onMethodStart(this.getClass());
        if (expedientes.getCodigoZona() != null && expedientes.getCodigoZona().trim().length() > 0) {
            StringTokenizer tokens = new StringTokenizer(expedientes.getCodigoZona(), ",");
            Set<String> zonas = new HashSet<String>();
            while (tokens.hasMoreTokens()) {
                String zona = tokens.nextToken();
                zonas.add(zona);
            }
            expedientes.setCodigoZonas(zonas);
        } else {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            expedientes.setCodigoZonas(usuario.getCodigoZonas());
        }
        EventFactory.onMethodStop(this.getClass());
        return expedienteDao.buscarExpedientesPaginado(expedientes);
    }
    
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_PAGINATED_DINAMICO)
    public Page findExpedientesPaginatedDinamico(DtoBuscarExpedientes expedientes, String params) {
    	int limit = 25;
    	return this.findExpedientesPaginatedDinamico(expedientes, params, limit, false);
    }

    /**
     * Busca expedientes para un filtro con busquedas optimizadas para Recobro.
     *
     * @param expedientes
     *            DtoBuscarExpedientes el filtro
     * @return List la lista
     */
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_RECOBRO_PAGINATED_DINAMICO)
    public Page findExpedientesRecobroPaginatedDinamico(DtoBuscarExpedientes expedientes, String params) {
    	int limit = 25;
    	return this.findExpedientesPaginatedDinamico(expedientes, params, limit, true);
    }

    private Page findExpedientesPaginatedDinamico(DtoBuscarExpedientes expedientes, String params, int limit, Boolean esBusquedaExpRecobro) {
    	Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
    	expedientes.setLimit(limit);
    	EventFactory.onMethodStart(this.getClass());
        if (expedientes.getCodigoZona() != null && expedientes.getCodigoZona().trim().length() > 0) {
            StringTokenizer tokens = new StringTokenizer(expedientes.getCodigoZona(), ",");
            Set<String> zonas = new HashSet<String>();
            while (tokens.hasMoreTokens()) {
                String zona = tokens.nextToken();
                zonas.add(zona);
            }
            expedientes.setCodigoZonas(zonas);
        } else {
           
            expedientes.setCodigoZonas(usuario.getCodigoZonas());
        }
        EventFactory.onMethodStop(this.getClass());
        
        if (esBusquedaExpRecobro) {
            return expedienteDao.buscarExpedientesRecobroPaginadoDinamico(expedientes,usuario,params);
        }else{
            return expedienteDao.buscarExpedientesPaginadoDinamico(expedientes,usuario,params);
        }
    }

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_PARA_EXCEL_DINAMICO)
    public List<Expediente> findExpedientesParaExcelDinamico(DtoBuscarExpedientes dto, String params) {
		Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_EXPEDIENTES);
        int limit = Integer.parseInt(param.getValor());
		Page p = this.findExpedientesPaginatedDinamico(dto, params, limit, false);
        return (List<Expediente>) p.getResults();
    }
    
    @SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_RECOBRO_PARA_EXCEL_DINAMICO)
    public List<Expediente> findExpedientesRecobroParaExcelDinamico(DtoBuscarExpedientes dto, String params) {
        Page p = this.findExpedientesPaginatedDinamico(dto, params, 2000, true);
        return (List<Expediente>) p.getResults();
    }
    
    /**
     * Busca expedientes para un contrato determinado.
     *
     * @param idExpediente El id del expediente
     * @return List
     */
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_CONTRATO_POR_ID)
    public List<ExpedienteContrato> findExpedientesContratoPorId(Long idExpediente) {
        return expedienteDao.findContratosExpediente(idExpediente);
    }

    /**
     * {@inheritDoc}
     */
	@BusinessOperation(InternaBusinessOperation.CONTRATOS_DE_UN_EXPEDIENET_SIN_PAGINAR)
    public List<DtoExpedienteContrato> contratosDeUnExpedienteSinPaginar(DtoBuscarContrato dto) {
        // Lista de contratos del expediente
        List<ExpedienteContrato> expedienteContratosExpediente = expedienteDao.findContratosExpediente(dto.getIdExpediente());
        // Lista de contratos inclu�dos en el procedimiento si ya existe
        List<ExpedienteContrato> expedienteContratosIncluidos;
        if (dto.getIdProcedimiento() != null && !dto.getIdProcedimiento().equals("")) {
            Procedimiento prc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, dto.getIdProcedimiento());
            expedienteContratosIncluidos = prc.getExpedienteContratos();
        } else {
            expedienteContratosIncluidos = new ArrayList<ExpedienteContrato>();
        }
        // Lista de todos los contratos del expedientes, con el check 'seleccionado' en el dto en true
        // si ya estaba incluido en el procedimiento
        List<DtoExpedienteContrato> dtoExpedienteContratos = new ArrayList<DtoExpedienteContrato>();
        for (int i = 0; i < expedienteContratosExpediente.size(); i++) {
            DtoExpedienteContrato dtoExpedienteContrato = new DtoExpedienteContrato();
            dtoExpedienteContrato.setExpedienteContrato(expedienteContratosExpediente.get(i));
            if (expedienteContratosIncluidos.contains(expedienteContratosExpediente.get(i))) {
                dtoExpedienteContrato.setSeleccionado(true);
            } else {
                dtoExpedienteContrato.setSeleccionado(false);
            }
            dtoExpedienteContratos.add(dtoExpedienteContrato);
        }
        return dtoExpedienteContratos;
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_PERSONAS_BY_EXPEDIENET_ID)
    public List<Persona> findPersonasByExpedienteId(Long idExpediente) {
        return expedienteDao.findPersonasContratosExpediente(idExpediente);
    }

    /**
     * Retorna todas las personas intervinientes y sus relaciones dependiendo del ambito del expediente.
     *
     * @param idPersona Long con el id de la persona de pase
     * @param ambitoExpediente String con el c�digo del �mbito del expediente
     * @return List
     */
    private HashMap<String, List<Long>> obtenerPersonasGeneracionExpediente(Long idPersona, String ambitoExpediente, Integer cantidadMaxima) {
        HashMap<String, List<Long>> hPersonas = new HashMap<String, List<Long>>(3);
        List<Long> personasExpediente = new ArrayList<Long>();
        personasExpediente.add(idPersona);

        List<Long> personasPase = new ArrayList<Long>(1);
        personasPase.add(idPersona);
        hPersonas.put(MAP_PERSONAS_PASE, personasPase);

        try {

            //Si debemos recuperar las personas del grupo
            if ((personasExpediente.size() < cantidadMaxima)
                    && (DDAmbitoExpediente.PERSONAS_GRUPO.equals(ambitoExpediente)
                            || DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION.equals(ambitoExpediente) || DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION
                            .equals(ambitoExpediente))) {

                List<Long> personasTemporal = expedienteDao.obtenerPersonasRelacionadosExpedienteGrupo(idPersona);
                hPersonas.put(MAP_PERSONAS_GRUPO, getListaRecortada(cantidadMaxima, personasExpediente.size(), personasTemporal));
                agregaContratosLista(cantidadMaxima, personasTemporal, personasExpediente);
            }

            //Si debemos recuperar las personas de la primera generaci�n
            if ((personasExpediente.size() < cantidadMaxima)
                    && (DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION.equals(ambitoExpediente) || DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION
                            .equals(ambitoExpediente))) {

                List<Long> personasTemporal = expedienteDao.obtenerPersonasRelacionadosExpedientePrimeraGeneracion(personasExpediente);
                hPersonas.put(MAP_PERSONAS_GENERACION_1, getListaRecortada(cantidadMaxima, personasExpediente.size(), personasTemporal));
                agregaContratosLista(cantidadMaxima, personasTemporal, personasExpediente);
            }

            //Si debemos recuperar las personas de la segunda generaci�n
            if ((personasExpediente.size() < cantidadMaxima) && (DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION.equals(ambitoExpediente))) {

                List<Long> personasTemporal = expedienteDao.obtenerPersonasRelacionadosExpedienteSegundaGeneracion(personasExpediente);
                hPersonas.put(MAP_PERSONAS_GENERACION_2, getListaRecortada(cantidadMaxima, personasExpediente.size(), personasTemporal));
                agregaContratosLista(cantidadMaxima, personasTemporal, personasExpediente);
            }

        } catch (NonRollbackException boe) {
            logger.info("Llegue a la maxima cantidad de personas para un expediente, se descartan los demas. Persona de Pase: " + idPersona);
        }

        return hPersonas;
    }

    /**
     * Retorna todos los contratos de todos los intervinientes y sus relaciones dependiendo del ambito del expediente.
     *
     * @param idContrato Long con el id del contrato de pase
     * @param idPersona Long con el id de la persona de pase
     * @param ambitoExpediente String con el c�digo del �mbito del expediente
     * @return List
     */
    private HashMap<String, List<Long>> obtenerContratosGeneracionExpediente(Long idContrato, Long idPersona, String ambitoExpediente,
            Integer cantidadMaxima) {
        HashMap<String, List<Long>> hContratos = new HashMap<String, List<Long>>(3);
        List<Long> contratosExpediente = new ArrayList<Long>();
        contratosExpediente.add(idContrato);

        List<Long> contratosPase = new ArrayList<Long>(1);
        contratosPase.add(idContrato);
        hContratos.put(MAP_CONTRATOS_PASE, contratosPase);

        try {

            //Si debemos recuperar los contratos del grupo
            if ((contratosExpediente.size() < cantidadMaxima)
                    && (DDAmbitoExpediente.CONTRATOS_GRUPO.equals(ambitoExpediente)
                            || DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION.equals(ambitoExpediente) || DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION
                            .equals(ambitoExpediente))) {

                List<Long> contratosTemporal = expedienteDao.obtenerContratosRelacionadosExpedienteGrupo(contratosExpediente, idPersona);
                hContratos.put(MAP_CONTRATOS_GRUPO, getListaRecortada(cantidadMaxima, contratosExpediente.size(), contratosTemporal));
                agregaContratosLista(cantidadMaxima, contratosTemporal, contratosExpediente);
            }

            //Si debemos recuperar los contratos de la primera generaci�n
            if ((contratosExpediente.size() < cantidadMaxima)
                    && (DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION.equals(ambitoExpediente) || DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION
                            .equals(ambitoExpediente))) {

                List<Long> contratosTemporal = expedienteDao.obtenerContratosRelacionadosExpedientePrimeraGeneracion(contratosExpediente);
                hContratos.put(MAP_CONTRATOS_GENERACION_1, getListaRecortada(cantidadMaxima, contratosExpediente.size(), contratosTemporal));
                agregaContratosLista(cantidadMaxima, contratosTemporal, contratosExpediente);
            }

            //Si debemos recuperar los contratos de la segunda generaci�n
            if ((contratosExpediente.size() < cantidadMaxima) && (DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION.equals(ambitoExpediente))) {

                List<Long> contratosTemporal = expedienteDao.obtenerContratosRelacionadosExpedienteSegundaGeneracion(contratosExpediente);
                hContratos.put(MAP_CONTRATOS_GENERACION_2, getListaRecortada(cantidadMaxima, contratosExpediente.size(), contratosTemporal));
                agregaContratosLista(cantidadMaxima, contratosTemporal, contratosExpediente);
            }

        } catch (NonRollbackException boe) {
            logger.info("Llegue a la maxima cantidad de contratos para un expediente, se descartan los demas. Contrato de Pase: " + idContrato);
        }

        return hContratos;
    }

    /**
     * Recupera el m�ximo de contratos adicionales para un expediente.
     * Si no existe valor en la BBDD informa el error y usa el valor 20 por defecto
     * @return Integer
     */
    private Integer getLimiteContratosAdicionales() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_CONTRATOS_ADICIONALES);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            logger.warn("No esta parametrizada la cantidad maxima de contratos por expediente, se toma un valor por default");
            return Integer.valueOf("20");
        }
    }

    /**
     * Recupera el m�ximo de personas adicionales para un expediente.
     * Si no existe valor en la BBDD informa el error y usa el valor 20 por defecto
     * @return Integer
     */
    private Integer getLimitePersonasAdicionales() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_PERSONAS_ADICIONALES);
            return Integer.valueOf(param.getValor());
        } catch (ParametrizationException e) {
            logger.warn("No esta parametrizada la cantidad maxima de personas por expediente, se toma un valor por default");
            return Integer.valueOf("10");
        }
    }

    /**
     * Recorta la lista
     * @param cantidadMaxima
     * @param tamActualLista
     * @param contratosTemp
     * @return
     */
    private List<Long> getListaRecortada(Integer cantidadMaxima, int tamActualLista, List<Long> contratosTemp) {
        List<Long> lista = new ArrayList<Long>();

        int cantTemp = contratosTemp.size();
        int cantExp = tamActualLista;
        if ((cantTemp + cantExp) > cantidadMaxima) {
            int cantPerm = cantidadMaxima - cantExp;
            for (int i = cantTemp - 1; i >= cantPerm; i--) {
                contratosTemp.remove(i);
            }
            lista.addAll(contratosTemp);
            return lista;
        } else {
            lista.addAll(contratosTemp);
            return lista;
        }
    }

    /**
     * agrega contratos a la lista de contratos de expediente siempre y cuando no se pase del limite.
     * Si se pasa lanza una BusinessOperationException para que se frene el proceso.
     * @param cantidadMaxima cantidadMaxima
     * @param contratosTemp contratosTemp
     * @param contratosExpediente contratosExpediente
     */
    private void agregaContratosLista(Integer cantidadMaxima, List<Long> contratosTemp, List<Long> contratosExpediente) {
        int cantTemp = contratosTemp.size();
        int cantExp = contratosExpediente.size();
        if ((cantTemp + cantExp) > cantidadMaxima) {
            int cantPerm = cantidadMaxima - cantExp;
            for (int i = cantTemp - 1; i >= cantPerm; i--) {
                contratosTemp.remove(i);
            }
            contratosExpediente.addAll(contratosTemp);
            throw new NonRollbackException("Se llego al limite de contratos");
        }
        contratosExpediente.addAll(contratosTemp);

    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_OBTEER_SUPERVISOR_GENERACION_EXPEDIENTE)
    public List<String> obtenerSupervisorGeneracionExpediente(DtoBuscarExpedientes expediente) {
        return expedienteDao.obtenerSupervisorGeneracionExpediente(expediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE)
    public Expediente getExpediente(Long idExpediente) {
    	EventFactory.onMethodStart(this.getClass());
        return expedienteDao.get(idExpediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_SAVE_OR_UPDATE)
    @Transactional(readOnly = false)
    public void saveOrUpdate(Expediente exp) {
        expedienteDao.saveOrUpdate(exp);
    }

    /**
     * M�todo para setearle el nombre a un expediente en funci�n del nombre del primer titular.
     * @param expediente Expediente al que debemos setearle el nombre
     */
    private void setearNombreExpediente(Expediente expediente) {
        Persona persona = expediente.getContratoPase().getPrimerTitular();

        if (persona == null || persona.getApellidoNombre() == null || persona.getApellidoNombre().trim().length() == 0) {
            expediente.setDescripcionExpediente("EXP_CNT_" + expediente.getContratoPase().getCodigoContrato());
        } else {
            expediente.setDescripcionExpediente(persona.getApellidoNombre());
        }
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_AUTO)
    @Transactional(readOnly = false)
    public Expediente crearExpedienteAutomatico(Long idContrato, Long idPersona, Long idArquetipo, Long idBPMExpediente, Long idBPMCliente) {

        validarContratoPase(idContrato);

        Expediente expediente = new Expediente();
        expediente.setExpProcessBpm(idBPMExpediente);

        //Seteamos las personas/contratos del expediente
        setearPersonasContratosExpediente(expediente, idContrato, idPersona, idArquetipo);

        // Estado Expediente
        setEstadoExpediente(expediente);
        DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO);

        expediente.setEstadoExpediente(estadoExpediente);

        // AAA
        ActitudAptitudActuacion aaa = new ActitudAptitudActuacion();
        aaa.setAuditoria(Auditoria.getNewInstance());
        expediente.setAaa(aaa);

        // El expediente no es manual
        expediente.setManual(false);

        //Seteo el arquetipo del expediente
        Arquetipo arq = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, idArquetipo);
        expediente.setArquetipo(arq);

        //Obtenemos la oficina del contrato de pase
        // VRE
        //List<Cliente> clientes = clienteManager.buscarClientesTitularesPorContrato(idContrato);        
        //Long oficina = obtenerMayorVRE(idContrato);
        Contrato cnt = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);

        if (cnt != null) {
            Oficina ofi = cnt.getOficina();
            expediente.setOficina(ofi);
        } else {
            //new ParametrizationException("No existe oficina para el expediente a generar");
            throw new GenericRollbackException("expediente.oficinaNoExistente");
        }
        // Anular Clientes relacionados
        eliminarProcesosClientesRelacionados(expediente, idBPMCliente);

        //Le seteamos el nombre ya que ahora no se obtiene a trav�s de una f�rmula
        setearNombreExpediente(expediente);
        
        // Seteamos el tipo de expediente
        DDTipoExpediente tipo = null;
        if(arq !=null && arq.getItinerario()!=null && arq.getItinerario().getdDtipoItinerario().getItinerarioSeguimiento())
        	tipo = genericDao.get(DDTipoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoExpediente.TIPO_EXPEDIENTE_SEGUIMIENTO), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
        else
        	tipo = genericDao.get(DDTipoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoExpediente.TIPO_EXPEDIENTE_RECUPERACION), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
        expediente.setTipoExpediente(tipo); 
	

        saveOrUpdate(expediente);

        executor.execute(InternaBusinessOperation.BO_POL_MGR_INICIALIZAR_POLITICAS_EXPEDIENTE, expediente);

        return expediente;
    }

    /**
     * Extrae de los vectores de contratos (hContratos), las personas asociadas a esos contratos y devuelve un conjunto de vectores
     * @param idPersona
     * @param idContrato
     * @param hContratos
     * @return
     */
    private HashMap<String, List<Long>> obtenerPersonasDeContratos(Long idPersona, Long idContrato, HashMap<String, List<Long>> hContratos) {
        HashMap<String, List<Long>> hPersonas = new HashMap<String, List<Long>>(4);
        List<Long> contratosPase = hContratos.get(MAP_CONTRATOS_PASE);
        List<Long> contratosGrupo = hContratos.get(MAP_CONTRATOS_GRUPO);
        List<Long> contratosGeneracion1 = hContratos.get(MAP_CONTRATOS_GENERACION_1);
        List<Long> contratosGeneracion2 = hContratos.get(MAP_CONTRATOS_GENERACION_2);

        Integer limitePersonas = Integer.MAX_VALUE;

        if (contratosPase != null && contratosPase.size() > 0) {
            List<Long> vectorTemporal = expedienteDao.obtenerPersonasDeContratos(idPersona, idContrato, contratosPase, limitePersonas);
            hPersonas.put(MAP_PERSONAS_PASE, vectorTemporal);
        }

        if (contratosGrupo != null && contratosGrupo.size() > 0) {
            List<Long> vectorTemporal = expedienteDao.obtenerPersonasDeContratos(idPersona, idContrato, contratosGrupo, limitePersonas);
            hPersonas.put(MAP_PERSONAS_GRUPO, vectorTemporal);
        }

        if (contratosGeneracion1 != null && contratosGeneracion1.size() > 0) {
            List<Long> vectorTemporal = expedienteDao.obtenerPersonasDeContratos(idPersona, idContrato, contratosGeneracion1, limitePersonas);
            hPersonas.put(MAP_PERSONAS_GENERACION_1, vectorTemporal);
        }

        if (contratosGeneracion2 != null && contratosGeneracion2.size() > 0) {
            List<Long> vectorTemporal = expedienteDao.obtenerPersonasDeContratos(idPersona, idContrato, contratosGeneracion2, limitePersonas);
            hPersonas.put(MAP_PERSONAS_GENERACION_2, vectorTemporal);
        }
        return hPersonas;
    }

    /**
     * Extrae de los vectores de personas (hPersonas), los contratos asociados a esas personas y devuelve un conjunto de vectores
     * @param idPersona
     * @param idContrato
     * @param hPersonas
     * @return
     */
    private HashMap<String, List<Long>> obtenerContratosDePersonas(Long idPersona, Long idContrato, HashMap<String, List<Long>> hPersonas) {
        HashMap<String, List<Long>> hContratos = new HashMap<String, List<Long>>(3);
        List<Long> personasPase = hPersonas.get(MAP_PERSONAS_PASE);
        List<Long> personasGrupo = hPersonas.get(MAP_PERSONAS_GRUPO);
        List<Long> personasGeneracion1 = hPersonas.get(MAP_PERSONAS_GENERACION_1);
        List<Long> personasGeneracion2 = hPersonas.get(MAP_PERSONAS_GENERACION_2);

        Integer limiteContratos = Integer.MAX_VALUE;

        if (personasPase != null && personasPase.size() > 0) {
            List<Long> vectorTemporal = expedienteDao.obtenerContratosDePersonas(idPersona, idContrato, personasPase, limiteContratos);
            hContratos.put(MAP_CONTRATOS_PASE, vectorTemporal);
        }

        if (personasGrupo != null && personasGrupo.size() > 0) {
            List<Long> vectorTemporal = expedienteDao.obtenerContratosDePersonas(idPersona, idContrato, personasGrupo, limiteContratos);
            hContratos.put(MAP_CONTRATOS_GRUPO, vectorTemporal);
        }

        if (personasGeneracion1 != null && personasGeneracion1.size() > 0) {
            List<Long> vectorTemporal = expedienteDao.obtenerContratosDePersonas(idPersona, idContrato, personasGeneracion1, limiteContratos);
            hContratos.put(MAP_CONTRATOS_GENERACION_1, vectorTemporal);
        }

        if (personasGeneracion2 != null && personasGeneracion2.size() > 0) {
            List<Long> vectorTemporal = expedienteDao.obtenerContratosDePersonas(idPersona, idContrato, personasGeneracion2, limiteContratos);
            hContratos.put(MAP_CONTRATOS_GENERACION_2, vectorTemporal);
        }
        return hContratos;
    }

    /**
     * Setea la personas y los contratos de un expediente.
     * @param expediente Expediente donde almacenar personas y contratos
     * @param idContrato Contrato de pase
     * @param idPersona Persona de pase
     * @param idArquetipo Arquetipo de la persona
     */
    private void setearPersonasContratosExpediente(Expediente expediente, Long idContrato, Long idPersona, Long idArquetipo) {
        Arquetipo arq = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, idArquetipo);
        DDAmbitoExpediente ambitoExpediente = arq.getItinerario().getAmbitoExpediente();
        Boolean expedienteRecuperacion = arq.getItinerario().getdDtipoItinerario().getItinerarioRecuperacion();

        Integer limitePersonas = getLimitePersonasAdicionales();
        Integer limiteContratos = getLimiteContratosAdicionales();

        HashMap<String, List<Long>> hContratos;
        HashMap<String, List<Long>> hPersonas;

        //Dependiendo de si la generaci�n es de recuperaci�n de seguimiento
        if (expedienteRecuperacion) {
            hContratos = obtenerContratosGeneracionExpediente(idContrato, idPersona, ambitoExpediente.getCodigo(), limiteContratos);
            hPersonas = obtenerPersonasDeContratos(idPersona, idContrato, hContratos);
            //hPersonas = obtenerPersonasDeContratos(idContrato, idPersona, hContratos);

        } else {
            validarPersonaPase(idPersona);

            hPersonas = obtenerPersonasGeneracionExpediente(idPersona, ambitoExpediente.getCodigo(), limitePersonas);
            hContratos = obtenerContratosDePersonas(idPersona, idContrato, hPersonas);
        }

        List<ExpedienteContrato> contratos = setearContratosExpediente(idContrato, hContratos, expediente, limiteContratos);
        List<ExpedientePersona> personas = setearPersonasExpediente(idPersona, hPersonas, expediente, limitePersonas);

        expediente.setContratos(contratos);
        expediente.setPersonas(personas);
    }

    /**
     * Valida que el contrato no exista en un expediente activo, bloqueado o congelado.
     * De ser asi lanza una excepci�n
     * @param idContrato
     * @throws BusinessOperationException contrato en otro expediente.
     */
    private void validarContratoPase(Long idContrato) {
        Expediente exp = expedienteDao.buscarExpedientesParaContrato(idContrato);
        if (exp != null) { throw new NonRollbackException("expediente.contrato.invalido.otroExpediente", idContrato); }
    }

    /**
     * Valida que la persona no exista en un expediente activo, bloqueado o congelado de seguimiento.
     * De ser asi lanza una excepci�n
     * @param idPersona
     * @throws BusinessOperationException contrato en otro expediente.
     */
    private void validarPersonaPase(Long idPersona) {
        Expediente exp = expedienteDao.buscarExpedientesSeguimientoParaPersona(idPersona);
        if (exp != null) { throw new NonRollbackException("expediente.persona.invalido.otroExpediente", idPersona); }
    }

    /**
     * {@inheritDoc}
     */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_SEGUIMIENTO)
    @Transactional(readOnly = false)
    public Expediente crearExpedienteManualSeg(Long idPersona) {
    	return this.crearExpedienteManualSeg(idPersona,null);
    	
    }
	
	@SuppressWarnings("unchecked")
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_GESTION_DEUDA)
	@Transactional(readOnly=false)
	public Expediente crearExpedienteManualGestDeuda(Long idPersona, Long idArquetipo) {
        // Se asigna como contrato de pase el de mayor riesgo de la persona de pase (artf554001)
        List<Contrato> contratos = (List<Contrato>) executor.execute(
                PrimariaBusinessOperation.BO_CNT_MGR_OBTENER_CONTRATOS_GENERACION_EXPEDIENTE_MANUAL, idPersona);
        if (contratos.size()>0) {
	        Contrato contratoMax = contratos.get(0);
	        Float riesgoMax = 0F;
	        for (Contrato contrato : contratos) {
	            Float riesgo = contrato.getRiesgo();
	            if (!Checks.esNulo(riesgo)) {
		            if (riesgo > riesgoMax) {
		                contratoMax = contrato;
		                riesgoMax = riesgo;
		            }
	            }
	        }
	        // Creamos el expediente
	        Expediente expediente = crearExpedienteManual(idPersona, contratoMax.getId(),idArquetipo);
	       
	        return expediente;
        } else {
        	return null;
        }		
	}
	
    
	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_SEGUIMIENTO_ARQ)
    @Transactional(readOnly = false)
    public Expediente crearExpedienteManualSeg(Long idPersona, Long idArquetipo) {
        // Se asigna como contrato de pase el de mayor riesgo de la persona de pase (artf554001)
        List<Contrato> contratos = (List<Contrato>) executor.execute(
                PrimariaBusinessOperation.BO_CNT_MGR_OBTENER_CONTRATOS_GENERACION_EXPEDIENTE_MANUAL, idPersona);
        if (contratos.size()>0) {
	        Contrato contratoMax = contratos.get(0);
	        Float riesgoMax = contratoMax.getRiesgo();
	        for (Contrato contrato : contratos) {
	            Float riesgo = contrato.getRiesgo();
	            if (riesgo > riesgoMax) {
	                contratoMax = contrato;
	                riesgoMax = riesgo;
	            }
	        }
	        // Creamos el expediente
	        Expediente expediente = crearExpedienteManual(idPersona, contratoMax.getId(),idArquetipo);
	       
	        return expediente;
        } else {
        	return null;
        }
    }
    
    
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL)
    @Transactional(readOnly = false)
    public Expediente crearExpedienteManual(Long idPersona, Long idContrato) {
    	return this.crearExpedienteManual(idPersona, idContrato, null);
    }
    	


	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CREAR_EXPEDIENTE_MANUAL_ARQ)
    @Transactional(readOnly = false)
    public Expediente crearExpedienteManual(Long idPersona, Long idContrato, Long idArquetipo) {
        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
        //Validamos que alguien mas no haya creado un expediente concurrentemente
        Boolean sinExpedientesActivos = this.sinExpedientesActivosDeUnaPersona(idPersona);

        if (!sinExpedientesActivos) { throw new BusinessOperationException("expediente.creacionManual.existente", persona.getApellidoNombre()); }

        Cliente cliente = persona.getClienteActivo();
        if (cliente == null) {
        	//Ahora esto está deprecated
        	//idArquetipo = persona.getArquetipoCalculado();
        	
        	//Ahora el arquetipo viene previamente seleccionado, pero sino, lo cogemos de la persona
        	if (idArquetipo==null) {
        		Arquetipo arquetipo = arquetipoDao.getArquetipoPorPersona(persona.getId());
        		if (arquetipo!= null)
        			idArquetipo = arquetipo.getId();
        	}
        	if (!arquetipoDao.get(idArquetipo).getItinerario().getdDtipoItinerario().getItinerarioGestionDeuda()) {
        		executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_CREAR_CLIENTE, idPersona, null, idArquetipo, true);
        	} else {
        		executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_CREAR_CLIENTE_GEST_DEUDA, idPersona, null, idArquetipo, true);
        	}
        } else {
        	if (idArquetipo==null)
        		idArquetipo = cliente.getArquetipo().getId();
        }

        Expediente expediente = new Expediente();

        //Seteamos las personas/contratos del expediente
        setearPersonasContratosExpediente(expediente, idContrato, idPersona, idArquetipo);

        //Seteo expediente MANUAL
        expediente.setManual(true);
        // Estado Expediente
        setEstadoExpediente(expediente);
        DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_PROPUESTO);

        expediente.setEstadoExpediente(estadoExpediente);
        // AAA
        //Seteo el arquetipo del expediente
        Arquetipo arq = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, idArquetipo);
        expediente.setArquetipo(arq);
        // VRE
        //Long oficina = obtenerMayorVRE(idContrato);
        Contrato cnt = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);

        if (cnt != null) {
            Oficina ofi = cnt.getOficina();
            expediente.setOficina(ofi);
        } else {
            //No existe el cliente aun, tomo la oficina del contrato
            Contrato contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);
            expediente.setOficina(contrato.getOficina());
        }
        //TODO Revisar la forma de obtener el nombre del expediente para igualarlo al nuevo batch
        //Le seteamos el nombre ya que ahora no se obtiene a trav�s de una f�rmula
        setearNombreExpediente(expediente);
        
        // Seteamos el tipo de expediente
        DDTipoExpediente tipo = null;
        if(arq !=null && arq.getItinerario()!=null && arq.getItinerario().getdDtipoItinerario().getItinerarioSeguimiento()) {
        	tipo = genericDao.get(DDTipoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoExpediente.TIPO_EXPEDIENTE_SEGUIMIENTO), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
        } else {
        	if (arq!=null && arq.getItinerario()!=null && arq.getItinerario().getdDtipoItinerario().getItinerarioGestionDeuda()) {
        		tipo = genericDao.get(DDTipoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoExpediente.TIPO_EXPEDIENTE_GESTION_DEUDA), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
        	} else {
        		tipo = genericDao.get(DDTipoExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoExpediente.TIPO_EXPEDIENTE_RECUPERACION), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
        	}
        }
        expediente.setTipoExpediente(tipo); 
		
		saveOrUpdate(expediente);

        return expediente;
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CONFIRMAR_EXPEDIENTE_AUTOMATICO)
    @Transactional(readOnly = false)
    public void confirmarExpedienteAutomatico(Long idExpediente) {
        Expediente exp = this.getExpediente(idExpediente);
        ActitudAptitudActuacion aaa = new ActitudAptitudActuacion();
        aaa.setAuditoria(Auditoria.getNewInstance());
        exp.setAaa(aaa);
        DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO);

        exp.setEstadoExpediente(estadoExpediente);
        // Anular Clientes relacionados
        eliminarProcesosClientesRelacionados(exp, Long.MIN_VALUE);
        Map<String, Object> param = new HashMap<String, Object>();
        param.put(ExpedienteBPMConstants.EXPEDIENTE_MANUAL_ID, exp.getId());
        Long bpmid = null;
        if(exp.isGestionDeuda()){
        	bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, ExpedienteBPMConstants.EXPEDIENTE_DEUDA_PROCESO, param);
        }else{
        	bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, ExpedienteBPMConstants.EXPEDIENTE_PROCESO, param);
        }
        exp.setExpProcessBpm(bpmid);

        saveOrUpdate(exp);

        //Inicializamos la prepolitica y la politica CE
        executor.execute(InternaBusinessOperation.BO_POL_MGR_INICIALIZAR_POLITICAS_EXPEDIENTE, exp);
    }

    /**
     * setea el estado del expediente.
     * @param expediente expediente
     */
    private void setEstadoExpediente(Expediente expediente) {

        DDEstadoItinerario estado = (DDEstadoItinerario) executor.execute(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE,
                DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE);
        expediente.setEstadoItinerario(estado);
        expediente.setFechaEstado(new Date());
    }

    /**
     * setea los contratos de un expediente.
     *
     * @param contratoPrincipal
     *            contrato principal
     * @param contratosAdicionales
     *            contratos adicionales.
     * @param expediente
     *            expediente
     * @return lista de contratos
     */
    private List<ExpedienteContrato> setearContratosExpediente(Long contratoPrincipal, HashMap<String, List<Long>> hContratos, Expediente expediente,
            Integer cantidadMaxima) {
        /*
         * En este m�todo es necesario crear expl�citamente un objeto de auditor�a poruqe los objetos
         * ExpedienteContrato se salvan indirectamente al salvar el expediente, por lo tanto nunca se
         * ejecuta el save de su dao, que es el que deber�a crear el obj de auditor�a.
         * No se puede llamar al save del dao de ExpedienteContrato porque todav�a no existe el Expediente
         * al cual asociarlo.
         */
        List<Long> contratosPase = new ArrayList<Long>(1);
        List<Long> contratosPaseAux = hContratos.get(MAP_CONTRATOS_PASE);
        List<Long> contratosGrupo = hContratos.get(MAP_CONTRATOS_GRUPO);
        List<Long> contratosGeneracion1 = hContratos.get(MAP_CONTRATOS_GENERACION_1);
        List<Long> contratosGeneracion2 = hContratos.get(MAP_CONTRATOS_GENERACION_2);

        contratosPase.add(contratoPrincipal);
        if (contratosPaseAux == null) contratosPaseAux = new ArrayList<Long>(0);
        if (contratosGrupo == null) contratosGrupo = new ArrayList<Long>(0);
        if (contratosGeneracion1 == null) contratosGeneracion1 = new ArrayList<Long>(0);
        if (contratosGeneracion2 == null) contratosGeneracion2 = new ArrayList<Long>(0);

        int size = 1 + contratosPaseAux.size() + contratosGrupo.size() + contratosGeneracion1.size() + contratosGeneracion2.size();
        List<Long> controlDuplicados = new ArrayList<Long>(size);
        List<ExpedienteContrato> contratos = new ArrayList<ExpedienteContrato>(size);

        //Seteamos los cuatro niveles de contratos
        DDAmbitoExpediente ambitoExpedientePase = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDAmbitoExpediente.class, DDAmbitoExpediente.CONTRATO_PASE);

        DDAmbitoExpediente ambitoGrupo = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDAmbitoExpediente.class, DDAmbitoExpediente.CONTRATOS_GRUPO);

        DDAmbitoExpediente ambitoGen1 = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDAmbitoExpediente.class, DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION);

        DDAmbitoExpediente ambitoGen2 = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDAmbitoExpediente.class, DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION);

        cantidadMaxima = addContratos(controlDuplicados, contratosPase, contratos, ambitoExpedientePase, expediente, true, cantidadMaxima);
        cantidadMaxima = addContratos(controlDuplicados, contratosPaseAux, contratos, ambitoExpedientePase, expediente, false, cantidadMaxima);
        cantidadMaxima = addContratos(controlDuplicados, contratosGrupo, contratos, ambitoGrupo, expediente, false, cantidadMaxima);
        cantidadMaxima = addContratos(controlDuplicados, contratosGeneracion1, contratos, ambitoGen1, expediente, false, cantidadMaxima);
        cantidadMaxima = addContratos(controlDuplicados, contratosGeneracion2, contratos, ambitoGen2, expediente, false, cantidadMaxima);

        return contratos;
    }

    /**
     * A�ade al vectorDestino los contratos del vectorOrigen que no est�n en el 'controlDuplicados'. A esos contratos les pondr� un ambito definido
     * @param controlDuplicados
     * @param vectorOrigen
     * @param vectorDestino
     * @param ambito
     * @param expediente
     * @param isPase
     */
    private int addContratos(List<Long> controlDuplicados, List<Long> vectorOrigen, List<ExpedienteContrato> vectorDestino,
            DDAmbitoExpediente ambito, Expediente expediente, Boolean isPase, int cantidadMaxima) {
        ExpedienteContrato expCon;
        Contrato contrato;

        if (cantidadMaxima == 0) return cantidadMaxima;

        for (Long c : vectorOrigen) {
            if (!controlDuplicados.contains(c)) {
                controlDuplicados.add(c);

                contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, c);

                expCon = new ExpedienteContrato();
                expCon.setAuditoria(Auditoria.getNewInstance());
                expCon.setAmbitoExpediente(ambito);

                if (isPase) {
                    expCon.setCexPase(1);
                } else {
                    expCon.setCexPase(0);
                }
                expCon.setExpediente(expediente);
                expCon.setContrato(contrato);

                vectorDestino.add(expCon);
            }

            cantidadMaxima--;
            if (cantidadMaxima == 0) return cantidadMaxima;
        }

        return cantidadMaxima;
    }

    /**
     * setea las personas de un expediente.
     *
     * @param personaPrincipal persona principal
     * @param hPersonas personas adicionales.
     * @param expediente expediente
     * @return lista de personas
     */
    private List<ExpedientePersona> setearPersonasExpediente(Long personaPrincipal, HashMap<String, List<Long>> hPersonas, Expediente expediente,
            Integer cantidadMaxima) {
        /*
         * En este m�todo es necesario crear expl�citamente un objeto de auditor�a porque los objetos
         * ExpedientePersona se salvan indirectamente al salvar el expediente, por lo tanto nunca se
         * ejecuta el save de su dao, que es el que deber�a crear el obj de auditor�a.
         * No se puede llamar al save del dao de ExpedientePersona porque todav�a no existe el Expediente
         * al cual asociarlo.
         */
        List<Long> personasPase = new ArrayList<Long>(1);
        List<Long> personasPaseAux = hPersonas.get(MAP_PERSONAS_PASE);
        List<Long> personasGrupo = hPersonas.get(MAP_PERSONAS_GRUPO);
        List<Long> personasGeneracion1 = hPersonas.get(MAP_PERSONAS_GENERACION_1);
        List<Long> personasGeneracion2 = hPersonas.get(MAP_PERSONAS_GENERACION_2);

        personasPase.add(personaPrincipal);
        if (personasPaseAux == null) personasPaseAux = new ArrayList<Long>(0);
        if (personasGrupo == null) personasGrupo = new ArrayList<Long>(0);
        if (personasGeneracion1 == null) personasGeneracion1 = new ArrayList<Long>(0);
        if (personasGeneracion2 == null) personasGeneracion2 = new ArrayList<Long>(0);

        int size = 1 + personasPaseAux.size() + personasGrupo.size() + personasGeneracion1.size() + personasGeneracion2.size();
        List<Long> controlDuplicados = new ArrayList<Long>(size);
        List<ExpedientePersona> personas = new ArrayList<ExpedientePersona>(size);

        //Seteamos los cuatro niveles de personas
        DDAmbitoExpediente ambitoExpedientePase = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDAmbitoExpediente.class, DDAmbitoExpediente.PERSONA_PASE);

        DDAmbitoExpediente ambitoGrupo = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDAmbitoExpediente.class, DDAmbitoExpediente.PERSONAS_GRUPO);

        DDAmbitoExpediente ambitoGen1 = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDAmbitoExpediente.class, DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION);

        DDAmbitoExpediente ambitoGen2 = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDAmbitoExpediente.class, DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION);

        cantidadMaxima = addPersonas(controlDuplicados, personasPase, personas, ambitoExpedientePase, expediente, true, cantidadMaxima);
        cantidadMaxima = addPersonas(controlDuplicados, personasPaseAux, personas, ambitoExpedientePase, expediente, false, cantidadMaxima);
        cantidadMaxima = addPersonas(controlDuplicados, personasGrupo, personas, ambitoGrupo, expediente, false, cantidadMaxima);
        cantidadMaxima = addPersonas(controlDuplicados, personasGeneracion1, personas, ambitoGen1, expediente, false, cantidadMaxima);
        cantidadMaxima = addPersonas(controlDuplicados, personasGeneracion2, personas, ambitoGen2, expediente, false, cantidadMaxima);

        return personas;

    }

    /**
     * A�ade al vectorDestino las personas del vectorOrigen que no est�n en el 'controlDuplicados'. A esas personas les pondr� un ambito definido
     * @param controlDuplicados
     * @param vectorOrigen
     * @param vectorDestino
     * @param ambito
     * @param expediente
     * @param isPase
     */
    private int addPersonas(List<Long> controlDuplicados, List<Long> vectorOrigen, List<ExpedientePersona> vectorDestino, DDAmbitoExpediente ambito,
            Expediente expediente, Boolean isPase, int cantidadMaxima) {
        ExpedientePersona expPer;
        Persona persona;

        if (cantidadMaxima == 0) return cantidadMaxima;

        for (Long id : vectorOrigen) {
            if (!controlDuplicados.contains(id)) {
                controlDuplicados.add(id);

                persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, id);

                expPer = new ExpedientePersona();
                expPer.setAuditoria(Auditoria.getNewInstance());

                if (isPase) {
                    expPer.setPase(1);
                } else {
                    expPer.setPase(0);
                }

                expPer.setAmbitoExpediente(ambito);
                expPer.setExpediente(expediente);
                expPer.setPersona(persona);
                vectorDestino.add(expPer);

                cantidadMaxima--;
                if (cantidadMaxima == 0) return cantidadMaxima;
            }
        }

        return cantidadMaxima;
    }

    /**
     * Borra todos los clientes relacionados.
     * @param expediente expediente
     * @param idInvocacion id proceso bpm original
     */
    @SuppressWarnings("unchecked")
    private void eliminarProcesosClientesRelacionados(Expediente expediente, Long idInvocacion) {

        //Borramos clientes por contrato
        for (ExpedienteContrato expContrato : expediente.getContratos()) {
            Long idContrato = expContrato.getContrato().getId();
            List<Cliente> clientes = (List<Cliente>) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_BUSCAR_CLIENTES_POR_CONTRATO, idContrato);
            for (Cliente cliente : clientes) {
                if (cliente.getProcessBPM() != null && !cliente.getProcessBPM().equals(idInvocacion)) {
                    executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, cliente.getProcessBPM());
                } else {
                	//Ahora se eliminan todos los clientes (MANUALES/AUTOMATICOS) ya que en el job de creación de clientes se volverá a crear en caso necesario
                	//if (cliente.getProcessBPM() == null && EstadoCliente.ESTADO_CLIENTE_MANUAL.equals(cliente.getEstadoCliente().getCodigo())) {
                    //En caso de que se hayan generado manualmente
                	
                	// Ahora se borran todos los clientes en la creación de expedientes:  PRODUCTO-215
                    	executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE, cliente.getId());
                    //}
                }
            }
        }

        //Borramos clientes por personas
        for (ExpedientePersona expPersona : expediente.getPersonas()) {
            Cliente cliente = expPersona.getPersona().getClienteActivo();

            if (cliente != null) {
                if (cliente.getProcessBPM() != null && !cliente.getProcessBPM().equals(idInvocacion)) {
                    executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, cliente.getProcessBPM());
                } else {
                	//Ahora se eliminan todos los clientes (MANUALES/AUTOMATICOS) ya que en el job de creación de clientes se volverá a crear en caso necesario
                	//if (cliente.getProcessBPM() == null && EstadoCliente.ESTADO_CLIENTE_MANUAL.equals(cliente.getEstadoCliente().getCodigo())) {
                    //En caso de que se hayan generado manualmente
                    	executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE, cliente.getId());
                    //}
                }
            }
        }
    }

    /**
     * {@inheritDoc}
     */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CAMBIAR_ESTADO_ITINERARIO_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void cambiarEstadoItinerarioExpediente(Long idExpediente, String estadoItinerario) {
        DDEstadoItinerario ddEstadoItinerario = (DDEstadoItinerario) executor.execute(ConfiguracionBusinessOperation.BO_EST_ITI_MGR_FIND_BY_CODE,
                estadoItinerario);
        Expediente expediente = this.getExpediente(idExpediente);
        expediente.setEstadoItinerario(ddEstadoItinerario);
        this.saveOrUpdate(expediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_OBTENER_EXPEDIENTE_DE_UNA_PERSONA)
    public List<Expediente> obtenerExpedientesDeUnaPersona(Long idPersona) {
        List<Expediente> expedientes = null;
        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
        expedientes = expedienteDao.obtenerExpedientesDeUnaPersona(persona.getId());
        return expedientes;
    }
    
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_TIENE_EXPEDIENTE_SEGUIMIENTO)
    public Boolean tieneExpedienteDeSeguimiento(Long idPersona){
    	
    	Boolean resultado = false;
    	List<Expediente> expedientes = null;
    	
    	expedientes = expedienteDao.obtenerExpedientesDeUnaPersona(idPersona);
    	
    	for(Expediente e: expedientes){
    		Arquetipo arquetipo = e.getArquetipo();
    		
    		//Si el arquetipo del expediente es de seguimiento
    		//y
    		//el expediente esta (Activo/Bloqueado/Congelado)
    		if(arquetipo !=null && arquetipo.getItinerario()!=null && arquetipo.getItinerario().getdDtipoItinerario().getItinerarioSeguimiento()
    				&& (e.getEstaEstadoActivo() || e.getEstaBloqueado() || e.getEstaCongelado())) {
    			resultado = true;
    			break;
    		}
    	}
    	
    	return resultado;
    } 
    
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_TIENE_EXPEDIENTE_RECUPERACION)
    public Boolean tieneExpedienteDeRecuperacion(Long idPersona){
    	
    	Boolean resultado = false;
    	List<Expediente> expedientes = null;
    	
    	expedientes = expedienteDao.obtenerExpedientesDeUnaPersona(idPersona);
    	
    	for(Expediente e: expedientes){
    		Arquetipo arquetipo = e.getArquetipo();
    		
    		//Si el arquetipo del expediente es de recuperacion
    		//y
    		//el expediente esta (Activo/Bloqueado/Congelado)    		
    		if(arquetipo !=null 
    				&& arquetipo.getItinerario()!=null 
    				&& arquetipo.getItinerario().getdDtipoItinerario().getItinerarioRecuperacion()
    				&& (e.getEstaEstadoActivo() || e.getEstaBloqueado() || e.getEstaCongelado())) {
    			resultado = true;
    			break;
    		}
    	}
    	
    	return resultado;
    } 
    
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_OBTENER_EXPEDIENTE_DE_UNA_PERSONA_PAGINADOS)
    public Page obtenerExpedientesDeUnaPersonaPaginados(DtoListadoExpedientes dto) {
        return expedienteDao.obtenerExpedientesDeUnaPersonaPaginados(dto);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_OBTENER_EXPEDIENTES_DE_UNA_PERSONA_NO_CANCELADOS)
    public List<Long> obtenerExpedientesDeUnaPersonaNoCancelados(Long idPersona) {
        List<Long> expedientes = null;
        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
        expedientes = expedienteDao.obtenerExpedientesDeUnaPersonaNoCancelados(persona.getId());
        return expedientes;
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_SET_INSTANCE_CAMBIO_ESTADO_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void setInstanteCambioEstadoExpediente(Long idExpediente) {
        Expediente exp = expedienteDao.get(idExpediente);
        exp.setFechaEstado(new Date());
        expedienteDao.saveOrUpdate(exp);
    }

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_TITULOS_EXPEDIENTE)
    public List<Titulo> findTitulosExpediente(Long idExpediente) {
        Expediente exp = expedienteDao.get(idExpediente);
        List<Titulo> titulos = new ArrayList<Titulo>();
        for (ExpedienteContrato expCnt : exp.getContratos()) {
            titulos.addAll((Collection<Titulo>) executor.execute(PrimariaBusinessOperation.BO_TITULO_MGR_FIND_TITULOS_BY_CONTRATO, expCnt
                    .getContrato().getId()));
        }
        //System.out.println("DEVUELVO " + titulos.size() + " TITULOS");
        return titulos;
    }

    private Boolean compruebaElevacion(Expediente expediente, String estadoParaElevar, Boolean isSupervisor) {
        //Comprobaciones para ver si estamos en el estado correcto
        Long bpmProcess = expediente.getProcessBpm();
        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
        if (estadoParaElevar == null || !estadoParaElevar.equals(node)) {
            logger.error("No se puede enviar a revision/decisión porque el expediente no esta en completar/revisión");
            throw new BusinessOperationException("expediente.elevarRevision.errorJBPM");
        }

        if (!isSupervisor) {
            //Comprobaci�n de las reglas de elevaci�n
            List<ReglasElevacion> listadoReglas = getReglasElevacionExpediente(expediente.getId());
            for (ReglasElevacion regla : listadoReglas) {
                if (!regla.getCumple()) { return false; }
            }
        }

        return true;
    }
    
    
    private Boolean compruebaDevolucion(Expediente expediente, String estadoParaDevolver, String estadoNuevo){
    	//Comprobaciones para ver si estamos en el estado correcto
        Long bpmProcess = expediente.getProcessBpm();
        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
        if(estadoParaDevolver == null || !estadoParaDevolver.equals(node)){
        	 logger.error("No se puede devolver a revision/decisión porque el expediente no esta en decisión a comité");
             throw new BusinessOperationException("expediente.elevarRevision.errorJBPM");
        }
        DDEstadoItinerario estadoItinerario = expediente.getEstadoItinerario();
        Estado estado = (Estado) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_GET, expediente.getArquetipo().getItinerario(),
                estadoItinerario);

        List<ReglasElevacion> listadoReglas = expedienteDao.getReglasElevacion(estado);

        //obtenemos los acuerdos del expediente para luego comprobar las reglas
        List<Acuerdo> acuerdos = genericDao.getList(Acuerdo.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId()));
        
        //Comprobamos una a una si las reglas se cumplen
        for (ReglasElevacion regla : listadoReglas) {
        	
        	if(regla.getTipoReglaElevacion().getCodigo().equals(DDTipoReglasElevacion.MARCADO_GESTION_PROPUESTA)){
        		if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_DECISION_COMIT) && estadoNuevo!= null && estadoNuevo.equals(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE)){
        			regla.setCumple(cumplimientoReglaDCRE(expediente, acuerdos));
        			if(!regla.getCumple()){ return false;}
        		}else if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_FORMALIZAR_PROPUESTA) && estadoNuevo!= null && estadoNuevo.equals(DDEstadoItinerario.ESTADO_DECISION_COMIT)){
        			regla.setCumple(cumplimiendoReglaFPDC(expediente, acuerdos));
        			if(!regla.getCumple()){ return false;}
        		}else if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION) && estadoNuevo!= null && estadoNuevo.equals(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE)){
        			
        			List<String> estadosValidos = new ArrayList<String>();
        			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_ACEPTADO);
        			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_RECHAZADO);
        			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_CUMPLIDO);
        			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO);
        			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_CANCELADO);
    	    		
        			regla.setCumple(cumplimientoReglaGeneric( acuerdos, estadosValidos,DDEstadoAcuerdo.ACUERDO_ACEPTADO));
        			
        			if(!regla.getCumple()){ return false;}
        			
        		}else if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO) && estadoNuevo!= null && estadoNuevo.equals(DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION)){
        			regla.setCumple(cumplimientoReglaSANC(expediente, acuerdos));
        			if(!regla.getCumple()){ return false;}
        		}
        	}
        }
    	
    	return true;
    }

    /**
     * {@inheritDoc}
     */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_REVISION)
    @Transactional(readOnly = false)
    public void elevarExpedienteARevision(Long idExpediente, Boolean isSupervisor) {
        Expediente exp = expedienteDao.get(idExpediente);

        Boolean permitidoElevar = compruebaElevacion(exp, ExpedienteBPMConstants.STATE_COMPLETAR_EXPEDIENTE, isSupervisor);
        if (!permitidoElevar) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }

        Boolean politicasVigentes = (Boolean) executor.execute(InternaBusinessOperation.BO_POL_MGR_MARCAR_POLITICAS_VIGENTES, exp, null, false);

        //Si se ha marcado como vigente las pol�ticas, el expediente se decide
        if (politicasVigentes) {
            DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO);
            exp.setEstadoExpediente(estadoExpediente);
            saveOrUpdate(exp);

            //Si no se ha marcado como vigente, se siguie en la elevaci�n del expediente
        } else {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, exp.getProcessBpm(),
                    ExpedienteBPMConstants.TRANSITION_ENVIARAREVISION);
        }
    }
	
    /**
     * {@inheritDoc}
     */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_DE_REVISION_A_ENSANCION)
    @Transactional(readOnly = false)
    public void elevarExpedienteDeREaENSAN(Long idExpediente, Boolean isSupervisor) {
        Expediente exp = expedienteDao.get(idExpediente);

        Boolean permitidoElevar = compruebaElevacion(exp, ExpedienteBPMConstants.STATE_REVISION_EXPEDIENTE, isSupervisor);
        if (!permitidoElevar) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }
        
        executor.execute(InternaBusinessOperation.BO_POL_MGR_MARCAR_POLITICAS_VIGENTES, exp, null, false);
        
        /*El BPM debe cambiar el estado del itinerario en el expediente*/
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, exp.getProcessBpm(),ExpedienteBPMConstants.TRANSITION_ENVIARAENSANCION);
        
    }
	
	
    /**
     * {@inheritDoc}
     */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_DE_ENSANCION_A_SANCIONADO)
    @Transactional(readOnly = false)
    public void elevarExpedienteDeENSANaSANC(Long idExpediente, Boolean isSupervisor) {

        Expediente exp = expedienteDao.get(idExpediente);

        Boolean permitidoElevar = compruebaElevacion(exp, ExpedienteBPMConstants.STATE_EN_SANCION, isSupervisor);
        if (!permitidoElevar) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }
        
        executor.execute(InternaBusinessOperation.BO_POL_MGR_MARCAR_POLITICAS_VIGENTES, exp, null, false);

        //Verifico que tenga un comit� al cual elevar
        DDZona zonaExpediente = exp.getOficina().getZona();
        Comite comite = buscaComite(zonaExpediente, exp);
        if (comite == null) { throw new BusinessOperationException("expediente.comiteInexistente"); }

        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, exp.getProcessBpm(),ExpedienteBPMConstants.TRANSITION_ELEVAR_SANCIONADO);

    }
	
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_FORMALIZAR_PROPUESTA)
	@Transactional(readOnly = false)
	@Override
	public void elevarExpedienteAFormalizarPropuesta(Long idExpediente,
			Boolean isSupervisor) {
		 Expediente exp = expedienteDao.get(idExpediente);

	        Boolean permitidoElevar = compruebaElevacion(exp, ExpedienteBPMConstants.STATE_DECISION_COMITE, isSupervisor);
	        if (!permitidoElevar) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }

	        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, exp.getProcessBpm(),
	                    ExpedienteBPMConstants.TRANSITION_ENVIARAFORMALIZARPROPUESTA);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_DE_SANCIONADO_A_FORMALIZAR_PROPUESTA)
	@Transactional(readOnly = false)
	public void elevarExpedienteDeSancionadoAFormalizarPropuesta(Long idExpediente,Boolean isSupervisor) {
		 
		Expediente exp = expedienteDao.get(idExpediente);

	        Boolean permitidoElevar = compruebaElevacion(exp, ExpedienteBPMConstants.STATE_SANCIONADO, isSupervisor);
	        if (!permitidoElevar) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }
	        
	        ///Comprobamos que al menos una propuesta esté en estado elevada (PENDIENTE)
	        DDEstadoItinerario estadoItinerario = exp.getEstadoItinerario();
	        Estado estado = (Estado) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_GET, exp.getArquetipo().getItinerario(),
	                estadoItinerario);
	        List<ReglasElevacion> listadoReglas = expedienteDao.getReglasElevacion(estado);

	        //Comprobamos una a una si las reglas se cumplen
	        List<Acuerdo> acuerdos = genericDao.getList(Acuerdo.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", exp.getId()));
	        
	        for (ReglasElevacion regla : listadoReglas) {
	        	   String codigoTipoRegla = regla.getTipoReglaElevacion().getCodigo();
	               if(DDTipoReglasElevacion.MARCADO_GESTION_PROPUESTA.equals(codigoTipoRegla)){
	            	   for(Acuerdo acu : acuerdos){
	            		   if(acu.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_VIGENTE)){
	            			   permitidoElevar = false;
	            		   }
	            	   }
	               }
	        }
	        
	        if (!permitidoElevar) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }

	        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, exp.getProcessBpm(),
	                    ExpedienteBPMConstants.TRANSITION_ENVIARAFORMALIZARPROPUESTA);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_DE_SANCIONADO_A_COMPLETAR_EXPEDIENTE)
	@Transactional(readOnly = false)
	public void devolverExpedienteDeSancionadoACompletarExpediente(Long idExpediente,String respuesta, Boolean isSupervisor) {
		 
			Expediente exp = expedienteDao.get(idExpediente);
			
	        Long bpmProcess = exp.getProcessBpm();
	        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
	        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
	        if (ExpedienteBPMConstants.STATE_SANCIONADO.equals(node)) {

	            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, bpmProcess, ExpedienteBPMConstants.TRANSITION_APROBADOCONCONDICIONES);
	            
	            // *** Recuperamos la tarea generada en el BPM para cambiarle la descripción y ponerle los motivos de devolución ***
	            Long idTareaAsociada = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmProcess, TAREA_ASOCIADA_CE);
	            
	            if (idTareaAsociada != null) {
	                TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTareaAsociada);
	                if (tarea != null) {
	                    SubtipoTarea subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
	                            SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE);
	                    String descripcionTarea = subtipoTarea.getDescripcionLarga() + " - Devuelto por los motivos " + respuesta;
	                    tarea.setDescripcionTarea(descripcionTarea);
	                    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
	                }
	            }
	            // *** *** //

	            executor.execute(InternaBusinessOperation.BO_POL_MGR_DESHACER_ULTIMAS_POLITICAS, idExpediente);
	        } else {
	            logger.error("No se puede devoler a REVISION porque el expediente no esta en DECISION_COMITE");
	            throw new BusinessOperationException("expediente.devolucionRevision.errorJBPM");
	        }

	}
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_DE_FORMALIZAR_PROPUESTA_A_SANCIONADO)
	@Transactional(readOnly = false)
	public void devolverExpedienteDeFormalizarPropuestaASancionado(Long idExpediente,Boolean isSupervisor) {
		 
			Expediente exp = expedienteDao.get(idExpediente);

	        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, exp.getProcessBpm(),
	                    ExpedienteBPMConstants.TRANSITION_DEVOLVER_SANCIONADO);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_DE_SANCIONADO_A_EN_SANCION)
	@Transactional(readOnly = false)
	public void devolverExpedienteDeSancionadoAEnSancion(Long idExpediente,String respuesta, Boolean isSupervisor) {
		 
			Expediente exp = expedienteDao.get(idExpediente);
			
	        if(!isSupervisor){
	        	Boolean permitidoDevolver = compruebaDevolucion(exp, ExpedienteBPMConstants.STATE_SANCIONADO, DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION);
	        	if (!permitidoDevolver) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }
	        }

			
	        Long bpmProcess = exp.getProcessBpm();
	        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
	        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
	        if (ExpedienteBPMConstants.STATE_SANCIONADO.equals(node)) {

		        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, bpmProcess, ExpedienteBPMConstants.TRANSITION_DEVOLVER_EN_SANCION);
	            
	            // *** Recuperamos la tarea generada en el BPM para cambiarle la descripción y ponerle los motivos de devolución ***
	            Long idTareaAsociada = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmProcess, TAREA_ASOCIADA_ENSAN);
	            
	            if (idTareaAsociada != null) {
	                TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTareaAsociada);
	                if (tarea != null) {
	                    SubtipoTarea subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
	                            SubtipoTarea.CODIGO_TAREA_EN_SANCION);
	                    String descripcionTarea = subtipoTarea.getDescripcionLarga() + " - Devuelto por los motivos " + respuesta;
	                    tarea.setDescripcionTarea(descripcionTarea);
	                    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
	                }
	            }
	            // *** *** //

	            executor.execute(InternaBusinessOperation.BO_POL_MGR_DESHACER_ULTIMAS_POLITICAS, idExpediente);
	        } else {
	            logger.error("No se puede devoler a EN SANCION porque el expediente no esta en SANCIONADO");
	            throw new BusinessOperationException("expediente.devolucionRevision.errorJBPM");
	        }
	}
	

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_DECISION_COMITE)
	@Transactional(readOnly = false)
	@Override
	public void devolverExpedienteADecisionComite(Long idExpediente,
			String respuesta) {
        Expediente exp = expedienteDao.get(idExpediente);
        //comprobamos si se cumple la regla de validacion al devolver a revision
        Boolean permitidoDevolver = compruebaDevolucion(exp, ExpedienteBPMConstants.STATE_FORMALIZAR_PROPUESTA, DDEstadoItinerario.ESTADO_DECISION_COMIT);
        if (!permitidoDevolver) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }
        Long bpmProcess = exp.getProcessBpm();
        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
        if (ExpedienteBPMConstants.STATE_FORMALIZAR_PROPUESTA.equals(node)) {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, bpmProcess, ExpedienteBPMConstants.TRANSITION_DEVOLVERADECISION);

            // *** Recuperamos la tarea generada en el BPM para cambiarle la descripción y ponerle los motivos de devolución ***
            Long idTareaAsociada = (Long) executor
                    .execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmProcess, TAREA_ASOCIADA_DC);
            if (idTareaAsociada != null) {
                TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTareaAsociada);
                if (tarea != null) {
                    SubtipoTarea subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
                            SubtipoTarea.CODIGO_FORMALIZAR_PROPUESTA);
                    String descripcionTarea = subtipoTarea.getDescripcionLarga() + " - Devuelto por los motivos " + respuesta;
                    tarea.setDescripcionTarea(descripcionTarea);
                    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
                }
            }
            // *** *** //
            // Las politicas no se tocan cuando volvemos de FP a DC
            //executor.execute(InternaBusinessOperation.BO_POL_MGR_DESHACER_ULTIMAS_POLITICAS, idExpediente);
        } else {
            logger.error("No se puede devoler a completar porque el expediente no esta en revision");
            throw new BusinessOperationException("expediente.devolucionCompletar.errorJBPM");
        }		
	}

    /**
     * validar expediente aaa completo.
     * @param exp expediente
     * @return booleano
     */
    private boolean validarExpedienteCompletoAAA(Expediente exp) {
        ActitudAptitudActuacion aaa = exp.getAaa();
        if (aaa == null || aaa.getCausaImpago() == null) { return false; }

        if (aaa.getTipoAyudaActuacion() == null) { return false; }
        return true;
    }

    /**
     * valida que la fecha pasada como parametro sea de hace menos de 6 meses.
     * @param fechaAntigua fecha
     * @return boleano
     */
    private boolean validaSeisMesesAntiguedad(Date fechaAntigua) {
        if (fechaAntigua == null) { return true; }
        long now = new Date(System.currentTimeMillis()).getTime();
        long anterior = fechaAntigua.getTime();
        long dif = now - anterior;
        if (dif > APPConstants.SEIS_MESES) { return true; }
        return false;
    }

    /**
     * {@inheritDoc}
     */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_COMPLETAR)
    @Transactional(readOnly = false)
    public void devolverExpedienteACompletar(Long idExpediente, String respuesta) {
        Expediente exp = expedienteDao.get(idExpediente);
        Long bpmProcess = exp.getProcessBpm();
        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
        if (ExpedienteBPMConstants.STATE_REVISION_EXPEDIENTE.equals(node)) {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, bpmProcess, ExpedienteBPMConstants.TRANSITION_DEVOLVERACOMPLETAR);

            // *** Recuperamos la tarea generada en el BPM para cambiarle la descripción y ponerle los motivos de devolución ***
            Long idTareaAsociada = (Long) executor
                    .execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmProcess, TAREA_ASOCIADA_CE);
            if (idTareaAsociada != null) {
                TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTareaAsociada);
                if (tarea != null) {
                    SubtipoTarea subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
                            SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE);
                    String descripcionTarea = subtipoTarea.getDescripcionLarga() + " - Devuelto por los motivos " + respuesta;
                    tarea.setDescripcionTarea(descripcionTarea);
                    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
                }
            }
            // *** *** //

            executor.execute(InternaBusinessOperation.BO_POL_MGR_DESHACER_ULTIMAS_POLITICAS, idExpediente);
        } else {
            logger.error("No se puede devoler a completar porque el expediente no esta en revision");
            throw new BusinessOperationException("expediente.devolucionCompletar.errorJBPM");
        }
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_ELEVAR_EXPEDIENTE_A_DECISION_COMITE)
    @Transactional(readOnly = false)
    public void elevarExpedienteADecisionComite(Long idExpediente, Boolean isSupervisor) {

        Expediente exp = expedienteDao.get(idExpediente);

        Boolean permitidoElevar = compruebaElevacion(exp, ExpedienteBPMConstants.STATE_REVISION_EXPEDIENTE, isSupervisor);
        if (!permitidoElevar) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }

        //Verifico que tenga un comit� al cual elevar
        DDZona zonaExpediente = exp.getOficina().getZona();
        Comite comite = buscaComite(zonaExpediente, exp);
        if (comite == null) { throw new BusinessOperationException("expediente.comiteInexistente"); }

        Boolean politicasVigentes = (Boolean) executor.execute(InternaBusinessOperation.BO_POL_MGR_MARCAR_POLITICAS_VIGENTES, exp, null, false);

        //Si se ha marcado como vigente las pol�ticas, el expediente se decide
        if (politicasVigentes) {

            DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO);
            exp.setEstadoExpediente(estadoExpediente);
            saveOrUpdate(exp);

            //Si no se ha marcado como vigente, se siguie en la elevación del expediente
        } else {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, exp.getProcessBpm(),
                    ExpedienteBPMConstants.TRANSITION_ENVIARADECISIONCOMITE);
        }
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_A_REVISION)
    @Transactional(readOnly = false)
    public void devolverExpedienteARevision(Long idExpediente, String respuesta) {
        Expediente exp = expedienteDao.get(idExpediente);
        List<Asunto> asuntos = exp.getAsuntos();
        if (asuntos != null && asuntos.size() > 0) { throw new BusinessOperationException("expediente.devolucionRevision.invalida"); }
        //comprobamos si se cumple la regla de validacion al devolver a revision
        Boolean permitidoDevolver = compruebaDevolucion(exp, ExpedienteBPMConstants.STATE_DECISION_COMITE, DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);
        if (!permitidoDevolver) { throw new BusinessOperationException("expediente.elevar.falloValidaciones"); }
        Long bpmProcess = exp.getProcessBpm();
        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
        if (ExpedienteBPMConstants.STATE_DECISION_COMITE.equals(node)) {
            //Map<String, Object> variables = new HashMap<String, Object>();
            //variables.put(RESPUESTA_DEVOLVER_RE, respuesta);
            //jbpmUtil.addVariablesToProcess(bpmProcess, variables);
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, bpmProcess, ExpedienteBPMConstants.TRANSITION_DEVOLVERAREVISION);
            // *** Recuperamos la tarea generada en el BPM para cambiarle la descripción y ponerle los motivos de devolución ***
            Long idTareaAsociada = (Long) executor
                    .execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmProcess, TAREA_ASOCIADA_RE);
            if (idTareaAsociada != null) {
                TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTareaAsociada);
                if (tarea != null) {
                    SubtipoTarea subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
                            SubtipoTarea.CODIGO_REVISAR_EXPEDIENE);
                    String descripcionTarea = subtipoTarea.getDescripcionLarga() + " - Devuelto por los motivos " + respuesta;
                    tarea.setDescripcionTarea(descripcionTarea);
                    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
                }
            }
            // *** *** //

            executor.execute(InternaBusinessOperation.BO_POL_MGR_DESHACER_ULTIMAS_POLITICAS, idExpediente);
        } else {
            logger.error("No se puede devoler a REVISION porque el expediente no esta en DECISION_COMITE");
            throw new BusinessOperationException("expediente.devolucionRevision.errorJBPM");
        }
    }
	
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_DEVOLVER_EXPEDIENTE_DE_ENSANCION_A_REVISION)
    @Transactional(readOnly = false)
    public void devolverExpedienteDeEnSancionARevision(Long idExpediente, String respuesta, Boolean isSupervisor) {
        
		Expediente exp = expedienteDao.get(idExpediente);
        List<Asunto> asuntos = exp.getAsuntos();
        if (asuntos != null && asuntos.size() > 0) { throw new BusinessOperationException("expediente.devolucionRevision.invalida"); }
        
        //comprobamos si se cumple la regla de validacion al devolver a revision
        if(!isSupervisor){
        	Boolean permitidoDevolver = compruebaDevolucion(exp, ExpedienteBPMConstants.STATE_EN_SANCION, DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE);
            if (!permitidoDevolver) { throw new BusinessOperationException("expediente.devolver.falloEstadoPropuestas"); }	
        }
        
        Long bpmProcess = exp.getProcessBpm();
        if (bpmProcess == null) { throw new BusinessOperationException("expediente.bpmprocess.error"); }
        
        String node = (String) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_ACTUAL_NODE, bpmProcess);
        
        if (ExpedienteBPMConstants.STATE_EN_SANCION.equals(node)) {

            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, bpmProcess, ExpedienteBPMConstants.TRANSITION_DEVOLVERAREVISION);
            
            // *** Recuperamos la tarea generada en el BPM para cambiarle la descripción y ponerle los motivos de devolución ***
            Long idTareaAsociada = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmProcess, TAREA_ASOCIADA_RE);
            
            if (idTareaAsociada != null) {
                TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTareaAsociada);
                if (tarea != null) {
                    SubtipoTarea subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE, SubtipoTarea.CODIGO_REVISAR_EXPEDIENE);
                    String descripcionTarea = subtipoTarea.getDescripcionLarga() + " - Devuelto por los motivos " + respuesta;
                    tarea.setDescripcionTarea(descripcionTarea);
                    executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
                }
            }

            executor.execute(InternaBusinessOperation.BO_POL_MGR_DESHACER_ULTIMAS_POLITICAS, idExpediente);
        } else {
            logger.error("No se puede devoler a REVISION porque el expediente no esta en EN SANCION");
            throw new BusinessOperationException("expediente.devolucionRevision.errorJBPM");
        }
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CALCULAR_COMITE_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void calcularComiteExpediente(Long idExpediente) {
        Expediente exp = expedienteDao.get(idExpediente);
        DDZona zonaExpediente = exp.getOficina().getZona();
        Comite comite = buscaComite(zonaExpediente, exp);
        exp.setComite(comite);
        saveOrUpdate(exp);
    }

    /**
     * busca los comite recursivamente hasta encontrar uno.
     * @param zona zona
     * @param volumenRiesgo riesgo del expediente
     * @return comite
     */
    private Comite buscaComite(DDZona zona, Expediente expediente) {
        for (Comite comite : zona.getComitesPriorizados()) {
            if (validarAtribucionComite(comite, expediente.getVolumenRiesgo()) && validarItinerarioComiteExpediente(comite, expediente)) { return comite; }
        }
        
        //Evitamos los bucles infinitos si se ha configurado incorrectamente las zonas --> zona.getZonaPadre() == zona
        if (zona.getZonaPadre() == null || zona.getZonaPadre() ==  zona) {
            logger.error("NO EXISTE COMITE ASOCIADO AL EXPEDIENTE");
            throw new GenericRollbackException("expediente.comiteInexistente");
        }
        return buscaComite(zona.getZonaPadre(), expediente);
    }

    /**
     * valida la atribucion del comite.
     * @param comite comite
     * @param volumenRiesgo riesgo
     * @return true or false
     */
    private boolean validarAtribucionComite(Comite comite, Double volumenRiesgo) {
        if (volumenRiesgo == null) { return true; }
        if (comite.getAtribucionMinima() == null
                || (comite.getAtribucionMinima().doubleValue() <= volumenRiesgo && comite.getAtribucionMaxima().doubleValue() >= volumenRiesgo)) { return true; }
        return false;
    }

    private boolean validarItinerarioComiteExpediente(Comite comite, Expediente exp) {
        long idItinerario = exp.getArquetipo().getItinerario().getId().longValue();
        List<Itinerario> itinerariosComite = comite.getItinerarios();
        for (Itinerario iti : itinerariosComite) {
            if (iti.getId().longValue() == idItinerario) { return true; }
        }
        return false;
    }

    /**
     * Indica si se puede mostrar la PESTAÑA de decisión de comit� de la consulta de expediente.
     * Cumple con los campos de precondiciones y activación del CU WEB-30,
     * los permisos a nivel de funciones de perfil los maneja la vista con los tags.
     * @param idExpediente Long: el id del expediente que se quiere ver.
     * @param tipoItinerario String: tipo de itinerario del expediente
     * @return un Boolean indicando si se puede o no ver el tab de DC.
     */
    private Boolean puedeMostrarSolapasDecision(Long idExpediente, boolean solapaRecuperacion) {
        Expediente exp = expedienteDao.get(idExpediente);   
        
        if(DDTipoItinerario.ITINERARIO_GESTION_DEUDA.equals(exp.getArquetipo().getItinerario().getdDtipoItinerario().getCodigo())){
        	////Comprobaciones para los expedientes de Gestión de deuda
        	if(!Checks.esNulo(exp.getEstadoItinerario()) && (exp.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_FORMALIZAR_PROPUESTA) || exp.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO))){
        		return Boolean.TRUE;
        	}else{
        		return Boolean.FALSE;
        	}
        }else if(exp.getArquetipo().getItinerario().getdDtipoItinerario().getItinerarioRecuperacion()){
        	///Comprobaciones para expedientes de recuperacion
        	if(exp.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_DECISION_COMIT)){
            	
        		Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        		
                for (Perfil perfil : usuario.getPerfiles()) {
                	if(exp.getIdGestorActual().equals(perfil.getId()) || exp.getIdSupervisorActual().equals(perfil.getId())){
                		return Boolean.TRUE;
                	}
                }
                
                return Boolean.FALSE;
                
        	}else{
        		return Boolean.FALSE;
        	}
        }
        
        ///Si el espediente no es de recuperacion o gestion de deuda no se muestra la pestaña
        return Boolean.FALSE;
        }
        
    
    /**
     * Indica si se puede mostrar la PESTAÑA de decisión de comit� de la consulta de expediente.
     * Cumple con los campos de precondiciones y activación del CU WEB-30,
     * los permisos a nivel de funciones de perfil los maneja la vista con los tags.
     * @param idExpediente Long: el id del expediente que se quiere ver.
     * @param tipoItinerario String: tipo de itinerario del expediente
     * @return un Boolean indicando si se puede o no ver el tab de DC.
     */
    private Boolean puedeMostrarMarcadoPoliticas(Long idExpediente) {
        Expediente exp = expedienteDao.get(idExpediente);
        
        if(!exp.getRecuperacion()){
        
	        String nombreTab = "MARCADO DE POLITICAS";
	        logger.debug("EVALUO SI DEBO MOSTRAR LA PESTAÑA " + nombreTab);
	        
	        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
	        
	        //VALIDO PRECONDICIONES CU WEB-30
	       
	    	if (!exp.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_DECISION_COMIT) && !exp.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO)){
	
	    		//No esta en decisión de comite o no tiene sesiones abiertas.
	            logger.debug("NO SE PUEDE MOSTRAR LA PESTAÑA " + nombreTab + " PORQUE NO ESTA EN EL ESTADO CORRESPONDIENTE ");
	            return Boolean.FALSE;
	        }
	       
	        for (Perfil perfil : usuario.getPerfiles()) {
	        	
	        	if(exp.getGestorActual().equalsIgnoreCase(perfil.getDescripcion()) || exp.getSupervisorActual().equalsIgnoreCase(perfil.getDescripcion())){
	        		logger.debug("MUESTRO EL TAB " + nombreTab);
	        		return Boolean.TRUE;
	        	}
	        }
	        logger.debug("NO SE PUEDE MOSTRAR LA PESTAÑA " + nombreTab + " PORQUE NO CORRESPONDE AL USUARIO " + usuario.getUsername());
	        return Boolean.FALSE;
        }else{
        	logger.debug("NO SE PUEDE MOSTRAR LA PESTAÑA PORQUE ES EXPEDIENTE DE RECUPERACION");
	        return Boolean.FALSE;
        }
        
    }

    /**
     * {@inheritDoc}
     */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_PUEDE_MOSTRAR_SOLAPA_DECISION_COMITE)
    public Boolean puedeMostrarSolapaDecisionComite(Long idExpediente) {
        return puedeMostrarSolapasDecision(idExpediente, true);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_PUEDE_MOSTRAR_SOLAPA_MARCADO_POLITICA)
    public Boolean puedeMostrarSolapaMarcadoPoliticas(Long idExpediente) {
        return puedeMostrarMarcadoPoliticas(idExpediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_SOLICITAR_CANCELACION_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void solicitarCancelacionExpediente(Long idExpediente) {
        DtoGenerarTarea dto = new DtoGenerarTarea(idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR, true, false, null, null);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_TAREA, dto);
        //Bloquea el expediente
        Expediente exp = this.getExpediente(idExpediente);

        DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO);
        exp.setEstadoExpediente(estadoExpediente);
        this.saveOrUpdate(exp);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_RECHAZAR_CANCELACION_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void rechazarCancelacionExpediente(Long idExpediente) {
        Expediente exp = this.getExpediente(idExpediente);

        //Si el expediente est� en DC, le devolvemos su estado Congelado
        if (DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(exp.getEstadoItinerario().getCodigo())) {

            DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO);
            exp.setEstadoExpediente(estadoExpediente);
        } else {
            //Si no est� en DC, lo marcamos como Activo
            DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO);
            exp.setEstadoExpediente(estadoExpediente);
        }

        this.saveOrUpdate(exp);
        //Borra la tarea de solicitud de cancelacion
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA, idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR);
        //Crea una notificacion al gestor para que sepa que le rechazaron
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                SubtipoTarea.CODIGO_NOTIFICACION_SOLICITUD_CANCELACION_EXPEDIENTE_RECHAZADA, null);
        //Desbloquea el expediente
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CANCELACION_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void cancelacionExp(Long idExpediente, boolean conNotificacion) {
        Expediente exp = this.getExpediente(idExpediente);

        DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO);
        exp.setEstadoExpediente(estadoExpediente);
        //expedienteDao.delete(exp);
        //for (ExpedienteContrato ec : exp.getContratos()){
        //	expedienteContratoDao.delete(ec);
        //}
        saveOrUpdate(exp);
        //Manda a fin el Bpm
        if (exp.getProcessBpm() != null) {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_MANDAR_A_FIN_PROCESS, exp.getProcessBpm());
        }
        
        //Si el expediente es de itinerario Seguimiento o Gestión de deuda
        if (exp.getCodigoTipoItinerario().equals(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO) 
        			|| exp.getCodigoTipoItinerario().equals(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO)
        			|| exp.getCodigoTipoItinerario().equals(DDTipoItinerario.ITINERARIO_GESTION_DEUDA)) {
	        //Cancelamos sus políticas
	        List<CicloMarcadoPolitica> ciclos = cicloMarcadoPoliticaDao.getCiclosMarcadoExpediente(exp.getId());
	        for (CicloMarcadoPolitica ciclo : ciclos) {
	        	for (Politica politica : ciclo.getPoliticas()) {
	        		if (politica.getEstadoPolitica().getCodigo().equals(DDEstadoPolitica.ESTADO_PROPUESTA)) {
	        			executor.execute(InternaBusinessOperation.BO_POL_MGR_CANCELAR_POLITICA, politica.getId());
	        		}
	        	}
			}
        }
        

        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_TAREAS_ASOCIADAS_EXPEDIENTE, exp.getId());

        if (conNotificacion) {
            //Crea una notificacion para el gestor para que sepa q se cancelo el expediente
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_CREAR_NOTIFICACION, idExpediente, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE,
                    SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_CERRADO, null);
        }
        executor.execute(ComunBusinessOperation.BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD_ELIMINADA, exp.getId(),
                DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
    }


	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CANCELACION_EXPEDIENTE_MANUAL)
    @Transactional(readOnly = false)
    public void cancelacionExpManual(Long idExpediente, Long idPersona) {
        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
        Expediente expediente = expedienteDao.get(idExpediente);
        String codigoSubtipoTarea;
        if (expediente.getSeguimiento()) {
            codigoSubtipoTarea = SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG;
        } else {
            codigoSubtipoTarea = SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL;
        }
        Cliente clienteActivo = persona.getClienteActivo();
        Long idCliente = clienteActivo.getId();
        cancelacionExp(idExpediente, true);

        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA, idCliente, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE,
                codigoSubtipoTarea);

        PropuestaExpedienteManual propuesta = getPropuestaExpedienteManual(idExpediente);
        if (propuesta != null) {
            propuestaExpedienteManualDao.delete(propuesta);
        }
        if (clienteActivo.getEstadoCliente().getCodigo().equals(EstadoCliente.ESTADO_CLIENTE_MANUAL)) {
            executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLIENTE, idCliente);
        }
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CONGELAR_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void congelarExpediente(Long idExpediente) {
        Expediente exp = this.getExpediente(idExpediente);

        DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO);
        exp.setEstadoExpediente(estadoExpediente);
        saveOrUpdate(exp);
        //Generacion del PDF
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_DESCONGELAR_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void desCongelarExpediente(Long idExpediente) {
        Expediente exp = this.getExpediente(idExpediente);

        DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO);
        exp.setEstadoExpediente(estadoExpediente);
        exp.setComite(null);
        saveOrUpdate(exp);
        //Borrar PDS
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_BUSCAR_AAA)
    public ActitudAptitudActuacion buscarAAA(Long idAAA) {

        return actitudAptitudActuacionDao.get(idAAA);

    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_UPDATE_AAA)
    @Transactional(readOnly = false)
    public void updateActitudAptitudActuacion(DtoActitudAptitudActuacion dtoAAA) {
		if(dtoAAA.getExp() != null){
			Expediente exp = this.getExpediente(dtoAAA.getExp());
			//Si el campo AAA de la tabla expediente tiene valor se actualiza si no se inserta uno nuevo.
			if(exp != null && exp.getAaa() != null){
				actitudAptitudActuacionDao.saveOrUpdate(dtoAAA.getAaa());		
			}else{
				exp.setAaa(dtoAAA.getAaa());
				expedienteDao.saveOrUpdate(exp);
				actitudAptitudActuacionDao.saveOrUpdate(dtoAAA.getAaa());
			}
		}
        
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_UPDATE_AAA_REVISION)
    @Transactional(readOnly = false)
    public void updateActitudAptitudActuacionRevision(DtoActitudAptitudActuacion dtoAAA) {
        String revision = dtoAAA.getAaa().getRevision();
        dtoAAA.setAaa(actitudAptitudActuacionDao.get(dtoAAA.getAaa().getId()));
        dtoAAA.getAaa().setRevision(revision);
        actitudAptitudActuacionDao.saveOrUpdate(dtoAAA.getAaa());
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_PERSONAS_TIT_CONTRATOS_EXPEDIENTES)
    @Transactional(readOnly = true)
    public List<Persona> findPersonasTitContratosExpediente(Long id) {
        return expedienteDao.findPersonasTitContratosExpediente(id);
    }


	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_PERSONAS_CONTRATOS_CON_ADJUNTOS)
    @Transactional(readOnly = true)
    public List<Persona> findPersonasContratosConAdjuntos(Long idExpediente) {
        return expedienteDao.findPersonasContratosConAdjuntos(idExpediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_CONTRATOS_CON_ADJUNTOS)
    @Transactional(readOnly = true)
    public List<Persona> findContratosConAdjuntos(Long idExpediente) {
        return expedienteDao.findContratosConAdjuntos(idExpediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_CONTRATOS_RIESGO_EXPEDIENTES)
    public List<Contrato> findContratosRiesgoExpediente(Long idExpediente) {
        List<ExpedienteContrato> cex = expedienteDao.findContratosExpediente(idExpediente, null);

        List<Contrato> contratos = new ArrayList<Contrato>(cex.size());

        for (ExpedienteContrato expCnt : cex) {
            contratos.add(expCnt.getContrato());
        }

        return contratos;
    }


	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_TOMAR_DECISION_COMITE)
    @Transactional(readOnly = false)
    public void tomarDecisionComite(Long idExpediente, String observaciones) {
        tomarDecisionComite(idExpediente, observaciones, false, true);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_TOMAR_DECISION_COMITE_COMPLETO)
    @Transactional(readOnly = false)
    public void tomarDecisionComite(Long idExpediente, String observaciones, boolean automatico, boolean generaNotificacion) {
        Expediente exp = getExpediente(idExpediente);
        Comite comite = (Comite) executor.execute(InternaBusinessOperation.BO_COMITE_MGR_GET_WITH_SESSIONS, exp.getComite().getId());
        if (exp.getEstaDecidido()) { throw new BusinessOperationException("expediente.tomarDecision.decisionYaTomada"); }

        if (!DDEstadoItinerario.ESTADO_DECISION_COMIT.equalsIgnoreCase(exp.getEstadoItinerario().getCodigo()) && !DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO.equalsIgnoreCase(exp.getEstadoItinerario().getCodigo())) { 
        	throw new BusinessOperationException("expediente.tomarDecision.estadoInvalido"); 
        }

        if (!Comite.INICIADO.equalsIgnoreCase(comite.getEstado())) { throw new BusinessOperationException("expediente.tomarDecision.sesionInvalida"); }
        marcarSinActuacionContratosPasivosNoVencidos(exp);
        if (!validarTodosContratosDecididos(exp.getContratos())) { throw new BusinessOperationException(
                "expediente.tomarDecision.contratosSinDecision"); }
        DecisionComite dc = new DecisionComite();
        dc.setSesion(comite.getUltimaSesion());
        dc.setObservaciones(observaciones);
        executor.execute(InternaBusinessOperation.BO_DECISIONN_COMITE_MRG_SAVE, dc);
        SesionComite sesion = (SesionComite) executor.execute(InternaBusinessOperation.BO_COMITE_MGR_GET_SESION_WITH_ASISTENTES, comite
                .getUltimaSesion().getId());
        Hibernate.initialize(sesion);
        //Confirma los asuntos del expediente
        //List<Asunto> asuntos = asuntosManager.obtenerAsuntosDeUnExpediente(idExpediente);
        List<Asunto> asuntos = exp.getAsuntos();
        for (Asunto a : asuntos) {
            if (automatico || a.getProcedimientos().size() > 0) {
                DDEstadoAsunto estadoAsuntoConfirmado = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                        DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
                a.setEstadoAsunto(estadoAsuntoConfirmado);
                a.setComite(comite);
                a.setSupervisorComite(sesion.getSupervisorSesionComite());
                executor.execute(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE, a);
                if(!Checks.estaVacio(a.getProcedimientos())){ 
                	for(Procedimiento proc : a.getProcedimientos()){
                		if(!Checks.esNulo(proc.getPropuesta()) && !Checks.esNulo(proc.getPropuesta().getEstadoAcuerdo())){
                			if(DDEstadoAcuerdo.ACUERDO_ACEPTADO.equals(proc.getPropuesta().getEstadoAcuerdo().getCodigo())){
                				executor.execute("propuestaApi.cambiarEstadoPropuesta", proc.getPropuesta(), DDEstadoAcuerdo.ACUERDO_VIGENTE,true);
                			}
                		}
                		
                	}
                }
                /* *********CPI - 30/09/2015*******
                AHORA NACEN LOS ASUNTOS SIEMPRE ACEPTADOS                
                if (generaNotificacion) {
                    executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GENERAR_TAREA_POR_CIERRE_DECISION, a);
                } else {
                    executor.execute(ExternaBusinessOperation.BO_ASU_MGR_CREAR_TAREA_ACEPTAR_ASUNTO, a);
                }
                executor.execute(ExternaBusinessOperation.BO_ASU_MGR_MARCAR_PROCEDIMIENTOS_COMO_DECIDIDOS, a);
                */
                executor.execute(ExternaBusinessOperation.BO_ASU_MGR_ACEPTAR_ASUNTO, a.getId(), true);
            } else {
                DDEstadoAsunto estadoAsuntoVacio = (DDEstadoAsunto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                        DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_VACIO);
                a.setEstadoAsunto(estadoAsuntoVacio);
                executor.execute(ExternaBusinessOperation.BO_ASU_MGR_BORRAR_ASUNTO, a.getId());
            }

        }

        exp.setDecisionComite(dc);
        DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO);
        exp.setEstadoExpediente(estadoExpediente);
        saveOrUpdate(exp);

        if (!automatico) {
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, exp.getProcessBpm(), ExpedienteBPMConstants.TRANSITION_TOMARDECISION);
//        } else {
            //executor.execute(InternaBusinessOperation.BO_COMITE_MGR_CERRAR_SESION, comite.getId(), false);
        }
    }

    /**
     * Marca sin actuacion los contratos pasivos no vencidos.
     * @exp Expediente
     */
    private void marcarSinActuacionContratosPasivosNoVencidos(Expediente exp) {
        for (ExpedienteContrato ec : exp.getContratos()) {
            if (ec.getContrato().getLastMovimiento().getRiesgo() == 0) {
                ec.setSinActuacion(Boolean.TRUE);
                expedienteContratoDao.update(ec);
            }
        }
    }

    /**
     * valida que todos los contratos tengan seleccionado una actuacion.
     * @param contratos contratos
     * @return boolean
     */
    private boolean validarTodosContratosDecididos(List<ExpedienteContrato> contratos) {

        List<Long> idExpedientesContratos = new ArrayList<Long>();

        //Extraemos todos los ExpedientesContratos de todos los procedimientos de los asuntos del expediente
        for (ExpedienteContrato c : contratos) {
            for (Asunto a : c.getExpediente().getAsuntos()) {
                for (Procedimiento p : a.getProcedimientos()) {
                    for (ExpedienteContrato ec : p.getExpedienteContratos()) {
                        if (!idExpedientesContratos.contains(ec.getId())) idExpedientesContratos.add(ec.getId());
                    }
                }
            }
        }

        //Comprobamos que lo cumpla
        for (ExpedienteContrato c : contratos) {
            //Si est� marcado como actuaci�n debemos buscar que tenga procedimientos
            if (c.getSinActuacion() == null || c.getSinActuacion() == false) {
                if (!idExpedientesContratos.contains(c.getId())) return false;
            }
        }

        return true;
    }

	public void liberarContratosSinActuacion(Long idExpediente) {
        Expediente exp = getExpediente(idExpediente);
        if (!exp.getEstaDecidido()) { throw new BusinessOperationException("expediente.tomarDecision.decisionNoTomada"); }
        if (!DDEstadoItinerario.ESTADO_DECISION_COMIT.equalsIgnoreCase(exp.getEstadoItinerario().getCodigo())) { throw new BusinessOperationException(
                "expediente.tomarDecision.estadoInvalido"); }

        for (ExpedienteContrato ec : exp.getContratosDescartados()) {
            expedienteContratoDao.delete(ec);
        }
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_UPLOAD)
    @Transactional(readOnly = false)
    public String upload(WebFileItem uploadForm) {
        FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero est� vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }

        Integer max = getLimiteFichero();

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Expediente expediente = expedienteDao.get(Long.parseLong(uploadForm.getParameter("id")));
        //        Hibernate.initialize(expediente.getAdjuntos());
        expediente.addAdjunto(fileItem);
        expedienteDao.save(expediente);

        return null;
    }

    /**
     * Recupera el l�mite de tama�o de un fichero.
     * @return limite
     */
    private Integer getLimiteFichero() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_FICHERO_EXPEDIENTE);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            logger.warn("No esta parametrizado el l�mite m�ximo del fichero en bytes para expedientes, se toma un valor por defecto (2Mb)");
            return new Integer(2 * 1024 * 1024);
        }
    }

    /**
     * {@inheritDoc}
     */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_DELETE_ADJUNTO)
    @Transactional(readOnly = false)
    public void deleteAdjunto(Long expedienteId, Long adjuntoId) {
        Expediente expediente = getExpediente(expedienteId);
        AdjuntoExpediente adj = expediente.getAdjunto(adjuntoId);
        if (adj == null) { return; }
        expediente.getAdjuntos().remove(adj);
        expedienteDao.save(expediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_BAJAR_ADJUNTO)
    public FileItem bajarAdjunto(Long adjuntoId) {
        return adjuntoExpedienteDao.get(adjuntoId).getAdjunto().getFileItem();
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_GET_PROPUESTA_EXPEDIENTE_MANUAL)
    public PropuestaExpedienteManual getPropuestaExpedienteManual(Long idExpediente) {
        return propuestaExpedienteManualDao.getPropuestaDelExpediente(idExpediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_PROPONER_ACTIVAR_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void proponerActivarExpediente(DtoCreacionManualExpediente dto) {
        Expediente exp = getExpediente(dto.getIdExpediente());
        Persona per = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, dto.getIdPersona());
        
        //Cambiamos el arquetipo del cliente según el seleccionado en la primera ventana del wizzard
        Arquetipo arquetipo = arquetipoDao.get(dto.getIdArquetipo());
        
        //Primero asignamos a sus clientes el arquetipo seleccionado
        for (ExpedienteContrato expContrato : exp.getContratos()) {
        	Long idContrato = expContrato.getContrato().getId();
        	List<Cliente> clientes = (List<Cliente>) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_BUSCAR_CLIENTES_POR_CONTRATO, idContrato);
        	for (Cliente cliente: clientes) {
        		cliente.setArquetipo(arquetipo);
        		executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_SAVE_OR_UPDATE, cliente);
        	}
        }
        
        //Y ahora a los clientes por persona
        for (ExpedientePersona expPersona : exp.getPersonas()) {
        	Cliente cliente = expPersona.getPersona().getClienteActivo();
        	
        	if (cliente!=null) {
        		cliente.setArquetipo(arquetipo);
        		executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_SAVE_OR_UPDATE, cliente);
        	}
        }
        
        //Y al expediente
        exp.setArquetipo(arquetipo);
        
        if (!dto.getIsSupervisor()) {
            //Proponiendo
            PropuestaExpedienteManual propuesta = new PropuestaExpedienteManual();
            propuesta.setExpediente(exp);

            DDMotivoExpedienteManual motivoExpedienteManual = (DDMotivoExpedienteManual) executor.execute(
                    ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDMotivoExpedienteManual.class, dto.getCodigoMotivo());
            propuesta.setMotivo(motivoExpedienteManual);
            propuesta.setObservaciones(dto.getObservaciones());

            PlazoTareasDefault plazo;
            if (exp.getSeguimiento()) {
                plazo = (PlazoTareasDefault) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO,
                        PlazoTareasDefault.CODIGO_SOLICITUD_EXPEDIENTE_MANUAL_SEG);
            } else {
            	if (exp.isGestionDeuda()) {
            		plazo = (PlazoTareasDefault)executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO,
            				PlazoTareasDefault.CODIGO_SOLICITUD_EXPEDIENTE_MANUAL_GESTION_DEUDA);
            	} else {
            		plazo = (PlazoTareasDefault) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_PLAZO_TAREA_DEFAULT_POR_CODIGO,
                        PlazoTareasDefault.CODIGO_SOLICITUD_EXPEDIENTE_MANUAL);
            	}
            }
            
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD);
            Map<String, Object> param = new HashMap<String, Object>();
            param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, per.getClienteActivo().getId());
            param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
            /*param.put(TareaBPMConstants.ID_ENTIDAD_INFORMACION, exp.getId());
            param.put(TareaBPMConstants.CODIGO_TIPO_ENTIDAD, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);*/
            if (exp.getSeguimiento()) {
                param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG);
            } else {
            	if (exp.isGestionDeuda()) {
            		param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_GESTION_DEUDA);
            	} else {
            		param.put(TareaBPMConstants.CODIGO_SUBTIPO_TAREA, SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL);
            	}
            }
            param.put(TareaBPMConstants.PLAZO_PROPUESTA, plazo.getPlazo());

            //Seteamos la descripcion de la tarea
            SubtipoTarea subtipoTarea;
            if (exp.getSeguimiento()) {
                subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
                        SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG);
            } else {
            	if (exp.isGestionDeuda()) {
            		subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
            				SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_GESTION_DEUDA);
            	} else {
            		subtipoTarea = (SubtipoTarea) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET_SUBTIPO_TAREA_BY_CODE,
                        SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL);
            	}
            }
            String descripcion = subtipoTarea.getDescripcionLarga() + ". " + propuesta.getMotivo().getDescripcionLarga() + ". "
                    + propuesta.getObservaciones() + ".";
            if (descripcion.length() > APPConstants.TAREA_NOTIFICACION_MAX_DESCRIPCION) {
                descripcion = descripcion.substring(0, APPConstants.TAREA_NOTIFICACION_MAX_DESCRIPCION);
            }

            Long bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, TareaBPMConstants.TAREA_PROCESO, param);

            Long idTareaAsociada = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_GET_VARIABLES_TO_PROCESS, bpmid,
                    TareaBPMConstants.ID_TAREA);
            TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTareaAsociada);
            //param.put(TareaBPMConstants.DESCRIPCION_TAREA, descripcion);
            tarea.setDescripcionTarea(descripcion);
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);
            propuesta.setIdBPM(bpmid);
            propuestaExpedienteManualDao.save(propuesta);
        } else {
            if (dto.getIdPropuesta() != null && dto.getIdPropuesta() != -1) {
                //Avanza el proceso BPM de tareas genericas
                PropuestaExpedienteManual propuesta = propuestaExpedienteManualDao.get(dto.getIdPropuesta());
                executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, propuesta.getIdBPM(),
                        TareaBPMConstants.TRANSITION_TAREA_RESPONDIDA);
                propuestaExpedienteManualDao.delete(propuesta);
            }

            //activando

            DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO);
            exp.setEstadoExpediente(estadoExpediente);
            //AAA
            ActitudAptitudActuacion aaa = new ActitudAptitudActuacion();
            aaa.setAuditoria(Auditoria.getNewInstance());
            exp.setAaa(aaa);
            //Elimina los clientes si es que existieran
            eliminarProcesosClientesRelacionados(exp, null);
            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DETERMINAR_BBDD);
            // Crear proceso de expediente
            Map<String, Object> param = new HashMap<String, Object>();
            param.put(ExpedienteBPMConstants.EXPEDIENTE_MANUAL_ID, exp.getId());
            param.put(ClienteBPMConstants.PERSONA_ID, per.getId());
            Long bpmid = null;
            if(exp.isGestionDeuda()){
            	bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, ExpedienteBPMConstants.EXPEDIENTE_DEUDA_PROCESO, param);
            }else{
            	bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS, ExpedienteBPMConstants.EXPEDIENTE_PROCESO, param);
            }
            	exp.setProcessBpm(bpmid);
            saveOrUpdate(exp);

            executor.execute(InternaBusinessOperation.BO_POL_MGR_INICIALIZAR_POLITICAS_EXPEDIENTE, exp);
        }
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_EXCLUSION_EXPEDIENTE_CLIENTE_BY_EXPEDIENTE)
    public ExclusionExpedienteCliente findExclusionExpedienteClienteByExpedienteId(Long idExpediente) {
        return exclusionExpedienteClienteDao.findByExpedienteId(idExpediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_SAVE_OR_UPDATE_EXCLUSION_EXPEDIENTE_CLIENTE)
    @Transactional(readOnly = false)
    public void saveOrUpdateExclusionExpedienteCliente(ExclusionExpedienteCliente see) {
        exclusionExpedienteClienteDao.saveOrUpdate(see);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_SAVE_EXCLUSION_EXPEDIENTE_CLIENTE)
    @Transactional(readOnly = false)
    public void saveExclusionExpedienteCliente(DtoExclusionExpedienteCliente dto, Long idExpediente) {
        Expediente expediente;
        ExclusionExpedienteCliente exclExpCli;
        if (dto.getIdExclusion() != null) {
            exclExpCli = exclusionExpedienteClienteDao.get(dto.getIdExclusion());
            if (exclExpCli == null) { throw new BusinessOperationException("El objeto ExclusionExpedienteCliente con id = " + dto.getIdExclusion()
                    + " no existe."); }
            expediente = exclExpCli.getExpediente();
        } else {
            exclExpCli = new ExclusionExpedienteCliente();
            expediente = expedienteDao.get(idExpediente);
            if (expediente == null) { throw new BusinessOperationException(
                    "Se ha intentado crear una solicitud de exclusi�n con un id de expediente que " + "no existe o fue borrado"); }
        }
        exclExpCli.setExpediente(expediente);
        exclExpCli.setId(dto.getIdExclusion());
        exclExpCli.setObservacionesSolicitud(dto.getObservaciones());
        List<Persona> personas = new ArrayList<Persona>();
        Persona persona;
        for (int i = 0; i < dto.getIdsClientesExcluidos().size(); i++) {
            persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, dto.getIdsClientesExcluidos().get(i));
            if (persona == null) { throw new BusinessOperationException("Se ha intentado crear una solicitud de exclusi�n con ids de personas que "
                    + "no existen o fueron borrados"); }
            personas.add(persona);

        }
        exclExpCli.setPersonas(personas);

        saveOrUpdateExclusionExpedienteCliente(exclExpCli);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_BUSCAR_SOLICITUD_CANCELACION)
    public SolicitudCancelacion buscarSolicitudCancelacion(Long id) {
        return solicitudCancelacionDao.get(id);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_BUSCAR_SOLICITUD_CANCELACION_POR_TAREA)
    public SolicitudCancelacion buscarSolCancPorTarea(Long idTarea) {
        return solicitudCancelacionDao.buscarSolicitudPorTarea(idTarea);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_TOMAR_DECISION_CANCELACION)
    @Transactional(readOnly = false)
    public void tomarDecisionCancelacion(Long idExpediente, Long idSolicitud, boolean aceptar) {
        Expediente expediente = getExpediente(idExpediente);

        /* 
         * Agregado para poder aceptar o rechazar una solicitud de cancelacion directamente desde el 
         * panel de tareas, vendr� el idSolicitud en null, y habra que buscarlo
         * 
         */
        SolicitudCancelacion sc = null;
        if (idSolicitud == null) {

            TareaNotificacion tareaCancelacion = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_OBTENER_SOL_CANCEL_EXP,
                    idExpediente);
            sc = tareaCancelacion.getSolicitudCancelacion();
            idSolicitud = sc.getId();
        } else
            /* * * * * * * * * * * * * * * * */
            sc = buscarSolicitudCancelacion(idSolicitud);

        if (aceptar) {
            //Se acept� la solicictud de cancelaci�n
            cancelacionExp(idExpediente, true);
            sc.setAceptada(Boolean.valueOf(aceptar));
            solicitudCancelacionDao.update(sc);
        } else {
            //Se rechaz� la solicitud de cancelaci�n

            //Si el expediente est� en DC, le devolvemos su estado Congelado
            if (DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(expediente.getEstadoItinerario().getCodigo()) 
            		|| DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO.equals(expediente.getEstadoItinerario().getCodigo())) {
                DDEstadoExpediente estadoExpediente = (DDEstadoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                        DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO);
                expediente.setEstadoExpediente(estadoExpediente);
            } else {
                //Si no est� en DC, lo marcamos como Activo
                DDEstadoExpediente estadoActivo = (DDEstadoExpediente) dictionaryManager.getByCode(DDEstadoExpediente.class,
                        DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO);
                expediente.setEstadoExpediente(estadoActivo);
            }

            expedienteDao.update(expediente);
            sc.setAceptada(Boolean.valueOf(aceptar));
            solicitudCancelacionDao.update(sc);
            solicitudCancelacionDao.delete(sc);

            TareaNotificacion tarea = (TareaNotificacion) executor.execute(
                    ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_TAREA_SOLICITUD_CANCELADA_EXPEDIENTE, idSolicitud, idExpediente);
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID, tarea.getId());
            executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BUSCAR_NOTIFICAR_SOLICITUD_CANCELACION_RECHAZADA, expediente, sc);
        }
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CREAR_DATOS_PARA_DECISION_COMITE_AUTO)
    @Transactional(readOnly = false)
    public Long crearDatosParaDecisionComiteAutomatica(Long idExpediente, DecisionComiteAutomatico dca) {
        Expediente e = getExpediente(idExpediente);

        String descripcionExpediente = e.getDescripcionExpediente();
        final int maxLength = 35;
        if (descripcionExpediente.length() > maxLength) {
            descripcionExpediente = descripcionExpediente.substring(0, maxLength);
        }

        String nombre = "Asunto A - " + descripcionExpediente;

        String buscarNombre = "Asunto A%- " + descripcionExpediente;
        Long nAsuntos = (Long) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET_ASUNTOS_MISMO_NOMBRE, buscarNombre);

        if (nAsuntos != null && nAsuntos > 0) {
            nombre = "Asunto A" + (nAsuntos + 1) + " - " + descripcionExpediente;
        }

        DtoAsunto dto = new DtoAsunto();

        dto.setIdGestor(null);
        dto.setIdSupervisor(null);
        dto.setIdProcurador(null);
        dto.setIdExpediente(idExpediente);
        dto.setNombreAsunto(nombre);
        dto.setObservaciones("");

        if (dca.getGestor() != null) dto.setIdGestor(dca.getGestor().getId());
        if (dca.getSupervisor() != null) dto.setIdSupervisor(dca.getSupervisor().getId());

        Long idAsunto = (Long) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_CREAR_ASUNTO_DTO, dto);
        Asunto asunto = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);

        Long idProcedimiento = crearProcedimiento(dca, e.getContratoPase(), idAsunto, idExpediente);
        Procedimiento prc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idProcedimiento);
        List<Procedimiento> lista = new ArrayList<Procedimiento>();
        lista.add(prc);
        asunto.setProcedimientos(lista);
        executor.execute(ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE, asunto);

        // Descartamos contratos secundarios
        for (Contrato c : e.getContratosNoPase()) {
            for (Procedimiento procedimiento : c.getProcedimientos()) {
                executor.execute(ExternaBusinessOperation.BO_PRC_MGR_DELETE, procedimiento);
            }

            ExpedienteContrato ec = c.getExpedienteContrato(idExpediente);
            if (ec != null) {
                ec.setSinActuacion(Boolean.TRUE);
                expedienteContratoDao.update(ec);
            }
        }

        crearSesionComite(dca, e);

        if (dca.getAceptacionAutomatico()) {
            tomarDecisionComite(idExpediente, "decision automatica", true, false);
            executor.execute(ExternaBusinessOperation.BO_ASU_MGR_ACEPTAR_ASUNTO, idAsunto, true);
        } else {
            tomarDecisionComite(idExpediente, "decision automatica", true, true);
        }

        return idAsunto;
    }

    private Long crearProcedimiento(DecisionComiteAutomatico dca, Contrato c, Long idAsunto, Long idExpediente) {
        ProcedimientoDto dto = new ProcedimientoDto();

        //Recuperamos todos los intervinientes del contrato, no solo los titulares
        //dto.setPersonasAfectadas(c.getTitulares());
        dto.setPersonasAfectadas(c.getIntervinientes());

        //Se podria optimizar
        dto.setActuacion(dca.getTipoActuacion().getCodigo());
        dto.setTipoReclamacion(dca.getTipoReclamacion().getCodigo());
        dto.setTipoProcedimiento(dca.getTipoProcedimiento().getCodigo());
        dto.setPlazo(dca.getPlazoRecuperacion());
        dto.setRecuperacion(dca.getPorcentajeRecuperacion());
        dto.setSaldorecuperar(new BigDecimal(c.getLastMovimiento().getSaldoTotal()));
        dto.setAsunto(idAsunto);
        dto.setSaldoOriginalVencido(new BigDecimal(c.getLastMovimiento().getPosVivaVencida()));
        dto.setSaldoOriginalNoVencido(new BigDecimal(c.getLastMovimiento().getPosVivaNoVencida()));
        dto.setSeleccionContratos("" + c.getExpedienteContrato(idExpediente).getId());

        return (Long) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_SALVAR_PROCEDIMIMENTO, dto);
    }

    private void crearSesionComite(DecisionComiteAutomatico dca, Expediente e) {
        Comite comite = dca.getComite();
        e.setComite(comite);
        saveOrUpdate(e);

        DtoSesionComite dto = (DtoSesionComite) executor.execute(InternaBusinessOperation.BO_COMITE_MGR_GET_DTO, comite.getId());

        // Marca los presentes
        for (DtoAsistente asistente : dto.getAsistentes()) {
            asistente.setAsiste(true);
        }
        executor.execute(InternaBusinessOperation.BO_COMITE_MGR_CREAR_SESION, dto);
    }

    /**
     * {@inheritDoc}
     */
	@SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_INCLUIR_CONTRATOS_AL_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void incluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto) {
        List<Contrato> contratos = (List<Contrato>) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET_CONTRATOS_BY_ID, dto.getContratos());
        Expediente expediente = expedienteDao.get(dto.getIdExpediente());
        ExpedienteContrato cex;
        Contrato contrato;
        Cliente cliente;
        for (int i = 0; i < contratos.size(); i++) {
            cex = new ExpedienteContrato();
            contrato = contratos.get(i);
            cex.setContrato(contrato);
            cex.setExpediente(expediente);
            cex.setPase(0);
            DDAmbitoExpediente ambitoExpediente = (DDAmbitoExpediente) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDAmbitoExpediente.class, DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION);
            cex.setAmbitoExpediente(ambitoExpediente);
            //cex.setSinActuacion(true);
            expedienteContratoDao.save(cex);
            expediente.getContratos().add(cex);

            // Si el contrato es pase de algun cliente, marcamos al cliente como cancelado
            // para que en la pr�xima carga del batch vuelva a generar el cliente con el contrato
            // de pase que corresponda.
            cliente = (Cliente) executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_FIND_CLIENTE_POR_CONTRATO_PASE_ID, contrato.getId());

            if (cliente != null) {
                executor.execute(PrimariaBusinessOperation.BO_CLI_MGR_ELIMINAR_CLI_Y_BPM, cliente.getId());
                //cliente.setEstadoCliente(estadoClienteDao.getByCodigo(EstadoCliente.ESTADO_CLIENTE_CANCELADO));
                //clienteDao.save(cliente);
            }
        }
        expedienteDao.save(expediente);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_EXCLUIR_CONTRATOS_AL_EXPEDIENTE)
    @Transactional(readOnly = false)
    public void excluirContratosAlExpediente(DtoInclusionExclusionContratoExpediente dto) {
        Long idContrato = Long.parseLong(dto.getContratos());
        ExpedienteContrato expedienteContrato = expedienteContratoDao.get(dto.getIdExpediente(), idContrato);
        expedienteContratoDao.delete(expedienteContrato);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_EXISTE_DECISION_INICIADA)
    public void existeDecisionIniciada(Long idExpediente) {
        if (expedienteDao.get(idExpediente).getCantidadAsuntos() > 0) { throw new BusinessOperationException(
                "expedientes.excluirIncluirContratos.error"); }
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_PRORROGA_EXTRA)
    public void prorrogaExtra(Long idProcessInstance, Long idTareaAsociada, Date fechaPropuesta, String nombreTimer) {
        TareaNotificacion tarea = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, idTareaAsociada);
        tarea.setFechaVenc(fechaPropuesta);
        tarea.setAlerta(false);
        executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tarea);

        //Actualiza o crea el timer
        executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREA_O_RECALCULA_TIMER, idProcessInstance, nombreTimer, fechaPropuesta,
                GENERAR_NOTIFICACION);
    }

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_FIND_EXPEDIENTES_PARA_EXCEL)
    public List<Expediente> findExpedientesParaExcel(DtoBuscarExpedientes dto) {
        dto.setLimit(Integer.MAX_VALUE - 1);
        if (dto.getCodigoZona() != null && dto.getCodigoZona().trim().length() > 0) {
            StringTokenizer tokens = new StringTokenizer(dto.getCodigoZona(), ",");
            Set<String> zonas = new HashSet<String>();
            while (tokens.hasMoreTokens()) {
                String zona = tokens.nextToken();
                zonas.add(zona);
            }
            dto.setCodigoZonas(zonas);
        } else {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            dto.setCodigoZonas(usuario.getCodigoZonas());
        }

        Page p = expedienteDao.buscarExpedientesPaginado(dto);
        return (List<Expediente>) p.getResults();
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_GET_REGLAS_ELEVACION_EXPEDIENTE)
    public List<ReglasElevacion> getReglasElevacionExpediente(Long idExpediente) {
        //Recuperamos las reglas del estado del itinerario en el que se encuentra el expediente
        Expediente expediente = expedienteDao.get(idExpediente);
        DDEstadoItinerario estadoItinerario = expediente.getEstadoItinerario();
        Estado estado = (Estado) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_GET, expediente.getArquetipo().getItinerario(),
                estadoItinerario);

        List<ReglasElevacion> listadoReglas = expedienteDao.getReglasElevacion(estado);

        //Comprobamos una a una si las reglas se cumplen
        for (ReglasElevacion regla : listadoReglas) {
            construyeListadoEntidadesCumplimientoRegla(expediente, regla);
        }

        return listadoReglas;
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_GET_ENTIDADES_REGLA_ELEVACON_EXPEDIENTE)
    public List<ObjetoEntidadRegla> getEntidadReglaElevacionExpediente(Long idExpediente, Long idReglaElevacion) {
        //Recuperamos las reglas del estado del itinerario en el que se encuentra el expediente
        Expediente expediente = expedienteDao.get(idExpediente);
        ReglasElevacion regla = (ReglasElevacion) executor.execute(ConfiguracionBusinessOperation.BO_REGLAS_MGR_GET, idReglaElevacion);
        List<ObjetoEntidadRegla> listadoEntidades = construyeListadoEntidadesCumplimientoRegla(expediente, regla);

        return listadoEntidades;
    }
    
    
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_IS_RECOBRO)
    public boolean isRecobro(Long idExpediente) {
    	Expediente expediente = this.getExpediente(idExpediente);
    	if (expediente!=null)
    		return expediente.getTipoExpediente().getCodigo().equals(DDTipoExpediente.TIPO_EXPEDIENTE_RECOBRO);
    	else
    		return false;
    }


    /**
     * Devuelve un listado de objetosEntidad (cliente o contrato) que estan involucrados en con la regla que se le pasa, indicando
     * en cada objetoEntidad si cumple o no con la regla.
     * @param expediente
     * @param regla
     * @return
     */
    private List<ObjetoEntidadRegla> construyeListadoEntidadesCumplimientoRegla(Expediente expediente, ReglasElevacion regla) {
        List<ObjetoEntidadRegla> listadoEntidades = new ArrayList<ObjetoEntidadRegla>();

        //Presuponemos que la regla se cumple siempre
        regla.setCumple(true);

        String codigoTipoRegla = regla.getTipoReglaElevacion().getCodigo();
        DDAmbitoExpediente ambitoExpediente = regla.getAmbitoExpediente();
        DDEstadoItinerario estadoItinerario = expediente.getEstadoItinerario();

        List<ExpedientePersona> listadoPersonas = null;
        List<ExpedienteContrato> listadoContratos = null;
        Boolean ambitoPersona = false;
        Boolean ambitoContrato = false;
        

        if (ambitoExpediente != null) {
            if (ambitoExpediente.isAmbitoPersona()) {
                listadoPersonas = expedientePersonaDao.getListadoExpedientePersonaAmbito(expediente.getId(), ambitoExpediente);
                ambitoPersona = true;
            } else {
                if (ambitoExpediente.isAmbitoContrato()) {
                    listadoContratos = expedienteContratoDao.getListadoExpedienteContratoAmbito(expediente.getId(), ambitoExpediente);
                    ambitoContrato = true;
                }
            }
        }

        //Comprueba si se han marcado antecedentes (SOLO VALIDO PARA PERSONAS)
        if (DDTipoReglasElevacion.MARCADO_ANTECEDENTES.equals(codigoTipoRegla) && ambitoPersona) {
            //Recorremos todas las personas para ver si se han marcado o no antecedentes
            for (ExpedientePersona expPersona : listadoPersonas) {

                Persona persona = expPersona.getPersona();
                ObjetoEntidadRegla oer = new ObjetoEntidadRegla();
                oer.setEntidad(persona);
                oer.setPase(false);
                if (expPersona.getPase().intValue() == 1) {
                    oer.setPase(true);
                }

                if (persona.getAntecedente() == null || validaSeisMesesAntiguedad(persona.getAntecedente().getFechaVerificacion())) {
                    oer.setCumple(false);
                    regla.setCumple(false);
                } else {
                    oer.setCumple(true);
                }

                listadoEntidades.add(oer);
            }
        } else {
            //Comprueba si se han marcado los documentos (SOLO VALIDO PARA CONTRATOS)
            if (DDTipoReglasElevacion.MARCADO_DOCUMENTOS.equals(codigoTipoRegla) && ambitoContrato) {
                //Recorremos todos los contratos para ver si se han seteado titulos o no
                for (ExpedienteContrato expContrato : listadoContratos) {

                    Contrato contrato = expContrato.getContrato();

                    //Solo los documentos con riesgo
                    if (contrato.getLastMovimiento().getRiesgo() > 0) {
                        ObjetoEntidadRegla oer = new ObjetoEntidadRegla();
                        oer.setEntidad(contrato);
                        oer.setPase(false);
                        if (expContrato.getPase().intValue() == 1) {
                            oer.setPase(true);
                        }

                        if (contrato.getTitulos() == null || contrato.getTitulos().size() == 0) {
                            oer.setCumple(false);
                            regla.setCumple(false);
                        } else {
                            oer.setCumple(true);
                        }

                        listadoEntidades.add(oer);
                    }
                }
            } else {
                //Comprueba si se ha rellenado la gesti�n y an�lisis (SOLO VALIDO PARA EXPEDIENTE)
                if (DDTipoReglasElevacion.MARCADO_GESTION_ANALISIS.equals(codigoTipoRegla)) {
                    if (!validarExpedienteCompletoAAA(expediente)) {
                        regla.setCumple(false);
                    }
                } else {

                    //Comprueba si se han marcado la gesti�n de sintesis (SOLO VALIDO PARA PERSONAS)
                    if (DDTipoReglasElevacion.MARCADO_GESTION_SINTESIS_ANALISIS.equals(codigoTipoRegla) && ambitoPersona) {
                        //Recorremos todas las personas para ver si se han marcado o no antecedentes
                        for (ExpedientePersona expPersona : listadoPersonas) {

                            Persona persona = expPersona.getPersona();
                            ObjetoEntidadRegla oer = new ObjetoEntidadRegla();
                            oer.setEntidad(persona);
                            oer.setPase(false);
                            if (expPersona.getPase().intValue() == 1) {
                                oer.setPase(true);
                            }

                            Boolean analisisCompleto = (Boolean) executor.execute(
                                    InternaBusinessOperation.BO_ANALISIS_POL_MGR_IS_ANALISIS_POLITICA_COMPLETO, persona.getId(), expediente.getId());

                            if (analisisCompleto) {
                                oer.setCumple(true);
                            } else {
                                oer.setCumple(false);
                                regla.setCumple(false);
                            }

                            listadoEntidades.add(oer);
                        }
                    } else {
                        //Comprueba si se han marcado las pol�ticas (SOLO VALIDO PARA PERSONAS)
                        if (DDTipoReglasElevacion.MARCADO_POLITICAS.equals(codigoTipoRegla) && ambitoPersona) {
                            //Recorremos todas las personas para ver si se han marcado o no antecedentes
                            for (ExpedientePersona expPersona : listadoPersonas) {

                                Persona persona = expPersona.getPersona();
                                ObjetoEntidadRegla oer = new ObjetoEntidadRegla();
                                oer.setEntidad(persona);
                                oer.setPase(false);
                                if (expPersona.getPase().intValue() == 1) {
                                    oer.setPase(true);
                                }

                                Politica politica = (Politica) executor.execute(
                                        InternaBusinessOperation.BO_POL_MGR_GET_POLITICA_PROPUESTA_EXPEDIENTE_PERSONA_ESTADO_ITINERARIO, persona,
                                        expediente, estadoItinerario);

                                if (isPoliticaPropuestaValida(politica)) {
                                    oer.setCumple(true);
                                } else {
                                    oer.setCumple(false);
                                    regla.setCumple(false);
                                }

                                listadoEntidades.add(oer);
                            }
                        } else {
                            //Comprueba si se han marcado la solvencia (SOLO VALIDO PARA PERSONAS)
                            if (DDTipoReglasElevacion.MARCADO_SOLVENCIA.equals(codigoTipoRegla) && ambitoPersona) {
                                //Recorremos todas las personas para ver si se han marcado o no antecedentes
                                for (ExpedientePersona expPersona : listadoPersonas) {

                                    Persona persona = expPersona.getPersona();
                                    ObjetoEntidadRegla oer = new ObjetoEntidadRegla();
                                    oer.setEntidad(persona);
                                    oer.setPase(false);
                                    if (expPersona.getPase().intValue() == 1) {
                                        oer.setPase(true);
                                    }

                                    if (validaSeisMesesAntiguedad(persona.getFechaVerifSolvencia())) {
                                        oer.setCumple(false);
                                        regla.setCumple(false);
                                    } else {
                                        oer.setCumple(true);
                                    }

                                    listadoEntidades.add(oer);
                                }
                            } else{
                            	
                            	//Comprobamos si se cumple la regla Gestionar Propuesta 
                            	if(DDTipoReglasElevacion.MARCADO_GESTION_PROPUESTA.equals(codigoTipoRegla)){
                            		
                            		//obtenemos todas las propuestas del expediente
                            		List<Acuerdo> acuerdos = genericDao.getList(Acuerdo.class, genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId()));
                            		
                            		//CE
                            		if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE)){
                            			
                            			//llamamos al metodo cumplimientoReglaCE para determinar si se cumple o no la regla.
                            			regla.setCumple(cumplimientoReglaCERE(expediente, acuerdos));
                            		}
                            		//RE
                            		if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE)){
                            			
                            			//llamamos al mismo metodo que para el itinerario CE ya que la regla es la misma
                            			regla.setCumple(cumplimientoReglaCERE(expediente, acuerdos));
                            		}
                            		
                            		//de DC a FP
                            		if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_DECISION_COMIT)){
                            			regla.setCumple(cumplimientoReglaDCFP(expediente, acuerdos));                            			
                            		}
                            		
                            		///de RE a ENSAN
                            		if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION)){
                            			List<String> estadosValidos = new ArrayList<String>();
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_PROPUESTO);
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_RECHAZADO);
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_CUMPLIDO);
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO);
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_CANCELADO);
                        	    		
                            			regla.setCumple(cumplimientoReglaGeneric( acuerdos, estadosValidos,DDEstadoAcuerdo.ACUERDO_PROPUESTO));                           			
                            		}
                            		
                            		///SANC
                            		if(expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO)){
                            			List<String> estadosValidos = new ArrayList<String>();
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_PROPUESTO);
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_ACEPTADO);
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_RECHAZADO);
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_CUMPLIDO);
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO);
                            			estadosValidos.add(DDEstadoAcuerdo.ACUERDO_CANCELADO);
                        	    		
                            			regla.setCumple(cumplimientoReglaGeneric( acuerdos, estadosValidos,DDEstadoAcuerdo.ACUERDO_ACEPTADO)); 
                            		}
                            		
                            	} else {
                            		//Comprobamos si se cumple la regla Sancionar Propuesta
                            		if (DDTipoReglasElevacion.MARCADO_SANCIONAR_PROPUESTA.equals(codigoTipoRegla)) {
                            			//La relga se cumple si el expediente tiene una sanción con una propuesta
                            			if (!Checks.esNulo(expediente.getSancion()) && !Checks.esNulo(expediente.getSancion().getDecision())) {
                            				regla.setCumple(true);
                            			} else {
                            				regla.setCumple(false);
                            			}
                            		}
                            	}
                            }
                        }
                    }
                }
            }
        }

        return listadoEntidades;
    }
    
    
    /**
     * Decide si se ha cumplido la regla para el itinerario Finalizar Propuesta(FP) a Decision Comite (DC) la cual consiste en comprobar si en las propuestas del expediente, siempre que exista alguna,
     * al menos una tenga el estado "vigente", "rechazada, "Cumplida" o "Incumplida"
     * @param expediente
     * @param acuerdos
     * @return
     */
    private boolean cumplimiendoReglaFPDC(Expediente expediente, List<Acuerdo> acuerdos){
    	Boolean cumple = false;
    	int i = 0;
    	
    	if(acuerdos != null){
    		//recorremos las propuestas del expediente
	    	for(Acuerdo acuerdo: acuerdos){
	    		//Booleano que controla si hemos encontrado una propuesta en estado vigente
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_VIGENTE)){
	    			i++;
	    		}
	    		//Booleano que controla si hemos encontrado una propuesta en estado rechazada
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_RECHAZADO)){
	    			i++;
	    		}
	    		//Booleano que controla si hemos encontrado una propuesta en estado cumplido
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_CUMPLIDO)){
	    			i++;
	    		}
	    		//Booleano que controla si hemos encontrado una propuesta en estado incumplido
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO)){
	    			i++;
	    		}
	    		
	    		//las que vengan en estado cancelado no cuentan por tanto se añaden a la lista para que se cumpla la regla
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equalsIgnoreCase(DDEstadoAcuerdo.ACUERDO_CANCELADO)){
	    			i++;
				}
	    	}
	    	
	    	//Comprobamos si las propuestas tienen el estado correcto (vigente, rechazado, cumplida, incumplida) para cumplir la regla
	    	if(acuerdos.size() > 0 && acuerdos.size() == i){
	    		cumple = true;
	    	}else{
	    		cumple = false;
	    	}
    	}    	
    	
    	return cumple;
    }
    
    
    /**
     * Decide si se ha cumplido la regla para el itinerario Decision comite (DC) a Finalizar Propuesta(FP) la cual consiste en comprobar si en las propuestas del expediente, siempre que exista alguna,
     * al menos una es obligatorio que tenga el estado "elevada" y el resto en estado "elevada", "rechazada, "Cumplida" o "Incumplida"
     * @param expediente
     * @param acuerdos
     * @return
     */
    private boolean cumplimientoReglaDCFP(Expediente expediente, List<Acuerdo> acuerdos){
    	Boolean cumple = false;
    	Boolean elevadaEncontrada = false;
    	int i = 0;
    	if(acuerdos != null){
    		//recorremos las propuestas del expediente
    		for (Acuerdo acuerdo : acuerdos){
    	
	    		//Booleando que comprueba si hay una propuesta elevada (codigo aceptado)
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_ACEPTADO)){
	    			elevadaEncontrada = true;
	    			i++;
	    		}
	    		
	    		//Booleano que comprueba si hay una propuesta en estado Rechazada
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_RECHAZADO)){
	    			i++;
	    		}
	    		
	    		//Booleano que comprueba si hay una propuesta en estado Cumplida
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_CUMPLIDO)){
	    			i++;
	    		}
	    		
	    		//Boolenado que comprueba si hay una propuesta en estado Incumplida
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO)){
	    			i++;
	    		}
	    		
	    		//las que vengan en estado cancelado no cuentan por tanto se añaden a la lista para que se cumpla la regla
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equalsIgnoreCase(DDEstadoAcuerdo.ACUERDO_CANCELADO)){
				   i++;
				}
    		}
    	
	    	//Para el caso de una sola propuesta tiene que ser obligatoria en estado elevada, sino no se cumple la regla
	    	if(acuerdos.size() == 1 && elevadaEncontrada){
	    		cumple = true;
	    	}else if(acuerdos.size() == 1 && !elevadaEncontrada){
	    		cumple = false;
	    	}
	    	
	    	//Para el caso de mas de una propuesta, obligatoriamente tiene que haber una en estado elevada y el resto en elevada, rechazada, cumplida o incumplida
	    	if(acuerdos.size() > 1 && acuerdos.size() == i && elevadaEncontrada){
	    		cumple = true;
	    	}else if(acuerdos.size() > 1 && acuerdos.size() != i){
	    		cumple = false;
	    	} 	
    	}
    	
    	return cumple;
    }
    
    /**
     * Decide si se ha cumplido la regla para el itinerario Decision comite (DC) a Revisar Expediente (RE) la cual consiste en comprobar si en las propuestas del expediente, siempre que exista alguna,
     * al menos una es obligatorio que tenga el estado "elevada" y el resto en estado "elevada" o "rechazada"
     * @param expediente
     * @param acuerdos
     * @return
     */
    private boolean cumplimientoReglaDCRE(Expediente expediente, List<Acuerdo> acuerdos){
    	Boolean cumple = false;
    	Boolean elevadaEncontrada = false;
    	int i = 0;
    	
    	if(acuerdos != null){
    		//recorremos las propuestas del expediente
	    	for(Acuerdo acuerdo : acuerdos){
	    		//Booleano que comprueba si hay una propuesta en estado Elevada (codigo aceptado)
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_ACEPTADO)){
	    			elevadaEncontrada = true;
	    			i++;
	    		}
	    		
	    		//Booleano que comprueba si hay una propuesta en estado rechazada
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_RECHAZADO)){
	    			i++;
	    		}
				  //Booleano que comprueba si hay una propuesta en estado cumplida
	    		if(acuerdo.getEstadoAcuerdo().getClass().equals(DDEstadoAcuerdo.ACUERDO_CUMPLIDO)){
	    			i++;
	    		}
				  //Booleano que comprueba si hay una propuesta en estado incumplida
	    		if(acuerdo.getEstadoAcuerdo().getClass().equals(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO)){
	    			i++;
	    		}
	    		//las que vengan en estado cancelado no cuentan por tanto se añaden a la lista para que se cumpla la regla
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equalsIgnoreCase(DDEstadoAcuerdo.ACUERDO_CANCELADO)){
				   i++;
				}
	    	}
	    	
	    	//Para el caso de una sola propuesta tiene que ser obligatoria en estado elevada, si no no se cumple la regla
	    	if(acuerdos.size() == 1 && elevadaEncontrada){
	    		cumple = true;
	    	}else if (acuerdos.size() == 1 && !elevadaEncontrada){
	    		cumple = false;
	    	}
	    	
	    	//Para el caso de más de una propuesta tiene que haber minimo una en estado elevada y el resto en estado elevada, rechazada, cumplida o incumplida si 
	   	    //hubiese en otro estado no se cumpliria la regla.
	    	if(acuerdos.size() > 1 && acuerdos.size() == i && elevadaEncontrada){
	    		cumple = true;
	    	}else if(acuerdos.size() > 1 && acuerdos.size() != i) {
	    		cumple = false;
	    	}
    	}
       	
    	return cumple;
    }
    
    /**
     * Decide si se ha cumplido la regla para el itinerario Completar Expediente (CE), o Revisar expediente (RE), la cual consiste en comprobar si en las propuestas del expediente, siempre que exista alguna,
     * al menos una es obligatorio que tenga el estado "propuesta" y el resto en estado "propuesta" o "rechazada"
     * @param expediente
     * @param acuerdos
     * @return
     */
    private boolean cumplimientoReglaCERE(Expediente expediente, List<Acuerdo> acuerdos){
    	
      Boolean propuestaEncontrada = false;
      Boolean cumple = false;
      int i = 0;
      
      if(acuerdos != null){
		 //recorremos las propuestas del expediente
		  for(Acuerdo acuerdo:acuerdos){
			  //Booleano que comprueba si hay una propuesta en estado propuesto
			  if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_PROPUESTO)){
				  propuestaEncontrada = true;
				  i++;
			  }
			  //Booleano que comprueba si hay una propuesta en estado rechazado                            				  
			  if(acuerdo.getEstadoAcuerdo().getCodigo().equalsIgnoreCase(DDEstadoAcuerdo.ACUERDO_RECHAZADO)){
				  i++;
			  }
			  //Booleano que comprueba si hay una propuesta en estado cumplida
			  if(acuerdo.getEstadoAcuerdo().getCodigo().equalsIgnoreCase(DDEstadoAcuerdo.ACUERDO_CUMPLIDO)){
				  i++;
			  }
			  //Booleano que comprueba si hay una propuesta en estado incumplida
			  if(acuerdo.getEstadoAcuerdo().getCodigo().equalsIgnoreCase(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO)){
				  i++;
			  }
			  //las que vengan en estado cancelado no cuentan por tanto se añaden a la lista para que se cumpla la regla
	    	  if(acuerdo.getEstadoAcuerdo().getCodigo().equalsIgnoreCase(DDEstadoAcuerdo.ACUERDO_CANCELADO)){
				  i++;
			  }
			  
		  }
		  
		  //Para el caso de una sola propuesta tiene que ser obligatoria en estado propuesta, si no no se cumple la regla
		  if(acuerdos.size() == 1 && propuestaEncontrada){
			  cumple =  true;
		  }else if(acuerdos.size() == 1 && !propuestaEncontrada){
			  cumple =  false;
		  }
		  
		//Para el caso de más de una propuesta tiene que haber minimo una en estado propuesta y el resto en estado propuesta, rechazada, cumplida o incumplida si 
	   	    //hubiese en otro estado no se cumpliria la regla.
		  if(acuerdos.size() > 1 && acuerdos.size() == i && propuestaEncontrada){
			  cumple =  true;
		  }else if(acuerdos.size() > 1 && acuerdos.size() != i){
			  cumple = false;
		  }
      }
	  
	  return cumple;
	  
    }
    
    
    /**
     * Decide si se ha cumplido la regla para el itinerario En sanción(ENSAN) a SANCIONADO (DC) o REVISAR EXPEDIENTE (RE) la cual consiste en comprobar si en las propuestas del expediente, siempre que exista alguna,
     * al menos una tenga el estado "vigente", "rechazada, "Cumplida" o "Incumplida"
     * @param expediente
     * @param acuerdos
     * @return
     */
    private boolean cumplimientoReglaENSAN(Expediente expediente, List<Acuerdo> acuerdos){
    	Boolean cumple = false;
    	int i = 0;
    	
    	if(acuerdos != null){
    		//recorremos las propuestas del expediente
	    	for(Acuerdo acuerdo: acuerdos){
	    		//Booleano que controla si hemos encontrado una propuesta en estado elevada
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_VIGENTE)){
	    			i++;
	    		}
	    		//Booleano que controla si hemos encontrado una propuesta en estado rechazada
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_RECHAZADO)){
	    			i++;
	    		}
	    		//Booleano que controla si hemos encontrado una propuesta en estado cumplido
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_CUMPLIDO)){
	    			i++;
	    		}
	    		//Booleano que controla si hemos encontrado una propuesta en estado incumplido
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO)){
	    			i++;
	    		}
	    		
	    		//las que vengan en estado cancelado no cuentan por tanto se añaden a la lista para que se cumpla la regla
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equalsIgnoreCase(DDEstadoAcuerdo.ACUERDO_CANCELADO)){
	    			i++;
				}
	    	}
	    	
	    	//Comprobamos si las propuestas tienen el estado correcto (vigente, rechazado, cumplida, incumplida) para cumplir la regla
	    	if(acuerdos.size() > 0 && acuerdos.size() == i){
	    		cumple = true;
	    	}else{
	    		cumple = false;
	    	}
    	}    	
    	
    	return cumple;
    }
    
    /**
     * Decide si se ha cumplido la regla para el itinerario En sanción(ENSAN) a SANCIONADO (DC) o REVISAR EXPEDIENTE (RE) la cual consiste en comprobar si en las propuestas del expediente, siempre que exista alguna,
     * al menos una tenga el estado "vigente", "rechazada, "Cumplida" o "Incumplida"
     * @param expediente
     * @param acuerdos
     * @return
     */
    private boolean cumplimientoReglaSANC(Expediente expediente, List<Acuerdo> acuerdos){
    	Boolean cumple = false;
    	int i = 0;
    	
    	if(acuerdos != null){
    		//recorremos las propuestas del expediente
	    	for(Acuerdo acuerdo: acuerdos){
	    		//Booleano que controla si hemos encontrado una propuesta en estado elevada
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_VIGENTE)){
	    			i++;
	    		}
	    		//Booleano que controla si hemos encontrado una propuesta en estado rechazada
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_RECHAZADO)){
	    			i++;
	    		}
	    		//Booleano que controla si hemos encontrado una propuesta en estado cumplido
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_CUMPLIDO)){
	    			i++;
	    		}
	    		//Booleano que controla si hemos encontrado una propuesta en estado incumplido
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equals(DDEstadoAcuerdo.ACUERDO_INCUMPLIDO)){
	    			i++;
	    		}
	    		
	    		//las que vengan en estado cancelado no cuentan por tanto se añaden a la lista para que se cumpla la regla
	    		if(acuerdo.getEstadoAcuerdo().getCodigo().equalsIgnoreCase(DDEstadoAcuerdo.ACUERDO_CANCELADO)){
	    			i++;
				}
	    	}
	    	
	    	//Comprobamos si las propuestas tienen el estado correcto (vigente, rechazado, cumplida, incumplida) para cumplir la regla
	    	if(acuerdos.size() > 0 && acuerdos.size() == i){
	    		cumple = true;
	    	}else{
	    		cumple = false;
	    	}
    	}    	
    	
    	return cumple;
    }
    
    
    private boolean cumplimientoReglaGeneric(List<Acuerdo> acuerdos, List<String> estadosValidos,String estadoObligatorio){
    	Boolean cumple = false;
    	Boolean elevadaEncontrada = false;
    	int i = 0;
    	if(acuerdos != null && !Checks.estaVacio(estadosValidos)){
    		//recorremos las propuestas del expediente
    		for (Acuerdo acuerdo : acuerdos){
    			
    			if(estadosValidos.contains(acuerdo.getEstadoAcuerdo().getCodigo())){
    				i++;
    			}
    			
    			if(!Checks.esNulo(estadoObligatorio) && estadoObligatorio.equals(acuerdo.getEstadoAcuerdo().getCodigo())){
    				elevadaEncontrada = true;
    			}

    		}
    	
	    	//Para el caso de una sola propuesta tiene que ser obligatoria en estado "estadoObligatorio", sino no se cumple la regla
	    	if(acuerdos.size() == 1 && elevadaEncontrada){
	    		cumple = true;
	    	}else if(acuerdos.size() == 1 && !elevadaEncontrada){
	    		cumple = false;
	    	}
	    	
	    	//Para el caso de mas de una propuesta, obligatoriamente tiene que haber una en estado "estadoObligatorio" y el resto en "estadosValidos"
	    	if(acuerdos.size() > 1 && acuerdos.size() == i && elevadaEncontrada){
	    		cumple = true;
	    	}else if(acuerdos.size() > 1 && acuerdos.size() != i){
	    		cumple = false;
	    	} 	
    	}
    	
    	return cumple;
    }
    

    /**
     * Decide si la pol�tica es v�lida en contenido (cumple con las reglas de objetivos, etc.).
     * @param politica La pol�tica a comprobar
     * @return
     */
    private Boolean isPoliticaPropuestaValida(Politica politica) {
        //Si no hay pol�tica, falla
        if (politica == null) { return false; }

        //Si la pol�tica no es vigente, falla
        if (!politica.getEsPropuesta()) { return false; }

        //Si la pol�tica no tiene objetivos, falla
        if (politica.getCantidadObjetivos() == 0) { return false; }

        //Comprobamos que los objetivos siguen la tendencia de la pol�tica
        /*
        List<Objetivo> listadoObjetivos = politica.getEstadoItinerarionActual().getObjetivos();

        for (Objetivo objetivo : listadoObjetivos) {
            if (!objetivoManager.compruebaValidezObjetivo(objetivo)) return false;
        }
        */

        //Si cumple con todo, entonces es correcta
        return true;
    }

    /**
     * {@inheritDoc}
     */
	@SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_GET_PERSONAS_MARCADO_OBLIGATORIO)
    public List<DtoPersonaPoliticaUlt> getPersonasMarcadoObligatorio(Long idExpediente) {
        // Obtenermos el expediente correspondiente
        Expediente expediente = expedienteDao.get(idExpediente);
        DDTipoReglasElevacion tipoReglasElevacion = (DDTipoReglasElevacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDTipoReglasElevacion.class, DDTipoReglasElevacion.MARCADO_POLITICAS);

        DDEstadoItinerario estadoItinerario = expediente.getEstadoItinerario();
        Estado estado = (Estado) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_GET, expediente.getArquetipo().getItinerario(),
                estadoItinerario);

        List<ReglasElevacion> reglas = (List<ReglasElevacion>) executor.execute(ConfiguracionBusinessOperation.BO_REGLAS_MGR_FIND_BY_TIPO_AND_ESTADO,
                tipoReglasElevacion.getId(), estado.getId());
        ReglasElevacion reglaElevacion = new ReglasElevacion();
        if (reglas.size() > 0) {
            reglaElevacion = reglas.get(0);
        } else
            return new ArrayList<DtoPersonaPoliticaUlt>();

        List<ObjetoEntidadRegla> listadoEntidadesCumplimientoRegla = construyeListadoEntidadesCumplimientoRegla(expediente, reglaElevacion);

        List<DtoPersonaPoliticaUlt> personas = new ArrayList<DtoPersonaPoliticaUlt>();
        DtoPersonaPoliticaUlt dto;
        for (ObjetoEntidadRegla objetoEntidadRegla : listadoEntidadesCumplimientoRegla) {
            dto = new DtoPersonaPoliticaUlt();
            dto.setPersona(objetoEntidadRegla.getPersona());
            Politica pol = (Politica) executor.execute(InternaBusinessOperation.BO_POL_MGR_BUSCAR_ULTIMA_POLITICA, dto.getPersona().getId());
            dto.setPoliticaUltima(pol);
            personas.add(dto);
        }

        return personas;
    }

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_GET_PERSONAS_MARCADO_OPCIONAL)
    public List<DtoPersonaPoliticaUlt> getPersonasMarcadoOpcional(Long idExpediente) {

        Expediente expediente = expedienteDao.get(idExpediente);
        List<Persona> personasObligatorias = new ArrayList<Persona>();
        List<ExpedientePersona> totalPersonas = expediente.getPersonas();

        // Obtenermos el expediente correspondiente
        DDTipoReglasElevacion tipoReglasElevacion = (DDTipoReglasElevacion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                DDTipoReglasElevacion.class, DDTipoReglasElevacion.MARCADO_POLITICAS);
        DDEstadoItinerario estadoItinerario = expediente.getEstadoItinerario();
        Estado estado = (Estado) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_GET, expediente.getArquetipo().getItinerario(),
                estadoItinerario);

        List<ReglasElevacion> reglas = (List<ReglasElevacion>) executor.execute(ConfiguracionBusinessOperation.BO_REGLAS_MGR_FIND_BY_TIPO_AND_ESTADO,
                tipoReglasElevacion.getId(), estado.getId());

        if (reglas.size() > 0) {
            ReglasElevacion reglaElevacion;
            reglaElevacion = reglas.get(0);
            List<ObjetoEntidadRegla> listadoEntidadesCumplimientoRegla = construyeListadoEntidadesCumplimientoRegla(expediente, reglaElevacion);

            for (ObjetoEntidadRegla objetoEntidadRegla : listadoEntidadesCumplimientoRegla) {
                personasObligatorias.add(objetoEntidadRegla.getPersona());
            }
        }

        List<DtoPersonaPoliticaUlt> personasOpcionales = new ArrayList<DtoPersonaPoliticaUlt>();
        DtoPersonaPoliticaUlt dto;

        for (ExpedientePersona expedientePersona : totalPersonas) {
            if (!personasObligatorias.contains(expedientePersona.getPersona())) {
            	dto = new DtoPersonaPoliticaUlt();
                dto.setPersona(expedientePersona.getPersona());
                Politica pol = (Politica) executor.execute(InternaBusinessOperation.BO_POL_MGR_BUSCAR_ULTIMA_POLITICA, dto.getPersona().getId());
                dto.setPoliticaUltima(pol);
                personasOpcionales.add(dto);
            }
        }

        return personasOpcionales;
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_CERRAR_DECISION_POLITICA)
    @Transactional(readOnly = false)
    public Boolean cerrarDecisionPolitica(Long idExpediente) {
        Expediente expediente = expedienteDao.get(idExpediente);

        Comite comite = (Comite) executor.execute(InternaBusinessOperation.BO_COMITE_MGR_GET_WITH_SESSIONS, expediente.getComite().getId());
        if (expediente.getEstaDecidido()) { throw new BusinessOperationException("expediente.tomarDecision.decisionYaTomada"); }

        if (expediente.isGestionDeuda()) {
        	if (!DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO.equalsIgnoreCase(expediente.getEstadoItinerario().getCodigo())) { throw new BusinessOperationException(
        			"expediente.tomarDecision.estadoInvalido"); }
        } else {
        	if (!DDEstadoItinerario.ESTADO_DECISION_COMIT.equalsIgnoreCase(expediente.getEstadoItinerario().getCodigo())) { throw new BusinessOperationException(
                "expediente.tomarDecision.estadoInvalido"); }
        }

        if (!Comite.INICIADO.equalsIgnoreCase(comite.getEstado())) { throw new BusinessOperationException("expediente.tomarDecision.sesionInvalida"); }

        Boolean permitidoElevar = false;
        
        if (expediente.isGestionDeuda()) {
        	permitidoElevar = compruebaElevacion(expediente, ExpedienteBPMConstants.SANCIONADO, true);
        } else {
        	permitidoElevar = compruebaElevacion(expediente, ExpedienteBPMConstants.DECISION_COMITE, true);
        }
        if (!permitidoElevar) { throw new BusinessOperationException("expediente.cerrarDecisionPolitica.errorValidacion"); }

        Boolean politicasVigentes = (Boolean) executor
                .execute(InternaBusinessOperation.BO_POL_MGR_MARCAR_POLITICAS_VIGENTES, expediente, null, false);

        //Si se ha marcado como vigente las pol�ticas, el expediente se cancela
        if (politicasVigentes) {
            marcarSinActuacionTodosContratos(expediente);
            DecisionComite dc = new DecisionComite();
            dc.setSesion(comite.getUltimaSesion());
            dc.setObservaciones("");
            executor.execute(InternaBusinessOperation.BO_DECISIONN_COMITE_MRG_SAVE, dc);
            expediente.setDecisionComite(dc);
            
            //Si el expediente no es de gestión de deuda, se decide
            if (!expediente.isGestionDeuda()) {
            	DDEstadoExpediente estadoDecidido = (DDEstadoExpediente) dictionaryManager.getByCode(DDEstadoExpediente.class, DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO);
            
            	expediente.setEstadoExpediente(estadoDecidido);
            }
            expedienteDao.saveOrUpdate(expediente);

            if (!expediente.isGestionDeuda()) {
	            executor.execute(ComunBusinessOperation.BO_JBPM_MGR_SIGNAL_PROCESS, expediente.getProcessBpm(),
	                    ExpedienteBPMConstants.TRANSITION_TOMARDECISION);
            }
            
            //Si no se ha marcado como vigente, se lanza una excepci�n porque deber�a
        } else {
            logger.error("Alguna de las pol�ticas del expediente " + idExpediente
                    + " no se han podido marcar como vigente una vez cerrada decisi�n de comit� de pol�ticas");
            throw new BusinessOperationException("expediente.cerrarDecisionPolitica.errorMarcado");
        }

        return true;
    }
	

    /**
     * Marca todos los contratos del expediente como sin actuaci�n
     * @param expediente
     */
    @Transactional(readOnly = false)
    private void marcarSinActuacionTodosContratos(Expediente expediente) {
        for (ExpedienteContrato ec : expediente.getContratos()) {
            ec.setSinActuacion(true);
            expedienteContratoDao.update(ec);
        }

    }

    /**
     * {@inheritDoc}
     */
	@BusinessOperation
    @Transactional(readOnly = false)
    public Boolean cerrarDecisionPoliticaSuperusuario(Long idPolitica) {

        Politica politica = (Politica) executor.execute(InternaBusinessOperation.BO_POL_MGR_GET, idPolitica);
        Boolean politicasVigentes = (Boolean) executor.execute(InternaBusinessOperation.BO_POL_MGR_MARCAR_POLITICAS_VIGENTES, null, politica, true);

        //Si no se ha marcado como vigente, se lanza una excepci�n porque deber�a
        if (!politicasVigentes) {
            logger.error("La politica " + idPolitica + " no se ha podido marcar como vigente una vez cerrada decisi�n de superusuario");
            throw new BusinessOperationException("expediente.cerrarDecisionPolitica.errorMarcado");
        }

        return true;
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_GET_PERSONAS_POLITICAS_DEL_EXPEDIENTE)
    public List<DtoPersonaPoliticaExpediente> getPersonasPoliticasDelExpediente(Long idExpediente) {
        Expediente expediente = expedienteDao.get(idExpediente);
        List<DtoPersonaPoliticaExpediente> list = new ArrayList<DtoPersonaPoliticaExpediente>();
        if (expediente.getSeguimiento() || expediente.isGestionDeuda()) {
            DtoPersonaPoliticaExpediente dto;
            for (ExpedientePersona expedientePersona : expediente.getPersonas()) {
                Long idPersona = expedientePersona.getPersona().getId();
                dto = new DtoPersonaPoliticaExpediente();
                dto.setPersona(expedientePersona.getPersona());
                Politica politica = (Politica) executor.execute(InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICA_VIGENTE, idPersona);
                if (politica == null) {

                    CicloMarcadoPolitica cmp = (CicloMarcadoPolitica) executor.execute(
                            InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA_EXP, idPersona, idExpediente);
                    if (cmp != null)
                        politica = cmp.getUltimaPolitica();
                    else
                        continue;
                }

                dto.setPolitica(politica);
                dto.setFecha((new SimpleDateFormat(FormatUtils.DDMMYYYY)).format(FormatUtils.fechaSinHora(politica.getAuditoria().getFechaCrear())));
                list.add(dto);
            }
        }
        return list;
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_UPDATE_EXPEDIENTE_CONTRATO)
    @Transactional(readOnly = false)
    public void updateExpedienteContrato(ExpedienteContrato ec) {
        expedienteContratoDao.update(ec);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDINTE_CONTRATO)
    public ExpedienteContrato getExpedienteContrato(Long ecId) {
        return expedienteContratoDao.get(ecId);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_GUARDAR_SOLICITUD_CANCELACION)
    public void guardarSolicitudCancelacion(SolicitudCancelacion solicitudCancelacion) {
        solicitudCancelacionDao.save(solicitudCancelacion);
    }

	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(InternaBusinessOperation.BO_EXP_MGR_SIN_EXPEDIENTES_ACTIVOS_DE_UNA_PERSONA)
    @Transactional(readOnly = false)
    public Boolean sinExpedientesActivosDeUnaPersona(Long idPersona) {
        Long nExp = 0L;

        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);

        if (persona.getArquetipoCalculado() != null) {
            Arquetipo arq = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET, persona.getArquetipoCalculado());
            Boolean isRecuperacion = arq.getItinerario().getdDtipoItinerario().getItinerarioRecuperacion();

            //Si se va a crear un expediente de recuperaci�n
            if (isRecuperacion) {
                //Se buscan expedientes de seguimiento
                nExp = expedienteDao.getNumExpedientesActivos(persona.getId(), false);
            } else {
                //Si se crea un expediente de seguimiento se busca cualquier tipo de expediente
                nExp = expedienteDao.getNumExpedientesActivos(persona.getId(), true) + expedienteDao.getNumExpedientesActivos(persona.getId(), false);
            }
        }

        return nExp.longValue() == 0;

    }

}
