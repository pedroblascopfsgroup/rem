-- MODIFICAR LOS DELETES QUE NO HACEN REFERENCIA A USUARIOCREAR

DELETE FROM ACT_PAC_PERIMETRO_ACTIVO WHERE USUARIOCREAR = 'MIG2';

UPDATE REM01.ACT_ACTIVO ACT SET
    ACT.ACT_BLOQUEO_PRECIO_FECHA_INI = NULL
    ,ACT.ACT_BLOQUEO_PRECIO_USU_ID = NULL
    ,ACT.DD_TPU_ID = NULL
    ,ACT.DD_EPU_ID = NULL
    ,ACT.DD_TCO_ID = NULL
    ,ACT.ACT_FECHA_IND_PRECIAR = NULL
    ,ACT.ACT_FECHA_IND_REPRECIAR = NULL
    ,ACT.ACT_FECHA_IND_DESCUENTO = NULL
    ,ACT.USUARIOMODIFICAR = NULL
    ,ACT.FECHAMODIFICAR = NULL
WHERE ACT.USUARIOMODIFICAR = 'MIG2'
;

DELETE FROM GIC_GASTOS_INFO_CONTABILIDAD WHERE USUARIOCREAR = 'MIG2';

DELETE FROM GIM_GASTOS_IMPUGNACION WHERE USUARIOCREAR = 'MIG2';

DELETE FROM GGE_GASTOS_GESTION WHERE USUARIOCREAR = 'MIG2';

DELETE FROM GDE_GASTOS_DETALLE_ECONOMICO WHERE USUARIOCREAR = 'MIG2';

DELETE FROM GPV_TBJ;

DELETE FROM GPV_ACT;

DELETE FROM GPV_GASTOS_PROVEEDOR WHERE USUARIOCREAR = 'MIG2';

DELETE FROM ACT_PVC_PROVEEDOR_CONTACTO WHERE USUARIOCREAR = 'MIG2'; 

DELETE FROM ACT_PRD_PROVEEDOR_DIRECCION WHERE USUARIOCREAR = 'MIG2';

DELETE FROM ACT_PVE_PROVEEDOR WHERE USUARIOCREAR = 'MIG2';

DELETE FROM ACT_PRP;

DELETE FROM PRP_PROPUESTAS_PRECIOS WHERE USUARIOCREAR = 'MIG2';

DELETE FROM ACT_HVA_HIST_VALORACIONES WHERE USUARIOCREAR = 'MIG2';

DELETE FROM ACT_COE_CONDICION_ESPECIFICA WHERE USUARIOCREAR = 'MIG2';

DELETE FROM ACT_HEP_HIST_EST_PUBLICACION WHERE USUARIOCREAR = 'MIG2';

DELETE FROM SUB_SUBSANACIONES WHERE USUARIOCREAR = 'MIG2';

DELETE FROM POS_POSICIONAMIENTO WHERE USUARIOCREAR = 'MIG2';

DELETE FROM FOR_FORMALIZACION WHERE USUARIOCREAR = 'MIG2';

DELETE FROM OEX_OBS_EXPEDIENTE WHERE USUARIOCREAR = 'MIG2'; 

DELETE FROM GEX_GASTOS_EXPEDIENTE WHERE USUARIOCREAR = 'MIG2';

-- DELETE FROM CEX_COMPRADOR_EXPEDIENTE WHERE USUARIOCREAR = 'MIG2';

DELETE FROM COM_COMPRADOR WHERE USUARIOCREAR = 'MIG2';

DELETE FROM OFR_TIA_TITULARES_ADICIONALES WHERE USUARIOCREAR = 'MIG2';

DELETE FROM RES_RESERVAS WHERE USUARIOCREAR = 'MIG2';

DELETE FROM COE_CONDICIONANTES_EXPEDIENTE WHERE USUARIOCREAR = 'MIG2';

DELETE FROM ACT_OFR;

DELETE FROM OFR_OFERTAS WHERE USUARIOCREAR = 'MIG2';

DELETE FROM VIS_VISITAS WHERE USUARIOCREAR = 'MIG2';

DELETE FROM CLC_CLIENTE_COMERCIAL WHERE USUARIOCREAR = 'MIG2';

COMMIT;
