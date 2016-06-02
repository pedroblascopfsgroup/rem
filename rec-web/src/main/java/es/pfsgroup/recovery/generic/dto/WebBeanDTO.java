package es.pfsgroup.recovery.generic.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;

public class WebBeanDTO extends WebDto implements Serializable {
	
	private static final long serialVersionUID = 1L;
	private BigDecimal ROWNUM_;
    
	/**
	 * @return the rOWNUM_
	 */
	public BigDecimal getROWNUM_() {
		return ROWNUM_;
	}

	/**
	 * @param rOWNUM_ the rOWNUM_ to set
	 */
	public void setROWNUM_(BigDecimal rOWNUM_) {
		ROWNUM_ = rOWNUM_;
	}
}
