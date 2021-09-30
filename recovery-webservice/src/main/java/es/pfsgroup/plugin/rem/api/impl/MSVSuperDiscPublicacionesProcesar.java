package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.Date;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDivHorizontal;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;

import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;

/***
 * 
 * Clase que procesa el fichero de carga masiva disclaimer de publicaciones
 *
 */

@Component
public class MSVSuperDiscPublicacionesProcesar extends AbstractMSVActualizador implements MSVLiberator {

	private final String VALID_OPERATION = MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_DISCLAIMER_PUBLICACION;

	public static final class COL_NUM {

		static final int NUM_ACTIVO = 0;
		static final int ESTADO_FISICO_ACTIVO = 1;
		static final int OCUPADO = 2;
		static final int CON_TITULO = 3;
		static final int TAPIADO = 4;
		static final int OTROS = 5;
		static final int MOTIVO_OTROS = 6;
		static final int ACTIVO_INTEGRADO = 7;
		static final int DIVISION_HORIZONTAL_INTEGRADO = 8;
		static final int ESTADO_DIVISION_HORIZONTAL = 9;

	}

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Override
	public String getValidOperation() {
		return VALID_OPERATION;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException {

		final String FILTRO_CODIGO = "codigo";
		final String ARROBA = "@";
		final String[] LISTA_SI = { "SI", "S" };
		final String[] LISTA_NO = { "NO", "N" };
		final String[] LISTA_INSCRITA = { "INSCRITA" };

		final String celdaActivo = exc.dameCelda(fila, COL_NUM.NUM_ACTIVO);
		final String celdaEstadoFisicoActivo = exc.dameCelda(fila, COL_NUM.ESTADO_FISICO_ACTIVO);
		final String celdaOcupado = exc.dameCelda(fila, COL_NUM.OCUPADO);
		final String celdaTitulo = exc.dameCelda(fila, COL_NUM.CON_TITULO);
		final String celdaTapiado = exc.dameCelda(fila, COL_NUM.TAPIADO);
		final String celdaOtros = exc.dameCelda(fila, COL_NUM.OTROS);
		final String celdaOtrosMotivos = exc.dameCelda(fila, COL_NUM.MOTIVO_OTROS);
		final String celdaIntegrado = exc.dameCelda(fila, COL_NUM.ACTIVO_INTEGRADO);
		final String celdaEstadoIntegrado = exc.dameCelda(fila, COL_NUM.DIVISION_HORIZONTAL_INTEGRADO);
		final String celdaSiNoInscrito = exc.dameCelda(fila, COL_NUM.ESTADO_DIVISION_HORIZONTAL);

		Activo activo = activoApi.getByNumActivo(Long.parseLong(celdaActivo));

		// Estado físico
		Filter filtroEstadoActivo = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaEstadoFisicoActivo);
		activo.setEstadoActivo(genericDao.get(DDEstadoActivo.class, filtroEstadoActivo));

		// Situacion Posesoria
		ActivoSituacionPosesoria situacionPosesoria = activo.getSituacionPosesoria();
		Integer ocupado = 0;
		Integer accesoTapiado = 0;
		Integer divisionHorizontal = 0;
		Integer inscritoDivisionHorizontal = 0;
		Date fechaHoy = new Date();
		
		Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		String usuarioModificar = usu == null ? MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_DISCLAIMER_PUBLICACION : MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_DISCLAIMER_PUBLICACION + " - " + usu.getUsername();

		// Ocupado
		if (Arrays.asList(LISTA_SI).contains(celdaOcupado.toUpperCase())) {
			ocupado = 1;
		}

		situacionPosesoria.setOcupado(ocupado);
		situacionPosesoria.setUsuarioModificarOcupado(usuarioModificar);
		situacionPosesoria.setFechaModificarOcupado(new Date());

		// ConTitulo
		if (ARROBA.equals(celdaOcupado)) {
			situacionPosesoria.setConTitulo(null);
		} else if (ARROBA.equals(celdaTitulo)) {
			situacionPosesoria.setConTitulo(null);
		} else {
			Filter filtroTipoTitulo = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO, celdaTitulo);
			DDTipoTituloActivoTPA tipoTitulo = genericDao.get(DDTipoTituloActivoTPA.class, filtroTipoTitulo);
			situacionPosesoria.setConTitulo(tipoTitulo);
		}
		situacionPosesoria.setUsuarioModificarConTitulo(usuarioModificar);
		situacionPosesoria.setFechaModificarOcupado(new Date());

