package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.test.cambiogestores.testcases;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.web.context.request.WebRequest;

import static org.mockito.Mockito.*;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.PeticionCambioMasivoGestoresDto;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.CambioMasivoGestoresAsuntoDao;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dto.PeticionCambioMasivoGestoresDtoImpl;

public class PeticionCambioMasivoTestCase {

	private static final String TIPO_GESTOR_KEY = "tipoGestor";
	private static final String ID_GESTOR_ORIGINAL_KEY = "idGestorOriginal";
	private static final String FECHA_INICIO_KEY = "fechaInicio";
	private static final String FECHA_FIN_KEY = "fechaFin";
	private static final String ID_NUEVO_GESTOR_KEY = "idNuevoGestor";
	private Usuario usuarioLogado;
	private Map<String, Object> randomData;
	private int numAsuntosTest;

	/**
	 * Crea un caso de pruebas para una petición de cambio masivo de gestor
	 * 
	 * @param usuarioLogado
	 *            Usuario que simulará estar logado
	 */
	public PeticionCambioMasivoTestCase(Usuario usuarioLogado) {
		if (usuarioLogado == null) {
			throw new IllegalArgumentException("usuarioLogado no puede ser NULL");
		}
		this.usuarioLogado = usuarioLogado;
		this.randomData = new HashMap<String, Object>();
		this.initializaRandomData();
		this.numAsuntosTest = new Random().nextInt(100);
	}

	/**
	 * DTO con la petición que recibe el controller
	 * 
	 * @return
	 */
	public PeticionCambioMasivoGestoresDtoImpl getWebDto() {
		Random r = new Random();
		PeticionCambioMasivoGestoresDtoImpl dto = new PeticionCambioMasivoGestoresDtoImpl();
		/* Simulamos que las fechas vienen vacías
		dto.setFechaInicio((Date) randomData.get(FECHA_INICIO_KEY));
		dto.setFechaFin((Date) randomData.get(FECHA_FIN_KEY));
		*/
		dto.setIdGestorOriginal((Long) this.randomData.get(ID_GESTOR_ORIGINAL_KEY));
		dto.setIdNuevoGestor((Long) this.randomData.get(ID_NUEVO_GESTOR_KEY));
		dto.setSolicitante(null);
		dto.setTipoGestor((String) this.randomData.get(TIPO_GESTOR_KEY));
		return dto;
	}

	/**
	 * Devuelve el usuario que simula estar logado
	 * 
	 * @return
	 */
	public Usuario getUsuarioLogado() {
		return this.usuarioLogado;
	}

	public PeticionCambioMasivoGestoresDto getManagerDto() {
		PeticionCambioMasivoGestoresDtoImpl dto = getWebDto();
		dto.setFechaInicio((Date) this.randomData.get(FECHA_INICIO_KEY));
		dto.setFechaFin((Date) this.randomData.get(FECHA_FIN_KEY));
		dto.setSolicitante(getUsuarioLogado());
		return dto;
	}

	
	public int getNumAsuntos() {
		return this.numAsuntosTest;
	}

	private List<Asunto> creaListaAsuntos(int numAsuntos) {
		List<Asunto> list = new ArrayList<Asunto>();
		for (int i=0; i< numAsuntos; i++){
			list.add(0, new Asunto());
		}
		return list;
	}

	

	private void initializaRandomData() {
		Random r = new Random();
		this.randomData.put(TIPO_GESTOR_KEY, r.nextLong() + "");
		this.randomData.put(ID_GESTOR_ORIGINAL_KEY, r.nextLong());
		this.randomData.put(FECHA_INICIO_KEY, createRandomDate());
		this.randomData.put(FECHA_FIN_KEY, createRandomDate());
		this.randomData.put(ID_NUEVO_GESTOR_KEY, r.nextLong());
	}


	public WebRequest mockeaWebRequest() {
		WebRequest req = mock(WebRequest.class);
		String fechaInicio = DateFormat.toString((Date) this.randomData.get(FECHA_INICIO_KEY));
		String fechaFin = DateFormat.toString((Date) this.randomData.get(FECHA_FIN_KEY));
		when(req.getParameter(FECHA_INICIO_KEY)).thenReturn(fechaInicio);
		when(req.getParameter(FECHA_FIN_KEY)).thenReturn(fechaFin);
		return req;
	}

	public PeticionCambioMasivoGestoresDto webRequest() {
		return new PeticionCambioMasivoGestoresDto() {
			
			@Override
			public boolean isReasignado() {
				// TODO Auto-generated method stub
				return false;
			}
			
			@Override
			public String getTipoGestor() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Usuario getSolicitante() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Long getIdNuevoGestor() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Long getIdGestorOriginal() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Date getFechaInicio() {
				return (Date) randomData.get(FECHA_INICIO_KEY);
			}
			
			@Override
			public Date getFechaFin() {
				return (Date) randomData.get(FECHA_FIN_KEY);
			}
		};
	}
	
	private Date createRandomDate() {
		Random r = new Random();
		int d = r.nextInt(29) + 1;
		int m = r.nextInt(12) + 1;
		int y = r.nextInt(100) + 2000;
		
		try {
			return DateFormat.toDate(d+"/"+m+"/"+y);
		} catch (ParseException e) {
			return null;
		}
	}

}
