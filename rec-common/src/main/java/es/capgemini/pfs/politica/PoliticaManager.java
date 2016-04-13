package es.capgemini.pfs.politica;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.api.ExpedienteManagerApi;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedientePersona;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoReglaVigenciaPolitica;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.ReglasVigenciaPolitica;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.dao.CicloMarcadoPoliticaDao;
import es.capgemini.pfs.politica.dao.DDTipoPoliticaDao;
import es.capgemini.pfs.politica.dao.PoliticaDao;
import es.capgemini.pfs.politica.dto.DtoPolitica;
import es.capgemini.pfs.politica.model.AnalisisPersonaPolitica;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica;
import es.capgemini.pfs.politica.model.DDEstadoObjetivo;
import es.capgemini.pfs.politica.model.DDEstadoPolitica;
import es.capgemini.pfs.politica.model.DDMotivo;
import es.capgemini.pfs.politica.model.DDTipoPolitica;
import es.capgemini.pfs.politica.model.Objetivo;
import es.capgemini.pfs.politica.model.ObjetoPermisosGestionObjetivos;
import es.capgemini.pfs.politica.model.Politica;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;

/**
 * Clase con los métodos de negocio relativos a los Objetivos.
 * @author Andrés Esteban
 *
 */
@Service
public class PoliticaManager {

    @Autowired
    private Executor executor;

    @Autowired
    private PoliticaDao politicaDao;
    
    @Autowired
    private DDTipoPoliticaDao ddTipoPoliticaDao;

    @Autowired
    private CicloMarcadoPoliticaDao cicloMarcadoPoliticaDao;

    @Autowired
    private DictionaryManager dictionaryManager;
    
    @Autowired
	private GenericABMDao genericDao;
    
    @Autowired
    private PersonaDao personaDao;
    