		// Tapiado
		if (Arrays.asList(LISTA_SI).contains(celdaTapiado.toUpperCase())) {
			accesoTapiado = 1;
			situacionPosesoria.setFechaAccesoTapiado(fechaHoy);
		}

		situacionPosesoria.setAccesoTapiado(accesoTapiado);

		// Otros => No hay que persistirlo

		// Motivo Otros Publicacion
		if (Checks.esNulo(celdaOtrosMotivos) || ARROBA.equals(celdaOtrosMotivos) || ARROBA.equals(celdaOtros)) {
			situacionPosesoria.setOtro(null);
		} else {
			situacionPosesoria.setOtro(celdaOtrosMotivos);
		}

		// genericDao.save(ActivoSituacionPosesoria.class, situacionPosesoria);
		activo.setSituacionPosesoria(situacionPosesoria);

		// DivisionHorizontal-Activo Integrado

		ActivoInfoRegistral activoInfoRegistral = activo.getInfoRegistral();

		if (ARROBA.equals(celdaSiNoInscrito) || ARROBA.equals(celdaEstadoIntegrado) || ARROBA.equals(celdaIntegrado) 
				|| Arrays.asList(LISTA_NO).contains(celdaIntegrado.toUpperCase())) {
			
			activoInfoRegistral.setDivHorInscrito(null);
			activoInfoRegistral.setEstadoDivHorizontal(null);

		} else {
			Filter filtroEstadoDivisionHorizontal = genericDao.createFilter(FilterType.EQUALS, FILTRO_CODIGO,
					celdaSiNoInscrito);
			DDEstadoDivHorizontal estadoDivisionHorizontal = genericDao.get(DDEstadoDivHorizontal.class,
					filtroEstadoDivisionHorizontal);

			if (Arrays.asList(LISTA_SI).contains(celdaIntegrado.toUpperCase())) {
				divisionHorizontal = 1;
			}
			
			if (!Checks.esNulo(activoInfoRegistral)) {

				if (Arrays.asList(LISTA_INSCRITA).contains(celdaEstadoIntegrado.toUpperCase())) {
					inscritoDivisionHorizontal = 1;
				}

				activoInfoRegistral.setDivHorInscrito(inscritoDivisionHorizontal);				
				activoInfoRegistral.setEstadoDivHorizontal(estadoDivisionHorizontal);
				
			}
			
		}

		activo.setDivHorizontal(divisionHorizontal);		
		activo.setInfoRegistral(activoInfoRegistral);
		
		activoDao.saveOrUpdate(activo);
		// genericDao.save(ActivoInfoRegistral.class, activoInfoRegistral);
		// lanzar el SP de publicaciones para el activo
		activoAdapter.actualizarEstadoPublicacionActivo(activo.getId(), false);

		if(activo!=null && situacionPosesoria!=null && usu!=null) {
			String cmasivaCodigo = this.getValidOperation();
			Filter filterCMasiva = genericDao.createFilter(FilterType.EQUALS, "codigo", cmasivaCodigo);
			MSVDDOperacionMasiva cMasiva = genericDao.get(MSVDDOperacionMasiva.class, filterCMasiva);
			
			if(cMasiva!=null && cMasiva.getDescripcion()!=null && (!celdaOcupado.isEmpty() || !celdaTitulo.isEmpty())) {
				HistoricoOcupadoTitulo histOcupado = new HistoricoOcupadoTitulo(activo,situacionPosesoria,usu,HistoricoOcupadoTitulo.COD_CARGA_MASIVA,cMasiva.getDescripcion().toString());
				genericDao.save(HistoricoOcupadoTitulo.class, histOcupado);
			}
		
		}

		return new ResultadoProcesarFila();
	}

}
