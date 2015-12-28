package es.capgemini.pfs.politica;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.dao.AnalisisParcelaPersonaDao;
import es.capgemini.pfs.politica.dao.AnalisisPersonaOperacionDao;
import es.capgemini.pfs.politica.dao.AnalisisPersonaPoliticaDao;
import es.capgemini.pfs.politica.dao.DDImpactoDao;
import es.capgemini.pfs.politica.dao.DDParcelasPersonasDao;
import es.capgemini.pfs.politica.dao.DDTipoGestionDao;
import es.capgemini.pfs.politica.dao.DDValoracionDao;
import es.capgemini.pfs.politica.dto.DtoAnalisisOperacion;
import es.capgemini.pfs.politica.dto.DtoAnalisisParcelaPersona;
import es.capgemini.pfs.politica.dto.DtoAnalisisPolitica;
import es.capgemini.pfs.politica.dto.DtoGestiones;
import es.capgemini.pfs.politica.dto.DtoGestionesRealizadas;
import es.capgemini.pfs.politica.dto.DtoListaAnalisisOperacion;
import es.capgemini.pfs.politica.dto.DtoListaAnalisisPersona;
import es.capgemini.pfs.politica.model.AnalisisParcelaPersona;
import es.capgemini.pfs.politica.model.AnalisisPersonaOperacion;
import es.capgemini.pfs.politica.model.AnalisisPersonaPolitica;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.politica.model.DDImpacto;
import es.capgemini.pfs.politica.model.DDParcelasPersonas;
import es.capgemini.pfs.politica.model.DDTipoAnalisis;
import es.capgemini.pfs.politica.model.DDTipoGestion;
import es.capgemini.pfs.politica.model.DDValoracion;
import es.capgemini.pfs.politica.model.Politica;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;

/**
 * Métodos de negocio del análisis de políticas.
 * 
 * @author pamuller
 * 
 */
@Service
public class AnalisisPoliticaManager {

    @Autowired
    private Executor executor;

    @Autowired
    private AnalisisParcelaPersonaDao analisisParcelaPersonaDao;

    @Autowired
    private DDImpactoDao impactoDao;

    @Autowired
    DDParcelasPersonasDao parcelasPersonasDao;

    @Autowired
    private DDValoracionDao valoracionDao;

    @Autowired
    private AnalisisPersonaOperacionDao analisisPersonaOperacionDao;
    @Autowired
    private AnalisisPersonaPoliticaDao analisisPersonaPoliticaDao;

    @Autowired
    private DDTipoGestionDao tipoGestionDao;

    /**
     * Indica si el analisis de politica para una persona en un expediente, está
     * o no completo
     * 
     * @param idPersona
     * @param idExpediente
     * @return
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_IS_ANALISIS_POLITICA_COMPLETO)
    public Boolean isAnalisisPoliticaCompleto(Long idPersona, Long idExpediente) {
        List<DDParcelasPersonas> listadoParcelasSinCompletar = analisisPersonaPoliticaDao.getParcelasSinCompletar(idPersona, idExpediente);
        List<Contrato> listadoOperacionesSinCompletar = analisisPersonaOperacionDao.getOperacionesSinCompletar(idPersona, idExpediente);

        // Si las parcelas están completas (o no existen) y los contratos están
        // completos (o no existen)
        return ((listadoParcelasSinCompletar != null && listadoParcelasSinCompletar.size() == 0) || listadoParcelasSinCompletar == null)
                && ((listadoOperacionesSinCompletar != null && listadoOperacionesSinCompletar.size() == 0) || listadoOperacionesSinCompletar == null);
    }

    /**
     * Ordena los registros de AnalisisParcelaPersona por tipo de análisis. Hace
     * un radix sort.
     * 
     * @param analisisPersonas
     *            los registros desordenados.
     * @return la lista ordenada por tipo de análisis.
     */
    @SuppressWarnings("unchecked")
    private List<AnalisisParcelaPersona> ordenarPorTipo(List<AnalisisParcelaPersona> analisisPersonas) {
        // Hago un radix sort para ordenar por tipos de análisis.
        List<DDTipoAnalisis> tiposAnalisis = (List<DDTipoAnalisis>) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_LIST,
                DDTipoAnalisis.class.getName());