    @Autowired
    private ExpedienteManagerApi expedienteManager;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * Crear o modifica la politica con los datos del Dto.
     * @param dto parámetros
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GUARDAR_POLITICA)
    @Transactional(readOnly = false)
    public void guardarPolitica(DtoPolitica dto) {
        Politica politica =  politicaDao.buscarUltimaPolitica(dto.getIdPersona());

        Long idPersona = dto.getIdPersona();
        Long idExpediente = dto.getIdExpediente();

        Persona persona = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
        Expediente expediente = null;
        if (idExpediente != null) {
            expediente = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);
        }

        //Recuperamos el ciclo de marcado, si no existe lo creamos
        CicloMarcadoPolitica cicloMarcado = null;
        if (politica != null) {
            cicloMarcado = politica.getCicloMarcadoPolitica();
        }
        if (cicloMarcado == null) {
            cicloMarcado = new CicloMarcadoPolitica();
            cicloMarcado.setExpediente(expediente);
            cicloMarcado.setPersona(persona);
            cicloMarcadoPoliticaDao.save(cicloMarcado);
        }

        //modificacion o alta
        DDTipoPolitica tipo = (DDTipoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDTipoPolitica.class, dto
                .getCodigoTipoPolitica());

        Perfil perfilGestor = (Perfil) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_BUSCAR_PERFIL_POR_CODIGO, dto
                .getCodigoGestorPerfil());

        DDZona zonaGestor = (DDZona) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDZona.class, dto.getCodigoGestorZona());

        Perfil perfilSuper = (Perfil) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_BUSCAR_PERFIL_POR_CODIGO, dto
                .getCodigoSupervisorPerfil());

        DDZona zonaSupervisor = (DDZona) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDZona.class, dto
                .getCodigoSupervisorZona());
        
        DDMotivo motivo = (DDMotivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDMotivo.class, dto.getMotivo());
        
        Auditoria auditoria = new Auditoria();

        politica.setTipoPolitica(tipo);
        politica.setCicloMarcadoPolitica(cicloMarcado);

        if (perfilGestor != null) {
            politica.setPerfilGestor(perfilGestor);
        }
        if (zonaGestor != null) {
            politica.setZonaGestor(zonaGestor);
        }

        if (perfilSuper != null) {
            politica.setPerfilSupervisor(perfilSuper);
        }
        if (zonaSupervisor != null) {
            politica.setZonaSupervisor(zonaSupervisor);
        }
        
        if(motivo != null){
        	politica.setMotivo(motivo);
        }
        
        if(dto.getFecha() != null){
        	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        	Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        	try {
				auditoria.setFechaCrear(sdf.parse(dto.getFecha()));
				auditoria.setUsuarioCrear(usuario.getNombre());
			} catch (ParseException e) {
				e.printStackTrace();
			}
        	politica.setAuditoria(auditoria);
        }
        
        politica.setUsuarioCreacion((Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO));

        if (politica.getId() == null) {
            //alta
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            Perfil perfilUsuario = getPerfilConFuncionSuperUsuario(usuario);

            DDEstadoItinerarioPolitica estadoActual = null;
            if (perfilUsuario != null) {
                estadoActual = (DDEstadoItinerarioPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                        DDEstadoItinerarioPolitica.class, DDEstadoItinerarioPolitica.ESTADO_VIGENTE);

            } else {
                //Uso el codigo porque es el mismo, pero si no fuera asi fallaría. En ese caso hay que buscar el que este relacionado.
                estadoActual = (DDEstadoItinerarioPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                        DDEstadoItinerarioPolitica.class, expediente.getEstadoItinerario().getCodigo());
            }

            politica.setEstadoItinerarioPolitica(estadoActual);
            politica.setUsuarioCreacion(usuario);
        }

        politicaDao.saveOrUpdate(politica);
    }

    /**
     * Busca si el perfil del usuario que tiene la función de super usuario.
     * @param Usuario usuario
     * @return Perfil
     */
    private Perfil getPerfilConFuncionSuperUsuario(Usuario usuario) {
        for (Perfil perfil : usuario.getPerfiles()) {
            for (Funcion funcion : perfil.getFunciones()) {
                if (funcion.getDescripcion().equalsIgnoreCase(Funcion.FUNCION_POLITICA_SUPERUSUARIO)) { return perfil; }
            }
        }
        return null;
    }

    /**
     * Recupera todas las políticas para la persona indicada.
     * @param idPersona Long
     * @return Lista de ciclos de políticas
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA)
    public List<CicloMarcadoPolitica> buscarPoliticasParaPersona(Long idPersona) {
        return politicaDao.buscarPoliticasParaPersona(idPersona);
    }

    /**
     * Recupera todas las politicas para un ciclo de marcado.
     * @param idCicloMarcadoPolitica Long
     * @return lista de Politicas
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICAS_CICLO_MARCADO_POLITICA)
    public List<Politica> buscarPoliticasCicloMarcadoPolitica(Long idCicloMarcadoPolitica) {
        CicloMarcadoPolitica cicloMarcado = cicloMarcadoPoliticaDao.get(idCicloMarcadoPolitica);
        if (cicloMarcado != null) { return cicloMarcado.getPoliticas(); }

        return new ArrayList<Politica>();
    }

    /**
     * Recupera todos los objetivos para el estado indicado.
     * @param idPolitica Long
     * @return lista de Objetivos
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_BUSCAR_OBJETIVOS_POLITICA)
    public List<Objetivo> buscarObjetivosPolitica(Long idPolitica) {
        Politica politica = politicaDao.get(idPolitica);
        if (politica == null) { return new ArrayList<Objetivo>(); }
        return politica.getObjetivos();
    }

    /**
     * Crear el dto para la politica indicada.
     * @param idPolitica long
     * @param idPersona long
     * @return DtoPolitica
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GET_DTO_POLITICA)
    public DtoPolitica getDtoPolitica(Long idPolitica, Long idPersona) {
        DtoPolitica dto = new DtoPolitica();
        Politica politica = politicaDao.get(idPolitica);
        if (politica == null) {
            politica = new Politica();
            DDEstadoPolitica estadoPolitica = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_PROPUESTA);

            politica.setEstadoPolitica(estadoPolitica);
        }
        dto.setIdPersona(idPersona);
        dto.setPolitica(politica);

        return dto;
    }

    /**
     * Recupera los tipos de politicas.
     * @return lista de tipos de politcas
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GET_TIPO_POLITICA_LIST)
    public List<DDTipoPolitica> getTipoPoliticaList() {
        return (List<DDTipoPolitica>) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_LIST, DDTipoPolitica.class.getName());
    }
    
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GET_TIPO_POLITICA_PERSONA_LIST)
    public List<DDTipoPolitica> getTipoPoliticaPersonaList(Long idPersona) {
    	//Si no podemos obtener la politica de la entidad para la persona
    	//Devolvemos todos los tipos de politicas
    	if (idPersona==null)
    		return this.getTipoPoliticaList();
    	
    	Persona persona = personaDao.get(idPersona);
    	if (persona==null)
    		return this.getTipoPoliticaList();
    	
    	if (persona.getPoliticaEntidad()==null)
    		return this.getTipoPoliticaList();
    	
    	//Si tenemos informado para la persona un tipo de politica de la entidad
    	//devolvemos el diccionario filtrado por los tipos que le corresponden
    	List<DDTipoPolitica> politicas = (List<DDTipoPolitica>)genericDao.getList(DDTipoPolitica.class,
    				genericDao.createFilter(FilterType.EQUALS, "politicaEntidad.id", persona.getPoliticaEntidad().getId()),
    				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
    	
    	//Si no hemos obtenido ninguna politica de la traducción, devolvemos todas
    	if (Checks.estaVacio(politicas)) {
    		return this.getTipoPoliticaList();
    	} else {
    		return politicas;
    	}
    }
    
    /**
     * Recuperamos los motivos 
     * @return
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GET_TIPO_MOTIVO)
    public List<DDMotivo> getMotivoList(){
    	Filter filtro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
    	List<DDMotivo> motivos = genericDao.getList(DDMotivo.class, filtro);
    	
		return motivos;
    }

    /**
     * Recupera los permisos del usuario conectado sobre los objetivos de la política (si es gestor o supervisor).
     * @param idPolitica long
     * @return list
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_COMPRUEBA_PERMISOS_USUARIO)
    public List<ObjetoPermisosGestionObjetivos> compruebaPermisosUsuario(Long idPolitica) {
        List<ObjetoPermisosGestionObjetivos> list = new ArrayList<ObjetoPermisosGestionObjetivos>(1);
        ObjetoPermisosGestionObjetivos permisos = new ObjetoPermisosGestionObjetivos();
        list.add(permisos);

        permisos.setEsGestorObjetivos(false);
        permisos.setEsSupervisorObjetivos(false);
        permisos.setEsGestorExpediente(false);
        permisos.setEsSupervisorExpediente(false);
        permisos.setEsVigente(false);
        permisos.setEsPropuesta(false);
        permisos.setEsPropuestaSuperusuario(false);

        Politica politica = politicaDao.get(idPolitica);
        Perfil perfilGestorExpediente = null;
        Perfil perfilSupervisorExpediente = null;
        Perfil perfilGestorObjetivos = null;
        Perfil perfilSupervisorObjetivos = null;
        DDZona zonaGestorObjetivos = null;
        DDZona zonaSupervisorObjetivos = null;

        if (politica != null) {
            perfilGestorObjetivos = politica.getPerfilGestor();
            perfilSupervisorObjetivos = politica.getPerfilSupervisor();

            zonaGestorObjetivos = politica.getZonaGestor();
            zonaSupervisorObjetivos = politica.getZonaSupervisor();

            permisos.setEsVigente(politica.getEsVigente());
            permisos.setEsPropuesta(politica.getEsPropuesta());

            permisos.setEsPropuestaSuperusuario(politica.getEsPropuestaSuperusuario());

            if (politica.getEsPropuesta()) {
                Expediente exp = politica.getCicloMarcadoPolitica().getExpediente();
                if (exp != null) {
                    Estado estado = exp.getArquetipo().getItinerario().getEstado(exp.getEstadoItinerario().getCodigo());
                    perfilGestorExpediente = estado.getGestorPerfil();
                    perfilSupervisorExpediente = estado.getSupervisor();
                }
            }
        }

        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);

        for (ZonaUsuarioPerfil zup : usuario.getZonaPerfil()) {
            if (zup.getPerfil().equals(perfilGestorObjetivos) && zup.getZona().equals(zonaGestorObjetivos)) {
                permisos.setEsGestorObjetivos(true);
            }
            if (zup.getPerfil().equals(perfilSupervisorObjetivos) && zup.getZona().equals(zonaSupervisorObjetivos)) {
                permisos.setEsSupervisorObjetivos(true);
            }

            if (zup.getPerfil().equals(perfilGestorExpediente)) {
                permisos.setEsGestorExpediente(true);
            }
            if (zup.getPerfil().equals(perfilSupervisorExpediente)) {
                permisos.setEsSupervisorExpediente(true);
            }
        }

        return list;
    }

    /**
     * Cierra la desición política del expediente (CU F3_WEB-113).
     * @param idExpediente Long
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_CERRAR_DECISION_POLITICA)
    @Transactional(readOnly = false)
    public void cerrarDecisionPolitica(Long idExpediente) {
        Expediente expediente = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, idExpediente);

        //Si el tipo de expediente no coincide con el el tipo de comite
        //Se emite un error
        if (expediente.getSeguimiento() && !expediente.getComite().isComiteSeguimiento()) { throw new BusinessOperationException("cerrarDecisionPolitica.expedienteNoSeguimiento", idExpediente); }
        if (expediente.isGestionDeuda() && !expediente.getComite().isComiteGestionDeuda()) { throw new BusinessOperationException("cerrarDecisionPolitica.expedienteNoGestionDeuda", idExpediente); }
        
        expedienteManager.cerrarDecisionPolitica(idExpediente);
    }

    /**
     * Inicializa las politicas al crear un expediente de seguimiento
     * @param expediente Expediente
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_INICIALIZAR_POLITICAS_EXPEDIENTE)
    public void inicializaPoliticasExpediente(Expediente expediente) {
        //Si no es un expediente de seguimiento y tampoco de gestión de deuda
        if (!expediente.getSeguimiento() && !expediente.isGestionDeuda()) { return; }

        DDAmbitoExpediente ambitoExpediente = expediente.getArquetipo().getItinerario().getAmbitoExpediente();

        List<ExpedientePersona> listadoPersonas = expediente.getPersonas(ambitoExpediente);

        for (ExpedientePersona pex : listadoPersonas) {
            Persona persona = pex.getPersona();

            // ********************************************************************** //
            // ** Creamos una ciclo de marcado de politica                         ** //
            // ********************************************************************** //
            CicloMarcadoPolitica cicloMarcado = new CicloMarcadoPolitica();
            cicloMarcado.setExpediente(expediente);
            cicloMarcado.setPersona(persona);
            cicloMarcadoPoliticaDao.save(cicloMarcado);

            // ********************************************************************** //
            // ** Creamos un análisis de marcado de política                       ** //
            // ********************************************************************** //
            //CU WEB-124 Se necesita un registro de análisis asociado a la política.
            AnalisisPersonaPolitica app = new AnalisisPersonaPolitica();
            app.setCicloMarcadoPolitica(cicloMarcado);
            executor.execute(InternaBusinessOperation.BO_ANALISIS_POL_MGR_SAVE, app);

            // ********************************************************************** //
            // ** Creamos una politica en estado histórica que será la prepolítica ** //
            // ********************************************************************** //
            DDEstadoItinerarioPolitica estadoItinerarioPolitica = (DDEstadoItinerarioPolitica) executor
                    .execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoItinerarioPolitica.class,
                            DDEstadoItinerarioPolitica.ESTADO_PREPOLITICA);

            Politica prepolitica = new Politica();

            DDEstadoPolitica estadoPolHistorica = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_HISTORICA);

            prepolitica.setEstadoPolitica(estadoPolHistorica);
            prepolitica.setEstadoItinerarioPolitica(estadoItinerarioPolitica);
            prepolitica.setCicloMarcadoPolitica(cicloMarcado);

            /**DDTipoPolitica politicaPersona = persona.getPrepolitica();
            if (politicaPersona != null) {
                prepolitica.setTipoPolitica(politicaPersona);
            }**/
            //Nueva forma de obtener el tipo de política
            
            
            DDTipoPolitica tipoPolitica = null;
            
            //Si el cliente tiene una politica de la entidad, se aplica esta
            if (persona.getPoliticaEntidad()!=null) {
            	//Hay que obtener la traducción a las politicas de recovery,
            	//Si hay mas de una posible, nos quedamos con la primera 
            	
            	tipoPolitica = ddTipoPoliticaDao.buscarTipoPoliticaAsociadaAEntidad(persona.getPoliticaEntidad().getCodigo());        	
            }
            
            //Si no se ha conseguido un tipo de politica
            if (tipoPolitica == null) {
	            Arquetipo arquetipo = null;
	            
	            //Si el expediente es automático se obtiene el arquetipo de la persona, de la tabla ARR
	            if (!expediente.isManual()) {
	            	arquetipo = (Arquetipo) executor.execute(ConfiguracionBusinessOperation.BO_ARQ_MGR_GET_RECUPERACION_BY_PERSONA, persona.getId());
	            } else {
	            	//Si no el arquetipo se preselecciona en la creación del expedietne manual
	            	arquetipo = expediente.getArquetipo();
	            }
	            	
	            
	            if( arquetipo!=null && arquetipo.getItinerario()!=null){
	            	tipoPolitica = arquetipo.getItinerario().getPrePolitica();
	            }
            }
            
            if (tipoPolitica!=null) {
                prepolitica.setTipoPolitica(tipoPolitica);
            }
            
            politicaDao.save(prepolitica);

            // ********************************************************************** //
            // ** Creamos una politica en estado propuesta que será la política CE ** //
            // ********************************************************************** //
            DDEstadoItinerarioPolitica estadoItinerarioPoliticaCE = (DDEstadoItinerarioPolitica) executor.execute(
                    ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoItinerarioPolitica.class,
                    DDEstadoItinerarioPolitica.ESTADO_COMPLETAR_EXPEDIENTE);

            Politica politicaCE = new Politica();

            DDEstadoPolitica estadoPolPropuesta = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                    DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_PROPUESTA);

            politicaCE.setEstadoPolitica(estadoPolPropuesta);
            politicaCE.setEstadoItinerarioPolitica(estadoItinerarioPoliticaCE);
            politicaCE.setCicloMarcadoPolitica(cicloMarcado);

            //Le seteamos el mismo gestor y supervisor del expediente
            Estado estado = (Estado) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_GET, expediente.getArquetipo().getItinerario(),
                    expediente.getEstadoItinerario());
            if (estado != null) {
                Perfil perfilGestor = estado.getGestorPerfil();
                Perfil perfilSupervisor = estado.getSupervisor();

                politicaCE.setPerfilGestor(perfilGestor);
                politicaCE.setPerfilSupervisor(perfilSupervisor);

                DDZona zonaGestor = getZonaJerarquicaPerfilZona(expediente.getOficina().getZona(), perfilGestor);
                DDZona zonaSupervisor = getZonaJerarquicaPerfilZona(expediente.getOficina().getZona(), perfilSupervisor);

                politicaCE.setZonaGestor(zonaGestor);
                politicaCE.setZonaSupervisor(zonaSupervisor);
            }
            //Nueva forma de obtener el tipo de política para CE
            if (tipoPolitica!=null) {
                politicaCE.setTipoPolitica(tipoPolitica);
            }

            politicaDao.save(politicaCE);
        }

    }

    private DDZona getZonaJerarquicaPerfilZona(DDZona zonaExpediente, Perfil perfilOrigen) {

        DDZona zonaBusqueda = zonaExpediente;
        Long idPerfil = perfilOrigen.getId();

        while (zonaBusqueda != null) {
            Boolean existe = (Boolean) executor
                    .execute(ConfiguracionBusinessOperation.BO_ZONA_MGR_EXISTE_PERFIL_ZONA, zonaBusqueda.getId(), idPerfil);
            if (existe) return zonaBusqueda;

            if (!Checks.esNulo(zonaBusqueda.getZonaPadre()) && zonaBusqueda == zonaBusqueda.getZonaPadre()) {
            	zonaBusqueda = null;
            } else {
            	zonaBusqueda = zonaBusqueda.getZonaPadre();
            }
        }

        throw new GenericRollbackException("No se encuentra correspondencia para zona-perfil: " + zonaExpediente.getId() + "-" + perfilOrigen.getId());
    }

    /**
     * Comprueba si todas las políticas cumplen con el marcado de vigencia y realiza las operaciones oportunas.
     * Si son vigentes, las copia en estado vigente e historifica las viejas
     * Si no son vigentes, las copia en el estado que le corresponda e historifica las viejas
     * @param expedienteOrigen Parametro opcional, expediente del que se desea extraer las políticas para marcar
     * @param politicaOrigen Parametro opcional, política única que se desea marcar
     * @param isSuperusuario Indica si es o no superusuario
     * @return Devuelve true si todas las políticas asociadas se han marcado como vigentes
     */
    @Transactional(readOnly = false)
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_MARCAR_POLITICAS_VIGENTES)
    public Boolean marcaPoliticasVigentes(Expediente expedienteOrigen, Politica politicaOrigen, Boolean isSuperusuario) {
        if (isSuperusuario && politicaOrigen == null) { throw new BusinessOperationException("politica.marcarVigencia.errorSuperusuario"); }
        if (!isSuperusuario && expedienteOrigen == null) { throw new BusinessOperationException("politica.marcarVigencia.errorExpediente"); }

        // ********************************************************************************** //
        // ** Extraemos las políticas involucradas en el marcado de vigencia               ** //
        // ********************************************************************************** //
        List<Politica> listadoPoliticas = new ArrayList<Politica>();

        //Si nos han pasado un expediente con todas sus politicas, extraemos todas al vector
        if (politicaOrigen == null) {
            DDEstadoItinerario estadoItinerario = expedienteOrigen.getEstadoItinerario();

            //Recuperamos todas las personas del expediente y le extraemos su política propuesta
            for (ExpedientePersona pex : expedienteOrigen.getPersonas()) {
                Persona persona = pex.getPersona();
                Politica politicaPersona = politicaDao.getPoliticaPropuestaExpedientePersonaEstadoItinerario(persona, expedienteOrigen,
                        estadoItinerario);
                if (politicaPersona != null) {
                    listadoPoliticas.add(politicaPersona);
                }
            }
        } else {
            //Si nos han pasado solo una política, la metemos en el vector
            listadoPoliticas.add(politicaOrigen);
        }

        // ********************************************************************************** //
        // ** Extraemos las personas exentas del marcado de vigencia                       ** //
        // ********************************************************************************** //
        List<Persona> listadoPersonasExentas = null;
        if (expedienteOrigen != null && expedienteOrigen.getExclusionExpedienteCliente() != null)
            listadoPersonasExentas = expedienteOrigen.getExclusionExpedienteCliente().getPersonas();
        else
            listadoPersonasExentas = new ArrayList<Persona>();

        // ********************************************************************************** //
        // ** Comprobamos si todas las políticas cumplen las reglas de marcado de vigencia ** //
        // ********************************************************************************** //
        Boolean politicasVigentes = compruebaVigenciaPoliticas(listadoPoliticas, isSuperusuario, expedienteOrigen, listadoPersonasExentas);

        // ********************************************************************************** //
        // ** Marcamos como vigente o no, las políticas asociadas al marcado               ** //
        // ********************************************************************************** //
        for (Politica politica : listadoPoliticas) {
            String motivoVigencia = null;
            DDEstadoItinerarioPolitica estadoItinerarioNuevaPolitica = null;
            DDEstadoPolitica estadoNuevaPolitica = null;
            DDEstadoObjetivo estadoNuevoObjetivo = null;

            //Si se debe marcar como vigente, se copia la política del estadoItinerario actual en política vigente
            if (politicasVigentes) {

                //Si se trata de una política de una persona exenta, la cancelamos
                if (listadoPersonasExentas.contains(politica.getCicloMarcadoPolitica().getPersona())) {
                    cancelarPolitica(politica.getId());
                    continue;
                }

                //Si no tiene tipo de política, la cancelamos
                if (politica.getTipoPolitica() == null) {
                    cancelarPolitica(politica.getId());
                    continue;
                }

                //De lo contrario, lo que hacemos es marcarla vigente
                Politica politicaVigente = politicaDao.buscarPoliticaVigente(politica.getCicloMarcadoPolitica().getPersona().getId());
                historificaPoliticaVigente(politicaVigente);

                //Si es superusuario no se crea una copia sino que se modifica la actual en estado itinerario vigente
                if (isSuperusuario) {

                    politica.setMotivo((DDMotivo) dictionaryManager.getByCode(DDMotivo.class, DDMotivo.MOT_MANUAL));
                    DDEstadoPolitica estadoPolVigente = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                            DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_VIGENTE);

                    politica.setEstadoPolitica(estadoPolVigente);
                    politicaDao.update(politica);

                    for (Objetivo objetivo : politica.getObjetivos()) {

                        objetivo.setEstadoObjetivo((DDEstadoObjetivo) dictionaryManager.getByCode(DDEstadoObjetivo.class,
                                DDEstadoObjetivo.ESTADO_CONFIRMADO));
                        executor.execute(InternaBusinessOperation.BO_OBJ_MGR_SAVE, objetivo);
                    }
                    //Si no es superusuario, si que se genera la copia
                } else {
                    String sEstadoItinerario = expedienteOrigen.getEstadoItinerario().getCodigo();
                    estadoItinerarioNuevaPolitica = (DDEstadoItinerarioPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                            DDEstadoItinerarioPolitica.class, DDEstadoItinerarioPolitica.ESTADO_VIGENTE);
                    estadoNuevaPolitica = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                            DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_VIGENTE);
                    estadoNuevoObjetivo = (DDEstadoObjetivo) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                            DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_CONFIRMADO);

                    if (DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(sEstadoItinerario)) {
                        motivoVigencia = DDMotivo.MOT_COMITE;
                    } else {
                        motivoVigencia = DDMotivo.MOT_GESTOR;
                    }
                }

                //Si no debe marcar vigente la política, se copia la política al siguiente estado
            } else {
                String sEstadoItinerario = expedienteOrigen.getEstadoItinerario().getCodigo();

                if(!Checks.esNulo(expedienteOrigen.getTipoExpediente()) && DDTipoExpediente.TIPO_EXPEDIENTE_GESTION_DEUDA.equals(expedienteOrigen.getTipoExpediente().getCodigo())){
                	// *** Si está en CE ***
                	 if (DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(sEstadoItinerario)) {
                         estadoItinerarioNuevaPolitica = (DDEstadoItinerarioPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                                 DDEstadoItinerarioPolitica.class, DDEstadoItinerarioPolitica.ESTADO_REVISAR_EXPEDIENTE);
                         estadoNuevaPolitica = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                                 DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_PROPUESTA);
                         estadoNuevoObjetivo = (DDEstadoObjetivo) dictionaryManager.getByCode(DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_PROPUESTO);
                     }else if(DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(sEstadoItinerario)){
                         estadoItinerarioNuevaPolitica = (DDEstadoItinerarioPolitica) executor.execute(
                                 ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoItinerarioPolitica.class,
                                 DDEstadoItinerarioPolitica.ESTADO_EN_SANCION);
                         estadoNuevaPolitica = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                                 DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_PROPUESTA);
                         estadoNuevoObjetivo = (DDEstadoObjetivo) dictionaryManager.getByCode(DDEstadoObjetivo.class,
                                 DDEstadoObjetivo.ESTADO_PROPUESTO);
                     }else if(DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION.equals(sEstadoItinerario)){
                         estadoItinerarioNuevaPolitica = (DDEstadoItinerarioPolitica) executor.execute(
                                 ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoItinerarioPolitica.class,
                                 DDEstadoItinerarioPolitica.ESTADO_SANCIONADO);
                         estadoNuevaPolitica = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                                 DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_PROPUESTA);
                         estadoNuevoObjetivo = (DDEstadoObjetivo) dictionaryManager.getByCode(DDEstadoObjetivo.class,
                                 DDEstadoObjetivo.ESTADO_PROPUESTO);
                     }
                }else{
                    // *** Si está en CE ***
                    if (DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(sEstadoItinerario)) {
                        estadoItinerarioNuevaPolitica = (DDEstadoItinerarioPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                                DDEstadoItinerarioPolitica.class, DDEstadoItinerarioPolitica.ESTADO_REVISAR_EXPEDIENTE);
                        estadoNuevaPolitica = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                                DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_PROPUESTA);
                        estadoNuevoObjetivo = (DDEstadoObjetivo) dictionaryManager.getByCode(DDEstadoObjetivo.class, DDEstadoObjetivo.ESTADO_PROPUESTO);
                    } else {
                        // *** Si está en RE ***
                        if (DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(sEstadoItinerario)) {
                            estadoItinerarioNuevaPolitica = (DDEstadoItinerarioPolitica) executor.execute(
                                    ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDEstadoItinerarioPolitica.class,
                                    DDEstadoItinerarioPolitica.ESTADO_DECISION_COMITE);
                            estadoNuevaPolitica = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                                    DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_PROPUESTA);
                            estadoNuevoObjetivo = (DDEstadoObjetivo) dictionaryManager.getByCode(DDEstadoObjetivo.class,
                                    DDEstadoObjetivo.ESTADO_PROPUESTO);
                        }
                    }	
                }
                
            }

            //Se copian y actualizan las políticas
            if (estadoItinerarioNuevaPolitica != null && estadoNuevaPolitica != null && estadoNuevoObjetivo != null) {
                Long idNuevaPolitica = generaNuevaPoliticaCopiada(politica, estadoItinerarioNuevaPolitica, estadoNuevaPolitica, estadoNuevoObjetivo);

                if (motivoVigencia != null) {
                    Politica nuevaPolitica = politicaDao.get(idNuevaPolitica);
                    nuevaPolitica.setMotivo((DDMotivo) dictionaryManager.getByCode(DDMotivo.class, motivoVigencia));

                    //Si tiene estado itinerario que corresponde con un estado de itinerario de la aplicación, cambiamos su gestor/supervisor
                    //(En caso contrario se quedará con el que tuviera la anterior política)
                    if (estadoItinerarioNuevaPolitica.getEstadoItinerario() != null) {
                        //Le seteamos el mismo gestor y supervisor del expediente en el siguiente estado
                        Estado estado = (Estado) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_GET, expedienteOrigen.getArquetipo()
                                .getItinerario(), estadoItinerarioNuevaPolitica.getEstadoItinerario());
                        if (estado != null) {
                            Perfil perfilGestor = estado.getGestorPerfil();
                            Perfil perfilSupervisor = estado.getSupervisor();

                            DDZona zonaGestor = getZonaJerarquicaPerfilZona(expedienteOrigen.getOficina().getZona(), perfilGestor);
                            DDZona zonaSupervisor = getZonaJerarquicaPerfilZona(expedienteOrigen.getOficina().getZona(), perfilSupervisor);

                            nuevaPolitica.setPerfilGestor(perfilGestor);
                            nuevaPolitica.setZonaGestor(zonaGestor);

                            nuevaPolitica.setPerfilSupervisor(perfilSupervisor);
                            nuevaPolitica.setZonaSupervisor(zonaSupervisor);
                        }
                    }

                    politicaDao.update(nuevaPolitica);
                }

                DDEstadoPolitica estadoPolitica = (DDEstadoPolitica) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
                        DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_HISTORICA);
                politica.setEstadoPolitica(estadoPolitica);
                Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
                politica.setUsuarioCreacion(usuario);

                politicaDao.update(politica);
            }

            //Si se han marcado las políticas como vigente, se deben lanzar para cada uno de los Objetivos su BPM
            if (politicasVigentes) {
                Politica politicaVigente = politicaDao.buscarPoliticaVigente(politica.getCicloMarcadoPolitica().getPersona().getId());

                //Le seteamos el plazo de vigencia
                Long plazoVigencia = politicaVigente.getTipoPolitica().getPlazoVigencia();
                if (plazoVigencia == null) plazoVigencia = 0L;

                Date fechaVigencia = new Date(System.currentTimeMillis() + plazoVigencia);
                politicaVigente.setFechaVigencia(fechaVigencia);

                politicaDao.update(politicaVigente);

                //Recorremos todos los objetivos
                for (Objetivo objetivo : politicaVigente.getObjetivos()) {
                    //Solo para aquellos objetivos confirmados y pendientes, se lanzará el BPM
                    if (objetivo.getEstaConfirmado() && objetivo.getEstaPendiente()) {
                        Long idObjetivo = objetivo.getId();

                        Map<String, Object> param = new HashMap<String, Object>();
                        param.put(ObjetivoBPMConstants.ID_OBJETIVO, idObjetivo);

                        Long bpmid = (Long) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_CREATE_PROCESS,
                                ObjetivoBPMConstants.OBJETIVO_PROCESO, param);
                        objetivo.setProcessBpm(bpmid);

                        executor.execute(InternaBusinessOperation.BO_OBJ_MGR_UPDATE, objetivo);
                    }
                }

            }

        }

        return politicasVigentes;
    }

    /**
     * Comprueba si todas las políticas del listado (menos las exentas por las personas) cumplen las reglas de vigencia del expediente en el estado actual
     * @param listadoPoliticas
     * @param isSuperusuario
     * @param expedienteOrigen
     * @param listadoPersonasExentas
     * @return
     */
    @Transactional(readOnly = false)
    private Boolean compruebaVigenciaPoliticas(List<Politica> listadoPoliticas, Boolean isSuperusuario, Expediente expedienteOrigen,
            List<Persona> listadoPersonasExentas) {
        //Si existen políticas, por defecto son vigentes hasta que se compruebe lo contrario
        Boolean politicasVigentes = (listadoPoliticas.size() > 0);

        if (!isSuperusuario) {
            String sEstadoItinerario = expedienteOrigen.getEstadoItinerario().getCodigo();

            for (Politica politica : listadoPoliticas) {

                //Si es una política de las personas exentas saltamos esta iteración
                if (listadoPersonasExentas.contains(politica.getCicloMarcadoPolitica().getPersona())) continue;

                Boolean isValida = false;

                //Si el expediente está en Decisión de Comité, directamente las políticas del expediente son vigentes
                if (DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(sEstadoItinerario) || DDEstadoItinerario.ESTADO_ITINERARIO_SANCIONADO.equals(sEstadoItinerario)) {
                    isValida = true;
                }

                //Si no es una política que está en DC (está en CE o RE) se lanzan las reglas de vigencia del estado
                else {
                    Estado estado = (Estado) executor.execute(ConfiguracionBusinessOperation.BO_EST_MGR_GET, expedienteOrigen.getArquetipo()
                            .getItinerario(), expedienteOrigen.getEstadoItinerario());

                    List<ReglasVigenciaPolitica> listadoReglas = estado.getReglasVigenciaPolitica();

                    //Si tiene alguna regla de inclusión/exclusión las revisamos                    
                    if (listadoReglas != null && listadoReglas.size() > 0) {

                        Boolean isInclusion = true;
                        Long nReglas = 0L;

                        //Comprobamos en primer lugar si cumple con las reglas de inclusion
                        for (ReglasVigenciaPolitica rvp : listadoReglas) {
                            DDTipoReglaVigenciaPolitica ddTipoRegla = rvp.getTipoReglaVigenciaPolitica();

                            if (ddTipoRegla.isReglaInclusion() == true
                                    && ddTipoRegla.isEstadoItinerario(expedienteOrigen.getEstadoItinerario().getCodigo())) {
                                nReglas++;

                                //Si no cumple la regla de inclusión, salimos
                                if (compruebaReglaVigencia(politica.getCicloMarcadoPolitica().getId(), ddTipoRegla, sEstadoItinerario) == false) {
                                    isInclusion = false;
                                    break;
                                }
                            }
                        }

                        //Si no tiene ninguna regla de inclusión, no podemos darla por incluida
                        if (nReglas == 0L) isInclusion = false;

                        //Si cumple todas las reglas de inclusión, comprobamos ahora las reglas de exclusión 
                        if (isInclusion) {
                            for (ReglasVigenciaPolitica rvp : listadoReglas) {
                                DDTipoReglaVigenciaPolitica ddTipoRegla = rvp.getTipoReglaVigenciaPolitica();

                                if (ddTipoRegla.isReglaInclusion() == false
                                        && ddTipoRegla.isEstadoItinerario(expedienteOrigen.getEstadoItinerario().getCodigo())) {
                                    //Si no cumple la regla de exclusión (es porque se debe excluir)
                                    if (compruebaReglaVigencia(politica.getCicloMarcadoPolitica().getId(), ddTipoRegla, sEstadoItinerario) == false) {
                                        isInclusion = false;
                                        break;
                                    }
                                }
                            }
                        }

                        //Si ha cumplido todas las reglas de exclusión y ha salvado todas las reglas de exclusión, la política es vigente
                        if (isInclusion) isValida = true;
                    }
                }

                politicasVigentes = politicasVigentes && isValida;
                //Si hay una vez que no se cumple, es tonteria seguir buscando, salimos del bucle
                if (!politicasVigentes) {
                    break;
                }
            }
        }

        return politicasVigentes;
    }

    /**
     * Recorre el ciclo de marcado de políticas y busca la política que corresponda al estado del itinerario indicado
     * @param cicloMarcadoPolitica
     * @param estadoItinerario
     * @return Devuelve la política dentro del CMP que corresponda al estado del itinerario indicado
     */
    @Transactional(readOnly = false)
    private Politica getPoliticaInCicloMarcado(CicloMarcadoPolitica cicloMarcadoPolitica, String estadoItinerario) {
        if (cicloMarcadoPolitica == null && estadoItinerario != null) return null;

        for (Politica politica : cicloMarcadoPolitica.getPoliticas()) {
            if (politica.getAuditoria().isBorrado() == false && politica.getEstadoItinerarioPolitica() != null) {
                if (politica.getEstadoItinerarioPolitica().getCodigo().equals(estadoItinerario)) {
                    //Hibernate.initialize(politica.getTipoPolitica());
                    return politica;
                }
            }
        }

        return null;
    }

    /**
     * Comprueba si la política se debe marcar o no como vigente según las reglas de vigencia
     * @param cicloMarcadoPolitica
     * @param ddTipoRegla
     * @param sEstadoItinerario
     * @return
     */
    @Transactional(readOnly = false)
    private Boolean compruebaReglaVigencia(Long idCicloMarcado, DDTipoReglaVigenciaPolitica ddTipoRegla, String sEstadoItinerario) {

        CicloMarcadoPolitica cicloMarcadoPolitica = cicloMarcadoPoliticaDao.get(idCicloMarcado);

        //Si no tenemos reglas no podemos comprobar la vigencia
        if (cicloMarcadoPolitica == null || ddTipoRegla == null || sEstadoItinerario == null) return false;

        Politica politicaPre = getPoliticaInCicloMarcado(cicloMarcadoPolitica, DDEstadoItinerarioPolitica.ESTADO_PREPOLITICA);
        Politica politicaCE = getPoliticaInCicloMarcado(cicloMarcadoPolitica, DDEstadoItinerarioPolitica.ESTADO_COMPLETAR_EXPEDIENTE);
        Politica politicaRE = getPoliticaInCicloMarcado(cicloMarcadoPolitica, DDEstadoItinerarioPolitica.ESTADO_REVISAR_EXPEDIENTE);

        if (politicaPre != null) Hibernate.initialize(politicaPre.getTipoPolitica());
        if (politicaCE != null) Hibernate.initialize(politicaCE.getTipoPolitica());
        if (politicaRE != null) Hibernate.initialize(politicaRE.getTipoPolitica());

        String codigoTipoRegla = ddTipoRegla.getCodigo();

        //Si el expediente está en CE
        if (DDEstadoItinerario.ESTADO_COMPLETAR_EXPEDIENTE.equals(sEstadoItinerario)) {
            //Si no existen las politicas, no lo podemos dar por vigente
            if (politicaPre == null || politicaCE == null) return false;
            if (politicaPre.getTipoPolitica() == null || politicaCE.getTipoPolitica() == null) return false;

            // ************************************** //
            // * Incluye si PRE = CE                * //
            // ************************************** //            
            if (DDTipoReglaVigenciaPolitica.INCLUSION_CONSENSO_PRE_CE.equals(codigoTipoRegla)) {
                //Si hay consenso entre la prepolitica y la CE, devolvemos true
                if (politicaPre.getTipoPolitica().getCodigo().equals(politicaCE.getTipoPolitica().getCodigo()))
                    return true;
                else
                    return false;
            }

            // ************************************** //
            // * Excluye si CE > PRE                * //
            // ************************************** //            
            else if (DDTipoReglaVigenciaPolitica.EXCLUSION_CE_MAYOR_PRE.equals(codigoTipoRegla)) {
                if (politicaCE.getTipoPolitica().getPeso().longValue() > politicaPre.getTipoPolitica().getPeso().longValue())
                    return false;
                else
                    return true;
            }

            // ************************************** //
            // * Excluye si CE < PRE                * //
            // ************************************** //            
            else if (DDTipoReglaVigenciaPolitica.EXCLUSION_CE_MENOR_PRE.equals(codigoTipoRegla)) {
                if (politicaCE.getTipoPolitica().getPeso().longValue() < politicaPre.getTipoPolitica().getPeso().longValue())
                    return false;
                else
                    return true;
            }

        }

        //Si el expediente está en RE
        else if (DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE.equals(sEstadoItinerario)) {
            //Si no existen las politicas, no lo podemos dar por vigente
            if (politicaCE == null || politicaRE == null) return false;
            if (politicaCE.getTipoPolitica() == null || politicaRE.getTipoPolitica() == null) return false;

            //Si se necesita chequear contra PRE y no existe, no la podemos dar por vigente
            if (DDTipoReglaVigenciaPolitica.INCLUSION_CONSENSO_PRE_CE_RE.equals(codigoTipoRegla)
                    || DDTipoReglaVigenciaPolitica.EXCLUSION_RE_MAYOR_PRE.equals(codigoTipoRegla)
                    || DDTipoReglaVigenciaPolitica.EXCLUSION_RE_MENOR_PRE.equals(codigoTipoRegla)) {
                if (politicaPre == null || politicaPre.getTipoPolitica() == null) return false;
            }

            // ************************************** //
            // * Incluye si CE = RE                 * //
            // ************************************** //            
            if (DDTipoReglaVigenciaPolitica.INCLUSION_CONSENSO_CE_RE.equals(codigoTipoRegla)) {
                //Si hay consenso entre CE y RE, devolvemos true
                if (politicaCE.getTipoPolitica().getCodigo().equals(politicaRE.getTipoPolitica().getCodigo()))
                    return true;
                else
                    return false;
            }

            // ************************************** //
            // * Incluye si PRE = CE = RE           * //
            // ************************************** //            
            else if (DDTipoReglaVigenciaPolitica.INCLUSION_CONSENSO_PRE_CE_RE.equals(codigoTipoRegla)) {
                //Si hay consenso entre la prepolitica, CE y RE, devolvemos true
                if (politicaPre.getTipoPolitica().getCodigo().equals(politicaCE.getTipoPolitica().getCodigo())
                        && politicaCE.getTipoPolitica().getCodigo().equals(politicaRE.getTipoPolitica().getCodigo()))
                    return true;
                else
                    return false;
            }

            // ************************************** //
            // * Excluye si RE > CE                 * //
            // ************************************** //            
            else if (DDTipoReglaVigenciaPolitica.EXCLUSION_RE_MAYOR_CE.equals(codigoTipoRegla)) {
                if (politicaRE.getTipoPolitica().getPeso().longValue() > politicaCE.getTipoPolitica().getPeso().longValue())
                    return false;
                else
                    return true;
            }

            // ************************************** //
            // * Excluye si RE < CE                 * //
            // ************************************** //            
            else if (DDTipoReglaVigenciaPolitica.EXCLUSION_RE_MENOR_CE.equals(codigoTipoRegla)) {
                if (politicaRE.getTipoPolitica().getPeso().longValue() < politicaCE.getTipoPolitica().getPeso().longValue())
                    return false;
                else
                    return true;
            }

            // ************************************** //
            // * Excluye si RE > PRE                * //
            // ************************************** //            
            else if (DDTipoReglaVigenciaPolitica.EXCLUSION_RE_MAYOR_PRE.equals(codigoTipoRegla)) {
                if (politicaRE.getTipoPolitica().getPeso().longValue() > politicaPre.getTipoPolitica().getPeso().longValue())
                    return false;
                else
                    return true;
            }

            // ************************************** //
            // * Excluye si RE < PRE                * //
            // ************************************** //            
            else if (DDTipoReglaVigenciaPolitica.EXCLUSION_RE_MENOR_PRE.equals(codigoTipoRegla)) {
                if (politicaRE.getTipoPolitica().getPeso().longValue() < politicaPre.getTipoPolitica().getPeso().longValue())
                    return false;
                else
                    return true;
            }

        }

        //Si no cumple ninguna regla, la vigencia es falsa (por si acaso)
        return false;
    }

    /**
     * Crea una copia exacta de la política y la guarda en BD.
     * @param politica Politica que deseamos copiar
     * @return Long El id de la nueva politica
     */
    private Long generaNuevaPoliticaCopiada(Politica politica, DDEstadoItinerarioPolitica estadoItinerarioNuevaPolitica,
            DDEstadoPolitica estadoNuevaPolitica, DDEstadoObjetivo estadoNuevoObjetivo) {

        //Creamos una copia de la política pero sin objetivos
        Politica nuevaPolitica = politica.clone();
        nuevaPolitica.setEstadoItinerarioPolitica(estadoItinerarioNuevaPolitica);
        nuevaPolitica.setEstadoPolitica(estadoNuevaPolitica);
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        nuevaPolitica.setUsuarioCreacion(usuario);
        politicaDao.save(nuevaPolitica);

        if (politica.getObjetivos() != null) {
            List<Objetivo> listadoObjetivos = new ArrayList<Objetivo>();

            for (Objetivo objetivo : politica.getObjetivos()) {
                Objetivo nuevoObjetivo = objetivo.clone();
                //Si el objetivo está propuesto se le cambia al nuevo estado de objetivo.
                //Si el objetivo está rechazado o borrado, se mantiene su estado anterior.
                if (nuevoObjetivo.getEstaPropuesto()) {
                    nuevoObjetivo.setEstadoObjetivo(estadoNuevoObjetivo);
                }
                nuevoObjetivo.setPolitica(nuevaPolitica);
                nuevoObjetivo.setDefinidoEstadoAnterior(true);

                executor.execute(InternaBusinessOperation.BO_OBJ_MGR_SAVE, nuevoObjetivo);

                listadoObjetivos.add(nuevoObjetivo);
            }

            nuevaPolitica.setObjetivos(listadoObjetivos);
            politicaDao.update(nuevaPolitica);
        }

        return nuevaPolitica.getId();
    }

    /**
     * Devuelve la política propuesta para una persona en un estado de itinerario en concreto.
     * @param persona Persona que se debe buscar
     * @param expediente Expediente que se debe buscar
     * @param estadoItinerario Estado del itinerario donde se encuentra la política
     * @return La política de la persona
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GET_POLITICA_PROPUESTA_EXPEDIENTE_PERSONA_ESTADO_ITINERARIO)
    public Politica getPoliticaPropuestaExpedientePersonaEstadoItinerario(Persona persona, Expediente expediente, DDEstadoItinerario estadoItinerario) {
        return politicaDao.getPoliticaPropuestaExpedientePersonaEstadoItinerario(persona, expediente, estadoItinerario);
    }

    /**
     * Devuelve la última política del último ciclo de marcado de la persona.
     * @param idPersona Long
     * @return la política vigente o null si no hay.
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_BUSCAR_ULTIMA_POLITICA)
    public Politica buscarUltimaPolitica(Long idPersona) {
        return politicaDao.buscarUltimaPolitica(idPersona);
    }

    /**
     * Devuelve la política vigente para la persona pasadaPorParámetro.
     * @param idPersona el id de la persona para la que se busca la plítica.
     * @return la política vigente o null si no hay.
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICA_VIGENTE)
    public Politica buscarPoliticaVigente(Long idPersona) {
        return politicaDao.buscarPoliticaVigente(idPersona);
    }

    /**
     * @param id long
     * @return Politica
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GET)
    public Politica get(Long id) {
        return politicaDao.get(id);
    }
    
    
    /**
     * @param id long
     * @return Politica
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GET_POL_BY_CMP)
    public List<Politica> getByCmp(Long id) {
        //return politicaDao.get(id) ;
    	return politicaDao.buscarPoliticasPorCmp(id);
    }

    /**
     * Cancela una política y mata sus BPMs
     * @param idPolitica Long
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_CANCELAR_POLITICA)
    @Transactional(readOnly = false)
    public Boolean cancelarPolitica(Long idPolitica) {
        Politica politicaOriginal = politicaDao.get(idPolitica);
        if (politicaOriginal == null) return false;

        CicloMarcadoPolitica cmp = politicaOriginal.getCicloMarcadoPolitica();

        for (Politica politica : cmp.getPoliticas()) {

            politica.setEstadoPolitica((DDEstadoPolitica) dictionaryManager.getByCode(DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_CANCELADO));
            politicaDao.update(politica);

            for (Objetivo objetivo : politica.getObjetivos()) {
                if (objetivo.getProcessBpm() != null) {
                    executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, objetivo.getProcessBpm());
                }
            }
        }
        return true;
    }

    /**
     * Cierra una decisión de política de un superusuario.
     * @param idPolitica long
     * @return Boolean devuelve si se cerró correctamente
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_CERRAR_DECISION_POLITICA_SUPERUSUARIO)
    @Transactional(readOnly = false)
    public Boolean cerrarDecisionPoliticaSuperusuario(Long idPolitica) {
        Politica politica = politicaDao.get(idPolitica);

        Boolean politicasVigentes = (Boolean) marcaPoliticasVigentes(null, politica, true);

        //Si no se ha marcado como vigente, se lanza una excepción porque debería
        if (!politicasVigentes) {
            logger.error("La politica " + idPolitica + " no se ha podido marcar como vigente una vez cerrada decisión de superusuario");
            throw new BusinessOperationException("expediente.cerrarDecisionPolitica.errorMarcado");
        }

        return true;
    }

    /**
     * @param idExpediente
     * @return
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GET_NUM_POLITICAS_GENERADAS)
    public Long getNumPoliticasGeneradas(Long idExpediente) {
        return politicaDao.getNumPoliticasGeneradas(idExpediente);
    }

    /**
     * Busca un ciclo de marcado de política para un expediente y una persona en concreto
     * @param idPersona long
     * @param idExpediente long
     * @return Boolean devuelve si se cerró correctamente
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA_EXP)
    public CicloMarcadoPolitica buscarPoliticasParaPersonaExpediente(Long idPersona, Long idExpediente) {
        return politicaDao.buscarPoliticasParaPersonaExpediente(idPersona, idExpediente);
    }

    /**
     * Recupera la última política generada y la borra, cambiandole el estado a propuesta a la penultima política, de entre todas las políticas marcadas en el expediente
     * @param idExpediente
     */
    @Transactional(readOnly = false)
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_DESHACER_ULTIMAS_POLITICAS)
    public void deshacerUltimasPoliticas(Long idExpediente) {
        List<CicloMarcadoPolitica> listadoCiclos = cicloMarcadoPoliticaDao.getCiclosMarcadoExpediente(idExpediente);

        for (CicloMarcadoPolitica cmp : listadoCiclos) {
            List<Politica> listadoPoliticas = cmp.getPoliticas();
            
            Collections.sort(listadoPoliticas, new Politica().getEstadoItinerarioComparator());
            
            if (listadoPoliticas.size()>1) {
	            Politica politicaBorrar = listadoPoliticas.get(listadoPoliticas.size() - 1);
	            Politica politicaProponer = listadoPoliticas.get(listadoPoliticas.size() - 2);
	
	            DDEstadoPolitica estadoPropuesta = (DDEstadoPolitica) dictionaryManager.getByCode(DDEstadoPolitica.class,
	                    DDEstadoPolitica.ESTADO_PROPUESTA);
	            politicaProponer.setEstadoPolitica(estadoPropuesta);
	
	            politicaDao.delete(politicaBorrar);
	            politicaDao.update(politicaProponer);
            }
        }
    }

    /**
     * Historifica una política vigente. Cancela todas las tareasNotificacion de los objetivos y mata sus BPMs
     * @param politica
     */
    @Transactional(readOnly = true)
    private void historificaPoliticaVigente(Politica politica) {
        //Si la política no existe o no es vigente salimos
        if (politica == null || !politica.getEsVigente()) return;

        for (Objetivo obj : politica.getObjetivos()) {

            //Borramos las tareas de los objetivos
            for (TareaNotificacion tar : obj.getTareas()) {
                executor.execute(ComunBusinessOperation.BO_TAREA_MGR_BORRAR_NOTIFICACION_TAREA_BY_ID, tar.getId());
            }

            //Borramos los BPMs si existen
            if (obj.getProcessBpm() != null) executor.execute(ComunBusinessOperation.BO_JBPM_MGR_DESTROY_PROCESS, obj.getProcessBpm());

        }

        //Marcamos la política como histórica
        politica.setEstadoPolitica((DDEstadoPolitica) dictionaryManager.getByCode(DDEstadoPolitica.class, DDEstadoPolitica.ESTADO_HISTORICA));
        politicaDao.save(politica);
    }
    
    /**
     * Devuelve los tipos de política no marcados como borrado
     * @return List<DDTipoPolitica> Lista de tipos de política
     */
    @BusinessOperation(InternaBusinessOperation.BO_POL_MGR_GET_TIPOS_POLITICA)
    public List<DDTipoPolitica> getTiposPolitica() {
        return genericDao.getList(DDTipoPolitica.class, genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
    }

}
