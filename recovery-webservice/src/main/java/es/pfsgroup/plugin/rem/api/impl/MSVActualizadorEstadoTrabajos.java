package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;

import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.AgendaTrabajo;
import es.pfsgroup.plugin.rem.model.HistorificadorPestanas;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDPestanas;
import es.pfsgroup.plugin.rem.model.dd.DDTipoApunte;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ConstantesTrabajo;
import es.pfsgroup.recovery.api.UsuarioApi;

@Component
public class MSVActualizadorEstadoTrabajos extends AbstractMSVActualizador implements MSVLiberator {

	protected final Log logger = LogFactory.getLog(getClass());
	private static final String EMAIL_RECHAZADO = "RECHAZADO";
	private static final String EMAIL_VALIDADO = "VALIDADO";

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_ESTADO_TRABAJOS;
	}

	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws JsonViewerException, IOException, ParseException, SQLException, Exception {
		return procesaFila(exc, fila, prmToken, new Object[0]);
	}

	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken, Object[] extraArgs)
			throws IOException, ParseException, JsonViewerException, SQLException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			// Variables temporales para asignar valores de filas excel
			Long tmpNumTrabajo = Long.parseLong(exc.dameCelda(fila, 0));
			String tmpAccion = exc.dameCelda(fila, 1).toUpperCase();
			String tmpComentario = exc.dameCelda(fila, 2);
			Trabajo trabajo = trabajoApi.getTrabajoByNumeroTrabajo(tmpNumTrabajo);
			AgendaTrabajo agenda = null;
			Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			HistorificadorPestanas historificador = new HistorificadorPestanas();
			
			historificador.setTrabajo(trabajo);
			historificador.setCampo(ConstantesTrabajo.DD_EST_ID);
			historificador.setColumna(ConstantesTrabajo.COLUMNA_DD_EST_ID);
			historificador.setPestana((DDPestanas) utilDiccionarioApi.dameValorDiccionarioByCod(DDPestanas.class,DDPestanas.CODIGO_FICHA));
			historificador.setTabla(ConstantesTrabajo.NOMBRE_TABLA);
			historificador.setUsuario(usuarioManager.getUsuarioLogado());
			historificador.setFechaModificacion(new Date());
			
			if(!Checks.esNulo(trabajo.getEstado().getDescripcion())) {
				historificador.setValorAnterior(trabajo.getEstado().getDescripcion());
			}

			DDEstadoTrabajo estadoTrabajo = genericDao.get(DDEstadoTrabajo.class,
					genericDao.createFilter(FilterType.EQUALS, "codigo", tmpAccion));
			trabajo.setEstado(estadoTrabajo);
			trabajo.setFechaCambioEstado(new Date());
			
			if (DDEstadoTrabajo.ESTADO_VALIDADO.equals(estadoTrabajo.getCodigo())) {
				trabajo.setFechaValidacion(new Date());
			}
			genericDao.update(Trabajo.class, trabajo);
			
			historificador.setValorNuevo(estadoTrabajo.getDescripcion());
			genericDao.save(HistorificadorPestanas.class, historificador);
			
			if (tmpComentario != null && !tmpComentario.isEmpty()) {
				agenda = new AgendaTrabajo();
				agenda.setTrabajo(trabajo);
				agenda.setFecha(new Date());
				agenda.setObservaciones(tmpComentario);
				agenda.setGestor(usu);
				DDTipoApunte tipoApunte = genericDao.get(DDTipoApunte.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoApunte.CODIGO_GESTION));
				agenda.setTipoGestion(tipoApunte);
				genericDao.save(AgendaTrabajo.class, agenda);
			}

			if (DDEstadoTrabajo.ESTADO_VALIDADO.equals(estadoTrabajo.getCodigo())) {
				trabajoApi.EnviarCorreoTrabajos(trabajo, EMAIL_VALIDADO);
			} else if (DDEstadoTrabajo.CODIGO_ESTADO_RECHAZADO.equals(estadoTrabajo.getCodigo())) {
				trabajoApi.EnviarCorreoTrabajos(trabajo, EMAIL_RECHAZADO);
			}

			resultado.setCorrecto(true);
		} catch (Exception e) {
			resultado.setCorrecto(false);
			resultado.setErrorDesc(e.getMessage());
			logger.error("Error en MSVActualizadorPerimetroActivo", e);
		}

		return resultado;
	}

}