        HashMap<String, List<AnalisisParcelaPersona>> hm = new HashMap<String, List<AnalisisParcelaPersona>>();
        for (DDTipoAnalisis ta : tiposAnalisis) {
            hm.put(ta.getCodigo(), new ArrayList<AnalisisParcelaPersona>());
        }
        // Asigno a la lista de cada tipo de codigo los registros que le
        // corresponden.
        for (AnalisisParcelaPersona app : analisisPersonas) {
            hm.get(app.getParcela().getTipoAnalisis().getCodigo()).add(app);
        }
        List<AnalisisParcelaPersona> ret = new ArrayList<AnalisisParcelaPersona>();
        // junto todo
        for (Iterator<String> it = hm.keySet().iterator(); it.hasNext();) {
            ret.addAll(hm.get(it.next()));
        }
        return ret;
    }

    /**
     * Devuelve los datos del listado de personas en el F3_WEB-124. Agrupa las
     * parcelas por tipo de analisis y por tipo parcela para el tipo de la
     * persona. Para los que tiene de valoración, impacto y comentario los
     * agrega.
     * 
     * @param idPersona
     *            el id de la persona sobre la que se quiere hacer el análisis.
     * @return la lista de AnalisisParcelaPersona.
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GET_PARCELAS_PERSONAS_PARA_CONSULTA)
    public List<AnalisisParcelaPersona> getParcelasPersonasParaConsulta(Long idPersona) {
        Persona p = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
        // Busco todas las parcelas

        List<DDParcelasPersonas> parcelasPersonas = parcelasPersonasDao.buscarPorTipoPersonaYSegmento(p.getTipoPersona(), p.getSegmento());

        // Buscamos todos los marcados, cual es la política que está en un
        // expediente y está propuesta
        CicloMarcadoPolitica cicloMarcadoPropuesto = null;
        List<CicloMarcadoPolitica> listadoCicloMarcado = (List<CicloMarcadoPolitica>) executor.execute(
                InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA, idPersona);

        for (CicloMarcadoPolitica cicloMarcado : listadoCicloMarcado) {
            if (cicloMarcado.getExpediente() != null && cicloMarcado.getUltimaPolitica().getEsPropuesta()) {
                cicloMarcadoPropuesto = cicloMarcado;
                break;
            }
        }

        // Busco los registros de AnalisisParcelasPersona para la persona.
        List<AnalisisParcelaPersona> analisisParcelasPersonas;
        if (cicloMarcadoPropuesto != null && cicloMarcadoPropuesto.getAnalisisPersonaPolitica() != null) {
            analisisParcelasPersonas = cicloMarcadoPropuesto.getAnalisisPersonaPolitica().getAnalisisParcelasPersonas();
        } else {
            analisisParcelasPersonas = new ArrayList<AnalisisParcelaPersona>();
        }
        // Hago merge entre los registros de análisis y parcelas. Si no hay
        // registro de análisis creo uno
        // para enviar los datos de la parcela a la web.
        List<AnalisisParcelaPersona> ret = new ArrayList<AnalisisParcelaPersona>();
        for (DDParcelasPersonas parcela : parcelasPersonas) {
            boolean esta = false;
            for (AnalisisParcelaPersona app : analisisParcelasPersonas) {
                if (app.getParcela().getId() == parcela.getId()) {
                    esta = true;
                    ret.add(app);
                }
            }
            if (!esta) {
                AnalisisParcelaPersona app2 = new AnalisisParcelaPersona();
                app2.setParcela(parcela);
                ret.add(app2);
            }
        }
        return ordenarPorTipo(ret);
    }

    /**
     * Busca los datos para hacer la edición de un analisis de parcela persona.
     * 
     * @param idParcela
     *            el id de la parcela.
     * @param idAppSeleccionado
     *            el id del que está seleccionado. Puede ser Nulo.
     * @return el registro de AnalisisParcelaPersona asociado o uno vacío si
     *         todavía no existe.
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_EDITAR_ANALISIS_PERSONA)
    public AnalisisParcelaPersona editarAnalisisPersona(Long idParcela, Long idAppSeleccionado) {
        if (idAppSeleccionado != null) {
            // Es una modificación.
            return analisisParcelaPersonaDao.get(idAppSeleccionado);
        }
        // se está creando el registro.
        AnalisisParcelaPersona app = new AnalisisParcelaPersona();
        app.setParcela(parcelasPersonasDao.get(idParcela));
        return app;

    }

    /**
     * Devuelve el listado de DDValoración para cargar el combo.
     * 
     * @return el listado de DDValoración.
     */
    @BusinessOperation
    public List<DDValoracion> getTiposValoracion() {
        return valoracionDao.getList();
    }

    /**
     * Devuelve el listado de DDImpacto para cargar el combo.
     * 
     * @return el listado de DDImpacto.
     */
    @BusinessOperation
    public List<DDImpacto> getTiposImpacto() {
        return impactoDao.getList();
    }

    /**
     * Guarda un registro de AnalisisParcelaPersona.
     * 
     * @param dto
     *            trae los datos
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GUARDAR_ANALISIS_PARCELA_PERSONA)
    @Transactional
    public void guardarAnalisisParcelaPersona(DtoAnalisisParcelaPersona dto) {
        AnalisisParcelaPersona app;
        if (dto.getIdAnalisisParcelaPersona() != null) {
            // es una modificación
            app = analisisParcelaPersonaDao.get(dto.getIdAnalisisParcelaPersona());
        } else {

            //Le seteo un comentario vacio si no existe uno (esto es para la modificación masiva)
            if (dto.getComentario() == null) dto.setComentario("");

            // creo uno nuevo.
            app = new AnalisisParcelaPersona();
            DDParcelasPersonas parcela = parcelasPersonasDao.get(dto.getIdParcela());
            app.setParcela(parcela);

            // Buscamos todos los marcados, cual es la política que está en un
            // expediente y está propuesta
            CicloMarcadoPolitica cicloMarcadoPropuesto = null;
            List<CicloMarcadoPolitica> listadoCicloMarcado = (List<CicloMarcadoPolitica>) executor.execute(
                    InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA, dto.getIdPersona());

            for (CicloMarcadoPolitica cicloMarcado : listadoCicloMarcado) {
                if (cicloMarcado.getExpediente() != null && cicloMarcado.getUltimaPolitica().getEsPropuesta()) {
                    cicloMarcadoPropuesto = cicloMarcado;
                    break;
                }
            }

            if (cicloMarcadoPropuesto != null) {
                app.setAnalisisPersonaPolitica(cicloMarcadoPropuesto.getAnalisisPersonaPolitica());
            }
        }
        DDImpacto impacto = (DDImpacto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDImpacto.class, dto.getCodigoImpacto());

        app.setImpacto(impacto);

        DDValoracion valoracion = (DDValoracion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDValoracion.class, dto
                .getCodigoValoracion());
        app.setValoracion(valoracion);

        if (dto.getComentario() != null) app.setComentario(dto.getComentario());

        analisisParcelaPersonaDao.saveOrUpdate(app);
    }

    /**
     * Devuelve la lista para llenar la tabla de analisis de contratos.
     * 
     * @param idPersona
     *            el id de la persona sobre la que se hace la consulta
     * @return la lista de personaoperaciones.
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GET_PERSONA_OPERACIONES)
    public List<AnalisisPersonaOperacion> getPersonasOperaciones(Long idPersona) {
        List<AnalisisPersonaOperacion> operaciones = analisisPersonaOperacionDao.buscarOperaciones(idPersona);
        Persona p = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, idPersona);
        List<Contrato> contratos = p.getContratos();
        // Hago merge entre las actuaciones y los contratos.
        List<AnalisisPersonaOperacion> ret = new ArrayList<AnalisisPersonaOperacion>();
        for (Contrato contrato : contratos) {
            boolean esta = false;
            for (Iterator<AnalisisPersonaOperacion> it = operaciones.iterator(); it.hasNext() && !esta;) {
                AnalisisPersonaOperacion apo = it.next();
                if (apo.getContrato().getId().longValue() == contrato.getId().longValue()) {
                    esta = true;
                    ret.add(apo);
                }
            }
            if (!esta) {
                AnalisisPersonaOperacion apo = new AnalisisPersonaOperacion();
                apo.setContrato(contrato);
                ret.add(apo);
            }
        }

        return ret;
    }

    /**
     * Busca los datos para hacer la edición de un analisis de contrato.
     * 
     * @param idContrato
     *            el id del contrato.
     * @param idAppSeleccionado
     *            el id del que está seleccionado. Puede ser Nulo.
     * @return el registro de AnalisisParcelaPersona asociado o uno vacío si
     *         todavía no existe.
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_EDITAR_ANALISIS_OPERACIONES)
    public AnalisisPersonaOperacion editarAnalisisOperaciones(Long idContrato, Long idAppSeleccionado) {
        if (idAppSeleccionado != null) {
            // Es una modificación.
            return analisisPersonaOperacionDao.get(idAppSeleccionado);
        }
        // se está creando el registro.
        AnalisisPersonaOperacion app = new AnalisisPersonaOperacion();
        Contrato cnt = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);
        app.setContrato(cnt);
        return app;

    }

    /**
     * Guarda un registro de AnalisisPersonaOperacion.
     * 
     * @param dto
     *            trae los datos
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GUARDAR_ANALISIS_OPERACIONES)
    @Transactional(readOnly = false)
    public void guardarAnalisisOperaciones(DtoAnalisisOperacion dto) {
        AnalisisPersonaOperacion app;
        if (dto.getIdAnalisisOperacion() != null) {
            // es una modificación
            app = analisisPersonaOperacionDao.get(dto.getIdAnalisisOperacion());
        } else {

            //Le seteo un comentario vacio si no existe uno (esto es para la modificación masiva)
            if (dto.getComentario() == null) dto.setComentario("");

            // creo uno nuevo.
            app = new AnalisisPersonaOperacion();
            Contrato contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, dto.getIdContrato());
            app.setContrato(contrato);

            // Buscamos todos los marcados, cual es la política que está en un
            // expediente y está propuesta
            CicloMarcadoPolitica cicloMarcadoPropuesto = null;
            List<CicloMarcadoPolitica> listadoCicloMarcado = (List<CicloMarcadoPolitica>) executor.execute(
                    InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA, dto.getIdPersona());
            for (CicloMarcadoPolitica cicloMarcado : listadoCicloMarcado) {
                if (cicloMarcado.getExpediente() != null && cicloMarcado.getUltimaPolitica().getEsPropuesta()) {
                    cicloMarcadoPropuesto = cicloMarcado;
                    break;
                }
            }

            if (cicloMarcadoPropuesto != null) {
                app.setAnalisisPersonaPolitica(cicloMarcadoPropuesto.getAnalisisPersonaPolitica());
            }
        }
        DDImpacto impacto = (DDImpacto) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDImpacto.class, dto.getCodigoImpacto());

        app.setImpacto(impacto);

        DDValoracion valoracion = (DDValoracion) executor.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE, DDValoracion.class, dto
                .getCodigoValoracion());

        app.setValoracion(valoracion);

        if (dto.getComentario() != null) app.setComentario(dto.getComentario());

        analisisPersonaOperacionDao.saveOrUpdate(app);
    }

    /**
     * Actualiza la información de gestiones realizadas en el análisis.
     * 
     * @param dto
     *            DtoGestionesRealizadas
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GUARDAR_GESTIONES_REALIZADAS)
    @Transactional(readOnly = false)
    public void guardarGestionesRealizadas(DtoGestionesRealizadas dto) {
        AnalisisPersonaPolitica app = analisisPersonaPoliticaDao.get(dto.getIdAnalisisPersonaPolitica());
        app.setObservacionesGestionesRealizadas(dto.getObservacionesGestiones());
        List<DDTipoGestion> gestionesRealizadas = tipoGestionDao.findByCodigos(new HashSet<String>(Arrays
                .asList(dto.getGestionesIncluir().split(","))));
        app.setGestionesRealizadas(gestionesRealizadas);
        analisisPersonaPoliticaDao.saveOrUpdate(app);
    }

    /**
     * Devuelve el análisis de la política vigente de la persona en cuestión.
     * 
     * @param idPersona
     *            el id de la persona.
     * @return devuelve el registro de analisis de la política vigente para la
     *         persona.
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GET_ANALISIS_POLITICA)
    public AnalisisPersonaPolitica getAnalisisPolitica(Long idPersona) {
        List<CicloMarcadoPolitica> listadoCicloMarcado = (List<CicloMarcadoPolitica>) executor.execute(
                InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA, idPersona);
        Politica politica = null;

        // Buscamos en todos los ciclos de marcado
        for (CicloMarcadoPolitica cicloMarcado : listadoCicloMarcado) {
            // Si existe uno que pertenezca a un expediente de seguimiento
            if (cicloMarcado.getExpediente() != null) {
                // Cuya política más actual esté en estado propuesto
                Politica aux = cicloMarcado.getUltimaPolitica();
                if (aux.getEsPropuesta()) {
                    politica = aux;
                    break;
                }
            }
        }

        if (politica == null) { return null; }
        return politica.getCicloMarcadoPolitica().getAnalisisPersonaPolitica();
    }

    /**
     * @param id
     *            Long
     * @return AnalisisPersonaPolitica
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GET_ANALISIS_POLITICA_BY_ID)
    public AnalisisPersonaPolitica getAnalisisPoliticaById(Long id) {
        return analisisPersonaPoliticaDao.get(id);
    }

    /**
     * Devuelve el registro de analisis de una política en particular.
     * 
     * @param idPolitica
     *            el id de la política
     * @return el registro de análisis
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GET_ANALISIS_POLITICA_HISTORICO)
    public AnalisisPersonaPolitica getAnalisisPoliticaHistorico(Long idPolitica) {
        Politica politica = (Politica) executor.execute(InternaBusinessOperation.BO_POL_MGR_GET, idPolitica);
        if (politica == null) { return null; }
        return politica.getCicloMarcadoPolitica().getAnalisisPersonaPolitica();
    }
    
    
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GET_ANALISIS_POLITICA_HISTORICO_BY_CMP)
    public AnalisisPersonaPolitica getAnalisisPoliticaHistoricoByCmp(Long idPolitica) {
        List<Politica> politicas = (List<Politica>) executor.execute(InternaBusinessOperation.BO_POL_MGR_GET_POL_BY_CMP, idPolitica);
        if (politicas == null || politicas.size() == 0) { 
        	return null; 
        }else{
           for(Politica politica : politicas){
        	   return politica.getCicloMarcadoPolitica().getAnalisisPersonaPolitica();
           }
        }
		return null;
    }

    /**
     * Devuelve los tipos de gestión, marcando los que están seleccionados.
     * 
     * @param idPersona
     *            el id de la persona.
     * @return la lista de DtoGestion
     */
    @SuppressWarnings("unchecked")
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GET_TIPOS_GESTIONES)
    public List<DtoGestiones> getTiposGestiones(Long idPersona) {
        List<DDTipoGestion> tiposGestion = tipoGestionDao.getList();

        // Buscamos todos los marcados, cual es la política que está en un
        // expediente y está propuesta
        CicloMarcadoPolitica cicloMarcadoPropuesto = null;
        List<CicloMarcadoPolitica> listadoCicloMarcado = (List<CicloMarcadoPolitica>) executor.execute(
                InternaBusinessOperation.BO_POL_MGR_BUSCAR_POLITICAS_PARA_PERSONA, idPersona);
        for (CicloMarcadoPolitica cicloMarcado : listadoCicloMarcado) {
            if (cicloMarcado.getExpediente() != null && cicloMarcado.getUltimaPolitica().getEsPropuesta()) {
                cicloMarcadoPropuesto = cicloMarcado;
                break;
            }
        }

        if (cicloMarcadoPropuesto == null) { return new ArrayList<DtoGestiones>(); }

        AnalisisPersonaPolitica app = cicloMarcadoPropuesto.getAnalisisPersonaPolitica();
        List<DDTipoGestion> gestionesRealizadas = app.getGestionesRealizadas();
        // hago merge entre las 2 listas para marcar en el dto los que están
        // seleccionados.
        List<DtoGestiones> ret = new ArrayList<DtoGestiones>();
        for (DDTipoGestion tipoGestion : tiposGestion) {
            DtoGestiones dto = new DtoGestiones();
            dto.setTipoGestion(tipoGestion);
            ret.add(dto);
            for (DDTipoGestion realizada : gestionesRealizadas) {
                if (realizada.getId().longValue() == tipoGestion.getId().longValue()) {
                    dto.setSeleccionado(Boolean.TRUE);
                }
            }
        }
        return ret;
    }

    /**
     * Guarda los cambios hechos a un registro de AnalisisPersonaPolitica.
     * 
     * @param dto
     *            el dto con los datos.
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GUARDAR_COMENTARIO_ANALISIS)
    @Transactional
    public void guardarComentarioAnalisis(DtoAnalisisPolitica dto) {
        AnalisisPersonaPolitica app = analisisPersonaPoliticaDao.get(dto.getIdAnalisisPolitica());
        if (dto.getEsSupervisor()) {
            app.setComentarioSupervisor(dto.getComentario());
        } else if (dto.getEsGestor()) {
            app.setComentarioGestor(dto.getComentario());
        }
        analisisPersonaPoliticaDao.save(app);
    }

    /**
     * @param app
     *            AnalisisPersonaPolitica
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_SAVE)
    public void save(AnalisisPersonaPolitica app) {
        analisisPersonaPoliticaDao.save(app);
    }

    /**
     * Guarda masivamente una lista de analisis de operacion, se llama a esta BO
     * cuando se edita un grid con varios elementos, desde el tab de analisis de
     * una persona
     * 
     * @param dto
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GUARDAR_ANALISIS_OPERACIONES_MASIVO)
    @Transactional(readOnly = false)
    public void guardarAnalisisOperacionesMasivo(DtoListaAnalisisOperacion dto) {
        DtoAnalisisOperacion[] dtos = dto.getAnalisisOperacionLista();
        for (DtoAnalisisOperacion o : dtos) {
            Long idContrato = o.getIdContrato();
            if (idContrato != null) {
                guardarAnalisisOperaciones(o);
            } else
                return;

        }
    }

    /**
     * Guarda masivamente una lista de analisis parcela persona, se llama a esta
     * BO cuando se edita un grid con varios elementos, desde el tab de analisis
     * de una persona
     * 
     * @param dto
     */
    @BusinessOperation(InternaBusinessOperation.BO_ANALISIS_POL_MGR_GUARDAR_ANALISIS_PERSONA_MASIVO)
    @Transactional(readOnly = false)
    public void guardarAnalisisPersonaMasivo(DtoListaAnalisisPersona dto) {
        DtoAnalisisParcelaPersona[] dtos = dto.getListaAnalisisPersona();
        for (DtoAnalisisParcelaPersona o : dtos) {
            Long idParcela = o.getIdParcela();
            if (idParcela != null) {
                guardarAnalisisParcelaPersona(o);
            } else
                return;

        }
    }
}
