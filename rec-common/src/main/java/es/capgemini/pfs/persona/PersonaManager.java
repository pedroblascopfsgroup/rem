package es.capgemini.pfs.persona;

import java.io.File;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.hibernate.annotations.Check;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.CSVWriteCursorReadCallBack;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.FileManager;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.antecedente.model.Antecedente;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.cliente.dto.DtoBuscarClientes;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.ingreso.model.Ingreso;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.DDTipoItinerario;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.dao.AdjuntoPersonaDao;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.dto.DtoSolvenciaPersona;
import es.capgemini.pfs.persona.dto.DtoUmbral;
import es.capgemini.pfs.persona.model.AdjuntoPersona;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;

/**
 * Manager para las operaciones relacionadas con Persona.
 * @author marruiz
 */
@Service
public class PersonaManager {

    @Autowired
    private Executor executor;

    @Autowired
    private PersonaDao personaDao;

    @Autowired
    private FileManager fileManager;

    @Autowired
    private AdjuntoPersonaDao adjuntoPersonaDao;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * obtiene una persona.
     * @param id id
     * @return persona
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET)
    public Persona get(Long id) {
        return personaDao.get(id);
    }

    /**
     * getByCodigo.
     * @param codigo codigo
     * @return persona
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_BY_CODIGO)
    public Persona getByCodigo(String codigo) {
        return personaDao.getByCodigo(codigo);
    }

    /**
     * getIdByCodigo.
     * @param codigo codigo
     * @return id
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_ID_BY_CODIGO)
    public Long getIdByCodigo(String codigo) {
        return personaDao.getByCodigo(codigo).getId();
    }

    /**
     * obtiene la persdona con sus contratos inicialzados.
     * @param id id
     * @return persona
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_WITH_CONTRATOS)
    @Transactional
    public Persona getWithContratos(Long id) {
        Persona p = personaDao.get(id);
        Hibernate.initialize(p.getContratos());
        return p;
    }

    /**
     * obtiene los bienes de la persona.
     * @param idPersona persona
     * @return bienes
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_BIENES)
    public List<Bien> getBienes(Long idPersona) {
        return personaDao.getBienes(idPersona);
    }

    /**
     * obtiene los contratos de la persona donde es titular.
     * @param idPersona idPersona
     * @return contratos
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CONTRATOS_GENERACION_EXP_MANUAL)
    public List<Contrato> obtenerContratosGeneracionExpManual(Long idPersona) {
        return (List<Contrato>) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_OBTENER_CONTRATOS_PERSONA_GENERACION_EXPEDIENTE_MANUAL,
                idPersona);
    }

    /**
     * obtiene el número de contratos de la persona donde es titular.
     * @param idPersona idPersona
     * @return contratos
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_NUM_CONTRATOS_GENERACION_EXP_MANUAL)
    public int obtenerNumContratosGeneracionExpManual(Long idPersona) {
        List<Contrato> list = (List<Contrato>) executor.execute(
                PrimariaBusinessOperation.BO_CNT_MGR_OBTENER_CONTRATOS_PERSONA_GENERACION_EXPEDIENTE_MANUAL, idPersona);
        if (list != null) { return list.size(); }

        return 0;
    }

    /**
     * Lista de ingresos de la persona.
     * @param idPersona Long
     * @return lista
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_INGRESOS)
    public List<Ingreso> getIngresos(Long idPersona) {
        return personaDao.getIngresos(idPersona);
    }

    /**
     * Lista de personas.
     * @return list
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_LIST)
    public List<Persona> getList() {
        return personaDao.getList();
    }

    /**
     * Metodo que lista todos los obj incluidos los eliminados mediante auditoria.
     *
     * @return lista FULL de todos los obj
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_LIST_FULL)
    public List<Persona> getListFull() {
        return personaDao.getListFull();
    }

    /**
     * @param persona Persona.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(Persona persona) {
        personaDao.saveOrUpdate(persona);
    }

    /**
     * Actualiza la observaciÃ³n de solvencia de la persona.
     * @param solvenciaPersona DtoSolvenciaPersona
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_UPDATE_SOLVENCIA)
    @Transactional(readOnly = false)
    public void updateSolvencia(DtoSolvenciaPersona solvenciaPersona) {
        personaDao.saveOrUpdate(solvenciaPersona.getPersona());
    }

    /**
     * Actualiza el umbral de la persona.
     * @param dtoUmbral DtoUmbral
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_UPDATE_UMBRAL)
    @Transactional(readOnly = false)
    public void updateUmbral(DtoUmbral dtoUmbral) {
        personaDao.saveOrUpdate(dtoUmbral.getPersona());
    }

    /**
     * delete a persona.
     * @param object persona
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_DELETE)
    public void delete(Persona object) {
        personaDao.delete(object);
    }

    /**
     * Obtiene las personas.
     * @param dto dto clientes
     * @return Lista de personas
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_FIND_CLIENTES)
    public List<Persona> findClientes(DtoBuscarClientes dto) {
        dto.setCodigoZonas(getCodigosDeZona(dto));
        if (dto.getIsBusquedaGV() != null && dto.getIsBusquedaGV().booleanValue()) {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            dto.setPerfiles(usuario.getPerfiles());
        }
        return personaDao.findClientes(dto);
    }

    /**
     * Obtiene las personas paginadas.
     * @param clientes dto clientes
     * @return Pagina de personas
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_FIND_CLIENTES_PAGINATED)
    public Page findClientesPaginated(DtoBuscarClientes clientes) {
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        if (clientes.getIsBusquedaGV() != null && clientes.getIsBusquedaGV().booleanValue()) {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            clientes.setPerfiles(usuario.getPerfiles());
        }
        //convertirTipoSituacion(clientes);
        return personaDao.findClientesPaginated(clientes);
    }

    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO)
    public Long obtenerCantidadDeVencidosUsuario() {
        DtoBuscarClientes clientes = new DtoBuscarClientes();
        //DDEstadoItinerario estado = ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).get(0);
        clientes.setSituacion(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        clientes.setIsPrimerTitContratoPase(Boolean.TRUE);
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        clientes.setPerfiles(usuario.getPerfiles());
        clientes.setIsBusquedaGV(Boolean.TRUE);
        clientes.setCodigoGestion(DDTipoItinerario.ITINERARIO_RECUPERACION);
        return personaDao.obtenerCantidadDeVencidosUsuario(clientes);
    }

    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO)
    public Long obtenerCantidadDeSeguimientoSistematicoUsuario() {
        DtoBuscarClientes clientes = new DtoBuscarClientes();
        //DDEstadoItinerario estado = ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).get(0);
        clientes.setSituacion(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        clientes.setIsPrimerTitContratoPase(Boolean.TRUE);
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        clientes.setPerfiles(usuario.getPerfiles());
        clientes.setIsBusquedaGV(Boolean.TRUE);

        clientes.setCodigoGestion(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SISTEMATICO);
        Long contador = personaDao.obtenerCantidadDeVencidosUsuario(clientes);

        return contador;
    }

    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO)
    public Long obtenerCantidadDeSeguimientoSintomaticoUsuario() {
        DtoBuscarClientes clientes = new DtoBuscarClientes();
        //DDEstadoItinerario estado = ddEstadoItinerarioDao.findByCodigo(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).get(0);
        clientes.setSituacion(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS);
        clientes.setIsPrimerTitContratoPase(Boolean.TRUE);
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        clientes.setPerfiles(usuario.getPerfiles());
        clientes.setIsBusquedaGV(Boolean.TRUE);

        clientes.setCodigoGestion(DDTipoItinerario.ITINERARIO_SEGUIMIENTO_SINTOMATICO);
        Long contador = personaDao.obtenerCantidadDeVencidosUsuario(clientes);

        return contador;
    }

    /**
     * Exporta clientes.
     *
     * @param clientes dto clientes
     * @return file
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_EXPORT_CLIENTES)
    public FileItem exportClientes(DtoBuscarClientes clientes) {
        clientes.setCodigoZonas(getCodigosDeZona(clientes));
        //convertirTipoSituacion(clientes);
        if (clientes.getIsBusquedaGV() != null && clientes.getIsBusquedaGV().booleanValue()) {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            clientes.setPerfiles(usuario.getPerfiles());
        }
        CSVWriteCursorReadCallBack leeDatos = new CSVWriteCursorReadCallBack("persons.csv", fileManager);
        personaDao.exportClientes(clientes, leeDatos);

        return leeDatos.getFileItem();
    }

    private Set<String> getCodigosDeZona(DtoBuscarClientes clientes) {
        Set<String> zonas;
        if (clientes.getCodigoZona() != null && clientes.getCodigoZona().trim().length() > 0) {
            List<String> list = Arrays.asList((clientes.getCodigoZona().split(",")));
            zonas = new HashSet<String>(list);
        } else {
            Usuario usuario = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            zonas = usuario.getCodigoZonas();
        }
        return zonas;
    }

    @SuppressWarnings("unchecked")
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_TIPOS_PERSONAS)
    public List<DDTipoPersona> getTiposPersonas() {
        return (List<DDTipoPersona>) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_LIST, DDTipoPersona.class.getName());
    }

    /**
     * @param fileManager the fileManager to set
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_SET_FILE_MANAGER)
    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    /**
     * Obtiene si tiene un expediente propuesto.
     * @param idPersona id de la persona
     * @return id del expediente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_ID_EXPEDIENTE_PROPUESTO_PERSONA)
    public Long obtenerIdExpedientePropuestoPersona(Long idPersona) {
        return personaDao.obtenerIdExpedientePropuestoPersona(idPersona);
    }

    /**
     * Obtiene si tiene un expediente propuesto.
     * @param idPersona id de la persona
     * @return Expediente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_EXPEDIENTE_PROPUESTO_PERSONA)
    public Expediente obtenerExpedientePropuestoPersona(Long idPersona) {
        return personaDao.obtenerExpedientePropuestoPersona(idPersona);
    }

    /**
     * Obtiene si lo hubiere el expediente (no borrado) de la persona en la
     * que uno de sus contratos en los que es titular es el de pase.
     * @param idPersona Long
     * @return Expediente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_EXPEDIENTE_CON_CNT_PASE_TITULAR)
    public Expediente getExpedienteConContratoPaseTitular(Long idPersona) {
        return personaDao.getExpedienteConContratoPaseTitular(idPersona);
    }

    /**
     * Crea un antecedente vacio para la persona si no tiene.
     * @param idPersona Long
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_CREAR_ANTECEDENTE_BASE)
    @Transactional(readOnly = false)
    public void crearAntecedenteBase(Long idPersona) {
        Persona persona = personaDao.get(idPersona);
        if (persona.getAntecedente() != null) { return; }
        Antecedente antecedente = new Antecedente();
        executor.execute(PrimariaBusinessOperation.BO_ANTECEDENTE_MGR_SAVE_OR_UPDATE, antecedente);

        persona.setAntecedente(antecedente);
        personaDao.saveOrUpdate(persona);
    }

    /**
     * Upload de archivos asociados a una persona.
     * @param uploadForm WebFileItem
     * @return String
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_UPLOAD)
    @Transactional(readOnly = false)
    public String upload(WebFileItem uploadForm) {
        FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero esté vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }

        Integer max = getLimiteFichero();

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Persona persona = personaDao.get(Long.parseLong(uploadForm.getParameter("id")));
        
		FileItem fiAdjunto = new FileItem();
		fiAdjunto.setFile(fileItem.getFile());
		fiAdjunto.setLength(fileItem.getLength());
		fiAdjunto.setFileName(fileItem.getFileName());
		fiAdjunto.setContentType(obtenerMimeTypeFichero(fiAdjunto.getFileName()));								

		persona.addAdjunto(fiAdjunto);
        personaDao.save(persona);
				
        return null;
    }

    
    private String obtenerMimeTypeFichero(String nombreFichero) {
		Map<String, String> mapaExtensiones = new HashMap<String, String>();
		mapaExtensiones.put(".pdf", "application/pdf");
		mapaExtensiones.put(".txt", "text/plain");
		mapaExtensiones.put(".doc", "application/msword");
		mapaExtensiones.put(".docx", "application/msword");
		mapaExtensiones.put(".xls", "application/excel");
		mapaExtensiones.put(".xlsx", "application/excel");
		mapaExtensiones.put(".xml", "application/xml");
		mapaExtensiones.put(".html", "text/html");
		mapaExtensiones.put(".jpg", "image/jpeg");
		mapaExtensiones.put(".gif", "image/gif");
		mapaExtensiones.put(".png", "image/png");
		
		String defaultExtension = "application/octet-stream";
		
		for (String clave : mapaExtensiones.keySet()) {
			if (nombreFichero.endsWith(clave)) {
				return mapaExtensiones.get(clave); 
			}
		}
		
		return defaultExtension;
	}
    
    /**
     * Recupera el límite de tamaño de un fichero.
     * @return limite
     */
    private Integer getLimiteFichero() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_FICHERO_PERSONA);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            logger.warn("No esta parametrizado el límite máximo del fichero en bytes para personas, se toma un valor por defecto (2Mb)");
            return new Integer(2 * 1025 * 1024);
        }
    }

    /**
     * bajar un adjunto.
     * @param adjuntoId Long
     * @return FileItem
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_DOWNLOAD_ADJUNTO)
    public FileItem downloadAdjunto(Long adjuntoId) {
        return adjuntoPersonaDao.get(adjuntoId).getAdjunto().getFileItem();
    }

    /**
     * Borra el adjunto.
     * @param personaId Long
     * @param adjuntoId Long
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_DELETE_ADJUNTO)
    @Transactional(readOnly = false)
    public void deleteAdjunto(Long personaId, Long adjuntoId) {
        Persona persona = personaDao.get(personaId);
        AdjuntoPersona adj = persona.getAdjunto(adjuntoId);
        if (adj == null) { return; }
        persona.getAdjuntos().remove(adj);
        personaDao.save(persona);
    }

    /**
     * Retorna el cliente activo de la persona.
     * @param idPersona Long
     * @return Cliente
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_GET_CLI_ACTIVO)
    public Cliente getClienteActivo(Long idPersona) {
        return personaDao.getClienteActivo(idPersona);
    }

    /**
     * Recupera la lista de contratos disponibles de la persona indicada para un futuro cliente.
     * El ultimo contrato es el contrato de pase.
     * @param personaId Long
     * @return lista de contratos.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CONTRATOS_PARA_FUTUROS_CLIENTES)
    public List<Contrato> obtenerContratosParaFuturoCliente(Long personaId) {
        return personaDao.obtenerContratosParaFuturoCliente(personaId);
    }

    /**
     * Recupera el numero de contratos disponibles de la persona indicada para un futuro cliente.
     * El ultimo contrato es el contrato de pase.
     * @param personaId Long
     * @return numero de contratos.
     */
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_NUMERO_CONTRATOS_PARA_FUTUROS_CLIENTES)
    public Long obtenerNumeroContratosParaFuturoCliente(Long personaId) {
        return personaDao.getContratosParaFuturoCliente(personaId);
    }
    
    @BusinessOperation(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_ZONA_PERSONA)
    public DDZona getZonaPersona(Long idPersona) {
    	Persona persona = personaDao.get(idPersona);
    	Oficina oficina = persona.getOficinaGestora();
    	if (!Checks.esNulo(oficina)) {
    		//Comprobamos si la oficina tiene zona
    		/*if(!Checks.esNulo(oficina.getZona())){
    			oficina.getZona().setDescripcion(oficina.getCodDescripOficina(true, false));
    		}*/
    		return oficina.getZona();
    	} else {
    		return null;
    	}
    }
    
}
