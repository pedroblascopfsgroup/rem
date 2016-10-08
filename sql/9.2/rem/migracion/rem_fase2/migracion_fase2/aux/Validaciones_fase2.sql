--VALIDACIONES

--QUERY QUE VERIFICA QUE NO HAYA OFERTAS EN ESTADO ACEPTADO Y CON FECHA_NOTIFICACION A NULL

SELECT OFR.OFR_NUM_OFERTA,OFR.DD_EOF_ID, OFR.OFR_FECHA_NOTIFICACION FROM OFR_OFERTAS OFR
WHERE OFR.DD_EOF_ID = 1
AND OFR.OFR_FECHA_NOTIFICACION IS NULL;

--#########################################################################################################################
--#########################################################################################################################
-- VALIDACIONES MIGRACION REM F2

-- CLIENTE_COMERCIAL
      select count(1) from MIG2_CLC_CLIENTE_COMERCIAL;
      select count(1) from CLC_CLIENTE_COMERCIAL where usuariocrear = 'MIG2';

-- VISITAS
      select count(1) from MIG2_VIS_VISITAS;
      select count(1) from VIS_VISITAS where usuariocrear = 'MIG2';

-- OFERTAS
      select count(1) from MIG2_OFR_OFERTAS;
      select count(1) from OFR_OFERTAS where usuariocrear = 'MIG2';

-- OFERTAS_ACTIVO
      select count(1) from MIG2_OFA_OFERTAS_ACTIVO;
      select count(1) from ACT_OFR; 

-- RESERVAS
      select count(1) from MIG2_RES_RESERVAS; 
      select count(1) from RES_RESERVAS where usuariocrear = 'MIG2'; 

-- TITULARES_ADICIONALES
      select count(1) from MIG2_OFR_TIA_TITULARES_ADI;
      select count(1) from OFR_TIA_TITULARES_ADICIONALES where usuariocrear = 'MIG2';
      select count(1) from rem01.mig2_ofr_not_exists where TABLA_MIG = 'MIG2_OFR_TIA_TITULARES_ADI';

-- COMPRADOR
      select count(1) from MIG2_COM_COMPRADORES; 
      select count(1) from COM_COMPRADOR where usuariocrear = 'MIG2';; 

-- COMPRADOR_EXPEDIENTE 
      select count(1) from MIG2_CEX_COMPRADOR_EXPEDIENTE;
      select count(1) from CEX_COMPRADOR_EXPEDIENTE where usuariocrear = 'MIG2';; 

-- FORMALIZACION
      select count(1) from MIG2_FOR_FORMALIZACIONES;
      select count(1) from FOR_FORMALIZACION where usuariocrear = 'MIG2';; 

-- POSICIONAMIENTO
      select count(1) from MIG2_POS_POSICIONAMIENTO;
      select count(1) from POS_POSICIONAMIENTO where usuariocrear = 'MIG2'; -- NO REALIZADO

-- CONDICIONES_ESPECIFICAS
      select count(1) from MIG2_ACT_COE_CONDICIONES_ESPEC;
      select count(1) from ACT_COE_CONDICION_ESPECIFICA where usuariocrear = 'MIG2'; 
      select COUNT(1) from MIG2_ACT_NOT_EXISTS where TABLA_MIG = 'MIG2_ACT_COE_CONDICIONES_ESPEC';

-- PERIMETRO_ACTIVO
      select count(1) from MIG2_PAC_PERIMETRO_ACTIVO; 
      select count(1) from ACT_PAC_PERIMETRO_ACTIVO where usuariocrear = 'MIG2';
      select COUNT(1) from MIG2_ACT_NOT_EXISTS where TABLA_MIG = 'MIG2_PAC_PERIMETRO_ACTIVO';
--#########################################################################################################################
--#########################################################################################################################
