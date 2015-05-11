package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto;

import java.math.BigInteger;

import es.capgemini.devon.dto.WebDto;

public class RecobroAccionesExtrajudicialesDto extends WebDto{

	private static final long serialVersionUID = -1937871007129547155L;

	private Long id;
	
	private BigInteger idEnvio;
	
	private Long idPersona;
	
	private Long idCicloRecobroCnt;
	
	private Long idCicloRecobroPer;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public BigInteger getIdEnvio() {
		return idEnvio;
	}

	public void setIdEnvio(BigInteger idEnvio) {
		this.idEnvio = idEnvio;
	}

	public Long getIdPersona() {
		return idPersona;
	}

	public void setIdPersona(Long idPersona) {
		this.idPersona = idPersona;
	}

	public Long getIdCicloRecobroCnt() {
		return idCicloRecobroCnt;
	}

	public void setIdCicloRecobroCnt(Long idCicloRecobroCnt) {
		this.idCicloRecobroCnt = idCicloRecobroCnt;
	}

	public Long getIdCicloRecobroPer() {
		return idCicloRecobroPer;
	}

	public void setIdCicloRecobroPer(Long idCicloRecobroPer) {
		this.idCicloRecobroPer = idCicloRecobroPer;
	}
	
}
