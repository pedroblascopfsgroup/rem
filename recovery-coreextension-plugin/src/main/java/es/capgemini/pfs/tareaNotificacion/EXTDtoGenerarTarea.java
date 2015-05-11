package es.capgemini.pfs.tareaNotificacion;

import es.capgemini.pfs.tareaNotificacion.VencimientoUtils.TipoCalculo;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;

public class EXTDtoGenerarTarea extends DtoGenerarTarea{

	
	private static final long serialVersionUID = 8722225794217960021L;
	
	public EXTDtoGenerarTarea() {
		super();
	}

	public EXTDtoGenerarTarea(Long idEntidad, String codigoTipoEntidad,
			String codigoSubtipoTarea, boolean enEspera, boolean esAlerta,
			Long plazo, String descripcion) {
		super(idEntidad, codigoTipoEntidad, codigoSubtipoTarea, enEspera,
				esAlerta, plazo, descripcion);
	}
	
	public EXTDtoGenerarTarea(Long idEntidad, String codigoTipoEntidad,
			String codigoSubtipoTarea, boolean enEspera, boolean esAlerta,
			Long plazo, String descripcion, TipoCalculo tipoCalculo) {
		super(idEntidad, codigoTipoEntidad, codigoSubtipoTarea, enEspera,
				esAlerta, plazo, descripcion);
		this.tipoCalculo = tipoCalculo;
	}
	
	public EXTDtoGenerarTarea(Long idEntidad, String codigoTipoEntidad, String codigoSubtipoTarea, boolean enEspera, boolean esAlerta, Long plazo,
            String descripcion, Long idTarea) {
		super(idEntidad, codigoTipoEntidad, codigoSubtipoTarea, enEspera, esAlerta, plazo, descripcion);
		this.idTarea = idTarea;
	}

	public void setTipoCalculo(TipoCalculo tipoCalculo) {
		this.tipoCalculo = tipoCalculo;
	}

	public TipoCalculo getTipoCalculo() {
		return tipoCalculo;
	}

	private TipoCalculo tipoCalculo;
	
	private Long idTarea;

	public Long getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
	

}
