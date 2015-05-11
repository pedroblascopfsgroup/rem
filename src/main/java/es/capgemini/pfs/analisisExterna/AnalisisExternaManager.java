package es.capgemini.pfs.analisisExterna;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.analisisExterna.dao.AnalisisExternaDao;
import es.capgemini.pfs.analisisExterna.dto.DtoAnalisisExterna;
import es.capgemini.pfs.analisisExterna.dto.DtoAnalisisExternaFormulario;
import es.capgemini.pfs.analisisExterna.dto.DtoAnalisisExternaTabla;
import es.capgemini.pfs.analisisExterna.model.DDCriterioAnalisisExterna;
import es.capgemini.pfs.analisisExterna.model.DDPlazoAceptacion;
import es.capgemini.pfs.despachoExterno.DespachoExternoManager;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.DDFaseProcesal;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.FormatUtils;
import es.capgemini.pfs.utils.ObjetoResultado;
import es.capgemini.pfs.utils.StringUtils;

/**
 * @author marruiz
 */
@Service
public class AnalisisExternaManager {

    @Resource
    private MessageService messageService;

    @Autowired
    private DictionaryManager dictionaryManager;

    @Autowired
    private TipoProcedimientoManager tipoProcedimientoManager;

    @Autowired
    private DespachoExternoManager despachoExternoManager;

    @Autowired
    private UsuarioManager usuarioManager;

    @Autowired
    private AnalisisExternaDao analisisExternaDao;

    @Autowired
    DDPlazoAceptacionManager plazoAceptacionManager;

