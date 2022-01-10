package es.pfsgroup.plugin.rem.api.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.recoveryComunicacion.RecoveryComunicacionManager;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;
import es.pfsgroup.plugin.rem.thread.ConvivenciaRecovery;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDAccionMasiva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;

/***
 * Clase que procesa el fichero de carga masiva valores perímetro Apple
 */
@Component
public class MSVActualizadorInformacionInscripcionCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GenericAdapter adapter;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	protected static final Log logger = LogFactory.getLog(MSVActualizadorInformacionInscripcionCargaMasiva.class);
	
	public static final class COL_NUM {
	
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		static final int ACT_NUM_ACTIVO = 0;
		static final int SITUACION_TITULO = 1;
		static final int FECHA_ENTREGA_TITULO_GESTORIA = 2;
		static final int FECHA_PRESENTACION_HACIENDA = 3;
		static final int FECHA_INSCRIPCION_REGISTRO = 4;
		static final int FECHA_RETIRADA_REGISTRO = 5;
		static final int FECHA_NOTA_SIMPLE = 6;
		static final int ACCION = 7;
		
	}

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_INSCRIPCIONES;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)throws Exception {

		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());

		final String numActivo = exc.dameCelda(fila, COL_NUM.ACT_NUM_ACTIVO);
		final String situacionTitulo = exc.dameCelda(fila, COL_NUM.SITUACION_TITULO);
		final String fechaEntregaTitulo = exc.dameCelda(fila, COL_NUM.FECHA_ENTREGA_TITULO_GESTORIA);
		final String fechaPresentacion = exc.dameCelda(fila, COL_NUM.FECHA_PRESENTACION_HACIENDA);
		final String fechaInscripcion = exc.dameCelda(fila, COL_NUM.FECHA_INSCRIPCION_REGISTRO);
		final String fechaRetirada = exc.dameCelda(fila, COL_NUM.FECHA_RETIRADA_REGISTRO);
		final String fechaNota = exc.dameCelda(fila, COL_NUM.FECHA_NOTA_SIMPLE);
		final String codAccion = exc.dameCelda(fila, COL_NUM.ACCION);

		transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		

		// Número de Activo
		Activo activo = activoApi.getByNumActivo(Long.parseLong(numActivo));
		ActivoTitulo titulo;
		if (DDAccionMasiva.CODIGO_ANYADIR.equals(codAccion)) {
			titulo = new ActivoTitulo();
			titulo.setActivo(activo);
			if (!Checks.esNulo(situacionTitulo)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", situacionTitulo);
				DDEstadoTitulo estadoTitulo = genericDao.get(DDEstadoTitulo.class, filtro);
				titulo.setEstado(estadoTitulo);
			}
			if (!Checks.esNulo(fechaEntregaTitulo)) {
				titulo.setFechaEntregaGestoria(obtenerDateExcel(fechaEntregaTitulo));
			}
			if (!Checks.esNulo(fechaPresentacion)) {
				titulo.setFechaPresHacienda(obtenerDateExcel(fechaPresentacion));
			}
			if (!Checks.esNulo(fechaInscripcion)) {
				titulo.setFechaInscripcionReg(obtenerDateExcel(fechaInscripcion));
			}
			if (!Checks.esNulo(fechaRetirada)) {
				titulo.setFechaRetiradaReg(obtenerDateExcel(fechaRetirada));
			}
			if (!Checks.esNulo(fechaNota)) {
				titulo.setFechaNotaSimple(obtenerDateExcel(fechaNota));
			}

			genericDao.save(ActivoTitulo.class, titulo);
		} else if (DDAccionMasiva.CODIGO_MODIFICAR.equals(codAccion)) {
			titulo = genericDao.get(ActivoTitulo.class,
					genericDao.createFilter(FilterType.EQUALS, "activo", activo));
			if (!Checks.esNulo(situacionTitulo)) {
				if (esEquis(situacionTitulo)) {
					titulo.setEstado(null);
				} else {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", situacionTitulo);
					DDEstadoTitulo estadoTitulo = genericDao.get(DDEstadoTitulo.class, filtro);
					titulo.setEstado(estadoTitulo);
				}
			}
			if (!Checks.esNulo(fechaEntregaTitulo)) {
				if (esEquis(fechaEntregaTitulo)) {
					titulo.setFechaEntregaGestoria(null);
				} else {
					titulo.setFechaEntregaGestoria(obtenerDateExcel(fechaEntregaTitulo));
				}
			}
			if (!Checks.esNulo(fechaPresentacion)) {
				if (esEquis(fechaPresentacion)) {
					titulo.setFechaPresHacienda(null);
				} else {
					titulo.setFechaPresHacienda(obtenerDateExcel(fechaPresentacion));
				}
			}
			if (!Checks.esNulo(fechaInscripcion)) {
				if (esEquis(fechaInscripcion)) {
					titulo.setFechaInscripcionReg(null);
				} else {
					titulo.setFechaInscripcionReg(obtenerDateExcel(fechaInscripcion));
				}
			}
			if (!Checks.esNulo(fechaRetirada)) {
				if (esEquis(fechaRetirada)) {
					titulo.setFechaRetiradaReg(null);
				} else {
					titulo.setFechaRetiradaReg(obtenerDateExcel(fechaRetirada));
				}
			}
			if (!Checks.esNulo(fechaNota)) {
				if (esEquis(fechaNota)) {
					titulo.setFechaNotaSimple(null);
				} else {
					titulo.setFechaNotaSimple(obtenerDateExcel(fechaNota));
				}
			}

			genericDao.save(ActivoTitulo.class, titulo);

			transactionManager.commit(transaction);

			if(activo.getCartera().getCodigo().equals(DDCartera.CODIGO_CARTERA_BBVA)){
				Thread llamadaAsincrona = new Thread(new ConvivenciaRecovery(activo.getId(), new ModelMap(), adapter.getUsuarioLogado().getUsername()));
				llamadaAsincrona.start();
			}
		}

		return new ResultadoProcesarFila();
	}

	private Date obtenerDateExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}
		
		if (esEquis(celdaExcel)) {
			return null;
		}

		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fecha = null;

		try {
			fecha = ft.parse(celdaExcel);
		} catch (ParseException e) {
			logger.error("error en MSVActualizadorInformacionInscripcionCargaMasiva", e);
		}

		return fecha;
	}

	private boolean esEquis(String cadena) {
		return cadena.trim().equalsIgnoreCase("X");
	}

}