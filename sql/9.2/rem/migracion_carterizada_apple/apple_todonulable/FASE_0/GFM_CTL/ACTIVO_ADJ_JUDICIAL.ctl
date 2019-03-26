
OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/ACTIVO_ADJ_JUDICIAL.dat'
BADFILE './CTLs_DATs/bad/ACTIVO_ADJ_JUDICIAL.bad'
DISCARDFILE './CTLs_DATs/rejects/ACTIVO_ADJ_JUDICIAL.bad'
INTO TABLE REM01.MIG_ADJ_JUDICIAL
TRUNCATE
TRAILING NULLCOLS
(
ACT_NUMERO_ACTIVO POSITION(1:17) INTEGER EXTERNAL NULLIF(ACT_NUMERO_ACTIVO=BLANKS) "CASE WHEN (:ACT_NUMERO_ACTIVO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACT_NUMERO_ACTIVO,1,17)||','||SUBSTR(:ACT_NUMERO_ACTIVO,18,0)),';',' '), '\"',''),'''','')) END",
ENTIDAD_EJECUTANTE POSITION(18:37) CHAR NULLIF(ENTIDAD_EJECUTANTE=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:ENTIDAD_EJECUTANTE),';',' '), '\"',''),'''','')",
ESTADO_ADJUDICACION POSITION(38:57) CHAR NULLIF(ESTADO_ADJUDICACION=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:ESTADO_ADJUDICACION),';',' '), '\"',''),'''','')",
AJD_FECHA_ADJUDICACION POSITION(58:65) DATE 'YYYYMMDD' NULLIF(AJD_FECHA_ADJUDICACION=BLANKS) "REPLACE(:AJD_FECHA_ADJUDICACION, '00000000', '')",
AJD_FECHA_DECRETO_FIRME POSITION(66:73) DATE 'YYYYMMDD' NULLIF(AJD_FECHA_DECRETO_FIRME=BLANKS) "REPLACE(:AJD_FECHA_DECRETO_FIRME, '00000000', '')",
AJD_FECHA_REA_POSESION POSITION(74:81) DATE 'YYYYMMDD' NULLIF(AJD_FECHA_REA_POSESION=BLANKS) "REPLACE(:AJD_FECHA_REA_POSESION, '00000000', '')",
AJD_IMPORTE_ADJUDICACION POSITION(82:98) INTEGER EXTERNAL NULLIF(AJD_IMPORTE_ADJUDICACION=BLANKS) "CASE WHEN (:AJD_IMPORTE_ADJUDICACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AJD_IMPORTE_ADJUDICACION,1,15)||','||SUBSTR(:AJD_IMPORTE_ADJUDICACION,16,2)),';',' '), '\"',''),'''','')) END",
JUZGADO POSITION(99:148) CHAR NULLIF(JUZGADO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:JUZGADO),';',' '), '\"',''),'''','')",
PLAZA_JUZGADO POSITION(149:178) CHAR NULLIF(PLAZA_JUZGADO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:PLAZA_JUZGADO),';',' '), '\"',''),'''','')",
AJD_NUM_AUTO POSITION(179:228) CHAR NULLIF(AJD_NUM_AUTO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:AJD_NUM_AUTO),';',' '), '\"',''),'''','')",
AJD_PROCURADOR POSITION(229:328) CHAR NULLIF(AJD_PROCURADOR=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:AJD_PROCURADOR),';',' '), '\"',''),'''','')",
AJD_LETRADO POSITION(329:428) CHAR NULLIF(AJD_LETRADO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:AJD_LETRADO),';',' '), '\"',''),'''','')",
AJD_ID_ASUNTO POSITION(429:445) INTEGER EXTERNAL NULLIF(AJD_ID_ASUNTO=BLANKS) "CASE WHEN (:AJD_ID_ASUNTO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AJD_ID_ASUNTO,1,17)||','||SUBSTR(:AJD_ID_ASUNTO,18,0)),';',' '), '\"',''),'''','')) END",
AJD_EXP_DEF_TESTI POSITION(446:450) INTEGER EXTERNAL NULLIF(AJD_EXP_DEF_TESTI=BLANKS) "CASE WHEN (:AJD_EXP_DEF_TESTI) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AJD_EXP_DEF_TESTI,1,5)||','||SUBSTR(:AJD_EXP_DEF_TESTI,6,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_F_DECRETO_N_FIRME POSITION(451:458) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_DECRETO_N_FIRME=BLANKS) "REPLACE(:BIE_ADJ_F_DECRETO_N_FIRME, '00000000', '')",
BIE_ADJ_F_INSCRIP_TITULO POSITION(459:466) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_INSCRIP_TITULO=BLANKS) "REPLACE(:BIE_ADJ_F_INSCRIP_TITULO, '00000000', '')",
BIE_ADJ_F_ENVIO_ADICION POSITION(467:474) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_ENVIO_ADICION=BLANKS) "REPLACE(:BIE_ADJ_F_ENVIO_ADICION, '00000000', '')",
BIE_ADJ_F_SOL_POSESION POSITION(475:482) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_SOL_POSESION=BLANKS) "REPLACE(:BIE_ADJ_F_SOL_POSESION, '00000000', '')",
BIE_ADJ_F_SEN_POSESION POSITION(483:490) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_SEN_POSESION=BLANKS) "REPLACE(:BIE_ADJ_F_SEN_POSESION, '00000000', '')",
BIE_ADJ_F_REA_POSESION POSITION(491:498) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_REA_POSESION=BLANKS) "REPLACE(:BIE_ADJ_F_REA_POSESION, '00000000', '')",
BIE_ADJ_F_SOL_LANZAMIENTO POSITION(499:506) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_SOL_LANZAMIENTO=BLANKS) "REPLACE(:BIE_ADJ_F_SOL_LANZAMIENTO, '00000000', '')",
BIE_ADJ_F_SEN_LANZAMIENTO POSITION(507:514) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_SEN_LANZAMIENTO=BLANKS) "REPLACE(:BIE_ADJ_F_SEN_LANZAMIENTO, '00000000', '')",
BIE_ADJ_F_REA_LANZAMIENTO POSITION(515:522) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_REA_LANZAMIENTO=BLANKS) "REPLACE(:BIE_ADJ_F_REA_LANZAMIENTO, '00000000', '')",
BIE_ADJ_F_SOL_MORATORIA POSITION(523:530) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_SOL_MORATORIA=BLANKS) "REPLACE(:BIE_ADJ_F_SOL_MORATORIA, '00000000', '')",
BIE_ADJ_F_RES_MORATORIA POSITION(531:538) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_RES_MORATORIA=BLANKS) "REPLACE(:BIE_ADJ_F_RES_MORATORIA, '00000000', '')",
BIE_ADJ_F_CONTRATO_ARREN POSITION(539:546) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_CONTRATO_ARREN=BLANKS) "REPLACE(:BIE_ADJ_F_CONTRATO_ARREN, '00000000', '')",
BIE_ADJ_F_CAMBIO_CERRADURA POSITION(547:554) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_CAMBIO_CERRADURA=BLANKS) "REPLACE(:BIE_ADJ_F_CAMBIO_CERRADURA, '00000000', '')",
BIE_ADJ_F_ENVIO_LLAVES POSITION(555:562) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_ENVIO_LLAVES=BLANKS) "REPLACE(:BIE_ADJ_F_ENVIO_LLAVES, '00000000', '')",
BIE_ADJ_F_RECEP_DEPOSITARIO POSITION(563:570) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_RECEP_DEPOSITARIO=BLANKS) "REPLACE(:BIE_ADJ_F_RECEP_DEPOSITARIO, '00000000', '')",
BIE_ADJ_F_ENVIO_DEPOSITARIO POSITION(571:578) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_ENVIO_DEPOSITARIO=BLANKS) "REPLACE(:BIE_ADJ_F_ENVIO_DEPOSITARIO, '00000000', '')",
BIE_ADJ_OCUPADO POSITION(579:580) INTEGER EXTERNAL NULLIF(BIE_ADJ_OCUPADO=BLANKS) "CASE WHEN (:BIE_ADJ_OCUPADO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_OCUPADO,1,2)||','||SUBSTR(:BIE_ADJ_OCUPADO,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_POSIBLE_POSESION POSITION(581:582) INTEGER EXTERNAL NULLIF(BIE_ADJ_POSIBLE_POSESION=BLANKS) "CASE WHEN (:BIE_ADJ_POSIBLE_POSESION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_POSIBLE_POSESION,1,2)||','||SUBSTR(:BIE_ADJ_POSIBLE_POSESION,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_OCUPANTES_DILIGENCIA POSITION(583:584) INTEGER EXTERNAL NULLIF(BIE_ADJ_OCUPANTES_DILIGENCIA=BLANKS) "CASE WHEN (:BIE_ADJ_OCUPANTES_DILIGENCIA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_OCUPANTES_DILIGENCIA,1,2)||','||SUBSTR(:BIE_ADJ_OCUPANTES_DILIGENCIA,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_LANZAMIENTO_NECES POSITION(585:586) INTEGER EXTERNAL NULLIF(BIE_ADJ_LANZAMIENTO_NECES=BLANKS) "CASE WHEN (:BIE_ADJ_LANZAMIENTO_NECES) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_LANZAMIENTO_NECES,1,2)||','||SUBSTR(:BIE_ADJ_LANZAMIENTO_NECES,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_ENTREGA_VOLUNTARIA POSITION(587:588) INTEGER EXTERNAL NULLIF(BIE_ADJ_ENTREGA_VOLUNTARIA=BLANKS) "CASE WHEN (:BIE_ADJ_ENTREGA_VOLUNTARIA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_ENTREGA_VOLUNTARIA,1,2)||','||SUBSTR(:BIE_ADJ_ENTREGA_VOLUNTARIA,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_NECESARIA_FUERA_PUB POSITION(589:590) INTEGER EXTERNAL NULLIF(BIE_ADJ_NECESARIA_FUERA_PUB=BLANKS) "CASE WHEN (:BIE_ADJ_NECESARIA_FUERA_PUB) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_NECESARIA_FUERA_PUB,1,2)||','||SUBSTR(:BIE_ADJ_NECESARIA_FUERA_PUB,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_EXISTE_INQUILINO POSITION(591:592) INTEGER EXTERNAL NULLIF(BIE_ADJ_EXISTE_INQUILINO=BLANKS) "CASE WHEN (:BIE_ADJ_EXISTE_INQUILINO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_EXISTE_INQUILINO,1,2)||','||SUBSTR(:BIE_ADJ_EXISTE_INQUILINO,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_LLAVES_NECESARIAS POSITION(593:594) INTEGER EXTERNAL NULLIF(BIE_ADJ_LLAVES_NECESARIAS=BLANKS) "CASE WHEN (:BIE_ADJ_LLAVES_NECESARIAS) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_LLAVES_NECESARIAS,1,2)||','||SUBSTR(:BIE_ADJ_LLAVES_NECESARIAS,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_GESTORIA_ADJUDIC POSITION(595:611) INTEGER EXTERNAL NULLIF(BIE_ADJ_GESTORIA_ADJUDIC=BLANKS) "CASE WHEN (:BIE_ADJ_GESTORIA_ADJUDIC) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_GESTORIA_ADJUDIC,1,17)||','||SUBSTR(:BIE_ADJ_GESTORIA_ADJUDIC,18,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_NOMBRE_ARRENDATARIO POSITION(612:661) CHAR NULLIF(BIE_ADJ_NOMBRE_ARRENDATARIO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_NOMBRE_ARRENDATARIO),';',' '), '\"',''),'''','')",
BIE_ADJ_NOMBRE_DEPOSITARIO POSITION(662:711) CHAR NULLIF(BIE_ADJ_NOMBRE_DEPOSITARIO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_NOMBRE_DEPOSITARIO),';',' '), '\"',''),'''','')",
BIE_ADJ_NOMBRE_DEPOSITARIO_F POSITION(712:761) CHAR NULLIF(BIE_ADJ_NOMBRE_DEPOSITARIO_F=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:BIE_ADJ_NOMBRE_DEPOSITARIO_F),';',' '), '\"',''),'''','')",
DD_EAD_ID POSITION(762:781) CHAR NULLIF(DD_EAD_ID=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_EAD_ID),';',' '), '\"',''),'''','')",
DD_SIT_ID POSITION(782:801) CHAR NULLIF(DD_SIT_ID=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_SIT_ID),';',' '), '\"',''),'''','')",
DD_FAV_ID POSITION(802:821) CHAR NULLIF(DD_FAV_ID=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_FAV_ID),';',' '), '\"',''),'''','')",
BIE_ADJ_F_RECEP_DEPOSITARIO_F POSITION(822:829) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_RECEP_DEPOSITARIO_F=BLANKS) "REPLACE(:BIE_ADJ_F_RECEP_DEPOSITARIO_F, '00000000', '')",
DD_TFO_ID POSITION(830:849) CHAR NULLIF(DD_TFO_ID=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_TFO_ID),';',' '), '\"',''),'''','')",
BIE_ADJ_REQ_SUBSANACION POSITION(850:851) INTEGER EXTERNAL NULLIF(BIE_ADJ_REQ_SUBSANACION=BLANKS) "CASE WHEN (:BIE_ADJ_REQ_SUBSANACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_REQ_SUBSANACION,1,2)||','||SUBSTR(:BIE_ADJ_REQ_SUBSANACION,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_NOTIF_DEMANDADOS POSITION(852:853) INTEGER EXTERNAL NULLIF(BIE_ADJ_NOTIF_DEMANDADOS=BLANKS) "CASE WHEN (:BIE_ADJ_NOTIF_DEMANDADOS) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_NOTIF_DEMANDADOS,1,2)||','||SUBSTR(:BIE_ADJ_NOTIF_DEMANDADOS,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_F_REV_PROP_CAN POSITION(854:861) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_REV_PROP_CAN=BLANKS) "REPLACE(:BIE_ADJ_F_REV_PROP_CAN, '00000000', '')",
BIE_ADJ_F_PROP_CAN POSITION(862:869) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_PROP_CAN=BLANKS) "REPLACE(:BIE_ADJ_F_PROP_CAN, '00000000', '')",
BIE_ADJ_F_REV_CARGAS POSITION(870:877) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_REV_CARGAS=BLANKS) "REPLACE(:BIE_ADJ_F_REV_CARGAS, '00000000', '')",
BIE_ADJ_F_PRES_INS_ECO POSITION(878:885) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_PRES_INS_ECO=BLANKS) "REPLACE(:BIE_ADJ_F_PRES_INS_ECO, '00000000', '')",
BIE_ADJ_F_PRES_INS POSITION(886:893) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_PRES_INS=BLANKS) "REPLACE(:BIE_ADJ_F_PRES_INS, '00000000', '')",
BIE_ADJ_F_CAN_REG_ECO POSITION(894:901) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_CAN_REG_ECO=BLANKS) "REPLACE(:BIE_ADJ_F_CAN_REG_ECO, '00000000', '')",
BIE_ADJ_F_CAN_REG POSITION(902:909) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_CAN_REG=BLANKS) "REPLACE(:BIE_ADJ_F_CAN_REG, '00000000', '')",
BIE_ADJ_F_CAN_ECO POSITION(910:917) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_CAN_ECO=BLANKS) "REPLACE(:BIE_ADJ_F_CAN_ECO, '00000000', '')",
BIE_ADJ_F_LIQUIDACION POSITION(918:925) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_LIQUIDACION=BLANKS) "REPLACE(:BIE_ADJ_F_LIQUIDACION, '00000000', '')",
BIE_ADJ_F_RECEPCION POSITION(926:933) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_RECEPCION=BLANKS) "REPLACE(:BIE_ADJ_F_RECEPCION, '00000000', '')",
BIE_ADJ_F_CANCELACION POSITION(934:941) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_CANCELACION=BLANKS) "REPLACE(:BIE_ADJ_F_CANCELACION, '00000000', '')",
BIE_ADJ_IMPORTE_ADJUDICACION POSITION(942:958) INTEGER EXTERNAL NULLIF(BIE_ADJ_IMPORTE_ADJUDICACION=BLANKS) "CASE WHEN (:BIE_ADJ_IMPORTE_ADJUDICACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_IMPORTE_ADJUDICACION,1,15)||','||SUBSTR(:BIE_ADJ_IMPORTE_ADJUDICACION,16,2)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_CESION_REMATE POSITION(959:960) INTEGER EXTERNAL NULLIF(BIE_ADJ_CESION_REMATE=BLANKS) "CASE WHEN (:BIE_ADJ_CESION_REMATE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_CESION_REMATE,1,2)||','||SUBSTR(:BIE_ADJ_CESION_REMATE,3,0)),';',' '), '\"',''),'''','')) END",
BIE_ADJ_CESION_REMATE_IMP POSITION(961:977) INTEGER EXTERNAL NULLIF(BIE_ADJ_CESION_REMATE_IMP=BLANKS) "CASE WHEN (:BIE_ADJ_CESION_REMATE_IMP) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_CESION_REMATE_IMP,1,15)||','||SUBSTR(:BIE_ADJ_CESION_REMATE_IMP,16,2)),';',' '), '\"',''),'''','')) END",
DD_DAD_ID POSITION(978:997) CHAR NULLIF(DD_DAD_ID=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_DAD_ID),';',' '), '\"',''),'''','')",
BIE_ADJ_F_CONTABILIDAD POSITION(998:1005) DATE 'YYYYMMDD' NULLIF(BIE_ADJ_F_CONTABILIDAD=BLANKS) "REPLACE(:BIE_ADJ_F_CONTABILIDAD, '00000000', '')",
BIE_ADJ_POSTORES POSITION(1006:1007) INTEGER EXTERNAL NULLIF(BIE_ADJ_POSTORES=BLANKS) "CASE WHEN (:BIE_ADJ_POSTORES) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:BIE_ADJ_POSTORES,1,2)||','||SUBSTR(:BIE_ADJ_POSTORES,3,0)),';',' '), '\"',''),'''','')) END",
VALIDACION CONSTANT "0"
)