    /**
     * Retorna los datos para el export a Excel.
     *
     * @param form DtoAnalisisExternaFormulario: datos de entrada para generar la información
     * @return DtoAnalisisExterna
     */
    @BusinessOperation
    public DtoAnalisisExterna exportAnalisis(DtoAnalisisExternaFormulario form) throws Exception {

        DtoAnalisisExterna dto = new DtoAnalisisExterna();
        List<DtoAnalisisExternaTabla> data = null;

        if (DDCriterioAnalisisExterna.CODIGO_TIPO_PROCEDIMIENTO.equals(form.getTipoSalida()))
            data = analisisExternaDao.buscarAgrupandoPorTipoProcedimiento(form);
        else if (DDCriterioAnalisisExterna.CODIGO_DESPACHO.equals(form.getTipoSalida()))
            data = analisisExternaDao.buscarAgrupandoPorDespacho(form);
        else if (DDCriterioAnalisisExterna.CODIGO_GESTOR.equals(form.getTipoSalida()))
            data = analisisExternaDao.buscarAgrupandoPorGestor(form);
        else if (DDCriterioAnalisisExterna.CODIGO_SUPERVISOR.equals(form.getTipoSalida()))
            data = analisisExternaDao.buscarAgrupandoPorSupervisor(form);
        else if (DDCriterioAnalisisExterna.CODIGO_FASE_PROCESAL.equals(form.getTipoSalida()))
            data = analisisExternaDao.buscarAgrupandoPorFaseProcesal(form);
        else
            throw new UserException("menu.analisisExterna.errorTipoSalida", new Object[] {});

        // *********************************************************** //
        // ** AÑADIMOS LOS CRITERIOS DE BÚSQUEDA                    ** //
        // *********************************************************** //

        dto.setData(data);
        dto.setTipoSalida(messageService.getMessage("menu.analisisExterna.tipoSalida." + form.getTipoSalida()));
        dto.setFechaCarga(FormatUtils.strADate(form.getFecha(), FormatUtils.DDMMYYYY));

        //Decidimos si se muestran procedimientos activos o no
        dto.setProcedimientosActivos("true".equals(form.getbProcedimientoActivo()));

        //Añadimos el plazo de aceptación
        if (!StringUtils.emtpyString(form.getCodigoPlazo())) {
            dto.setPlazoAceptacion((DDPlazoAceptacion) dictionaryManager.getByCode(DDPlazoAceptacion.class, form.getCodigoPlazo()));
        }

        //Añadimos el listado de tipos de procedimiento
        if (!StringUtils.emtpyString(form.getIdTipoProcedimientos())) {
            List<TipoProcedimiento> tiposProcedimiento = new ArrayList<TipoProcedimiento>();
            String[] listaCodigos = form.getIdTipoProcedimientos().split(",");
            for (String codigoTipoProcedimiento : listaCodigos) {
                tiposProcedimiento.add(tipoProcedimientoManager.getByCodigo(codigoTipoProcedimiento));
            }
            dto.setTiposProcedimiento(FormatUtils.objectListToString(tiposProcedimiento, "getDescripcion"));
        }

        //Añadimos el listado de despachos
        if (!StringUtils.emtpyString(form.getCodigoDespachos())) {
            List<DespachoExterno> despachos = new ArrayList<DespachoExterno>();
            String[] listaIds = form.getCodigoDespachos().split(",");
            for (String idDespacho : listaIds) {
                despachos.add(despachoExternoManager.get(new Long(idDespacho)));
            }
            dto.setDespachos(FormatUtils.objectListToString(despachos, "getDespacho"));
        }

        //Añadimos el listado de fases procesal
        if (!StringUtils.emtpyString(form.getCodigosFase())) {
            List<DDFaseProcesal> listadoFases = new ArrayList<DDFaseProcesal>();
            String[] listaCodigos = form.getCodigosFase().split(",");
            for (String codigoFase : listaCodigos) {
                listadoFases.add((DDFaseProcesal) dictionaryManager.getByCode(DDFaseProcesal.class, codigoFase));
            }
            dto.setFasesProcesal(FormatUtils.objectListToString(listadoFases, "getDescripcion"));
        }

        //Añadimos el listado de usuarios gestores
        if (!StringUtils.emtpyString(form.getIdUsuariosGestor())) {
            List<Usuario> listadoUsuarios = new ArrayList<Usuario>();
            String[] listaIds = form.getIdUsuariosGestor().split(",");
            for (String idUsuario : listaIds) {
                listadoUsuarios.add(usuarioManager.get(new Long(idUsuario)));
            }
            dto.setGestores(FormatUtils.objectListToString(listadoUsuarios, "getApellidoNombre"));
        }

        //Añadimos el listado de usuarios supervisores
        if (!StringUtils.emtpyString(form.getIdUsuariosSupervisor())) {
            List<Usuario> listadoUsuarios = new ArrayList<Usuario>();
            String[] listaIds = form.getIdUsuariosSupervisor().split(",");
            for (String idUsuario : listaIds) {
                listadoUsuarios.add(usuarioManager.get(new Long(idUsuario)));
            }
            dto.setSupervisores(FormatUtils.objectListToString(listadoUsuarios, "getApellidoNombre"));
        }

        return dto;
    }

    /**
     * Busca los 'AnalisisExterna', es decir, datos analizados de la BBDD segÃºn los criterios indicados en el dto.
     * @param dto criterios de busqueda.
     * @return Lista de ObjetoResultado
     * @throws Exception e
     */
    @BusinessOperation
    public List<ObjetoResultado> buscar(DtoAnalisisExternaFormulario dto) throws Exception {
        Long count = analisisExternaDao.buscarCount(dto);

        ObjetoResultado oRes = new ObjetoResultado();
        oRes.setResultados(count);

        if (count == 0L) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            String mensaje = ms.getMessage("analisis.busqueda.salida.jerarquico.noHayDatos", new Object[] {}, MessageUtils.DEFAULT_LOCALE);

            oRes.setCodigoResultado(ObjetoResultado.RESULTADO_ERROR);
            oRes.setMensajeError(mensaje);
        } else {
            oRes.setCodigoResultado(ObjetoResultado.RESULTADO_OK);
        }

        List<ObjetoResultado> list = new ArrayList<ObjetoResultado>(1);
        list.add(oRes);
        return list;
    }

}
